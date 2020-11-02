import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class LoginDataStorage {
  /// Instantiate a secured local storage
  FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Update access token
  void updateTokens(Map<String,dynamic> tokens) async {
    try {
      Map<String, dynamic> storedData = await this._storage.readAll();
      if (storedData.isNotEmpty && tokens != null && tokens.containsKey('accessToken') && tokens.containsKey('refreshToken')) {
        tokens.forEach((key, value) {
          this._storage.write(key: key, value: value);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Store data into a secured local storage
  void store(Map<String, dynamic> data) {
    try {
      if (data != null && data.containsKey('accessToken') && data.containsKey('refreshToken') && data.containsKey('username') && data.containsKey('email')) {
        data.forEach((key, value) {
          this._storage.write(key: key, value: value);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  /// Retrieve the data from a secured local storage
  Future<Map<String, dynamic>> retrieve() async {
    try {
      return await this._storage.readAll();
    } catch (e) {
      debugPrint(e.toString());
      return {};
    }
  }


  /// Clear all the data inside a secured local storage
  Future<void> clearAll() async {
    try {
      await this._storage.deleteAll();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}