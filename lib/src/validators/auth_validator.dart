class AuthValidator {
  /// Validate email
  String validateEmail(String email) {
    RegExp regExp = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b');

    if (email == null || email.isEmpty) {
      return 'Empty email!';
    } else if (!regExp.hasMatch(email)) {
      return 'Invalid email format!';
    } else {
      return null;
    }
  }

  /// Validate password
  String validatePassword(String password) {
    if (password == null || password.isEmpty) {
      return 'Empty password!';
    } else if (password.length < 8) {
      return 'Password is too short (at least 8 characters)';
    } else {
      return null;
    }
  }
}