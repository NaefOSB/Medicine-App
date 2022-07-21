import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/view/product/manage_product.dart';
import 'package:medicine_app/view/single_store/category/custom_single_store_category.dart';
import 'package:medicine_app/view/single_store/category/manage_categories.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';

import 'custom_alert.dart';

// ignore: must_be_immutable
class CustomStoreMenu extends StatelessWidget {
  List<String> menu = ['إضافة منتج', 'إضافة قسم', 'إدارة الأقسام'];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        FontAwesomeIcons.ellipsisV,
        size: 18,
        color: fourthColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 30,
      ),
      itemBuilder: (BuildContext context) {
        return menu.map((menu) {
          return PopupMenuItem(
            child: Container(
                alignment: Alignment.center,
                child: CustomText(
                  title: menu,
                  alignment: Alignment.center,
                )),
            value: menu,
          );
        }).toList();
      },
      onSelected: (value) async {
        switch (value) {
          case 'إضافة منتج':
            {
              showDialog(
                  context: context,
                  builder: (context) => CustomAlert(
                      title: 'قسم المنتج',
                      content: 'الرجاء إختيار قسم المنتج !!',
                      titleAlignment: Alignment.center,
                      contentAlignment: Alignment.center,
                      titleFontWeight: FontWeight.bold,
                      titleColor: fourthColor,
                      hasSecondButton: true,
                      firstButtonText: 'منتج',
                      secondButtonText: 'عرض',
                      onPressed1: () {
                        Get.back();
                        Get.to(() => ManageProduct(
                              productType: 'المنتجات',
                            ));
                      },
                      onPressed2: () {
                        Get.back();
                        Get.to(() => ManageProduct(
                              productType: 'العروض',
                            ));
                      }));
              break;
            }
          case 'إضافة قسم':
            {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => CustomSingleStoreCategory());

              break;
            }
          case 'إدارة الأقسام':
            {
              Get.to(() => ManageSingleStoreCategories());
              break;
            }
        }
      },
    );
  }
}
