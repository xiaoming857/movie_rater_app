import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_rater/services/auth.dart';

class SettingPage extends StatefulWidget {
  final Auth auth = Auth();

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void _onBack() {
    Navigator.of(context).pop(false);
  }


  void _onSignOut() async {
    await widget.auth.logout();
    Navigator.of(context).pop(true);
  }

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

          onPressed: _onBack,
        ),
      ),


      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.auth.currentUser.username,
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
              widget.auth.currentUser.email,
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

              onPressed: _onSignOut,
            ),
          ],
        ),
      ),
    );
  }
}
