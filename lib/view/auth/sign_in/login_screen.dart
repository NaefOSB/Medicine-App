import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/auth_view_model.dart';
import 'package:medicine_app/view/widgets/rounded_button.dart';
import 'package:medicine_app/view/widgets/rounded_text_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: must_be_immutable
class SignIn extends GetWidget<AuthViewModel> {
  final String state;
  final Widget toPage;

  SignIn({this.state = 'toHomePage', this.toPage});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<AuthViewModel>(
        builder: (controller) => Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                  body: ModalProgressHUD(
                inAsyncCall: controller.signInPageIsLoading,
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.signInPageFormKey,
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: size.height * 0.12),
                          Image.asset(
                            'assets/images/login-2.png',
                            height: size.height * 0.35,
                            color: kPrimaryColor,
                          ),
                          SizedBox(height: size.height * 0.08),
                          // inputs
                          // RoundedTextField(
                          //   hintText: "البريد الإلكتروني",
                          //   keyboardType: 'email',
                          //   icon: Icons.email,
                          //   controller: controller.signInPageEmail,
                          //   onChanged: (value) {},
                          //   validator: (value) {
                          //     if (value.toString().isEmpty) {
                          //       return 'الرجاء إدخال البريد الإلكتروني';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          RoundedTextField(
                            hintText: "رقم الجوال",
                            keyboardType: 'phone',
                            icon: Icons.phone_android,
                            controller: controller.signInPageEmail,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'الرجاء إدخال رقم الجوال';
                              }else if(value.toString().length<8){
                                return 'الرجاء إدخال رقم اكبر من 8 ارقام';

                              }
                              return null;
                            },
                          ),
                          RoundedTextField(
                            hintText: "كلمة المرور",
                            controller: controller.signInPagePassword,
                            onChanged: (value) {},
                            isPassword: true,
                            icon: Icons.lock,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) =>
                                controller.loginMethodValidator(state:state,toPage:toPage),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'الرجاء إدخال كلمة المرور';
                              }
                            },
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          RoundedButton(
                            text: "تـسـجـيـل الـدخـول",
                            press: () => controller.loginMethodValidator(state:state,toPage:toPage),
                          ),
                          SizedBox(height: size.height * 0.03),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
            ));
  }
}
