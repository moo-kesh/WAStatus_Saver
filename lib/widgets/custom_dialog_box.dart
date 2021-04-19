import 'package:flutter/material.dart';

class CustomDialogBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('How to use ?'),
            Text('1. Open WhatsApp app and watch some statuses'),
            Text('2. After that open WAStatus Saver app.'),
            ElevatedButton(onPressed: () {}, child: Text('Got it!'))
          ],
        ),
      ),
    );
  }
}
