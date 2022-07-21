import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/view/single_store/category/custom_single_store_category.dart';
import 'package:medicine_app/view/widgets/custom_alert.dart';

class SingleStoreCategoryViewModel extends GetxController {
  bool isLoading = false;
  TextEditingController categoryController = TextEditingController();

  void processLoading() {
    isLoading = true;
    update();
  }

  void processNotLoading() {
    isLoading = false;
    update();
  }

  addCategory() async {
    try {
      var userDetails = UserStorage().getUserInfo();
      if (userDetails.id != null &&
          userDetails.id.isNotEmpty &&
          categoryController.text.isNotEmpty) {
        processLoading();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDetails.id)
            .collection('categories')
            .add({
          'name': categoryController.text,
          'createdDate': DateTime.now()
        });
        Get.back();
        processNotLoading();
      }
    } catch (e) {
      processNotLoading();
    }
  }

  moveCategoryToEditPage({categoryId, categoryName}) {
    categoryController.text = categoryName;
    showDialog(
        context: Get.context,
        builder: (context) => CustomSingleStoreCategory(
              state: 'EDIT',
              categoryId: categoryId,
            ));
  }

  editCategory({String categoryId}) async {
    try {
      var userDetails = UserStorage().getUserInfo();
      if (userDetails.id != null &&
          userDetails.id.isNotEmpty &&
          categoryId.isNotEmpty) {
        processLoading();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDetails.id)
            .collection('categories')
            .doc(categoryId)
            .update({'name': categoryController.text});
        Get.back();
        processNotLoading();
      }
    } catch (e) {
      processNotLoading();
    }
  }

  deleteCategory({categoryId}) async {
    try {
      // CONFIRMATION PROCESS
      showDialog(
          context: Get.context,
          builder: (context) => CustomAlert(
                title: 'عملية حذف',
                content: 'هل أنت متأكد من انك تريد حذف هذا القسم ؟؟',
                titleAlignment: Alignment.center,
                contentAlignment: Alignment.center,
                titleFontWeight: FontWeight.bold,
                titleColor: fourthColor,
                firstButtonText: 'إلغاء',
                secondButtonText: 'حذف',
                hasSecondButton: true,
                onPressed1: () => Get.back(),
                onPressed2: () async {
                  var userDetails = UserStorage().getUserInfo();
                  if (userDetails.id != null &&
                      userDetails.id.isNotEmpty &&
                      categoryId.isNotEmpty) {
                    //  TO CLOSE THE ALERT
                    Get.back();

                    processLoading();
                    // bool allowedToDelete =
                    //     await isCategoryHasProducts(categoryId: categoryId);
                    bool allowedToDelete = true;
                    if (allowedToDelete) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userDetails.id)
                          .collection('categories')
                          .doc(categoryId)
                          .delete();
                    } else {
                      showDialog(
                          context: Get.context,
                          builder: (context) => CustomAlert(
                                title: 'يمنع الحذف',
                                content:
                                    ' هذا القسم يحتوي على منتجات !!!، لحذف هذا القسم قم بالتخلص من المنتجات المرتبط بهذا القسم.',
                                titleColor: fourthColor,
                                titleFontWeight: FontWeight.bold,
                                titleAlignment: Alignment.center,
                                contentAlignment: Alignment.center,
                                firstButtonText: 'موافق',
                                onPressed1: () => Get.back(),
                              ));
                    }
                    processNotLoading();
                  }
                },
              ));
    } catch (e) {
      processNotLoading();
    }
  }

  Future<bool> isCategoryHasProducts({categoryId}) async {
    //  TO CHECK IS THE CATEGORY HAS PRODUCT OR NOT
    //  TO PREVENT DELETION IF THE CATEGORY HAS PRODUCTS
  }
}
