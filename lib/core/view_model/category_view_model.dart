import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicine_app/view/widgets/custom_alert.dart';

class CategoryViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // for manage_category page
  TextEditingController categoryController;
  File image;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool manageCategoryPageIsLoading = false;

  void isLoadingMethod(){
    manageCategoryPageIsLoading = true;
    update();
  }
  void isNotLoadingMethod(){
    manageCategoryPageIsLoading = false;
    update();
  }

  @override
  void onInit() {
    categoryController = new TextEditingController();
    super.onInit();
  }

  Future getImage() async {
    // to pick the image from the gallery
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    image = img;
  }

   uploadImageAndGetUrl() async {
    //To Upload The Image Into Firebase Storage
    var storageImage = FirebaseStorage.instance.ref().child(image.path);
    var task = storageImage.putFile(image);
    return await (await task).ref.getDownloadURL();
  }

  void validate() async {
    if (formKey.currentState.validate() && image != null) {
      if (image.path != null) {
        isLoadingMethod();
        await saveDateToCategoryCollection();
        isNotLoadingMethod();

      }
    } else if (image == null) {
      showDialog(
          context: Get.context,
          builder: (context) => CustomAlert(
                title: 'لاتوجد صورة',
                content: 'الرجاء إضافة صورة لهذا القسم',
                onPressed1: () => Get.back(),
              ));
    }
  }

  saveDateToCategoryCollection() async{
    var imgUrl = await uploadImageAndGetUrl();
    if(imgUrl.toString().isNotEmpty) {
      _firestore.collection('categories').add({
        'name': categoryController.text,
        'imgUrl': imgUrl
      });
    }
  }
}
