import 'package:flutter/material.dart';
import 'package:movie_rater/src/services/api.dart';

class AddMovieDialog extends StatefulWidget {
  final Api _api = Api();

  @override
  _AddMovieDialogState createState() => _AddMovieDialogState();
}

class _AddMovieDialogState extends State<AddMovieDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _movieTitleController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
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

          onTap: (this._isLoading) ? null : () {
            this._movieTitleController.clear();
            Navigator.of(context).pop();
          },
        ),

        RaisedButton(
          color: Colors.blueAccent,
          disabledColor: Colors.blueAccent ,

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
            if (_formKey.currentState.validate()) {
              setState(() {this._isLoading = !this._isLoading;});
              await widget._api.addMovie(this._movieTitleController.text);
              this._movieTitleController.clear();
              setState(() {this._isLoading = !this._isLoading;});
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
