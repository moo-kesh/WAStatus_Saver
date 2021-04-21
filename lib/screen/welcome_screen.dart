import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:whatsapp_status/screen/home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 18,
          shadowColor: Colors.black,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.all(Radius.circular(25)),
                shape: BoxShape.rectangle),
            /*image: DecorationImage(
                        image: Image.asset('assets/graphics/app_icon_bg.png')
                            .image)),*/
            child: Hero(
              tag: 'appIcon',
              child: ImageIcon(
                Image.asset('assets/graphics/appbar_icon.png').image,
                color: Colors.white,
                size: 100,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          'WAStatus Saver',
          style: GoogleFonts.lato(
            fontSize: 40,
            color: Colors.greenAccent,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 40,
          width: 60,
          child: LoadingIndicator(
            indicatorType: Indicator.lineScalePulseOut,
            color: Colors.greenAccent,
          ),
        )
      ],
    )));
  }
}
