import 'package:flutter/material.dart';
import 'package:movie_rater/src/services/auth.dart';


class SettingPage extends StatelessWidget {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Profile'
        ),

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),

          onPressed: () => _onBack(context),
        ),
      ),


      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              this._auth.user.username,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            SizedBox(
              height: 15,
            ),

            Text(
              this._auth.user.email,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87
              ),
            ),

            SizedBox(
              height: 60,
            ),

            RaisedButton(
              child: Text(
                'Sign Out',
              ),

              onPressed: () => _onSignOut(context, this._auth),
            ),
          ],
        ),
      ),
    );
  }


  void _onBack(BuildContext context) {
    Navigator.of(context).pop();
  }


  void _onSignOut(BuildContext context, Auth auth) async {
    await auth.logout();
    Navigator.of(context).pop();
  }
}
