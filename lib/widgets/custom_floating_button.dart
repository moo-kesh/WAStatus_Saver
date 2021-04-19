import 'package:flutter/material.dart';

class CustomFloatingButton extends StatelessWidget {
  CustomFloatingButton(
      {@required this.label,
      @required this.icon,
      @required this.activeColor,
      @required this.borderRadius});
  final String label;
  final IconData icon;
  final Color activeColor;
  final BorderRadius borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: activeColor, borderRadius: borderRadius),
      padding: EdgeInsets.all(9),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
          ),
          Icon(
            icon,
            color: Colors.white,
            size: 25,
          ),
        ],
      ),
    );
  }
}
