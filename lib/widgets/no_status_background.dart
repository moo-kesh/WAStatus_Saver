import 'package:flutter/material.dart';

class NoStatusesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      /*Container(
          height: 100,
          width: 100,
          child: Image.asset(
            'assets/graphics/folder.png',
          )),*/
      Icon(
        Icons.warning_amber_rounded,
        size: 50,
        color: Colors.greenAccent,
      ),
      Text(
        'Empty',
        style: TextStyle(color: Colors.grey, fontSize: 20),
      ),
    ]);
  }
}
