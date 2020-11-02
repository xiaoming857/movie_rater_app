import 'package:flutter/material.dart';

class User {
  final String _username;
  final String _email;
  String _accessToken;
  String _refreshToken;

  User(this._accessToken, this._refreshToken, this._username, this._email);


  String get username => _username;
  String get email => _email;
  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;


  void updateTokens(Map<String,dynamic> tokens) {
    if (tokens != null && tokens.containsKey('accessToken') && tokens.containsKey('refreshToken')) {
      this._accessToken = tokens['accessToken'];
      this._refreshToken = tokens['refreshToken'];
    }
  }

  factory User.fromMap(Map<String, dynamic> data) {
    if (data != null && data.containsKey('accessToken') && data.containsKey('refreshToken') && data.containsKey('username') && data.containsKey('email')) {
      return User(
        data['accessToken'],
        data['refreshToken'],
        data['username'],
        data['email'],
      );
    }

    return null;
  }


  factory User.empty() {
    return null;
  }


  Map<String, dynamic> toMap() {
    return {
      'accessToken': this._accessToken,
      'refreshToken': this._refreshToken,
      'username': this._username,
      'email': this._email,
    };
  }

  @override
  String toString() {
    return {
      'accessToken': this._accessToken,
      'refreshToken': this._refreshToken,
      'username': this._username,
      'email': this._email,
    }.toString();
  }
}