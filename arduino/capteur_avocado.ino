// ═══════════════════════════════════════════════════════════
//  AVOCADOGUARD — ESP32 + BME280 + MQ-135 → Firebase RTDB
//  Projet AgroSafe — BAI + BLE JSON + Ring Buffer hors-ligne
// ═══════════════════════════════════════════════════════════

#include <WiFi.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <Wire.h>
#include <Adafruit_BME280.h>
#include "esp_bt.h"


// ───────────────────────────────────────
//  SECRETS
// ───────────────────────────────────────
#include "secrets.h"

// ───────────────────────────────────────
//  PINS
// ───────────────────────────────────────
#define MQ135_PIN   34
#define SDA_PIN     21
#define SCL_PIN     22

// ───────────────────────────────────────
//  PARAMÈTRES GÉNÉRAUX
// ───────────────────────────────────────
#define SEND_INTERVAL_MS        10000
#define MODULE_ID               "module1"
#define WIFI_TIMEOUT_MS         10000
#define BLE_SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define BLE_CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

// ───────────────────────────────────────
//  PARAMÈTRES BAI
// ───────────────────────────────────────
#define BAI_BASELINE_SAMPLES  12
#define BAI_WINDOW             8
#define BAI_SEUIL_STABLE      20.0
#define BAI_SEUIL_MATURATION  60.0

// ───────────────────────────────────────
//  PARAMÈTRES RING BUFFER
// ───────────────────────────────────────
#define BUFFER_SIZE 10

// ───────────────────────────────────────
//  GLOBAUX — SYSTÈME
// ───────────────────────────────────────
FirebaseData    fbdo;
FirebaseAuth    auth;
FirebaseConfig  config;
Adafruit_BME280 bme;

BLEServer*         pServer         = nullptr;
BLECharacteristic* pCharacteristic = nullptr;
bool bleClientConnected = false;

unsigned long lastSend   = 0;
bool firebaseReady       = false;
bool bmeFound            = false;
uint32_t cycleCount      = 0;

// ───────────────────────────────────────
//  GLOBAUX — BAI
// ───────────────────────────────────────
float   baiBaseline   = -1.0;
float   baiWindow[BAI_WINDOW];
uint8_t baiWindowIdx  = 0;
bool    baiReady      = false;
uint8_t baselineCount = 0;
float   baselineSum   = 0.0;

// ───────────────────────────────────────
//  GLOBAUX — ALERTES BLE
// ───────────────────────────────────────
uint16_t alertCount   = 0;
String   lastAlertMsg = "Aucune";

// ───────────────────────────────────────
//  RING BUFFER — stockage hors-ligne
// ───────────────────────────────────────
struct Mesure {
  float    temp;
  float    hum;
  float    pres;
  int      co2;
  int      co2_raw;
  float    bai;
  uint32_t timestamp;
  bool     valide;
};

Mesure  offlineBuffer[BUFFER_SIZE];
uint8_t bufferHead  = 0;
uint8_t bufferCount = 0;

// ═══════════════════════════════════════
//  CALLBACKS BLE
// ═══════════════════════════════════════
class BLECallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pSvr) override {
    bleClientConnected = true;
    Serial.println(F("BLE client connecté"));
  }
  void onDisconnect(BLEServer* pSvr) override {
    bleClientConnected = false;
    pSvr->startAdvertising();
    Serial.println(F("BLE client déconnecté — advertising relancé"));
  }
};

// ═══════════════════════════════════════
//  INIT WIFI
// ═══════════════════════════════════════
void initWiFi() {
  Serial.println(F(">>> INIT WiFi"));
  WiFi.disconnect(true);
  delay(1000);
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  unsigned long t0 = millis();
  while (WiFi.status() != WL_CONNECTED) {
    if (millis() - t0 > WIFI_TIMEOUT_MS) {
      Serial.printf("\nTimeout WiFi. Status=%d\n", WiFi.status());
      return;
    }
    delay(500);
    Serial.print('.');
  }
  Serial.println();
  Serial.print(F("WiFi OK — IP: "));
  Serial.println(WiFi.localIP());
}

// ═══════════════════════════════════════
//  INIT BLE
// ═══════════════════════════════════════
void initBLE() {
  Serial.println(F(">>> INIT BLE"));
  BLEDevice::init(String("AgroSafe-") + MODULE_ID);

  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new BLECallbacks());

  BLEService* pService = pServer->createService(BLE_SERVICE_UUID);
  pCharacteristic = pService->createCharacteristic(
    BLE_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY
  );
  pCharacteristic->addDescriptor(new BLE2902());
  pService->start();

  BLEAdvertising* pAdv = BLEDevice::getAdvertising();
  pAdv->addServiceUUID(BLE_SERVICE_UUID);
  pAdv->setScanResponse(true);
  pAdv->setMinPreferred(0x06);
  BLEDevice::startAdvertising();

  Serial.println(F("BLE OK"));
}

