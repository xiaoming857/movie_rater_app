import 'dart:io';

import 'package:flutter/material.dart';

import 'package:movie_rater/pages/sign_up_page.dart';
import 'package:movie_rater/services/auth.dart';
import 'package:movie_rater/widgets/error_alert.dart';

class SignInPage extends StatefulWidget {
  final Auth auth = Auth();
  final Function refresh;

  SignInPage(this.refresh);

  @override
  _SignInPageState createState() => _SignInPageState();
}


class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  bool _isLoading = false;


  void _onSignIn(BuildContext context) async {
    String errorTitle;
    String errorMessage;

    try {
      if (this._formKey.currentState.validate()) {
        setState(() {
          this._isLoading = true;
        });

        if (await widget.auth.login(this._email.text, this._password.text)) {
          widget.refresh();
        }
      }
    } on SocketException catch (error) {
      errorTitle = error.message;
      errorMessage = error.osError.message;
      debugPrint(error.toString());
    } on HttpException catch (error) {
      errorTitle = 'Http Exception';
      errorMessage = error.message;
      debugPrint(error.toString());
    } catch (error) {
      errorTitle = 'Unknown Error';
      errorMessage = error.toString();
      debugPrint(error.toString());
    }

    if (errorTitle != null && errorMessage != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorAlert(errorTitle, errorMessage);
          }
      );
    }


    setState(() {
      this._isLoading = false;
    });
  }

  void _onCreateNewAccountPage() async {
    bool isSuccess = await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext ctx) {
        return SignUpPage();
      }
    ));

    debugPrint(isSuccess.toString());

    if (isSuccess) {
      widget.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Movie Rater',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),


                    SizedBox(
                      height: MediaQuery.of(context).size.height / 7,
                    ),


                    Form(
                      key: this._formKey,
                      autovalidate: true,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 3 / 4,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _email,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Email is empty';
                                }

                                return null;
                              },

                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (String value) {
                                FocusScope.of(context).requestFocus(this._passwordFocus);
                              },

                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Email',
                              ),
                            ),


                            SizedBox(
                              height: 15,
                            ),


                            TextFormField(
                              obscureText: true,
                              controller: _password,
                              focusNode: this._passwordFocus,
                              onFieldSubmitted: (String value) => this._onSignIn(context),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Password is empty';
                                }

                                return null;
                              },

                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Password',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),


                    SizedBox(
                      height: 60,
                    ),


                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40,
                      child: RaisedButton(
                        child: Text(
                          'Sign In',
                        ),
                        onPressed: () => _onSignIn(context),
                      ),
                    ),


                    SizedBox(
                      height: 10,
                    ),


                    InkWell(
                      child: Text(
                        'or create a new account',
                      ),
                      onTap: _onCreateNewAccountPage,
                    ),
                  ],
                ),
              ),
            ),

            if (this._isLoading)
              Container(
                color: Colors.white.withAlpha(100),
                child: Center(
                  child: CircularProgressIndicator(
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
