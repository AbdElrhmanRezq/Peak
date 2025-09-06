# 📱 PEAK – Fitness & Workout Tracker  

![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue?logo=flutter)
![Supabase](https://img.shields.io/badge/Supabase-Backend-brightgreen?logo=supabase)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Made with ❤️](https://img.shields.io/badge/Made%20with-%F0%9F%92%9C-red)

PEAK is a **fitness and workout tracking mobile application** built with **Flutter**.  
It helps users plan workouts, track progress, connect with friends, and stay motivated with personalized routines and summaries.  

The app integrates with **Supabase** for authentication and backend services, and uses **Riverpod** for efficient state management.  

---

## ✨ Features  

- 👤 **User Authentication** (Sign up, Login, Logout) via Supabase  
- 🏋️‍♂️ **Workout Management**  
  - Create custom workouts  
  - Search and select exercises  
  - View detailed exercise info  
  - Track workouts with live sessions  
  - Save and view summaries  
- 📊 **Progress Tracking**  
  - Streaks calendar (via Heatmap)  
  - Workout history and stats  
- 🔍 **Explore Section**  
  - Discover exercises  
  - View public workouts  
- 🤝 **Social Features**  
  - Add and manage friends  
  - View other users’ workouts  
- 🧑 **Profile Management**  
  - Edit profile and settings  
  - Track personal info (age, weight, height, gender)  
- 🎨 **Smooth UI/UX**  
  - Onboarding flow  
  - Splash and initial setup screens  
  - Custom theme and icons  

---

## 🛠️ Tech Stack  

**Frontend**  
- [Flutter](https://flutter.dev/) (Dart SDK ^3.8.1)  
- [Riverpod](https://riverpod.dev/) for state management  
- [Material Design](https://m3.material.io/) with custom themes  

**Backend & Services**  
- [Supabase](https://supabase.com/) for authentication & database  
- `.env` config for secure API keys  

**Libraries & Packages**  
- `supabase_flutter` – Supabase integration  
- `flutter_riverpod` & `riverpod` – state management  
- `flutter_dotenv` – environment variables  
- `cached_network_image` – image caching  
- `image_picker` & `image_cropper` – profile image handling  
- `smooth_page_indicator` – onboarding  
- `flutter_heatmap_calendar` – streak tracking  
- `http` – API requests  

---

## 🚀 Getting Started  

### Prerequisites  
- Flutter SDK (>=3.8.1) → https://docs.flutter.dev/get-started/install  
- Dart → https://dart.dev/get-dart  
- Supabase project (for API keys)  

### Setup  

1. Clone the repo  
```
git clone https://github.com/your-username/peak.git
cd peak
```

2. Install dependencies  
```
flutter pub get
```

3. Create a `.env` file in the project root and add your Supabase credentials  
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

4. Run the app  
```
flutter run
```

---

## 📸 Screenshots (Optional)  
_Add screenshots or GIFs of your app here to showcase UI._  

---

## 🔧 Configuration  

- Assets are stored under `assets/` (images, icons, gifs, fonts).  
- Custom font used: **Viga**.  
- App launcher icon configured with `flutter_launcher_icons`.  

---

## 👥 Contributing  

Contributions are welcome!  
To contribute:  
1. Fork the project  
2. Create a feature branch (`git checkout -b feature/new-feature`)  
3. Commit changes (`git commit -m 'Add new feature'`)  
4. Push to branch (`git push origin feature/new-feature`)  
5. Open a Pull Request  

---

## 📄 License  

This project is licensed under the MIT License.  
Feel free to use and modify it for personal projects.  
