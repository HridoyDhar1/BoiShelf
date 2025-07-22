# 📚 BoiShelf

**BoiShelf** is a Flutter-powered marketplace where users can **buy and sell books (old or new), notes, and educational materials**—just like a social platform. It integrates Firebase, machine learning, and geolocation to provide a seamless, intelligent, and user-friendly experience.

---

## 🚀 Features

### 🔐 Authentication
- Login, Signup, Forget Password, OTP Verification
- Firebase Authentication with secure validation

### 🏠 Main Screens
- **Home** – View recently listed books and recommendations
- **Explore** – Discover books based on categories, filters, and trends
- **Sell** – Upload books and notes with details, images, and auto-fill features
- **Profile** – Manage user details, listings, and preferences

### 🤖 Smart Features
- **Book Condition Detection** – Uses ML model (TFLite) to detect physical condition (torn cover, bent corners, spots)
- **Auto Book Info Extraction** – Automatically detects book name and author via OCR (Text Recognition)

### 📍 Location
- Integrated geolocation to show nearby book listings

### 💬 Social + Chat
- Users can post listings like a social media feed
- Chat with buyers/sellers using real-time messaging

### 💰 Payments
- (Optional/Future) Secure payment system integration to handle book transactions

---

## 🛠️ Tech Stack

| Layer               | Tools Used                          |
|---------------------|-------------------------------------|
| **Frontend**        | Flutter, Dart                       |
| **Architecture**    | BLoC, GetX (Hybrid State Management)|
| **Backend**         | Firebase Firestore, Auth, Storage   |
| **ML Integration**  | TFLite, TextRecognizer (OCR)        |
| **Real-time Chat**  | Firebase Firestore                  |
| **Geolocation**     | Geolocator, Google Maps             |
| **Image Handling**  | Image Picker, Camera, File Upload   |

---

## 📸 Screenshots

| Login | Home | Video Playback |
|-------|------|----------------|
> _Coming Soon_ – Add GIFs or screenshots of your app in action here to attract users and contributors.

---


## ⚙️ Architecture

The app uses a hybrid **GetX + BLoC** architecture for optimized modularity, readability, and separation of concerns.

##🧠 Future Plans
✅ Push Notifications (Firebase Cloud Messaging)
✅ Book Delivery Tracking
✅ In-app Video Preview for Book Condition
✅ Stripe/RazorPay Payment Gateway




##⭐ Show Your Support
Give a ⭐️ if you like the project and want to support it!

## ⚙️ How to Run

1. **Clone the repo**
 
