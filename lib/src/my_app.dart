import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movie_rater/src/pages/sign_in_page.dart';
import 'package:movie_rater/src/pages/home_page.dart';
import 'package:movie_rater/src/services/auth.dart';
import 'package:movie_rater/src/pages/loading_page.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (BuildContext ctx, Auth auth, Widget child) {
        return FutureBuilder(
          future: auth.refresh(),
          builder: (BuildContext ctx, AsyncSnapshot asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.none) {
              return Container();
            } else if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage();
            } else {
              if (asyncSnapshot.hasData) {
                // debugPrint('MYAPP: ' + asyncSnapshot.data.toString());
                return HomePage();
              } else {
                return SignInPage();
              }
            }
          },
        );
      },
    );
  }
}