import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/model/abot_store_model.dart';
import 'package:medicine_app/view/home_page/initialize_page.dart';
import 'package:medicine_app/view/widgets/custom_alert.dart';
import 'package:medicine_app/view/widgets/custom_alert_switch.dart';

class AboutStoreViewModel extends GetxController {
  bool isLoading = false;
  bool isFirst = true; // for set values to each controller for once
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  TextEditingController description;
  TextEditingController address;
  TextEditingController bankAccounts;
  TextEditingController phoneNumber1;
  TextEditingController phoneNumber2;

  @override
  void onInit() {
    description = new TextEditingController();
    address = new TextEditingController();
    bankAccounts = new TextEditingController();
    phoneNumber1 = new TextEditingController();
    phoneNumber2 = new TextEditingController();
    // TODO: implement onInit
    super.onInit();
  }

  isProcessLoading() {
    isLoading = true;
    update();
  }

  isProcessNotLoading() {
    isLoading = false;
    update();
  }

  setValueToEachController({AboutStoreModel model}) {
    if (isFirst) {
      description = new TextEditingController(text: model.description);
      address = new TextEditingController(text: model.address);
      bankAccounts = new TextEditingController(text: model.bankAccounting);
      phoneNumber1 = new TextEditingController(text: model.phoneNumber1);
      phoneNumber2 = new TextEditingController(text: model.phoneNumber2);
      isFirst = false;
      update();
    }
  }

  updateData({String storeId}) async {
    try {
      // storeId => the user id of the SUPPLIER

      isProcessLoading();
      await _firebaseFirestore
          .collection('users')
          .doc(storeId)
          .collection('details')
          .doc('details')
          .set({
        'description': description.text,
        'address': address.text,
        'bankAccounting': bankAccounts.text,
        'phoneNumber1': phoneNumber1.text,
        'phoneNumber2': phoneNumber2.text,
      });
      isProcessNotLoading();
      Get.back();
      showDialog(
          context: Get.context,
          builder: (context) => CustomAlert(
                title: 'عملية ناجحة',
                content: 'تمت عملية الحفظ بنجاح',
                contentAlignment: Alignment.center,
                onPressed1: () => Get.back(),
                firstButtonText: 'موافق',
              ));
    } catch (e) {
      print(e);
    }
  }

  bool isThisStoreIsMe({storeId}) {
    try {
      var userDetails = UserStorage().getUserInfo();
      if (userDetails.id != null &&
          userDetails.id.isNotEmpty &&
          userDetails.accountType != null &&
          userDetails.accountType.isNotEmpty) {
        if (userDetails.id == storeId) {
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  changeStoreBuyState({bool state}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(UserStorage().getUserInfo().id)
        .update({'saleState': state});
    UserStorage().write('saleState', state.toString());
    Get.offAll(() => InitializePage());
  }
}
