import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/core/services/login_format.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/model/user_information.dart';
import 'package:medicine_app/view/home_page/home_page.dart';
import 'package:medicine_app/view/home_page/initialize_page.dart';

class EditAccountViewModel extends GetxController {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  UserInformation _user = new UserInformation();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // for controllers
  TextEditingController ownerNameController;
  TextEditingController workNameController;
  TextEditingController addressController;
  TextEditingController phoneNumberController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;

  @override
  void onInit() {
    getUserData();
  }

  void getUserData() async {
    isProcessLoading();
    var userId = UserStorage().getUserInfo().id.toString();
    var userData =
        await _firebaseFirestore.collection('users').doc(userId).get();
    var email = await _firebaseAuth.currentUser.email;
    _user = new UserInformation(
      id: userId,
      name: userData['userName'],
      storeName: userData['storeName'],
      address: userData['address'],
      phoneNumber: userData['phoneNumber'],
      email: email.toString(),
    );
    isProcessNotLoading();
    ownerNameController = new TextEditingController(text: _user.name);
    workNameController = new TextEditingController(text: _user.storeName);
    addressController = new TextEditingController(text: _user.address);
    phoneNumberController = new TextEditingController(text: _user.phoneNumber);
    emailController = new TextEditingController(text: _user.email);
    passwordController = new TextEditingController();
    confirmPasswordController = new TextEditingController();
    update();
  }

  isProcessLoading() {
    isLoading = true;
    update();
  }

  isProcessNotLoading() {
    isLoading = false;
    update();
  }

  updateProcess() async {
    try {
      if (formKey.currentState.validate()) {
        isProcessLoading();
        // to reset the email
        var user = await FirebaseFirestore.instance
            .collection('users')
            .doc(UserStorage().getUserInfo().id)
            .get();
        //  to update name,activity name,location, and phone number
        await _firebaseFirestore
            .collection('users')
            .doc(UserStorage().getUserInfo().id)
            .update({
          'userName': ownerNameController.text,
          'storeName': workNameController.text,
          'address': addressController.text,
          'phoneNumber': phoneNumberController.text,
        });
        // to update the storeName in Get Storage
        var userDataDetails = UserStorage().getUserInfo();
        UserStorage().setUserInfo(UserInformation(
            id: userDataDetails.id,
            name: ownerNameController.text,
            accountType: userDataDetails.accountType,
            storeName: workNameController.text,
            saleState: userDataDetails.saleState));


        if (user.exists && user['phoneNumber'] != null) {
          if (user['phoneNumber'].toString() !=
              phoneNumberController.text.toString()) {
            var email = LoginFormat.getLoginFormat(
                phoneNumber: phoneNumberController.text);
            await _firebaseAuth.currentUser.updateEmail(email);
          }
        }
        // to reset the password
        if (passwordController.text.isNotEmpty) {
          await _firebaseAuth.currentUser
              .updatePassword(passwordController.text);
        }
        Get.offAll(() => InitializePage());
        isProcessNotLoading();
      }
    } catch (e) {
      print(e.code);
      isProcessNotLoading();
    }
  }
}
