import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

// Update typedefs to match the new Go function signature
typedef GetGithubAvatarNative = Pointer<Void> Function(
    Pointer<Utf8> username, Pointer<Int32> length);
typedef GetGithubAvatarDart = Pointer<Void> Function(
    Pointer<Utf8> username, Pointer<Int32> length);

class GithubAvatar {
  static final DynamicLibrary _lib = DynamicLibrary.open('github_avatar.so');

  static final GetGithubAvatarDart _getGithubAvatar = _lib
      .lookupFunction<GetGithubAvatarNative, GetGithubAvatarDart>('GetGithubAvatar');

  static Uint8List getAvatar(String username) {
    final usernamePointer = username.toNativeUtf8();
    final lengthPointer = calloc<Int32>();

    try {
      final resultPointer = _getGithubAvatar(usernamePointer, lengthPointer);
      final length = lengthPointer.value;

      if (length <= 0 || resultPointer == nullptr) {
        return Uint8List(0);
      }

      // Convert the raw bytes to Uint8List
      final Uint8List bytes = resultPointer.cast<Uint8>().asTypedList(length);
      return Uint8List.fromList(bytes); // Create a copy of the data

    } finally {
      calloc.free(usernamePointer);
      calloc.free(lengthPointer);
    }
  }
}
