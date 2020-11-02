import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_rater/src/models/movie.dart';
import 'package:movie_rater/src/models/review.dart';
import 'package:movie_rater/src/models/user.dart';
import 'package:movie_rater/src/services/auth.dart';

import '../models/user.dart';

class Api {
  /// Singleton
  static final Api _apiService = Api._internal();
  factory Api() {return _apiService;}
  Api._internal();

  final Auth _auth = Auth();


  /// Get movies from the server
  Future<List<Movie>> getMovies() async {
    List<Movie> movies = [];
    try {
      var response = await http.get(
          this._auth.baseUrl + '/movies',
          headers: {
            HttpHeaders.authorizationHeader: this._auth.prefix + this._auth.user.accessToken,
          }
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException(
            'Can not establish connection to server!',
            Duration(seconds: 15),
          );
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> rawData = json.decode(response.body);
        if (rawData != null && rawData.isNotEmpty) {
          rawData.forEach((element) {
            if (element != null && element.containsKey('ID') && element.containsKey('Title') && element.containsKey('AvgRating')) {
              movies.add(Movie.fromMap(element));
            }
          });
        }


      } else if (response.statusCode == 401) {
        User user = await this._auth.refresh();
        if (user != null) {
          movies = await this.getMovies();
        }
      } else {
        debugPrint('GETMOVIES ERROR: ' + json.decode(response.body).toString());
      }
    } on TimeoutException catch (e) {
      debugPrint('GETMOVIES: ' + e.toString());
    } catch (e) {
      debugPrint('GETMOVIES EXCEPTION: ' + e.toString());
    }

    return movies;
  }


  /// Add a movie to the server
  Future<void> addMovie(String title) async {
    try {
      var response = await http.post(
        this._auth.baseUrl + '/movie',
        headers: {
          HttpHeaders.authorizationHeader: this._auth.prefix + this._auth.user.accessToken,
        },

        body: <String, dynamic>{
          'title': title,
        },
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException(
            'Can not establish connection to server!',
            Duration(seconds: 15),
          );
        },
      );

      if (response.statusCode == 401) {
        User user = await this._auth.refresh();
        if (user != null) {
          this.addMovie(title);
        }
      }
    } on TimeoutException catch (e) {
      debugPrint('ADDMOVIE: ' + e.toString());
    } catch (e) {
      debugPrint('ADDMOVIE Exception: ' + e.toString());
    }
  }


  /// Get reviews from the server
  Future<List<Review>> getReviews(int movieId) async {
    List<Review> reviews = [];
    if (movieId != null) {
      try {
        var response = await http.get(
            this._auth.baseUrl + '/reviews/' + movieId.toString(),
            headers: {
              HttpHeaders.authorizationHeader: this._auth.prefix + this._auth.user.accessToken,
            }
        ).timeout(
          Duration(seconds: 15),
          onTimeout: () {
            throw TimeoutException(
              'Can not establish connection to server!',
              Duration(seconds: 15),
            );
          },
        );


        if (response.statusCode == 200) {
          List<dynamic> rawData = json.decode(response.body);
          if (rawData != null && rawData.isNotEmpty) {
            rawData.forEach((element) {
              if (element != null && element.containsKey('ID') && element.containsKey('Rating') && element.containsKey('Comment') && element.containsKey('Username')) {
                reviews.add(Review.fromMap(element));
              }
            });
          }
        } else if (response.statusCode == 401) {
          User user = await this._auth.refresh();
          if (user != null) {
            reviews = await this.getReviews(movieId);
          }
        }
      } on TimeoutException catch (e) {
        debugPrint('GETREVIEW: ' + e.toString());
      } catch (e) {
        debugPrint('GETREVIEW Exception: ' + e.toString());
      }
    }

    return reviews;
  }


  /// Add a review to the server
  Future<void> addReview(int movieId, int rating, {String comment}) async {
    try {
      String url = this._auth.baseUrl + '/review/' + movieId.toString();

      var response = await http.post(
          url,
          headers: {
            HttpHeaders.authorizationHeader: this._auth.prefix + this._auth.user.accessToken,
          },

          body: {
            'rating': rating.toString(),
            'comment': comment,
          }
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException(
            'Can not establish connection to server!',
            Duration(seconds: 15),
          );
        },
      );

      if (response.statusCode == 401) {
        User user = await this._auth.refresh();
        if (user != null) {
          this.addReview(movieId, rating, comment: comment);
        }
      }
    } on TimeoutException catch (e) {
      debugPrint('ADDREVIEW: ' + e.toString());
    } catch (e) {
      debugPrint('ADDREVIEW EXCEPTION: ' + e.toString());
    }
  }
}