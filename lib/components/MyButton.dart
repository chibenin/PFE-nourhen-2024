import 'package:flutter/material.dart';
class MyButton extends StatelessWidget {

  final Function()? onTap;
  final String text;
  final Color? color;
  const MyButton({super.key, required this.onTap, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal:30 ),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),

          ),),
      ),
    );
  }
}
