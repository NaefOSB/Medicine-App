import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/category_view_model.dart';
import 'package:medicine_app/view/widgets/custom_image.dart';
import 'package:medicine_app/view/widgets/rounded_button.dart';
import 'package:medicine_app/view/widgets/rounded_text_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ManageCategory extends GetWidget<CategoryViewModel> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<CategoryViewModel>(builder: (controller)=>ModalProgressHUD(
      inAsyncCall: controller.manageCategoryPageIsLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text('إضافة قسم'),
          centerTitle: true,
        ),
        body: Form(
          key: controller.formKey,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.1, vertical: size.height * 0.02),
            child: ListView(
              children: [
                CustomImage(image: controller.image,onTap:()=> controller.getImage(),),
                SizedBox(
                  height: size.height * 0.14,
                ),
                RoundedTextField(
                  hintText: 'اسم القسم',
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'الرجاء إدخال أسم لهذا القسم !!';
                    }
                  },
                  icon: Icons.category,
                  controller: controller.categoryController,
                ),
                RoundedButton(
                  text: 'حفظ القسم',
                  fontSize: 15.0,
                  press: () {
                    controller.validate();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
