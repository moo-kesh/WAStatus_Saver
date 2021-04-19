import 'package:flutter/material.dart';

class NoStatusesWidget extends StatelessWidget {
  NoStatusesWidget({@required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(
        Icons.warning_amber_rounded,
        size: 50,
        color: Colors.greenAccent,
      ),
      Text(
        text,
        style: TextStyle(color: Colors.grey, fontSize: 20),
      ),
    ]);
  }
}
