import 'package:flutter/material.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';

class CustomFloatingButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  CustomFloatingButton({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: kPrimaryColor,
      // child: Icon(Icons.home),
      child: CustomText(
        title: text,
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        alignment: Alignment.center,
      ),
    );
  }
}
