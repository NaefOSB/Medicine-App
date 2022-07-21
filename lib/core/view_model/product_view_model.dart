import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/model/product_model.dart';
import 'package:medicine_app/view/home_page/home_page.dart';
import 'package:medicine_app/view/widgets/custom_alert.dart';

class ProductViewModel extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var categoryStream = FirebaseFirestore.instance
      .collection('users')
      .doc(UserStorage().getUserInfo().id)
      .collection('categories')
      .snapshots();

  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<String> productType = ['المنتجات', 'العروض'];
  final List<String> currencyList = ['ر.ي', 'ر.س', '\$'];
  final List<String> productStateList = [
    'متوفر',
    'غير متوفر',
    'شارف على الأنتهاء'
  ];

  // for controllers
  TextEditingController productNameController;
  TextEditingController priceController;
  TextEditingController productCategoryController;
  TextEditingController bonusController;
  TextEditingController quantityController;
  TextEditingController endDateController;
  TextEditingController descriptionController;
  TextEditingController productStateController;
  TextEditingController orderedQuantityController;
  TextEditingController currencyController;
  bool categoryError = false;
  bool currencyError = false;

  @override
  void onInit() {
    productNameController = new TextEditingController();
    priceController = new TextEditingController();
    productCategoryController = new TextEditingController();
    bonusController = new TextEditingController();
    quantityController = new TextEditingController();
    endDateController = new TextEditingController();
    descriptionController = new TextEditingController();
    productStateController = new TextEditingController();
    orderedQuantityController = new TextEditingController();
    currencyController = new TextEditingController();
    super.onInit();
  }

  void isProcessLoading() {
    isLoading = true;
    update();
  }

  void isProcessNotLoading() {
    isLoading = false;
    update();
  }

  void validate({String state, String productId, String type}) async {
    try {
      if (formKey.currentState.validate() &&
          productCategoryController.text != 'قسم المنتج' &&
          currencyController.text != 'العملة') {
        // for disable error if everything is correct
        categoryError = false;
        currencyError = false;
        isProcessLoading();
        if (state == 'ADD') {
          await createProduct(type: type);
        } else {
          await editProductProcess(productId);
        }
        isProcessNotLoading();
      } else {
        if (productCategoryController.text == 'قسم المنتج') {
          categoryError = true;
        } else {
          categoryError = false;
        }

        if (currencyController.text == 'العملة') {
          currencyError = true;
        } else {
          currencyError = false;
        }

        update();
      }
    } catch (e) {
      isProcessNotLoading();
    }
  }

  Future<void> createProduct({String type}) async {
    await _firestore.collection('products').add({
      'name': productNameController.text,
      'endDate': endDateController.text,
      'bonus': bonusController.text,
      'quantity': quantityController.text,
      'description': descriptionController.text,
      'storeID': '${UserStorage().getUserInfo().id}',
      'storeName': '${UserStorage().getUserInfo().storeName}',
      'price': priceController.text,
      'type': type, // either 'منتجات' or 'عروض'
      'categoryId': productCategoryController.text,
      'visibility': 'متوفر',
      // 'متوفر','غير متوفر','على وشك النفاذ'
      'currency': currencyController.text
    });
    await showDialog(
        context: Get.context,
        builder: (context) => CustomAlert(
              title: 'عملية ناجحة',
              content: 'تمت العملية بنجاح !!',
              contentAlignment: Alignment.center,
              onPressed1: () => Get.back(),
              firstButtonText: 'موافق',
            ));
    clearFields();
    Get.back();
  }

  void clearFields() {
    productNameController.clear();
    priceController.clear();
    bonusController.clear();
    quantityController.clear();
    descriptionController.clear();
    productCategoryController.text = 'قسم المنتج';
    endDateController.text = 'تاريخ الإنتهاء';
  }

  void setDataFields({ProductModel model}) {
    print(model.categoryId);
    productNameController = new TextEditingController(text: model.name);
    priceController = new TextEditingController(text: model.price);
    productCategoryController =
        new TextEditingController(text: model.categoryId);
    bonusController = new TextEditingController(text: model.bonus);
    quantityController = new TextEditingController(text: model.quantity);
    endDateController = new TextEditingController(text: model.endDate);
    descriptionController = new TextEditingController(text: model.description);
    currencyController = new TextEditingController(text: model.currency);
    update();
  }

  Future<void> editProductProcess(String productId) async {
    await _firestore.collection('products').doc(productId).update({
      'name': productNameController.text,
      'endDate': endDateController.text,
      'bonus': bonusController.text,
      'quantity': quantityController.text,
      'description': descriptionController.text,
      // 'storeID': '${UserStorage().getUserInfo().id}',
      'price': priceController.text,
      'categoryId': productCategoryController.text,
      // either 'منتجات' or 'عروض'
      'visibility': 'متوفر',
      // 'متوفر','غير متوفر','على وشك النفاذ'
      'currency': currencyController.text
    });
    showDialog(
        context: Get.context,
        builder: (context) => CustomAlert(
              title: 'عملية ناجحة',
              content: 'تمت عملية التعديل بنجاح !!',
              contentAlignment: Alignment.center,
              onPressed1: () => Get.back(),
              firstButtonText: 'موافق',
            ));
    Get.offAll(() => HomePage());
  }

  Future<void> deleteProduct(String productId) async {
    showDialog(
        context: Get.context,
        builder: (context) => CustomAlert(
              title: 'حذف منتج',
              content: 'هل أنت متأكد من انك تريد حذف هذا المنتج ؟',
              contentAlignment: Alignment.center,
              firstButtonText: 'إلغاء',
              secondButtonText: 'حذف',
              hasSecondButton: true,
              onPressed1: () => Get.back(),
              onPressed2: () async {
                Get.back();
                isProcessLoading();
                await _firestore.collection('products').doc(productId).delete();
                isProcessNotLoading();
                Get.offAll(() => HomePage());
              },
            ));
  }

  void quantityValidate(String value) {
    if (value == '0') {
      orderedQuantityController.clear();
      update();
    }
  }

  void validateDeletionButton({ProductModel model}) {
    if (UserStorage().getUserInfo().id == model.storeID) {
      // for delete the product
      deleteProduct(model.id);
    } else {
      //  for add to cart
    }
  }

  changeVisibility({String productId, String value}) async {
    showDialog(
        context: Get.context,
        builder: (context) => CustomAlert(
              title: 'تعديل حالة المنتج',
              content: 'هل أنت متأكد من انك تريد تعديل حالة هذا المنتج ؟',
              contentAlignment: Alignment.center,
              firstButtonText: 'إلغاء',
              secondButtonText: 'تعديل',
              hasSecondButton: true,
              onPressed1: () => Get.back(),
              onPressed2: () async {
                Get.back();
                isProcessLoading();
                await _firestore
                    .collection('products')
                    .doc(productId)
                    .update({'visibility': value});
                isProcessNotLoading();
              },
            ));
  }
}
