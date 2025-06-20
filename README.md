# Suvidha Software Solutions — Interview Project

This Flutter project was created as part of an interview task. It demonstrates user authentication using an API, state management using MVVM + Provider, persistent login storage, and location fetching using Google Maps and GPS.

---

## 🔑 Features

- ✅ **User Sign-In API Integration**
  - Uses a POST API to authenticate the user.
  - Parses and displays user details on the profile screen after successful login.

- 📍 **Current Location Fetching**
  - Uses the `geolocator` package to get the user's GPS location.
  - Captures latitude, longitude, and check-in time during login.
  - Location is saved using `SharedPreferences`.

- 🗺️ **Google Maps Integration (Extendable)**
  - Framework is ready for map display using `google_maps_flutter`.
  - Location markers and routes can be visualized using polylines (code structure included).

---

## 🏛️ Architecture

- MVVM Pattern (Model-View-ViewModel)
- `provider` for state management
- `shared_preferences` for local storage
- Clean separation of core services, models, views, and business logic

---

## 📱 Screens

### 1. **Sign-In Screen**
- Input: Email and Password
- Button: Sign In
- Displays error message on failure

### 2. **Profile Screen**
- Displays:
  - Full Name
  - Email
  - Phone
  - Role
  - Branch ID
  - Location ID
  - Financial Year ID
  - Latitude & Longitude
  - Check-in Time

---

## 🚀 Getting Started

### ✅ Prerequisites
- Flutter 3.22.4 or higher
- Android SDK 33 or above
- Enable location permissions on device/emulator
