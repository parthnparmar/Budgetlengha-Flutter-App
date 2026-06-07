# Budgetlengha Flutter App

Flutter mobile app converted from the PHP/Bootstrap website.

## Setup

### 1. Create Flutter Project

```bash
# Run from c:\xampp\htdocs\300WEB\
flutter create --org com.budgetlengha budgetlengha_flutter
# Then copy all files from budgetlengha_app/lib/ into budgetlengha_flutter/lib/
# Copy pubspec.yaml content into the new project's pubspec.yaml
# Copy assets/ folder
```

### OR — Use this folder directly

```bash
cd budgetlengha_app
flutter pub get
flutter run
```

> **Note:** Flutter requires a `pubspec.yaml` at the project root with a valid Flutter SDK. If running `flutter run` here fails, create a new Flutter project and copy the `lib/` contents + merge the `pubspec.yaml`.

---

## Android Internet Permission

Add to `android/app/src/main/AndroidManifest.xml` inside `<manifest>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

---

## Image URLs

Products load images from your local XAMPP server. The app uses:
- `http://10.0.2.2:3000/` — Android emulator address for localhost

For a real device on the same Wi-Fi, replace `10.0.2.2` with your machine's local IP (e.g. `192.168.1.x`).

---

## Screens

| Screen | Matches Website Page |
|--------|---------------------|
| HomeScreen | `index1.php` — hero section |
| ProductsScreen | `index2.php` — product grid with category filter |
| CartScreen | `mycart.php` — cart table, quantity, remove, checkout |
| SignInScreen | `signin.php` |
| SignUpScreen | `signup1.php` (User Sign Up) |
| AboutScreen | `about.php` |
| ServicesScreen | `service.php` |
| ContactScreen | `html/contact.html` |

## Color Theme

| Color | Hex | Usage |
|-------|-----|-------|
| Primary | `#a83f39` | Buttons, titles, accents |
| Accent | `#ff9800` | Logo border, hover |
| Dark | `#333333` | Navbar, footer |
| Background | `#f9f9f9` | Page backgrounds |
