import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/auth_view_model.dart';
import 'package:medicine_app/view/home_page/background.dart';
import 'package:medicine_app/view/widgets/custom_dropdown.dart';
import 'package:medicine_app/view/widgets/rounded_button.dart';
import 'package:medicine_app/view/widgets/rounded_text_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUp extends GetWidget<AuthViewModel> {
  final String state;

  SignUp({this.state});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<AuthViewModel>(
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
                                (state == 'ADMIN')
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
                                (state == 'SUPPLIER')
                                    ? Obx(() => CustomDropDown(
                                          icon: Icons.business_outlined,
                                          hintText: 'نوع النشاط',
                                          stream: controller.categoriesStream,
                                          controller:
                                              controller.workTypeController,
                                          errorText: 'الرجاء إختيار نوع النشاط',
                                          isList: true,
                                          hasError:
                                              controller.accountType.value,
                                        ))
                                    : Container(),
                                Obx(
                                  () => CustomDropDown(
                                    icon: Icons.location_city,
                                    hintText: 'إختر المحافظة',
                                    controller: controller.cityController,
                                    stream: controller.citiesStream,
                                    errorText: 'الرجاء إختيار المحافظة',
                                    hasError: controller.city.value,
                                  ),
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
                                  hintText: 'كلمة المرور',
                                  controller: controller.passwordController,
                                  icon: Icons.lock,
                                  isPassword: true,
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'الرجاء إدخال كلمة المرور';
                                    } else if (value.toString().length < 6) {
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
                                  onFieldSubmitted: (value) => controller
                                      .validationProcess(state: state),
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'الرجاء تأكيد كلمة المرور';
                                    } else if (value.toString() !=
                                        controller.passwordController.text) {
                                      return 'كلمة المرور المدخلة غير متطابقة';
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                RoundedButton(
                                  text: 'إنشاء حساب',
                                  press: () => controller.validationProcess(
                                      state: state),
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
