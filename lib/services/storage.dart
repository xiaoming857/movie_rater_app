import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


/// Storage is used to store data inside a secured local storage. The data stored
/// is in a key and value pairs, key being a [String] and value being [dynamic].
/// It is noted that the storage is [static] and the data stored should be remembered
/// to avoid memory waste. The data can be cleared only with the [clear] method.
class Storage{
  /// Instantiate a secured local storage
  static final _storage = FlutterSecureStorage();

  /// Store data into a secured local storage
  static void store(Map<String, dynamic> map) {
    try {
      map.forEach((key, value) async {
          await _storage.write(key: key, value: value);
        },
      );
    } catch (error) {
      if (error == PlatformException) {
        debugPrint('Platform Exception Error: ' + error.toString());
      }

      debugPrint('Unknown Error: ' + error.toString());
    }
  }

  /// Retrieve the data from a secured local storage
  static Future<Map<String, dynamic>> retrieve() async {
    try {
      return await _storage.readAll();
    } catch (error) {
      if (error == PlatformException) {
        debugPrint('Platform Exception Error: ' + error.toString());
      }

      debugPrint('Unknown Error: ' + error.toString());
      return {};
    }
  }

  /// Clear all the data inside a secured local storage
  static Future<void> clear() async {
    try {
      await _storage.deleteAll();
    } catch (error) {
      if (error == PlatformException) {
        debugPrint('Platform Exception Error: ' + error.toString());
      }

      debugPrint('Unknown Error: ' + error.toString());
    }
  }

  @override
  String toString() {
    return Storage.retrieve().toString();
  }
}