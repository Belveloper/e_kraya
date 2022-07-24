import 'package:flutter/material.dart';



class ReusableCard extends StatelessWidget {
  final Color colour;
  final Widget child;
  ReusableCard({@required this.colour, this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: colour,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}