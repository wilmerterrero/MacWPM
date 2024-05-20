# MacWPM

MacWPM is a Mac OS menubar app that displays the current words per minute (WPM) of the user. It is designed to be used while typing to help users improve their typing speed.

## Distribution

### Build and Notarize

To build and notarize the app, run the following command in the root directory of the project:

```bash
fastlane macos notarized
```

### Generate appcast.xml

Run generate_appcast tool from Sparkle’s distribution archive specifying the path to the folder with update archives. Allow it to access the Keychain if it asks for it (it’s needed to generate signatures in the appcast).

```bash
./bin/generate_appcast /path/to/your/updates_folder/
```