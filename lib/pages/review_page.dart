import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:movie_rater/services/api_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewPage extends StatefulWidget {
  final ApiService _api = ApiService();
  final Map<String, dynamic> _movieData;

  ReviewPage(this._movieData);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _reviewComment = TextEditingController();

  void _onBack() {
    Navigator.of(context).pop();
  }


  void _addReview() {
    double rate = 0.0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  tapOnlyMode: true,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Icon(
                      Icons.star,
                      color: Colors.amberAccent,
                    );
                  },

                  onRatingUpdate: (double rating) {
                    rate = rating;
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
                    controller: this._reviewComment,
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

              onTap: () {
                this._reviewComment.clear();
                Navigator.of(context).pop();
              },
            ),

            RaisedButton(
              color: Colors.blueAccent,

              child: Text(
                'Add',
              ),

              onPressed: () async {
                await widget._api.addReview(
                  widget._movieData['ID'],
                  rate,
                  comment: this._reviewComment.text
                );

                setState(() {});
                this._reviewComment.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget._movieData['Title'],
        ),

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),

          onPressed: _onBack,
        ),
      ),

      body: FutureBuilder(
        future: widget._api.getReview(widget._movieData['ID']),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.done) {
            if (asyncSnapshot.hasData) {
              return ListView.builder(
                  itemCount: asyncSnapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                asyncSnapshot.data[index]['Username'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87
                                ),
                              ),
                            ),

                            RatingBarIndicator(
                              itemCount: 5,
                              itemSize: 20,
                              rating: asyncSnapshot.data[index]['Rating'].toDouble(),
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
                          asyncSnapshot.data[index]['Comment'],
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.black87
                          ),
                        ),
                      ),
                    );
                  }
              );
            }

            return Container();
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),

        tooltip: 'Add Review',

        onPressed: this._addReview,
      ),
    );
  }
}
