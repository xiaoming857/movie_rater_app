class Review {
  int _id;
  int _rating;
  String _comment;
  String _username;

  Review(this._id, this._rating, this._comment, this._username);

  int get id => _id;
  int get rating => _rating;
  String get comment => _comment;
  String get username => _username;

  factory Review.fromMap(Map<String, dynamic> data) {
    if (data != null && data.containsKey('ID') && data.containsKey('Rating') && data.containsKey('Comment') && data.containsKey('Username')) {
      return Review(
        data['ID'],
        data['Rating'],
        data['Comment'],
        data['Username'],
      );
    }

    return null;
  }


}