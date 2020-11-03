import 'package:flutter/material.dart';
import 'package:movie_rater/src/services/auth.dart';
import 'package:movie_rater/src/validators/auth_validator.dart';

class SignInPage extends StatefulWidget {
  final Auth auth = Auth();

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with AuthValidator{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  final double _textFieldFontSize = 16;
  bool _hasFirstSubmit = false;
  bool _hidePassword = true;
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top);
    return Scaffold(
      backgroundColor: Colors.white,
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
                        height: height * 2 / 5,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Movie Rater',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),


                      SizedBox(
                        height: height * 3 / 5,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 4 / 5,
                            height: height * 1/2,
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),

                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(2,3),
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                  ),
                                ]
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87
                                    ),
                                  ),
                                ),

                                Form(
                                  key: this._formKey,
                                  autovalidate: this._hasFirstSubmit,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 70,
                                        child: TextFormField(
                                          controller: this._emailController,
                                          validator: validateEmail,
                                          textInputAction: TextInputAction.next,
                                          style: TextStyle(
                                              fontSize: this._textFieldFontSize
                                          ),

                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: this._textFieldFontSize),
                                            hintText: 'Email',
                                            prefixIcon: Icon(
                                              Icons.email,
                                            ),
                                          ),

                                          onFieldSubmitted: (String value) {
                                            FocusScope.of(context).requestFocus(this._passwordFocus);
                                          },
                                        ),
                                      ),



                                      SizedBox(
                                        height: 70,
                                        child: TextFormField(
                                          controller: this._passwordController,
                                          validator: validatePassword,
                                          focusNode: this._passwordFocus,
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

                                          onFieldSubmitted: (String value) => this._onLogin(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                                Column(
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
                                          'Login',
                                        ),

                                        onPressed: this._onLogin,
                                      ),
                                    ),


                                    SizedBox(
                                      height: 10,
                                    ),


                                    InkWell(
                                      child: Text(
                                        'or create a new account',
                                      ),
                                      onTap: _openSignUpPage,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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


  void _onLogin () async {
    setState(() {this._hasFirstSubmit = true;});
    if (this._formKey.currentState.validate()) {
      setState(() {this._isLoading = !this._isLoading;});
      await widget.auth.login(this._emailController.text, this._passwordController.text);
      setState(() {this._isLoading = !this._isLoading;});
    }
  }


  void _openSignUpPage () async {
    await Navigator.of(context).pushNamed('/signUp');
  }
}
