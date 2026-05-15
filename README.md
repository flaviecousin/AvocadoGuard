# 🥑AvocadoGuard

*Master 1, ISEN, January to April 2026, Teacher: Djida Ayad*

Flutter Application for real-time monitoring of avocado storage conditions (temperature, humidity, CO2, BAI) via an ESP32 sensor connected to Firebase Realtime Database with alerts, history and batch reporting.

![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![C++](https://img.shields.io/badge/C++-00599C?style=for-the-badge&logo=cplusplus&logoColor=white)
![CMake](https://img.shields.io/badge/CMake-064F8C?style=for-the-badge&logo=cmake&logoColor=white)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![Makefile](https://img.shields.io/badge/Makefile-427819?style=for-the-badge&logo=gnu&logoColor=white)

## 📖 Preview
<img height="500" alt="splash" src="https://github.com/user-attachments/assets/7c5a04d1-31f3-4e7a-8a70-f2f68ffdadc2" />
<img height="500" alt="home" src="https://github.com/user-attachments/assets/031eb1b0-5845-472d-9633-ac707b02edf5" />
<img height="500" alt="module2" src="https://github.com/user-attachments/assets/bd82d4d2-eada-4bd3-94cf-d6ecfd3dfd59" /> 
<img height="500" alt="historic" src="https://github.com/user-attachments/assets/9fcc7da2-17ed-4fbc-9fad-2dcd1d2e611d" />
<img height="500" alt="alertes" src="https://github.com/user-attachments/assets/53b8c4cd-d9e9-4d19-8229-f95ef184e345" />
<img height="500" alt="report" src="https://github.com/user-attachments/assets/97b54cdb-5987-4cb0-834b-7f81cdc2fa47" />
<img height="500" alt="report2" src="https://github.com/user-attachments/assets/95ad0b00-30d0-45cb-9c9a-eebdc9673e08" />

**Main features of the project:**
- Detection of degradation's signs
- Monitoring of storage parameters
- Visualization of storage status
- Alert in case of risk
- History of the measures and alerts
- Communication between the sensors, the cloud and the application

## 🗃️ Project structure
<img width="1296" height="1205" alt="AvocadoGuard - WBS(13)" src="https://github.com/user-attachments/assets/e6669553-9bcd-45c3-9ca5-0a6d29f8691f" />
The code for the embedded system was put in the folder called 'arduino'.
The code for the app was mainly put in the folder called 'lib'. It was structured around this:

```
lib/
|---core/
    |---constants/               # Shared data structures used across widgets
    |---data/                    # Simulated data used before connecting the sensors to the app
    |---models/                  # Data models (LotConfig, ConnectionStatus...)
    |---services/                # Firebase, notifications, configuration logic
    |---theme/                   # Theme of the app
|---l10n/                        # Translations (french and english)
|---screens/                     # One folder per screen
    |---avocado_module/          # Code for the main screens (realtime data and configuration)
    |---history/                 # Code for the history screen
    |---home/                    # Code for the home screen
    |---profile/                 # Code for the profile screens
    |---reports/                 # Code for the reports screens
    |---splash/                  # Code for the loading screen and the account screens (logging and creation)
|---widgets/                     # Reusable UI components
```

## 💽 Prerequisites and installation
### Flutter SDK
Flutter SDK version: '>=3.0.0 <4.0.0'

### Firebase configuration
This project uses Firebase. You need to set up your own Firebase project, configure FlutterFire CLI and add the required configuration files.
You can create a project on console.firebase.google.com after loging into your Firebase account.
You can then configure FlutterFire CLI to your environment with this instruction in your terminal:
```Bash
# To install FlutterFire CLI
dart pub global activate flutterfire_cli
```
These steps will automatically configure the file firebase_options.dart.

1. 'google-services.json' and 'GoogleService-Info.plist'
On Firebase, you can add an Android and/or iOS app to your project.
For Android: you can download the 'google-services.json' file and place it in 'android/app'
For iOS: you can download: 'GoogleService-Info.plist' file and place it in 'ios/Runner'

2. 'firebase_options.dart'
```Bash
flutterfire configure
```
This instruction will generate the file 'firebase_options.dart' directly in the folder 'lib' and is ignored by Git, so it must be generated locally.

3. '.env'
Create a '.env' file at the root of the project with the following content:
```Bash
FIREBASE_DATABASE_URL = your_database_realtime_database_url
FIREBASE_API_KEY = your_database_api_key
FIREBASE_APP_ID = your_database_application_id
FIREBASE_MESSAGING_SENDER_ID = your_messaging_sender_id
FIREBASE_PROJECT_ID = your_project_id
FIREBASE_STORAGE_BUCKET = your_storage_bucket
```
This file is ignored by Git for security reason

### Execution of the app
To run the application use these instructions:
```Bash
flutter clean
flutter pub get
flutter run
```
To execute the app on your phone, you need to connect it with a USB cable to your computer.
You also need to enable de **Developer Mode** and **USB Debugging** on your phone. To enable these:
1. Go to Settings > About phone
2. Tap Build number 7 times until you see "You are now a developer"
3. Go back to Settings > Developer options
4. Enable USB Debugging
5. Connect your device via USB and run 'flutter run'. You can use the instruction
   ```Bash
   flutter devices
   ```
   to make sure your phone is recongnized by Flutter and there is no problem.
### Arduino Libraries
Install the following libraries via Arduino IDE -> Tools -> Manage Libraries
- Firebase ESP Client
- Adafruit BME280 Library
- Adafruit Unified Sensor
The following libraries are built-in with the ESP32 board package and require no separate installation:
- WiFi
- BLEDevice / BLEServer / VLEUtils / BLE2902
- Wire
- esp_bt
### ESP32 Board Package 
If not already installed, go to Tools -> Board -> Boards Manager and install esp32
### Speed
Change the 
### To run the code
1. Fill in your credentials in the SECRETS section at the top of the file:
   ```cpp
   #define WIFI_SSID       "your_wifi_network_name"
   #define WIFI_PASSWORD   "your_wifi_password"
   #define DATABASE_URL    "your_firebase_realtime_database_url"
   #define DATABASE_SECRET "your_firebase_database_secret"
   ```
3. Select your board: Tools -> Board -> ESP32 Arduino -> ESP32 Dev Module
4. Select the correct port: Tools -> Port after connecting the ESP32 to your computer
5. Click Upload
6. Open Tools -> Serial Monitor and set the speed to 115000 bauds or 115600 bauds (or values around these) to see the boot logs and sensor readings
## 🛠️ Structure of Firebase and Firestore
Expected structure in the Firebase Realtime Database:
```
capteurs/
   |---module1/
          |---historique/
          |---live/
                |---bai: your_value
                |---co2: your_value # the real value after normalization
                |---co2_raw: your_value
                |---humidite: your_value
                |---pression: your_value
                |---status: "your_text"
                |---temperature: your_value
                |---timestamp: your_value # time spent since the ESP32 sent the first data
                |---ts: your_value # number of seconds spent since 01/01/1970 00:00
                |---ts_ok: your_value
```
Expected structure in Firestore Database:
```
users/{userId}
   |---{userId}
          |---alertes/
                |---{alerteId}
                        |---date: your_value
                        |---message: "your_text"
                        |---nom: "your_text"
                        |---userId: "your_secured_name"
          |---mesures/
                |---{mesureId}
                        |---bai: your_value
                        |---co2: your_value
                        |---date: your_value
                        |---humidity: your_value
                        |---temperature: your_value
          |---capteursId: your_text
          |---co2Max: your_value
          |---culture: your_text
          |---darkMode: your_value # change the theme of the app
          |---frequency: your_value
          |---humidityMax: your_value
          |---lastModified: your_value # last time the configuration screen was modified
          |---locale: "your_text" # language chosen by the user
          |---lotName: "your_text"
          |---role: "your_text"
          |---temperatureMax: your_value


                |---co2: your_value # the real value after normalization
                |---co2_raw: your_value
                |---humidite: your_value
                |---pression: your_value
                |---status: "your_text"
                |---temperature: your_value
                |---timestamp: your_value # time spent since the ESP32 sent the first data
                |---ts: your_value # number of seconds spent since 01/01/1970 00:00
                |---ts_ok: your_value
```
## 🧩 Features
### 📡 ESP32 Firmware
- **Real-time sensing:** 
  Temperature, humidity and pressure via BME280 sensor and concentration of CO2 via MQ-135 sensor
  
- **BAI (Biological Activity Index):** 
  Custom ripeness indicator calculated from MQ-135 baseline drift to detect avocado fermentation stages (Stable -> Maturation -> Fermentation alert)
  
- **Firebase Realtime Database:** 
  Live data pushed every 10 seconds to '/capteurs/module1/live' and timestamped history saved to 'capteurs/module1/historique'
  
- **Offline ring buffer:** 
  Up to 10 measurements stored locally wheb WiFi is unavailable, automatically synced to Firebase on reconnection
  
- **BLE notifications:** 
  JSON payload broadcast via Bluetooth Low Energy for direct mobile connection without WiFi (this wasn't implemented into the app)
  
- **Auto-reconnection:** 
   Automatic WiFi and Firebase reconnection on connection loss

### 📱 Application
#### Authentification
- **Login and registration:** 
  Email and password authentification via Firebase Auth with form validation, password visibility toggle and error feedback
- **Password reset:**
  Reset link sent by email directly from the login screen
- **Role selection:**
  User choose their profile (farmer or storage manager) at registration, editable from the profile screen

#### Home
- **Overview dashboard:**
  Summary card showing the monitor lot, sensor ID and live connection status at a glance
- **Quick navigation:**
  Direct access to history, lot report and the real-time module from the home screen
#### Real-time Module
- **Live sensor dashboard:** 
  Live display of temperature, humidity, CO2 and BAI mesurements received from the ESP32 via Firebase Realtime Database and updated according to a user-configured frequency
- **Configurable alert thresholds:**
  Custom max values per sensor (temperature, humidity, CO2); active alerts shown as an in-app banner with details on tap
- **Connection status indicator:**
  Live/Delayed/Offline badge reflecting the time elapsed since the last sensor measurement
- **Lot configuration:**
  Sensor ID, lot name, culture type, display frequency and alert thresholds saved in Firestore
#### History
- **Sensor charts:**
  Line charts for temperature, humidity and CO2 over 1 hour, 7 days or 30 days with a configurable alert threshold line
- **Statistics:**
  Min, max and average values computed for the selected sensor and period
- **Alert journal:**
  Chronological log of all past alerts with timestamp and details
#### Lot Report
- **30-day report:**
  Global risk score, sensor statistics and CSV export for the current period
- **Historical snapshots:**
  Visual silo timeline giving access to the 3 previous 30-day period reports
- **CSV export:**
  Full measurement history exportable for external analysis
#### Profile
- **Settings:**
  Dark mode and push notifications preferences saved to Firestore and applied app-wide
- **Multilingual support:**
  Full French and English translations throughout the app, switchable from user profile
- **Account management:**
  Email update with verification, password reset and role change from the profile screen
- **Quick access:**
  Shortcuts to the module, history and report pages

## 🛡️ Features of Firebase and Firestore
You need to secure your databases by adding rules.
Rules for Firestore:
```Bash
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
  	
    // Collection users - chaque utilisateur accède uniquement à son propre document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    
    	// Pour sauvegarder les alertes
      match /alertes/{alerteId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      // Pour sauvegarder l'historique des mesures
      match /mesures/{mesureId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```
Rules for Firebase:
```Bash
{
  "rules": {
    "capteurs": {
      "module1": {
        "live": {
          "$uid": {
            ".read": "auth != null && auth.uid === $uid",
            ".write": false
          }
        }
      }
    }
  }
}
```
