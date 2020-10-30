class User {
  String username;
  String email;

  User({this.username, this.email});

  // Get properties from map
  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      username: map["username"],
      email: map["email"],
    );
  }

  // Get map from properties
  Map<String, dynamic> toJson() {
    return {
      "username": this.username,
      "email": this.email,
    };
  }

  @override
  String toString() {
    return ("Username: " + this.username + "\nEmail: " + this.email);
  }
}