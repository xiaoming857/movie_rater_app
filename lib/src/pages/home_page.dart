import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_rater/src/models/movie.dart';
import 'package:movie_rater/src/services/api.dart';
import 'package:movie_rater/src/widgets/custom_circular_progress_indicator.dart';
import 'package:movie_rater/src/pages/review_page.dart';


class HomePage extends StatefulWidget {
  final Api _api = Api();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _movieTitleController = TextEditingController();
  Timer _timer;
  int _itemNum;

  @override
  void initState() {
    super.initState();
    this._setAutoRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    this._timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movie Rater"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: _openSettingPage,
          )
        ],
      ),

      body: FutureBuilder(
        future: widget._api.getMovies(),
        builder: (BuildContext ctx, AsyncSnapshot<List<Movie>> asyncSnapShot) {
          if (asyncSnapShot.connectionState == ConnectionState.done) {
            if (asyncSnapShot.hasData) {
              this._itemNum = asyncSnapShot.data.length;
              return RefreshIndicator(
                onRefresh: this._onRefresh,
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),

                    itemCount: asyncSnapShot.data.length,
                    itemBuilder: (BuildContext ctx, int index) {

                      return Card(
                        child: ListTile(
                          title: Text(
                            asyncSnapShot.data[index].title,
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                asyncSnapShot.data[index].avgRating.toString(),
                              ),

                              Icon(
                                Icons.star,
                                color: Colors.amberAccent,
                              ),
                            ],
                          ),

                          onTap: () => this._openMovieReview(asyncSnapShot.data[index]),
                        ),
                      );
                    }
                ),
              );
            }

            return Container();
          }

          return Center(
            child: CustomCircularProgressIndicator(
              label: 'Retrieving Movies',
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),

        tooltip: 'Add Movie',

        onPressed: this._onAddMovie,
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


  void _setAutoRefresh() {
    this._timer = Timer.periodic(
      Duration(
        seconds: 15,
      ),

      (Timer timer) async {
        if (this._itemNum != (await widget._api.getMovies()).length) {
          setState(() {});
        }
      }
    );
  }


  void _openSettingPage() async {
    this._timer.cancel();
    await Navigator.of(context).pushNamed('/setting');
    setState(() {});
    this._setAutoRefresh();
  }

  void _openMovieReview(Movie movie) async {
    this._timer.cancel();
    await Navigator.of(context).push(
      MaterialPageRoute(
        maintainState: false,
        builder: (_) {
          return ReviewPage(movie);
        }
      )
    );

    setState(() {});
    this._setAutoRefresh();
  }

  void _onAddMovie() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Add movie',
            ),

            content: Form(
              key: this._formKey,
              child: TextFormField(
                controller: this._movieTitleController,
                autofocus: true,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Title is empty';
                  } else if (value.length < 3) {
                    return 'Title is too short (min 3 characters)';
                  }

                  return null;
                },

                decoration: InputDecoration(
                  hintText: 'Title',
                ),
              ),
            ),

            actions: [
              InkWell(
                child: Text(
                  'cancel',
                ),

                onTap: () {
                  this._movieTitleController.clear();
                  Navigator.of(context).pop();
                },
              ),

              RaisedButton(
                color: Colors.blueAccent,

                child: Text(
                  'Add',
                ),

                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await widget._api.addMovie(this._movieTitleController.text);
                    this._movieTitleController.clear();
                    setState(() {});
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        }
    );
  }
}