// ═══════════════════════════════════════
//  INIT BME280
// ═══════════════════════════════════════
void initBME280() {
  Serial.println(F(">>> INIT BME280"));
  Wire.begin(SDA_PIN, SCL_PIN);
  if (bme.begin(0x76)) {
    bmeFound = true;
    Serial.println(F("BME280 OK @ 0x76"));
  } else if (bme.begin(0x77)) {
    bmeFound = true;
    Serial.println(F("BME280 OK @ 0x77"));
  } else {
    Serial.println(F("BME280 NON TROUVE"));
  }
}

// ═══════════════════════════════════════
//  INIT MQ-135
// ═══════════════════════════════════════
void initMQ135() {
  Serial.println(F(">>> INIT MQ-135"));
  Serial.printf("MQ135 raw initial = %d\n", analogRead(MQ135_PIN));
}

// ═══════════════════════════════════════
//  INIT BAI
// ═══════════════════════════════════════
void initBAI() {
  Serial.println(F(">>> INIT BAI — baseline sur les prochains cycles"));
  for (int i = 0; i < BAI_WINDOW; i++) baiWindow[i] = 0.0;
}

// ═══════════════════════════════════════
//  INIT BUFFER
// ═══════════════════════════════════════
void initBuffer() {
  for (int i = 0; i < BUFFER_SIZE; i++) offlineBuffer[i].valide = false;
  Serial.println(F(">>> INIT Buffer hors-ligne OK"));
}

// ═══════════════════════════════════════
//  INIT FIREBASE
// ═══════════════════════════════════════
void initFirebase() {
  Serial.println(F(">>> INIT Firebase"));
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println(F("WiFi indispo — Firebase reporté"));
    delay(5000);
    return;
  }
  config.database_url               = DATABASE_URL;
  config.signer.tokens.legacy_token = DATABASE_SECRET;
  config.token_status_callback      = tokenStatusCallback;

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  unsigned long t0 = millis();
  while (!Firebase.ready() && millis() - t0 < 5000) {
    delay(200);
    Serial.print('.');
  }
  Serial.println();

  if (Firebase.ready()) {
    firebaseReady = true;
    Serial.println(F("Firebase OK"));
  } else {
    Serial.println(F("Firebase ERREUR"));
  }
}

// ═══════════════════════════════════════
//  LECTURE CAPTEURS BME280
// ═══════════════════════════════════════
float lireTemperature() {
  float t = bme.readTemperature();
  return isnan(t) ? -999.0 : t;
}
float lireHumidite() {
  float h = bme.readHumidity();
  return isnan(h) ? -999.0 : h;
}
float lirePression() {
  float p = bme.readPressure();
  return (isnan(p) || p < 1.0) ? -999.0 : p / 100.0F;
}

// ═══════════════════════════════════════
//  CALCUL BAI
// ═══════════════════════════════════════
float calculerBAI(int rawADC) {
  float raw = (float)rawADC;

  if (baselineCount < BAI_BASELINE_SAMPLES) {
    baselineSum += raw;
    baselineCount++;
    if (baselineCount == BAI_BASELINE_SAMPLES) {
      baiBaseline = baselineSum / BAI_BASELINE_SAMPLES;
      baiReady    = true;
      for (int i = 0; i < BAI_WINDOW; i++) baiWindow[i] = baiBaseline;
      Serial.printf(">>> BAI baseline : %.1f (sur %d cycles)\n",
                    baiBaseline, BAI_BASELINE_SAMPLES);
    }
    return -1.0;
  }

  baiWindow[baiWindowIdx] = raw;
  baiWindowIdx = (baiWindowIdx + 1) % BAI_WINDOW;

  float avg = 0.0;
  for (int i = 0; i < BAI_WINDOW; i++) avg += baiWindow[i];
  avg /= BAI_WINDOW;

  float bai = ((avg - baiBaseline) / baiBaseline) * 100.0;
  return constrain(bai, 0.0, 100.0);
}

const char* interpretBAI(float bai) {
  if (bai < 0.0)                   return "CALIBRATION";
  if (bai < BAI_SEUIL_STABLE)      return "STABLE";
  if (bai < BAI_SEUIL_MATURATION)  return "MATURATION";
  return "ALERTE FERMENTATION";
}

