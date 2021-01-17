import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:movie_rater/src/models/user.dart';
import 'package:movie_rater/src/services/login_data_storage.dart';

class Auth with ChangeNotifier {
  static final Auth _auth = Auth._instance();
  factory Auth() {
    return _auth;
  }
  Auth._instance();


  // final String baseUrl = 'http://10.0.2.2:8080/api';
  final String baseUrl = 'https://test.crazyming.xyz/api';
  final String _prefix = 'Bearer ';
  final LoginDataStorage _loginDataStorage = LoginDataStorage();
  User _user;


  User get user => _user;
  String get prefix => _prefix;


  Future<User> refresh() async {
    String url = this.baseUrl + '/refresh';
    try {
      Map<String, dynamic> storedData = await this._loginDataStorage.retrieve();
      if (storedData.isEmpty) {
        return null;
      }

      if (this._user == null) {
        this._user = User.fromMap(storedData);
      }

      http.Response response = await http.get(
          url,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + this._user.refreshToken,
          }
      ).timeout(
          Duration(seconds: 15),
          onTimeout: () {
            throw TimeoutException(
              'Can not establish connection to server!',
              Duration(seconds: 15),
            );
          }
      );


      Map<String, dynamic> result = json.decode(response.body);
      if (response.statusCode == 200) {
        this._user.updateTokens(result);
        this._loginDataStorage.updateTokens(result);
        return this._user;
      } else if (response.statusCode == 401) {
        this.logout();
        notifyListeners();
        debugPrint('Refresh token expired');
      } else {
        debugPrint('REFRESH ERROR: ' + result.toString());
      }
    } on TimeoutException catch (e) {
      // this.logout();
      // notifyListeners();
      debugPrint('REFRESH EXCEPTION: ' + e.toString());
    } catch (e) {
      debugPrint('REFRESH EXCEPTION: ' + e.toString());
    }

    return this._user;
  }


  Future<void> login(String email, String password) async {
    String url = this.baseUrl + '/login';
    try {
      http.Response response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      ).timeout(
          Duration(seconds: 15),
          onTimeout: () {
            throw TimeoutException(
              'Can not establish connection to server!',
              Duration(seconds: 15),
            );
          }
      );

      Map<String, dynamic> result = json.decode(response.body);
      if (response.statusCode == 200) {
        this._user = User.fromMap(result);
        this._loginDataStorage.store(result);
        notifyListeners();
      } else {
        debugPrint('LOGIN ERROR: ' + result.toString());
      }
    } catch (e) {
      debugPrint('LOGIN EXCEPTION: ' + e.toString());
    }
  }


  Future<void> register([String username, String email, String password]) async {
    String url = this.baseUrl + '/register';
    try {
      var response = await http.post(
          url,
          body: {
            "username": username,
            "email": email,
            "password": password,
          }
      ).timeout(
          Duration(seconds: 15),
          onTimeout: () {
            throw TimeoutException(
              'Can not establish connection to server!',
              Duration(seconds: 15),
            );
          }
      );

      Map<String, dynamic> result = json.decode(response.body);
      if (response.statusCode == 200) {
        this._user = User.fromMap(result);
        this._loginDataStorage.store(result);
        notifyListeners();
      } else {
        debugPrint('REGISTER ERROR: ' + result.toString());
      }
    } catch (e) {
      debugPrint('REGISTER EXCEPTION: ' + e.toString());
    }
  }


  Future<void> logout() async {
    this._user = User.empty();
    this._loginDataStorage.clearAll();
    notifyListeners();
  }
}