import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/about_store_view_model.dart';
import 'package:medicine_app/model/abot_store_model.dart';
import 'package:medicine_app/view/widgets/rounded_button.dart';
import 'package:medicine_app/view/widgets/rounded_text_field.dart';
import 'package:medicine_app/view/widgets/rounded_text_field_area.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditAboutStore extends GetWidget<AboutStoreViewModel> {
  final AboutStoreModel model;

  EditAboutStore({this.model});

  @override
  Widget build(BuildContext context) {
    if (controller.isFirst) {
      controller.setValueToEachController(model: model);
    }
    return GetBuilder<AboutStoreViewModel>(
      builder: (controller) => ModalProgressHUD(
        inAsyncCall: controller.isLoading,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text('إدارة تعرفة الشركة',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: fourthColor,
                      fontWeight: FontWeight.bold)),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: fourthColor,
                ),
                onPressed: () => Get.back(),
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
              centerTitle: true,
            ),
            body: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedTextFieldArea(
                      icon: Icons.description,
                      hintText: 'الوصف',
                      controller: controller.description,
                    ),
                    RoundedTextFieldArea(
                      icon: Icons.location_on_outlined,
                      hintText: 'العنوان',
                      controller: controller.address,
                    ),
                    RoundedTextFieldArea(
                      icon: Icons.comment_bank_outlined,
                      hintText: 'الحسابات المصرفية',
                      controller: controller.bankAccounts,
                    ),
                    RoundedTextField(
                      icon: Icons.phone_android,
                      hintText: 'رقم الجوال 1',
                      keyboardType: 'number',
                      controller: controller.phoneNumber1,
                    ),
                    RoundedTextField(
                      icon: Icons.phone_android,
                      hintText: 'رقم الجوال 2 (خياري)',
                      keyboardType: 'number',
                      controller: controller.phoneNumber2,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) =>
                          controller.updateData(storeId: model.storeId),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RoundedButton(
                      text: 'حــفــظ',
                      press: () =>
                          controller.updateData(storeId: model.storeId),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
