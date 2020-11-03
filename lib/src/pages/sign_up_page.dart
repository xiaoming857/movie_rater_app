import 'package:flutter/material.dart';
import 'package:movie_rater/src/services/auth.dart';
import 'package:movie_rater/src/validators/auth_validator.dart';

class SignUpPage extends StatefulWidget {
  final Auth _auth = Auth();

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with AuthValidator{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final double _textFieldFontSize = 16;
  bool _hasFirstSubmit = false;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isLoading = false;


  @override
  void dispose() {
    super.dispose();
    this._usernameController.dispose();
    this._emailController.dispose();
    this._passwordController.dispose();
    this._confirmPasswordController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),

        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 1 / 5,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'Create New Account',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87
                            ),
                          ),
                        ),
                      ),


                      SizedBox(
                        height: height * 3 / 5,
                        child: Form(
                          key: this._formKey,
                          autovalidate: this._hasFirstSubmit,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 3 / 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 70,
                                  child: TextFormField(
                                    controller: this._usernameController,
                                    validator: validateUsername,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(
                                      fontSize: this._textFieldFontSize,
                                    ),

                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(top: this._textFieldFontSize),
                                      hintText: 'Username',
                                      prefixIcon: Icon(
                                        Icons.person,
                                      ),
                                    ),

                                    onFieldSubmitted: (String value) {
                                      this._nextFocus(this._emailFocus);
                                    },
                                  ),
                                ),


                                SizedBox(
                                  height: 70,
                                  child: TextFormField(
                                    controller: this._emailController,
                                    validator: validateEmail,
                                    focusNode: this._emailFocus,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(
                                      fontSize: this._textFieldFontSize,
                                    ),

                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(top: this._textFieldFontSize),
                                      hintText: 'Email',
                                      prefixIcon: Icon(
                                        Icons.email,
                                      ),
                                    ),

                                    onFieldSubmitted: (String value) {
                                      this._nextFocus(this._passwordFocus);
                                    },
                                  ),
                                ),


                                SizedBox(
                                  height: 70,
                                  child: TextFormField(
                                    controller: this._passwordController,
                                    validator: validatePassword,
                                    focusNode: this._passwordFocus,
                                    textInputAction: TextInputAction.next,
                                    obscureText: this._hidePassword,
                                    style: TextStyle(
                                      fontSize: this._textFieldFontSize,
                                    ),

                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(top: this._textFieldFontSize),
                                      hintText: 'Password',
                                      prefixIcon: Icon(
                                        Icons.lock,
                                      ),

                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          (this._hidePassword) ? Icons.visibility_off : Icons.visibility,
                                        ),

                                        onPressed: () {
                                          setState(() {
                                            this._hidePassword = !this._hidePassword;
                                          });
                                        },
                                      ),
                                    ),

                                    onFieldSubmitted: (String value) {
                                      this._nextFocus(this._confirmPasswordFocus);
                                    },
                                  ),
                                ),


                                SizedBox(
                                  height: 70,
                                  child: TextFormField(
                                    controller: this._confirmPasswordController,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Password is empty';
                                      } else if (value != this._passwordController.text) {
                                        return 'Invalid passwords confirmation';
                                      }

                                      return null;
                                    },

                                    focusNode: this._confirmPasswordFocus,
                                    obscureText: this._hideConfirmPassword,
                                    style: TextStyle(
                                      fontSize: this._textFieldFontSize,
                                    ),

                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(top: this._textFieldFontSize),
                                      hintText: 'Confirm Password',
                                      prefixIcon: Icon(
                                        Icons.lock,
                                      ),

                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          (this._hideConfirmPassword) ? Icons.visibility_off : Icons.visibility,
                                        ),

                                        onPressed: () {
                                          setState(() {
                                            this._hideConfirmPassword = !this._hideConfirmPassword;
                                          });
                                        },
                                      ),
                                    ),

                                    onFieldSubmitted: (String value) => this._onLogUp(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),


                      SizedBox(
                        height: height * 1 / 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: RaisedButton(
                                color: Colors.blueAccent,
                                textTheme: ButtonTextTheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),

                                child: Text(
                                  'Log Up',
                                ),

                                onPressed: this._onLogUp,
                              ),
                            ),


                            SizedBox(
                              height: 10,
                            ),


                            InkWell(
                              child: Text(
                                'already has an account? Log In',
                              ),

                              onTap: this._onBackToSignInPage,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),


            if (this._isLoading)
              Container(
                color: Colors.white.withAlpha(150),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


  void _onLogUp() async {
    setState(() {this._hasFirstSubmit = true;});
    if (this._formKey.currentState.validate()) {
      setState(() {this._isLoading = !this._isLoading;});
      await widget._auth.register(this._usernameController.text, this._emailController.text, this._passwordController.text);
      setState(() {this._isLoading = !this._isLoading;});
      Navigator.of(context).pop();
    }
  }


  void _onBackToSignInPage() {
    Navigator.of(context).pop(false);
  }


  void _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }
}
