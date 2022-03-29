import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  const WideButton(
      {Key? key,
      required this.width,
      required this.text,
      required this.color,
      required this.action})
      : super(key: key);

  final double width;
  final String text;

  final Color color;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
      // Text(text,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400),),)
      width: width / 1.2,
      height: width / 9,
      child: TextButton(
        onPressed: action,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
