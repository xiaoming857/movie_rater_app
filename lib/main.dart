import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_rater/src/my_app.dart';
import 'package:movie_rater/src/pages/setting_page.dart';
import 'package:movie_rater/src/services/auth.dart';
import 'package:movie_rater/src/pages/sign_up_page.dart';


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
        '/signUp': (context) => SignUpPage(),
      },
    ),
  );
}



