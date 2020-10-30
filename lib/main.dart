import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

import 'package:movie_rater/services/auth.dart';
import 'package:movie_rater/pages/sign_in_page.dart';
import 'package:movie_rater/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: "Movie Rater",
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  final Auth auth = Auth();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.auth.isLoggedIn(),
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.data) {
              return SignInPage(refresh);
          }

          return HomePage(refresh);
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
