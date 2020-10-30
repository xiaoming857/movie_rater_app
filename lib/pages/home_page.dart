import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_rater/services/api_service.dart';
import 'package:movie_rater/pages/setting_page.dart';
import 'package:movie_rater/pages/review_page.dart';

class HomePage extends StatefulWidget {
  final ApiService api = ApiService();
  final Function refresh;


  HomePage(this.refresh);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _movieTitle = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _onSettingPage() async {
    bool result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext ctx) {
        return SettingPage();
      }
    ));

    if (result) {
      widget.refresh();
    }
  }


  void _addMovie() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add movie',
          ),

          content: Form(
            key: this._formKey,
            child: TextFormField(
              controller: this._movieTitle,
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
                this._movieTitle.clear();
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
                  await widget.api.addMovie(this._movieTitle.text);
                  this._movieTitle.clear();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: _onSettingPage,
          )
        ],
      ),

      body: FutureBuilder(
        future: widget.api.getMovie(),
        builder: (BuildContext ctx, AsyncSnapshot snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            if (snapShot.hasData) {
              return ListView.builder(
                  itemCount: snapShot.data.length,
                  itemBuilder: (BuildContext ctx, int index) {

                    return Card(
                      child: ListTile(
                        title: Text(
                          snapShot.data[index]['Title'],
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              snapShot.data[index]['AvgRating'].toString(),
                            ),

                            Icon(
                              Icons.star,
                              color: Colors.amberAccent,
                            ),
                          ],
                        ),

                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext ctx) {
                              return ReviewPage(snapShot.data[index]);
                            }
                          ));

                          setState(() {});
                        },
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

        tooltip: 'Add Movie',

        onPressed: this._addMovie,
      ),
    );
  }
}
