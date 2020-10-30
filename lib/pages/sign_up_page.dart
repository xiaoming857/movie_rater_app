import 'package:flutter/material.dart';
import 'package:movie_rater/services/auth.dart';

class SignUpPage extends StatefulWidget {
  Auth auth = Auth();

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  void _clear() {
    this._username.clear();
    this._email.clear();
    this._password.clear();
    this._confirmPassword.clear();
  }

  void _onSignUp() async {
    if (_formKey.currentState.validate()) {
      await widget.auth.register(this._username.text, this._email.text, this._password.text);
      Navigator.of(context).pop(true);
    }
  }


  void _onBackToSignInPage() {
    Navigator.of(context).pop(false);
  }


  void _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),

        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create New Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87
                  ),
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
                          controller: _username,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (String value) {
                            this._nextFocus(this._emailFocus);
                          },

                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Username is empty';
                            } else if (value.length < 3) {
                              return 'Username is too short (min 3 characters)';
                            }

                            return null;
                          },

                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Username',
                          ),
                        ),


                        SizedBox(
                          height: 15,
                        ),


                        TextFormField(
                          controller: _email,
                          focusNode: this._emailFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (String value) {
                            this._nextFocus(this._passwordFocus);
                          },

                          validator: (String value) {
                            RegExp regExp = RegExp('^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$');
                            if (value.isEmpty) {
                              return 'Email is empty';
                            } else if (!regExp.hasMatch(value)) {
                              return 'Invalid email format';
                            }

                            return null;
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
                          controller: _password,
                          focusNode: this._passwordFocus,
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          onFieldSubmitted: (String value) {
                            this._nextFocus(this._confirmPasswordFocus);
                          },

                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Password is empty';
                            } else if (value.length < 8) {
                              return 'Password is too short (min 8 characters)';
                            }

                            return null;
                          },

                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Password',
                          ),
                        ),


                        SizedBox(
                          height: 15,
                        ),


                        TextFormField(
                          controller: _confirmPassword,
                          focusNode: this._confirmPasswordFocus,
                          obscureText: true,
                          onFieldSubmitted: (String value) => this._onSignUp(),

                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Password is empty';
                            } else if (value != this._password.text) {
                              return 'Invalid passwords confirmation';
                            }

                            return null;
                          },

                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Confirm Password',
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
                              'Sign Up',
                            ),
                            onPressed: _onSignUp,
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),


                        InkWell(
                          child: Text(
                            'already has an account? Sign In',
                          ),
                          onTap: _onBackToSignInPage,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
