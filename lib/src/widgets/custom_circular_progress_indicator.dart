import 'package:flutter/material.dart';


class CustomCircularProgressIndicator extends StatelessWidget {
  final String label;

  CustomCircularProgressIndicator(
      {
        @required this.label,
      }
      ): assert(label != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(150),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            semanticsLabel: this.label,
          ),

          SizedBox(
            height: 30,
          ),

          Text(
            this.label,
            style: TextStyle(
                fontSize: 16
            ),
          ),
        ],
      ),
    );
  }
}

