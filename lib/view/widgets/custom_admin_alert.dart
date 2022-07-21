import 'package:flutter/material.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';
import 'package:medicine_app/view/widgets/rectangle_button.dart';

class CustomAdminAlert extends StatelessWidget {
  final Function onPress1;
  final Function onPress2;
  final Function onPress3;

  CustomAdminAlert({this.onPress1, this.onPress2, this.onPress3});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        titlePadding: EdgeInsets.only(top: 10.0, left: 0, bottom: 0, right: 0),
        title: CustomText(
          title: 'نوع الحساب',
          alignment: Alignment.center,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              CustomText(
                title: 'الرجاء إختيار نوع الحساب :',
                alignment: Alignment.center,
              ),
            ],
          ),
        ),
        actions: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RectangleButton(
                  text: 'مورد',
                  press: onPress1,
                ),
                RectangleButton(
                  text: 'عميل',
                  press: onPress2,
                ),
                RectangleButton(
                  text: 'مدير',
                  press: onPress3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
