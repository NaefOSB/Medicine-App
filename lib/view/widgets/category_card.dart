import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';

class CustomCard extends StatelessWidget {
  final String name;
  final String imgPath;
  final String imgPathTag;
  final Function onTap;
  final bool isImageFromInternet;

  CustomCard(
      {this.name, this.imgPath, this.onTap,this.imgPathTag, this.isImageFromInternet = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: InkWell(
            onTap: onTap,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3.0,
                        blurRadius: 5.0)
                  ],
                  color: Colors.white,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (isImageFromInternet)
                          ? CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: imgPath,
                              height: 55.0,
                              width: 55.0,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Hero(
                              tag: imgPathTag,
                              child: Container(
                                  height: 55.0,
                                  width: 55.0,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(imgPath),
                                          fit: BoxFit.contain)))),
                      SizedBox(height: 7.0),
                      CustomText(
                        title: name,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: secondColor,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 5.0),
                        fontFamily: 'Cairo',
                      )
                    ]))));
  }
}
