import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/core/services/firebase_services.dart';
import 'package:medicine_app/core/services/login_format.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/model/user_information.dart';
import 'package:medicine_app/view/home_page/home_page.dart';
import 'package:medicine_app/view/home_page/initialize_page.dart';
import 'package:medicine_app/view/widgets/custom_alert.dart';

class AuthViewModel extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> citiesStream =
      FirebaseFirestore.instance.collection('cities').snapshots();
  Stream<QuerySnapshot> categoriesStream =
      FirebaseFirestore.instance.collection('categories').snapshots();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool signInPageIsLoading = false;

  // for controllers
  TextEditingController ownerNameController;
  TextEditingController workNameController;
  TextEditingController workTypeController;
  TextEditingController cityController;
  TextEditingController addressController;
  TextEditingController phoneNumberController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;
  RxBool accountType = false.obs;
  RxBool city = false.obs;
  bool isDropDownForWork = false;
  bool isDropDownForCity = false;

  List<Map<String, String>> selectedListIndex = new List<Map<String, String>>();

  // for sign in page
  TextEditingController signInPageEmail;

  TextEditingController signInPagePassword;

  final GlobalKey<FormState> signInPageFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    ownerNameController = new TextEditingController();
    workNameController = new TextEditingController();
    workTypeController = new TextEditingController();
    cityController = new TextEditingController();
    addressController = new TextEditingController();
    phoneNumberController = new TextEditingController();
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    confirmPasswordController = new TextEditingController();
    signInPageEmail = new TextEditingController();
    signInPagePassword = new TextEditingController();
    super.onInit();
  }

  void changeLoading() {
    isLoading = !isLoading;
    update();
  }

  void validationProcess({String state}) async {
    if (formKey.currentState.validate() &&
        cityController.text != 'إختر المحافظة' &&
        workTypeController.text != 'نوع النشاط') {
      city.value = false;
      var result = await createAccount(state);
      _showError(errorCode: result, emailText: emailController.text);
    } else {
      if (workTypeController.text == 'نوع النشاط') {
        accountType.value = true;
      } else {
        accountType.value = false;
      }

      if (cityController.text == 'إختر المحافظة') {
        city.value = true;
      } else {
        city.value = false;
      }
    }
  }

  checkBoxList() {
    for (int i = 0; i < selectedListIndex.length; i++) {
      print(selectedListIndex[i]);
    }
  }

  getCities() async {
    var cities = await _firestore.collection('categories').get();
    print(cities.docs[0]['name']);
    print(cities.docs[0].id);
    return cities;
  }

  createAccount(String state) async {
    try {
      changeLoading();
      List<String> accountRoles = new List<String>();
      // to get the id of all selected account category
      String emailFormat =
          LoginFormat.getLoginFormat(phoneNumber: phoneNumberController.text);
      selectedListIndex.forEach((element) => accountRoles.add(element['id']));
      // var userInfo = await _auth.createUserWithEmailAndPassword(
      //     email: emailController.text, password: passwordController.text);
      var userInfo = await _auth.createUserWithEmailAndPassword(
          email: emailFormat, password: passwordController.text);
      if (userInfo != null && userInfo.user.uid != null) {
        _firestore.collection('users').doc(userInfo.user.uid).set({
          'userName': ownerNameController.text,
          'storeName': workNameController.text,
          'accountType': state,
          'cityID': cityController.text,
          'address': addressController.text,
          'phoneNumber': phoneNumberController.text,
          'accountCategory': accountRoles,
          'saleState': true
        });
      }
      changeLoading();
      return 'success';
    } catch (e) {
      isLoading = false;
      update();
      return e.code;
    }
  }

  _showError({String errorCode, String emailText}) {
    switch (errorCode) {
      case 'success':
        {
          Get.offAll(InitializePage());
          _showMessage(
              title: 'عملية ناجحة',
              content: 'تمت العملية بنجاح',
              onPressed1: () => Get.back(),
              firstButtonText: 'موافق');

          break;
        }
      case 'weak-password':
        {
          _showMessage(
              title: 'كلمة المرور ضعيفة',
              content:
                  'كلمة المرور التي ادخلتها ضعيفة الرجاء كتابة كلمة مرور قوية',
              onPressed1: () => Get.back(),
              firstButtonText: 'موافق');
          break;
        }
      case 'invalid-email':
        {
          if (emailText.contains(' ')) {
            _showMessage(
                title: 'خطا في الصياغ',
                content:
                    // 'صيغة البريد الإلكتروني الذي ادخلته خاطئة الرجاء التأكد من عدم وجود فراغات في البريد الإلكتروني سواء في بدايته او نهايته، مثال medicine@gmail.com',
                    'صيغة رقم الجوال الذي ادخلته خاطئة الرجاء التأكد من عدم وجود فراغات في رقم الجوال سواء في بدايته او نهايته.',
                firstButtonText: 'موافق',
                onPressed1: () => Get.back());
          } else {
            _showMessage(
              title: 'خطا في الصياغ',
              content:
                  // 'صيغة البريد الإلكتروني الذي ادخلته خاطئة الرجاء تصحيح الصياغ بما يتناسب مع صياغة البريد، مثال offers@gmail.com',
                  'صيغة رقم الجوال الذي ادخلته خاطئة الرجاء تصحيح الصياغ بما يتناسب مع صياغة الأرقام. ',
              firstButtonText: 'موافق',
              onPressed1: () => Get.back(),
            );
          }
          break;
        }
      case 'email-already-in-use':
        {
          _showMessage(
            // title: 'البريد موجود مسبقاً',
            title: 'رقم الجوال موجود مسبقاً',
            content:
                'رقم الجوال الذي ادخلته مسجل مسبقاً، الرجاء اختيار رقم اخر',
            firstButtonText: 'موافق',
            onPressed1: () => Get.back(),
          );
          break;
        }
      case 'user-not-found':
        {
          _showMessage(
              title: 'خطأ في البيانات',
              content:
                  // 'البريد الإلكتروني او كلمة المرور خاطئة الرجاء إدخال بيانات صحيحة',
                  'رقم الجوال او كلمة المرور خاطئة الرجاء إدخال بيانات صحيحة',
              onPressed1: () => Get.back(),
              firstButtonText: 'موافق');
          break;
        }
      case 'wrong-password':
        {
          _showMessage(
              title: 'خطأ في البيانات',
              content:
                  // 'البريد الإلكتروني او كلمة المرور خاطئة الرجاء إدخال بيانات صحيحة',
                  'رقم الجوال او كلمة المرور خاطئة الرجاء إدخال بيانات صحيحة',
              onPressed1: () => Get.back(),
              firstButtonText: 'موافق');
          break;
        }
      default:
        {
          _showMessage(
            title: 'حدث خطأ',
            content: errorCode,
            firstButtonText: 'موافق',
            onPressed1: () => Get.back(),
          );
          break;
        }
    }
  }

  void _showMessage(
      {String title,
      String content,
      String firstButtonText,
      Function onPressed1}) {
    showDialog(
        context: Get.context,
        builder: (context) => CustomAlert(
              title: title,
              content: content,
              contentAlignment: Alignment.center,
              firstButtonText: firstButtonText,
              onPressed1: onPressed1,
            ));
  }

  // ----------------------- Sign In Page -----------------------

  void signInPageLoading() {
    signInPageIsLoading = true;
    update();
  }

  void signInPageNotLoading() {
    signInPageIsLoading = false;
    update();
  }

  void loginMethodValidator({String state, Widget toPage}) async {
    if (signInPageFormKey.currentState.validate()) {
      var result = await signInMethod();
      if (result == 'success') {
        if (state == 'toHomePage') {
          Get.offAll(() => InitializePage());
        } else {
          if (toPage == null) {
            //  if he does not pass any page it will navigate to home page
            Get.offAll(() => InitializePage());
          } else {
            Get.off(() => toPage);
          }
        }
      } else {
        _showError(errorCode: result, emailText: signInPageEmail.text);
      }
    }
  }

  signInMethod() async {
    try {
      signInPageLoading();
      String email = LoginFormat.getLoginFormat(phoneNumber: signInPageEmail.text);
      // var result = await _auth.signInWithEmailAndPassword(
      //     email: signInPageEmail.text, password: signInPagePassword.text);
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: signInPagePassword.text);
      if (result != null && result.user.uid != null) {
        var userData = await FirebaseServices.getUserDetails(result.user.uid);
        UserStorage().setUserInfo(UserInformation(
            id: result.user.uid,
            name: userData['userName'],
            accountType: userData['accountType'],
            storeName: userData['storeName'],
            saleState: userData['saleState'].toString()));
        signInPageNotLoading();
        return 'success';
      }
      signInPageNotLoading();
    } catch (e) {
      signInPageNotLoading();
      return e.code;
    }
  }
}
