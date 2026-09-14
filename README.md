# Netflix like movie discovery App

A Netflix-inspired movie discovery app built by using Flutter.


## What you can do

- Browse trending movies
- Explore popular movies
- See movies currently playing
- Browse top-rated movies
- Search for movies
- View upcoming movies
- Switch between different sections of the app
- Select a profile
- Explore the Downloads and More sections

Movie data on the Home, Search, and Coming Soon screens comes from the TMDB API.

## Screens

The app contains:
- Splash Screen
- Profile Selection
- Home
- Search
- Coming Soon
- Downloads
- More Screen

## Built with

- Flutter & Dart
- BLoC / Cubit
- Dio
- TMDB API
- cached_network_image
- Equatable

## Project Structure

I kept the project separated into a few simple layers so that UI, API calls, and data handling don't get mixed together.

lib/
├── app/
├── core/
│   ├── config/
│   ├── network/
│   └── theme/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── screens/
│   ├── coming_soon/
│   ├── downloads/
│   ├── home/
│   ├── more/
│   ├── profiles/
│   ├── search/
│   └── splash/
├── shared/
└── main.dart

This is how the data flows
Screen
  ↓
Cubit
  ↓
Repository
  ↓
API Service
  ↓
TMDB API

This keeps the API and business logic outside the UI code.

TMDB API : The following TMDB endpoints are used:

/trending/movie/week
/movie/popular
/movie/now_playing
/movie/top_rated
/movie/upcoming
/search/movie

The API key is passed at runtime instead of being stored directly in the source code.

Getting Started
1. Clone the project
git clone https://github.com/BHIMNATH/netflix_clone.git
cd netflix_clone
2. Install dependencies
flutter pub get
3. Run the app

Add your TMDB API key when running:

flutter run --dart-define=TMDB_API_KEY=YOUR_TMDB_API_KEY
4. Build APK
flutter build apk --release --dart-define=TMDB_API_KEY=YOUR_TMDB_API_KEY

The APK will be generated at:

build/app/outputs/flutter-apk/app-release.apk
A few implementation details
Search

Search uses a short debounce before making an API request. This prevents an API call from being made for every character typed.

State handling

The API-driven screens handle:
- Loading
- Success
- Error
- Empty results
- Refresh
- Images

Movie posters and backdrops are loaded from TMDB using cached_network_image, with fallback handling when an image isn't available.

Why I built it this way - The goal was to keep the implementation straightforward while still following a structure that can be extended later.

For example, adding pagination, movie details, watchlists, authentication, or downloads can be done without putting all of the logic inside the screen widgets.

Running the project

Make sure you have:

Flutter installed
Android Studio / Android SDK
A TMDB API key

Then:

flutter pub get
flutter run --dart-define=TMDB_API_KEY=YOUR_TMDB_API_KEY
Disclaimer

This project was created for a machine test / educational purpose. Movie data and images are provided by TMDB. This project is not affiliated with or endorsed by Netflix.


### I would use this one

It is **shorter, natural, and believable**. It explains the important engineering decisions without sounding like you're trying to impress the reviewer with unnecessary terminology.

