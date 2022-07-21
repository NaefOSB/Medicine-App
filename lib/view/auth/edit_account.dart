import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/core/view_model/edit_account_view_model.dart';
import 'package:medicine_app/view/home_page/background.dart';
import 'package:medicine_app/view/widgets/rounded_button.dart';
import 'package:medicine_app/view/widgets/rounded_text_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditAccount extends GetWidget<EditAccountViewModel> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<EditAccountViewModel>(
        builder: (controller) => ModalProgressHUD(
              inAsyncCall: controller.isLoading,
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Scaffold(
                    body: Background(
                      child: SingleChildScrollView(
                        child: Form(
                          key: controller.formKey,
                          child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: size.height * 0.13),
                                Image.asset(
                                  'assets/images/signUp.png',
                                  color: kPrimaryColor,
                                  height: size.height * 0.35,
                                ),
                                SizedBox(height: size.height * 0.03),
                                RoundedTextField(
                                  hintText: 'اسم المالك',
                                  icon: Icons.person,
                                  controller: controller.ownerNameController,
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'الرجاء إدخال اسم المالك';
                                    }
                                  },
                                ),
                                (UserStorage().getUserInfo().accountType ==
                                        'ADMIN')
                                    ? Container()
                                    : RoundedTextField(
                                        hintText: 'اسم النشاط',
                                        controller:
                                            controller.workNameController,
                                        icon: Icons.home_work_outlined,
                                        validator: (value) {
                                          if (value.toString().isEmpty) {
                                            return 'الرجاء إدخال اسم النشاط';
                                          }
                                        },
                                      ),
                                RoundedTextField(
                                  hintText: 'الموقع',
                                  controller: controller.addressController,
                                  icon: Icons.location_on_outlined,
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'الرجاء إدخال الموقع';
                                    }
                                  },
                                ),
                                RoundedTextField(
                                  hintText: 'رقم الجوال',
                                  controller: controller.phoneNumberController,
                                  icon: Icons.phone,
                                  keyboardType: 'number',
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'الرجاء إدخال رقم الجوال';
                                    }
                                  },
                                ),
                                // RoundedTextField(
                                //   hintText: 'البريد الإلكتروني',
                                //   controller: controller.emailController,
                                //   icon: Icons.email,
                                //   keyboardType: 'email',
                                //   validator: (value) {
                                //     if (value.toString().isEmpty) {
                                //       return 'الرجاء إدخال البريد الإلكتروني';
                                //     }
                                //   },
                                // ),
                                RoundedTextField(
                                  hintText: 'كلمة المرور الجديدة',
                                  controller: controller.passwordController,
                                  icon: Icons.lock,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value.toString().isNotEmpty &&
                                        value.toString().length < 6) {
                                      return 'الرجاء إدخال كلمة مرور اكبر من 5 رومز';
                                    }
                                  },
                                ),
                                RoundedTextField(
                                  hintText: 'تأكيد كلمة المرور',
                                  controller:
                                      controller.confirmPasswordController,
                                  icon: Icons.lock,
                                  isPassword: true,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (value) =>
                                      controller.updateProcess(),
                                  validator: (value) {
                                    if (value.toString() !=
                                        controller.passwordController.text) {
                                      return 'كلمة المرور المدخلة غير متطابقة';
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                RoundedButton(
                                  text: 'تعديل الحساب',
                                  press: () => controller.updateProcess(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ));
  }
}