// ═══════════════════════════════════════
//  PAYLOAD BLE (JSON compact)
// ═══════════════════════════════════════
String buildBLEPayload(float t, float h, float p, int co2, float bai) {
  const char* status = interpretBAI(bai);

  // Comptage alertes
  if (baiReady && bai >= BAI_SEUIL_MATURATION) {
    alertCount++;
    lastAlertMsg = String(status) + " BAI=" + String(bai, 1);
  }

  char buf[200];
  snprintf(buf, sizeof(buf),
    "{\"t\":%.2f,\"h\":%.1f,\"p\":%.1f,\"co2\":%d,"
    "\"bai\":%.1f,\"status\":\"%s\","
    "\"alerts\":%d,\"last_alert\":\"%s\","
    "\"wifi\":%s,\"buf\":%d}",
    t, h, p, co2,
    bai < 0 ? 0.0f : bai,
    status,
    alertCount, lastAlertMsg.c_str(),
    WiFi.status() == WL_CONNECTED ? "true" : "false",
    bufferCount
  );
  return String(buf);
}

// ═══════════════════════════════════════
//  RING BUFFER — écriture
// ═══════════════════════════════════════
void bufferiserMesure(float t, float h, float p, int co2, int raw, float bai) {
  offlineBuffer[bufferHead] = {
    t, h, p, co2, raw,
    bai < 0 ? 0.0f : bai,
    (uint32_t)(millis() / 1000),
    true
  };
  bufferHead = (bufferHead + 1) % BUFFER_SIZE;
  if (bufferCount < BUFFER_SIZE) bufferCount++;
  Serial.printf("Buffer hors-ligne : %d/%d cycle(s)\n", bufferCount, BUFFER_SIZE);
}

// ═══════════════════════════════════════
//  RING BUFFER — vidage vers Firebase
// ═══════════════════════════════════════
void viderBuffer() {
  if (bufferCount == 0) return;
  if (!firebaseReady || !Firebase.ready()) return;

  Serial.printf(">>> Remontée buffer : %d cycle(s) en attente\n", bufferCount);

  uint8_t idx = (bufferHead - bufferCount + BUFFER_SIZE) % BUFFER_SIZE;

  for (uint8_t i = 0; i < bufferCount; i++) {
    Mesure& m = offlineBuffer[idx];
    if (!m.valide) { idx = (idx + 1) % BUFFER_SIZE; continue; }

    // Écriture dans historique avec timestamp comme clé
    String base = "/capteurs/" MODULE_ID "/historique/" + String(m.timestamp) + "/";

    bool ok = true;
    ok &= Firebase.RTDB.setFloat(&fbdo, base + "temperature", m.temp);
    ok &= Firebase.RTDB.setFloat(&fbdo, base + "humidite",    m.hum);
    ok &= Firebase.RTDB.setFloat(&fbdo, base + "pression",    m.pres);
    ok &= Firebase.RTDB.setInt  (&fbdo, base + "co2",         m.co2);
    ok &= Firebase.RTDB.setInt  (&fbdo, base + "co2_raw",     m.co2_raw);
    ok &= Firebase.RTDB.setFloat(&fbdo, base + "bai",         m.bai);
    ok &= Firebase.RTDB.setString(&fbdo, base + "source",     "buffer");

    if (ok) {
      m.valide = false;
      Serial.printf("  Buffer[%d] → historique/%lu OK\n", i, m.timestamp);
    } else {
      Serial.printf("  Buffer[%d] ERR — retry au prochain cycle\n", i);
      break;
    }

    idx = (idx + 1) % BUFFER_SIZE;
  }

  // Recompte
  bufferCount = 0;
  for (uint8_t i = 0; i < BUFFER_SIZE; i++)
    if (offlineBuffer[i].valide) bufferCount++;
}

