import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_rater/src/models/movie.dart';
import 'package:movie_rater/src/popup_dialogs/add_movie_dialog.dart';
import 'package:movie_rater/src/services/api.dart';
import 'package:movie_rater/src/widgets/custom_circular_progress_indicator.dart';
import 'package:movie_rater/src/pages/review_page.dart';


class HomePage extends StatefulWidget {
  final Api _api = Api();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    this._timer = null;
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
            if (asyncSnapShot.hasData && asyncSnapShot.data.isNotEmpty) {
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

            return Center(
              child: Text(
                'No Data'
              ),
            );
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

  void _onAddMovie() async {
    await showDialog(
      barrierDismissible: false,
      context: this.context,
      builder: (BuildContext context) {
        return AddMovieDialog();
      }
    );

    setState(() {});
  }
}

