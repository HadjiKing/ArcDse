# ArcDse

ArcDse is a free and open-source dental clinic management system. It supports patient management, appointment scheduling, photo attachments, multiple doctors, multiple users, offline operation, multi-device synchronization, multi-lingual support, secure access, and backups.

This project is based on and developed from [apexo](https://github.com/elselawi/apexo).

## Technology Stack

This project uses [Dart](https://github.com/dart-lang/sdk) and [Flutter](https://github.com/flutter/flutter) to run on multiple platforms from a single codebase. The design language is [Microsoft FluentUI](https://developer.microsoft.com/en-us/fluentui#/), as implemented by [Bruno D'Luka](https://github.com/bdlukaa).

The backend is [Pocketbase](https://pocketbase.io/). A cleanly installed Pocketbase instance with super-user credentials is enough to run this application — the application creates all required collections and values on first login.

## Available Platforms

- **Windows**: Supported
- **Android**: Supported
- **Web**: Partial support (photo uploading not yet supported)
- **iOS**: Planned
- **macOS**: Planned

## Features

- Patient management
- Appointment scheduling with calendar view
- Photo attachments per patient
- Multiple doctors support
- Multiple user accounts
- Offline-first with sync across devices
- Multi-lingual (RTL/LTR support)
- Backups
- Statistics and dashboards
- Lab work tracking
- Expense tracking
- Notes

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.4.4)
- [Dart SDK](https://dart.dev/get-dart) (>= 3.4.4)
- A running [Pocketbase](https://pocketbase.io/) instance

### Installation

```bash
# Clone the repository
git clone https://github.com/HadjiKing/ArcDse.git
cd ArcDse

# Install dependencies
flutter pub get

# Run the application
flutter run
```

### Building

```bash
flutter build windows
flutter build apk
flutter build web
```

## Contributing

All contributions are welcome, whether as a PR or issue. Please adhere to GitHub community standards.

## License

GNU General Public License v3.0. See [LICENSE.md](LICENSE.md) for details.