// ═══════════════════════════════════════
//  ÉCRITURE FIREBASE — cycle live
// ═══════════════════════════════════════
void envoyerFirebase(float t, float h, float p, int co2, int raw,
                     float bai, uint32_t ts) {
  // Live (écrasé à chaque cycle — pour lecture temps réel Flutter)
  String live = "/capteurs/" MODULE_ID "/live/";
  Firebase.RTDB.setFloat (&fbdo, live + "temperature", t);
  Firebase.RTDB.setFloat (&fbdo, live + "humidite",    h);
  Firebase.RTDB.setFloat (&fbdo, live + "pression",    p);
  Firebase.RTDB.setInt   (&fbdo, live + "co2",         co2);
  Firebase.RTDB.setInt   (&fbdo, live + "co2_raw",     raw);
  Firebase.RTDB.setFloat (&fbdo, live + "bai",         bai < 0 ? 0.0f : bai);
  Firebase.RTDB.setString(&fbdo, live + "status",      interpretBAI(bai));
  Firebase.RTDB.setInt   (&fbdo, live + "timestamp",   (int)ts);

  // Historique (append horodaté — pour graphes et alertes Flutter)
  String hist = "/capteurs/" MODULE_ID "/historique/" + String(ts) + "/";
  bool ok = true;
  ok &= Firebase.RTDB.setFloat (&fbdo, hist + "temperature", t);
  ok &= Firebase.RTDB.setFloat (&fbdo, hist + "humidite",    h);
  ok &= Firebase.RTDB.setFloat (&fbdo, hist + "pression",    p);
  ok &= Firebase.RTDB.setInt   (&fbdo, hist + "co2",         co2);
  ok &= Firebase.RTDB.setInt   (&fbdo, hist + "co2_raw",     raw);
  ok &= Firebase.RTDB.setFloat (&fbdo, hist + "bai",         bai < 0 ? 0.0f : bai);
  ok &= Firebase.RTDB.setString(&fbdo, hist + "status",      interpretBAI(bai));
  ok &= Firebase.RTDB.setString(&fbdo, hist + "source",      "live");

  if (!ok) {
    Serial.print(F("Firebase ERR historique: "));
    Serial.println(fbdo.errorReason().c_str());
  }
}

// ═══════════════════════════════════════
//  CYCLE D'ENVOI PRINCIPAL
// ═══════════════════════════════════════
void envoyerDonnees() {
  cycleCount++;
  uint32_t ts = (uint32_t)(millis() / 1000);

  // ── Lecture capteurs ──
  float temp   = lireTemperature();
  float hum    = lireHumidite();
  float pres   = lirePression();
  int   rawCO2 = analogRead(MQ135_PIN);
  int   ppm    = map(rawCO2, 0, 4095, 400, 5000);
  float bai    = calculerBAI(rawCO2);

  // ── Log série ──
  Serial.printf("C#%lu | T=%.2f°C H=%.1f%% P=%.1fhPa | CO2=%dppm raw=%d | BAI=%.1f [%s] | WiFi=%s buf=%d\n",
    cycleCount, temp, hum, pres, ppm, rawCO2, bai,
    interpretBAI(bai),
    WiFi.status() == WL_CONNECTED ? "OK" : "OFF",
    bufferCount);

  // ── BLE notify (avant Firebase — priorité 2.4GHz) ──
  if (bleClientConnected) {
    String payload = buildBLEPayload(temp, hum, pres, ppm, bai);
    pCharacteristic->setValue(payload.c_str());
    pCharacteristic->notify();
    Serial.println("BLE >> " + payload);
  }

  // ── Firebase ou buffer hors-ligne ──
  if (!firebaseReady || !Firebase.ready()) {
    Serial.println(F("Firebase indispo — mise en buffer"));
    bufferiserMesure(temp, hum, pres, ppm, rawCO2, bai);
    return;
  }

  // Vider le buffer avant d'écrire le cycle actuel
  viderBuffer();

  // Écriture cycle live + historique
  envoyerFirebase(temp, hum, pres, ppm, rawCO2, bai, ts);
}

// ═══════════════════════════════════════
//  SETUP
// ═══════════════════════════════════════
void setup() {
  Serial.begin(115200);
  delay(500);
  Serial.println(F("=== AVOCADOGUARD boot ==="));

  // Libère BR/EDR inutilisé → ~100-150 Ko RAM récupérés
  esp_bt_controller_mem_release(ESP_BT_MODE_CLASSIC_BT);

  initWiFi();
  initBLE();
  initBME280();
  initMQ135();
  initBAI();
  initBuffer();
  initFirebase();

  Serial.println(F("=== Boot OK ==="));
}

// ═══════════════════════════════════════
//  LOOP
// ═══════════════════════════════════════
void loop() {
  // Reconnexion WiFi si perdue
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println(F("WiFi perdu — reconnexion..."));
    WiFi.reconnect();
    delay(3000);
    return;
  }

  // Init Firebase différée
  if (!firebaseReady) {
    initFirebase();
    return;
  }

  // Cycle d'acquisition
  if (millis() - lastSend >= SEND_INTERVAL_MS) {
    lastSend = millis();
    envoyerDonnees();
  }
}
