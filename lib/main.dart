import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_rater/src/my_app.dart';
import 'package:movie_rater/src/pages/review_page.dart';
import 'package:movie_rater/src/pages/setting_page.dart';
import 'package:movie_rater/src/services/auth.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Movie Rater',
      home: ChangeNotifierProvider<Auth>(
        create: (BuildContext context) => Auth(),
        child: MyApp(),
      ),

      initialRoute: '/',
      routes: {
        '/main': (context) => MyApp(),
        '/setting': (context) => SettingPage(),
        '/review': (context) => ReviewPage(),
      },
    ),
  );
}



