import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/single_store_category_view_model.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';
import 'package:medicine_app/view/widgets/rectangle_button.dart';
import 'package:medicine_app/view/widgets/rounded_text_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CustomSingleStoreCategory extends StatelessWidget {
  String state;
  String categoryId;

  CustomSingleStoreCategory({this.state = 'ADD', this.categoryId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SingleStoreCategoryViewModel>(
      init: SingleStoreCategoryViewModel(),
      builder: (controller) => ModalProgressHUD(
        inAsyncCall: controller.isLoading,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: CustomText(
              title: (state == 'ADD') ? 'أضافة قسم' : 'تعديل القسم',
              alignment: Alignment.center,
              color: fourthColor,
              fontWeight: FontWeight.bold,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  RoundedTextField(
                    hintText: 'اسم القسم',
                    icon: FontAwesomeIcons.tape,
                    controller: controller.categoryController,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'الرجاء إدخال السعر';
                      }
                    },
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
                      text: 'إلغاء',
                      press: () => Get.back(),
                    ),
                    RectangleButton(
                      text: (state == 'ADD') ? 'إضافة' : 'تعديل',
                      press: () => (state == 'ADD')
                          ? controller.addCategory()
                          : controller.editCategory(categoryId: categoryId),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
