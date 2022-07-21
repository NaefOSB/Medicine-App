import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/about_store_view_model.dart';
import 'custom_text.dart';

class CustomAlertSwitch extends StatefulWidget {
  bool value;

  CustomAlertSwitch({this.value = true});

  @override
  _CustomAlertSwitchState createState() => _CustomAlertSwitchState();
}

class _CustomAlertSwitchState extends State<CustomAlertSwitch> {
  AboutStoreViewModel controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            SwitchListTile(
              value: widget.value,
              activeColor: kPrimaryColor,
              onChanged: (val) {
                setState(() {
                  widget.value = val;
                  controller.changeStoreBuyState(state: val);
                });
              },
              title: CustomText(
                title: 'تمكين / تعطل البيع',
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