```bash
git clone https://github.com/yourusername/UIPtv.git
cd UIPtv
flutter pub get
flutter run

##Directory structure:


└── hridoydhar1-boishelf.git/
    ├── README.md
    ├── analysis_options.yaml
    ├── devtools_options.yaml
    ├── firebase.json
    ├── pubspec.lock
    ├── pubspec.yaml
    ├── .metadata
    ├── android/
    │   ├── build.gradle.kts
    │   ├── gradle.properties
    │   ├── settings.gradle.kts
    │   ├── app/
    │   │   ├── build.gradle.kts
    │   │   ├── google-services.json
    │   │   └── src/
    │   │       ├── debug/
    │   │       │   └── AndroidManifest.xml
    │   │       ├── main/
    │   │       │   ├── AndroidManifest.xml
    │   │       │   ├── kotlin/
    │   │       │   │   └── com/
    │   │       │   │       └── example/
    │   │       │   │           └── book/
    │   │       │   │               └── MainActivity.kt
    │   │       │   └── res/
    │   │       │       ├── drawable/
    │   │       │       │   └── launch_background.xml
    │   │       │       ├── drawable-v21/
    │   │       │       │   └── launch_background.xml
    │   │       │       ├── values/
    │   │       │       │   └── styles.xml
    │   │       │       └── values-night/
    │   │       │           └── styles.xml
    │   │       └── profile/
    │   │           └── AndroidManifest.xml
    │   └── gradle/
    │       └── wrapper/
    │           └── gradle-wrapper.properties
    ├── assets/
    │   └── mobilenetv2.tflite
    ├── ios/
    │   ├── Podfile
    │   ├── Flutter/
    │   │   ├── AppFrameworkInfo.plist
    │   │   ├── Debug.xcconfig
    │   │   └── Release.xcconfig
    │   ├── Runner/
    │   │   ├── AppDelegate.swift
    │   │   ├── Info.plist
    │   │   ├── Runner-Bridging-Header.h
    │   │   ├── Assets.xcassets/
    │   │   │   ├── AppIcon.appiconset/
    │   │   │   │   └── Contents.json
    │   │   │   └── LaunchImage.imageset/
    │   │   │       ├── README.md
    │   │   │       └── Contents.json
    │   │   └── Base.lproj/
    │   │       ├── LaunchScreen.storyboard
    │   │       └── Main.storyboard
    │   └── RunnerTests/
    │       └── RunnerTests.swift
    ├── lib/
    │   ├── firebase_options.dart
    │   ├── main.dart
    │   ├── navigation.dart
    │   ├── core/
    │   │   ├── config/
    │   │   │   ├── app_route.dart
    │   │   │   ├── controller_binding.dart
    │   │   │   └── navigation_controller.dart
    │   │   ├── service/
    │   │   │   └── book_condtion_detecrot.dart
    │   │   ├── utils/
    │   │   │   ├── tensor_utils.dart
    │   │   │   └── tflte_helper.dart
    │   │   └── widget/
    │   │       ├── book_details.dart
    │   │       ├── book_iteam.dart
    │   │       ├── custom_passwordfield.dart
    │   │       └── custom_textfield.dart
    │   └── feature/
    │       ├── Auth/
    │       │   ├── data/
    │       │   │   └── model/
    │       │   │       └── user_model.dart
    │       │   └── presentation/
    │       │       ├── controller/
    │       │       │   └── auth_controller.dart
    │       │       ├── screen/
    │       │       │   ├── create_profile.dart
    │       │       │   ├── forget.dart
    │       │       │   ├── log.dart
    │       │       │   ├── login_screen.dart
    │       │       │   ├── reset.dart
    │       │       │   ├── signup_screen.dart
    │       │       │   ├── singup.dart
    │       │       │   └── verification.dart
    │       │       └── widget/
    │       │           └── social_icon.dart
    │       ├── Chat/
    │       │   └── presentation/
    │       │       ├── chat_list.dart
    │       │       └── chat_screen.dart
    │       ├── explore/
    │       │   ├── data/
    │       │   │   └── model/
    │       │   │       ├── book_model.dart
    │       │   │       └── model.dart
    │       │   └── presentation/
    │       │       ├── screen/
    │       │       │   └── explore_screen.dart
    │       │       └── widget/
    │       │           └── new_books.dart
    │       ├── home/
    │       │   ├── data/
    │       │   │   └── model/
    │       │   │       └── seller_model.dart
    │       │   └── presentation/
    │       │       ├── screen/
    │       │       │   └── home_screen.dart
    │       │       └── widget/
    │       │           ├── book_card.dart
    │       │           ├── bookpost_card.dart
    │       │           ├── card.dart
    │       │           ├── map.dart
    │       │           └── top_seller.dart
    │       ├── profile/
    │       │   └── presentation/
    │       │       └── screen/
    │       │           ├── edit_profile.dart
    │       │           └── profile_screen.dart
    │       ├── Saved/
    │       │   └── presentaion/
    │       │       ├── controller/
    │       │       │   └── book_controller.dart
    │       │       └── screen/
    │       │           └── save_screen.dart
    │       └── sell/
    │           ├── data/
    │           │   └── book_condition.dart
    │           ├── helper/
    │           │   └── tflite_helper.dart
    │           └── presentation/
    │               ├── controller/
    │               │   ├── book_condition.dart
    │               │   └── book_controller.dart
    │               ├── screen/
    │               │   └── sell_book.dart
    │               └── widget/
    │                   ├── drop_down.dart
    │                   ├── map.dart
    │                   ├── submit_button.dart
    │                   └── text_field.dart
    ├── linux/
    │   ├── CMakeLists.txt
    │   ├── flutter/
    │   │   ├── CMakeLists.txt
    │   │   ├── generated_plugin_registrant.cc
    │   │   ├── generated_plugin_registrant.h
    │   │   └── generated_plugins.cmake
    │   └── runner/
    │       ├── CMakeLists.txt
    │       ├── main.cc
    │       ├── my_application.cc
    │       └── my_application.h
    ├── macos/
    │   ├── Podfile
    │   ├── Flutter/
    │   │   ├── Flutter-Debug.xcconfig
    │   │   ├── Flutter-Release.xcconfig
    │   │   └── GeneratedPluginRegistrant.swift
    │   ├── Runner/
    │   │   ├── AppDelegate.swift
    │   │   ├── DebugProfile.entitlements
    │   │   ├── Info.plist
    │   │   ├── MainFlutterWindow.swift
    │   │   ├── Release.entitlements
    │   │   ├── Assets.xcassets/
    │   │   │   └── AppIcon.appiconset/
    │   │   │       └── Contents.json
    │   │   ├── Base.lproj/
    │   │   │   └── MainMenu.xib
    │   │   └── Configs/
    │   │       ├── AppInfo.xcconfig
    │   │       ├── Debug.xcconfig
    │   │       ├── Release.xcconfig
    │   │       └── Warnings.xcconfig
    │   └── RunnerTests/
    │       └── RunnerTests.swift
    ├── test/
    │   └── widget_test.dart
    ├── web/
    │   ├── index.html
    │   └── manifest.json
    └── windows/
        ├── CMakeLists.txt
        ├── flutter/
        │   ├── CMakeLists.txt
        │   ├── generated_plugin_registrant.cc
        │   ├── generated_plugin_registrant.h
        │   └── generated_plugins.cmake
        └── runner/
            ├── CMakeLists.txt
            ├── flutter_window.cpp
            ├── flutter_window.h
            ├── main.cpp
            ├── resource.h
            ├── runner.exe.manifest
            ├── Runner.rc
            ├── utils.cpp
            ├── utils.h
            ├── win32_window.cpp
            └── win32_window.h



   
 

            


