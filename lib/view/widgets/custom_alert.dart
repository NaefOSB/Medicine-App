import 'package:flutter/material.dart';
import 'package:medicine_app/view/widgets/rectangle_button.dart';

import 'custom_text.dart';

class CustomAlert extends StatelessWidget {
  final String title;
  final Alignment titleAlignment;
  final Color titleColor;
  final String content;
  final Alignment contentAlignment;
  final Color contentColor;
  final double fontSize;
  final FontWeight titleFontWeight;
  final FontWeight fontWeight;
  final Function onPressed1;
  final Function onPressed2;
  final String firstButtonText;
  final String secondButtonText;
  final bool hasSecondButton;

  CustomAlert(
      {this.title = '',
      this.titleAlignment = Alignment.center,
      this.titleColor = Colors.black,
      this.content = '',
      this.contentAlignment,
      this.contentColor = Colors.black,
      this.fontSize,
      this.fontWeight,
      this.titleFontWeight,
      this.onPressed1,
      this.onPressed2,
      this.firstButtonText = 'إلغاء',
      this.secondButtonText = 'موافق',
      this.hasSecondButton = false});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: CustomText(
          title: title,
          alignment: titleAlignment,
          color: titleColor,
          fontWeight: titleFontWeight,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              CustomText(
                title: content,
                fontSize: fontSize,
                fontWeight: fontWeight,
                alignment: contentAlignment,
                color: contentColor,
              ),
            ],
          ),
        ),
        actions: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RectangleButton(
                  text: firstButtonText,
                  press: onPressed1,
                ),
                (hasSecondButton)
                    ? SizedBox(
                        width: 25.0,
                      )
                    : Container(),
                (hasSecondButton)
                    ? RectangleButton(
                        text: secondButtonText,
                        press: onPressed2,
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
