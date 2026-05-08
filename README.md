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

## 🧩 Features
