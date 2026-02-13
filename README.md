# Bubbl Flutter SDK Example App

Public barebones Flutter example for Bubbl SDK integration.

This example is aligned with:
- `guides/flutter-sdk/quickstart.md`
- `guides/flutter-sdk/method-reference.md`
- `guides/flutter-sdk/usage-examples.md`
from `bubbl-docs-redocly`.

## What this app demonstrates

The method playground calls every `BubblFlutterSdk` API from the method reference:

- streams (`notificationEvents`, `geofenceEvents`, `deviceLogEvents`)
- boot/init and permissions
- tracking/campaign APIs
- segmentation/correlation APIs
- configuration/privacy APIs
- event/CTA/survey APIs
- tenant config APIs
- diagnostics/log APIs and utilities

## Setup

1. Replace placeholders in:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
2. Set Maps key:

```bash
export GOOGLE_MAPS_API_KEY=your-key
```

3. Install packages:

```bash
flutter pub get
```

## Test

```bash
flutter test
```

