import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/view/auth/sign_in/login_screen.dart';
import 'package:medicine_app/view/orders/ordered_clients.dart';
import 'package:medicine_app/view/orders/suppliers.dart';
import 'package:medicine_app/view/widgets/custom_alert.dart';

class ProcessManagement {
  static void requiredLoginAlert({Widget toPage}) {
    showDialog(
        context: Get.context,
        barrierDismissible: false,
        builder: (context) => CustomAlert(
            title: 'عملية تسجيل الدخول',
            titleFontWeight: FontWeight.bold,
            content:
                'هذه العملية تتطلب تسجيل الدخول، الرجاء سجل دخولك لتتمكن من تنفيد هذه العملية !!',
            contentAlignment: Alignment.center,
            firstButtonText: 'إلغاء',
            secondButtonText: 'تسجيل الدخول',
            hasSecondButton: true,
            onPressed1: () => Get.back(),
            onPressed2: () {
              Get.back(); // for the alert
              Get.to(
                () => SignIn(
                  state: 'notToHomePage',
                  toPage: toPage,
                ),
              );
            }));
  }

  // accountType state  => ADMIN,SUPPLIER,CLIENT or ''
  static void bottomNavigatorOrders() {
    var userDetails = UserStorage().getUserInfo();
    if (userDetails.id != null &&
        userDetails.id.isNotEmpty &&
        userDetails.accountType.isNotEmpty) {
      switch (userDetails.accountType) {
        case 'CLIENT':
          {
            var stream = FirebaseFirestore.instance
                .collection('orders')
                .where('CLIENTS', arrayContains: userDetails.id)
                .snapshots();
            Get.offAll(() => OrderedClients(
                  stream: stream,
                  accountType: userDetails.accountType,
                ));
            break;
          }
        case 'SUPPLIER':
          {
            var stream = FirebaseFirestore.instance
                .collection('orders')
                .doc(userDetails.id)
                .collection('requests')
                .snapshots();
            Get.offAll(() => OrderedClients(
                  stream: stream,
                  accountType: userDetails.accountType,
                ));
            break;
          }
        case 'ADMIN':
          {
            // it will navigate to supplier pages
            Get.offAll(() => AdminViewToSuppliers());
            break;
          }
      }
    } else {
      //  if the user is unauthenticated
      requiredLoginAlert();
    }
  }

  static void adminAndSupplierRequests() {
    // for only Admin & SUPPLIER that have ordered from a store
    var userDetails = UserStorage().getUserInfo();
    if (userDetails.accountType == 'SUPPLIER' ||
        userDetails.accountType == 'ADMIN') {
      Get.offAll(() => OrderedClients(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('CLIENTS', arrayContains: userDetails.id)
                .snapshots(),
            accountType: 'CLIENT',
          ));
    }
  }

  static void checkIfUserExist() async {
    try {
      var userDetails = UserStorage().getUserInfo();
      if (userDetails.id != null && userDetails.id.isNotEmpty) {
        var user = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDetails.id)
            .get();
        if (!user.exists) {
          await FirebaseAuth.instance.signOut();
          UserStorage().clearAll();
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
