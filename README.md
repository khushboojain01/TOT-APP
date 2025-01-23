# TOT (Tales Of Tails) APP: Dog Information Application

## Overview
TOT (Tales Of Tails) App is a Flutter-based mobile application that provides comprehensive information about dogs. The app leverages the FreeTestAPI for Dogs to fetch and display detailed dog information, with features including dog listing, detailed views, search functionality, and local dog saving capabilities.

## Features
- Fetch and display a list of dogs from the Dog API
- Detailed dog information screen
- Search dogs by name or breed
- Save favorite dogs to local database
- View saved dogs list

## Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- Internet connection

## Installation

### Clone the Repository
```bash
git clone https://github.com/khushboojain01/TOT-APP.git
cd tot-app
```

### Install Dependencies
```bash
flutter pub get
```

### Run the App
```bash
flutter run
```

## Project Structure
The project follows a standard Flutter structure:

```
tot-app/
│
├── lib/
│   ├── models/
│   │   └── dog_model.dart
│   ├── screens/
│   │   ├── dog_list_screen.dart
│   │   ├── dog_detail_screen.dart
│   │   ├── search_screen.dart
│   │   └── saved_dogs_screen.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   └── database_service.dart
│   └── main.dart
│
├── test/
├── android/
├── ios/
└── README.md
```

## Screenshots
![TOT](lib/image results)

## API Used
[FreeTestAPI for Dogs](https://freetestapi.com/apis/dogs)

## Database
Local storage implemented using SQLite for saving favorite dogs.

## Dependencies
- `http`: API calls
- `provider`: State management
- `sqflite`: Local database
- `cached_network_image`: Image caching

## Contribution
1. Fork the repository
2. Create your feature branch 
3. Commit your changes
4. Push to the branch 
5. Open a Pull Request

## License
Distributed under the MIT License.
