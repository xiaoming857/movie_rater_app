import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:movie_rater/models/user.dart';
import 'package:movie_rater/services/auth.dart';

class ApiService{
  // Singleton
  static final ApiService _apiService = ApiService._internal();
  factory ApiService() {return _apiService;}
  ApiService._internal();

  Auth auth = Auth();


  final String _baseUrl = 'http://10.0.2.2:8080';


  Future<List<dynamic>> getMovie() async {
    var response = await http.get(
        _baseUrl + '/movies',
        headers: {
          HttpHeaders.authorizationHeader: auth.token,
        }
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      debugPrint(data.toString());
      return data;
    }

    return [];
  }

  Future<void> addMovie(String title) async {
    var response = await http.post(
      _baseUrl + '/movie',
      headers: {
        HttpHeaders.authorizationHeader: auth.token,
      },

      body: <String, String>{
        'title': title,
      },
    );
  }

  Future<List<dynamic>> getReview(int movieId) async {
    var response = await http.get(
      this._baseUrl + '/reviews/' + movieId.toString(),
      headers: {
        HttpHeaders.authorizationHeader: this.auth.token,
      }
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      debugPrint(data.toString());
      return data;
    }

    return [];
  }

  Future<void> addReview(int movieId, double rating, {String comment}) async {
    String url = this._baseUrl + '/review/' + movieId.toString();

    var response = await http.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: this.auth.token,
      },

      body: {
        'rating': rating.toString(),
        'comment': comment,
      }
    );
  }
}