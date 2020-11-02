class Movie {
  int _id;
  String _title;
  double _avgRating;

  Movie(this._id, this._title, this._avgRating);

  int get id => _id;
  double get avgRating => _avgRating;
  String get title => _title;

  factory Movie.fromMap(Map<String, dynamic> data) {
    if (data != null && data.containsKey('ID') && data.containsKey('Title') && data.containsKey('AvgRating')) {
      return Movie(
        data['ID'].toInt(),
        data['Title'],
        data['AvgRating'].toDouble(),
      );
    }

    return null;
  }
}