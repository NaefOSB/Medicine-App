import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medicine_app/constant.dart';

class CustomImage extends StatelessWidget {
  final File image;
  final Function onTap;

  CustomImage({this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: InkWell(
        child: CircleAvatar(
          radius: 100,
          backgroundImage: (image == null) ? null : FileImage(image),
          backgroundColor: kPrimaryColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
