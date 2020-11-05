import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_rater/src/services/api.dart';

class AddReviewDialog extends StatefulWidget {
  final Api _api = Api();
  final int _movieId;

  AddReviewDialog(this._movieId);

  @override
  _AddReviewDialogState createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final TextEditingController _reviewCommentController = TextEditingController();
  double _rate = 0.0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Review',
      ),

      contentPadding: EdgeInsets.only(
          left: 25,
          right: 25,
          top: 20,
          bottom: 30
      ),

      content: Container(
        // color: Colors.red,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar(
                initialRating: 0,
                minRating: 0,
                maxRating: 5,
                itemCount: 5,
                direction: Axis.horizontal,
                glow: false,
                tapOnlyMode: false,
                itemBuilder: (BuildContext ctx, int index) {
                  return Icon(
                    Icons.star,
                    color: Colors.amberAccent,
                  );
                },

                onRatingUpdate: (double rating) {
                  _rate = rating;
                }
            ),


            SizedBox(
              height: 15,
            ),


            SizedBox(
              width: MediaQuery.of(context).size.width * 2 / 3,
              height: 120,
              child: TextField(
                scrollPhysics: BouncingScrollPhysics(),
                controller: this._reviewCommentController,
                maxLines: null,
                minLines: null,
                expands: true,

                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    hintText: 'Comment',
                    filled: true
                ),
              ),
            ),
          ],
        ),
      ),

      actions: [
        InkWell(
          child: Text(
            'cancel',
          ),

          onTap: (this._isLoading) ? null : () {
            this._reviewCommentController.clear();
            Navigator.of(context).pop();
          },
        ),

        RaisedButton(
          color: Colors.blueAccent,
          disabledColor: Colors.blueAccent,

          child: (this._isLoading)
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Add',
                ),

          onPressed: (this._isLoading) ? null : () async {
            setState(() {this._isLoading = !this._isLoading;});
            await widget._api.addReview(
              widget._movieId,
              _rate.toInt(),
              comment: this._reviewCommentController.text
            );

            setState(() {this._isLoading = !this._isLoading;});
            this._reviewCommentController.clear();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
