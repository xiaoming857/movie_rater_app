import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:movie_rater/src/models/movie.dart';
import 'package:movie_rater/src/models/review.dart';
import 'package:movie_rater/src/services/api.dart';
import 'package:movie_rater/src/widgets/custom_circular_progress_indicator.dart';
import 'package:movie_rater/src/popup_dialogs/add_review_dialog.dart';


class ReviewPage extends StatefulWidget {
  final Api _api = Api();
  final Movie _movie;

  ReviewPage(this._movie);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Timer _timer;
  int _itemNum;

  @override
  void initState() {
    super.initState();
    this._setAutoRefresh(widget._movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    this._timer.cancel();
    this._timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget._movie.title,
        ),

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),

          onPressed: _onBack,
        ),
      ),

      body: FutureBuilder(
        future: widget._api.getReviews(widget._movie.id),
        builder: (BuildContext context, AsyncSnapshot<List<Review>> asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.done) {
            if (asyncSnapshot.hasData && asyncSnapshot.data.isNotEmpty) {
              this._itemNum = asyncSnapshot.data.length;
              return RefreshIndicator(
                onRefresh: this._onRefresh,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics (
                    parent: BouncingScrollPhysics(),
                  ),

                  itemCount: asyncSnapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                asyncSnapshot.data[index].username,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87
                                ),
                              ),
                            ),

                            RatingBarIndicator(
                              itemCount: 5,
                              itemSize: 20,
                              rating: asyncSnapshot.data[index].rating.toDouble(),
                              itemBuilder: (BuildContext ctx, int index) {
                                return Icon(
                                  Icons.star,
                                  color: Colors.amberAccent,
                                );
                              },
                            ),
                          ],
                        ),

                        subtitle: Text(
                          asyncSnapshot.data[index].comment,
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.black87
                          ),
                        ),
                      ),
                    );
                  }
                ),
              );
            }

            return Center(
              child: Text(
                'No Data',
              ),
            );
          }

          return Center(
            child: CustomCircularProgressIndicator(
              label: 'Retrieving Reviews',
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),

        tooltip: 'Add Review',

        onPressed: () => this._onAddReview(widget._movie),
      ),
    );
  }

  Future<void> _onRefresh() {
    return Future(
            () {
          setState(() {});
        }
    );
  }

  void _setAutoRefresh(int movieId) {
    this._timer = Timer.periodic(
      Duration(
        seconds: 15,
      ),

      (Timer timer) async {
        if (this._itemNum != (await widget._api.getReviews(movieId)).length) {
          setState(() {});
        }
      }
    );
  }

  void _onBack() {
    Navigator.of(context).pop();
  }

  void _onAddReview(Movie _movie) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AddReviewDialog(_movie.id);
      }
    );

    setState(() {});
  }
}
