# Flutter Meets Go

A Flutter application that demonstrates how to integrate Go code with Flutter using Foreign Function Interface (FFI).

## Overview

<video src="https://github.com/user-attachments/assets/07530363-a811-44f5-a200-b4e1eb784413" width="30%" controls> </video>

This project showcases how to leverage Go's powerful features within a Flutter application through FFI (Foreign Function Interface). As a practical example, the app allows users to enter a GitHub username and fetch their profile avatar using a Go function that makes HTTP requests.

## How It Works

1. **Flutter UI**: The app provides a simple interface where users can enter a GitHub username and click a button to fetch the avatar.

2. **Go Backend**: A Go function (`GetGithubAvatar`) handles the HTTP request to GitHub's API to retrieve the user's avatar image.

3. **FFI Bridge**: Flutter communicates with the Go code through FFI, allowing seamless integration between the two languages.

## Technical Details

### Flutter Side
- Uses Dart FFI to call the compiled Go function
- Handles the UI and user interactions
- Processes and displays the returned image data

### Go Side
- Makes HTTP requests to GitHub's API
- Processes the response and extracts the avatar image
- Returns the image data back to Flutter

## Getting Started

### Prerequisites
- Flutter SDK
- Go compiler
- FFI package for Flutter
- Android NDK or Xcode for compilation

### Building the Go Library

#### For Android

First, create the necessary jniLibs directories if they don't exist:

```bash
mkdir -p android/app/src/main/jniLibs/arm64-v8a
mkdir -p android/app/src/main/jniLibs/armeabi-v7a
mkdir -p android/app/src/main/jniLibs/x86
mkdir -p android/app/src/main/jniLibs/x86_64
```

Then build for each architecture:

```bash
# For arm64
GOOS=android GOARCH=arm64 CGO_ENABLED=1 CC=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android21-clang go build -buildmode=c-shared -o android/app/src/main/jniLibs/arm64-v8a/github_avatar.so go_files/github_avatar.go

# For arm
GOOS=android GOARCH=arm CGO_ENABLED=1 CC=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/armv7a-linux-androideabi21-clang go build -buildmode=c-shared -o android/app/src/main/jniLibs/armeabi-v7a/github_avatar.so go_files/github_avatar.go

# For x86
GOOS=android GOARCH=386 CGO_ENABLED=1 CC=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/i686-linux-android21-clang go build -buildmode=c-shared -o android/app/src/main/jniLibs/x86/github_avatar.so go_files/github_avatar.go

# For x86_64
GOOS=android GOARCH=amd64 CGO_ENABLED=1 CC=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/x86_64-linux-android21-clang go build -buildmode=c-shared -o android/app/src/main/jniLibs/x86_64/github_avatar.so go_files/github_avatar.go
```

Note: The path to your NDK might be different. Adjust accordingly.

#### For iOS
```bash
go build -buildmode=c-archive -o ios/Runner/github_avatar.a go_files/github_avatar.go
```

After generating the `.a` file, you'll need to add it to your Xcode project:
1. Open the iOS project in Xcode
2. Drag the `github_avatar.a` and `github_avatar.h` files into your project
3. Add the library to "Link Binary With Libraries" in your target's Build Phases

#### For Linux/macOS/Windows Development
```bash
go build -buildmode=c-shared -o github_avatar.so go_files/github_avatar.go
```

### Running the Flutter App
1. Ensure the Go shared library is in the correct location
2. Run the Flutter app:
   ```
   flutter run
   ```

## Project Structure
- `lib/github_avatar.dart`: Contains the Dart FFI bindings to call the Go function
- `lib/main.dart`: The main Flutter application
- `go_files/github_avatar.go`: The Go code that fetches GitHub avatars

## Usage

```dart
// Import the GitHub avatar library
import 'github_avatar.dart';

// Fetch an avatar
final avatarBytes = GithubAvatar.getAvatar('username');

// Display it
if (avatarBytes.isNotEmpty) {
  Image.memory(avatarBytes)
}
```

## Performance Benefits

FFI provides several advantages over Method Channel:
- **Direct Memory Access**: No serialization/deserialization overhead
- **Reduced Context Switching**: Calls happen within the same thread context
- **Lower Latency**: Significantly faster for large data transfers like images
- **No Message Passing**: Avoids the overhead of passing messages between isolates

## License
This project is open source and available under the [MIT License](LICENSE).
