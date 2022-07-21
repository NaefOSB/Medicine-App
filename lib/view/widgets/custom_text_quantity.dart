import 'package:flutter/material.dart';
import 'package:medicine_app/constant.dart';

class CustomTextQuantity extends StatelessWidget {
  final TextEditingController controller;
  final Function onChange;
  final String hintText;

  CustomTextQuantity({this.controller, this.onChange, this.hintText});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(color: fourthColor)),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: controller,
        maxLength: 4,
        onChanged: onChange,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }
}
