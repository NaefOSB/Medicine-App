import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/core/services/process_management.dart';
import 'package:medicine_app/core/services/user_storage.dart';

class SecurityViewModel extends GetxController {
  checkIfUserLogin({Widget toPage}) {
    var userDetails = UserStorage().getUserInfo();
    if (userDetails.id != null &&
        userDetails.id.isNotEmpty &&
        userDetails.accountType.isNotEmpty) {
      Get.to(() => toPage);
    } else {
      ProcessManagement.requiredLoginAlert(toPage: toPage);
    }
  }
}
