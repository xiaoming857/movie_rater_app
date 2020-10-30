import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:movie_rater/services/storage.dart';
import 'package:movie_rater/models/user.dart';

enum Status {
  LOGGED_IN,
  LOGGED_OUT
}

class Auth{
  // Singleton
  static final Auth _auth = Auth._instance();
  factory Auth() {
    return _auth;
  }
  Auth._instance();

  final String _baseUrl = 'http://10.0.2.2:8080';
  User _currentUser;
  String _token;

  String get token => _token;
  User get currentUser => _currentUser;

  // Check if status is logged in
  Future<bool> isLoggedIn() async {
    String url = _baseUrl + "/status";

    // Checks if storage is empty
    try {
      Map<String, dynamic> storedData = await Storage.retrieve();
      if (storedData.length == 0) {
        return false;
      }

      // Checks if token is still valid
      final response = await http.get(
          url,
          headers: {
            HttpHeaders.authorizationHeader: storedData["token"],
          }
      );

      // If status code is ok
      if (response.statusCode == 200) {
        this._token = storedData["token"];
        this._currentUser = User.fromJson({
          "username": storedData["username"],
          "email": storedData["email"],
        });

        return true;
      }

      this._token = storedData["token"];
    } on SocketException catch(e) {
      this.logout();
      debugPrint(e.toString());
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }

    return false;
  }

  // Login
  Future<bool> login(String email, String password) async {
    if (!await this.isLoggedIn()) {
        var response = await http.post(
            _baseUrl + "/login",
            body: {
              "email": email,
              "password": password,
            }
        );

        Map<String, dynamic> data = json.decode(response.body);
        if (response.statusCode == 200) {
          this._token = "Bearer " + data["token"];
          this._currentUser = User.fromJson({
            "username": data["username"],
            "email": data["email"]
          });

          Storage.store({
            "token": this._token,
            "username": data["username"],
            "email": data["email"],
          });

          return true;
        }

        debugPrint(response.headers.toString());
        if (data.containsKey('error')) {
          throw HttpException(response.statusCode.toString() + ': ' + data['error']);
        }
    }

    return false;
  }

  // Register
  Future<bool> register([String username, String email, String password]) async {
    if (!await this.isLoggedIn()) {
      var response = await http.post(
          _baseUrl + "/register",
          body: {
            "username": username,
            "email": email,
            "password": password,
          }
      );

      Map<String, dynamic> data = json.decode(response.body);
      if (response.statusCode == 200) {
        this._token = "Bearer " + data["token"];
        this._currentUser = User.fromJson({
          "username": data["username"],
          "email": data["email"],
        });

        Storage.store({
          "token": this._token,
          "username": data["username"],
          "email": data["email"],
        });

        return true;
      }

      debugPrint(response.headers.toString());
      if (data.containsKey('error')) {
        throw HttpException(response.statusCode.toString() + ': ' + data['error']);
      }
    }

    return false;
  }

  Future<void> logout() async {
    await Storage.clear();
    this._token = null;
    this._currentUser = null;
  }
}