import 'package:flutter/material.dart';
import 'package:movie_rater/src/widgets/custom_circular_progress_indicator.dart';


class LoadingPage extends StatelessWidget {
  final String message;

  LoadingPage(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomCircularProgressIndicator(
                label: this.message,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
