# delphis_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Releasing ad hoc build
1) Ensure the environment is set properly (staging or production)
1) Ensure your provisioning profile for ad hoc has all required devices added to it through the apple developer console.
1) Ensure the provisioning profile is the ad hoc provisioning profile `ChathamAlpha Ad Hoc Provisioning` is the one I'm currently using.
1) Bump the version and / or build.
1) Click on archive and once archived use the `Validate` button
1) Once validated, click release. Ensure you setup the manifest build for OTA. The images don't really matter but set them so they actually resolve.
1) Upload the contents to an accessible location (e.g. s3).
1) Create a URL that looks like: `itms-services://?action=download-manifest&amp;url=https://static.chatham.ai/alpha/2020-05-08/manifest.plist` replacing the URL with the location you uploaded the data to.