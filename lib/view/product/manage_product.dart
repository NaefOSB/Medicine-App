import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/product_view_model.dart';
import 'package:medicine_app/model/product_model.dart';
import 'package:medicine_app/view/home_page/background.dart';
import 'package:medicine_app/view/widgets/custom_dropdown.dart';
import 'package:medicine_app/view/widgets/custom_dropdown_list.dart';
import 'package:medicine_app/view/widgets/custom_dropdown_product_category.dart';
import 'package:medicine_app/view/widgets/rounded_button.dart';
import 'package:medicine_app/view/widgets/rounded_text_field.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ManageProduct extends GetWidget<ProductViewModel> {
  final String state;
  final ProductModel model;
  final String productType;

  ManageProduct(
      {this.state = 'ADD', this.model, this.productType = 'المنتجات'});

  @override
  Widget build(BuildContext context) {
    if (state == "EDIT" && model != null) {
      controller.setDataFields(model: model);
    }
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ProductViewModel>(
      builder: (controller) => ModalProgressHUD(
        inAsyncCall: controller.isLoading,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Background(
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: size.height * 0.13),
                        Image.asset(
                          'assets/images/new_products.png',
                          color: kPrimaryColor,
                          height: size.height * 0.35,
                        ),
                        SizedBox(height: size.height * 0.03),
                        RoundedTextField(
                          hintText: 'اسم المنتج',
                          icon: Icons.title,
                          controller: controller.productNameController,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'الرجاء إدخال اسم المنتج';
                            }
                          },
                        ),
                        (productType == 'العروض')
                            ? Container()
                            : CustomDropDownProductCategory(
                                icon: Icons.category,
                                stream: controller.categoryStream,
                                controller:
                                    controller.productCategoryController,
                                hasError: controller.categoryError,
                                hintText: 'قسم المنتج',
                                errorText: 'الرجاء إختيار قسم المنتج',
                              ),
                        RoundedTextField(
                          hintText: 'السعر',
                          controller: controller.priceController,
                          keyboardType: 'number',
                          icon: Icons.attach_money,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'الرجاء إدخال السعر';
                            }
                          },
                        ),
                        CustomDropDownList(
                          icon: Icons.money,
                          hintText: 'العملة',
                          element: controller.currencyList,
                          controller: controller.currencyController,
                          errorText: 'الرجاء إختيار العملة',
                          hasError: controller.currencyError,
                        ),
                        RoundedTextField(
                          hintText: 'البوينص',
                          controller: controller.bonusController,
                          icon: Icons.system_update_alt_sharp,
                          keyboardType: 'number',
                        ),
                        RoundedTextField(
                          hintText: 'الكمية',
                          controller: controller.quantityController,
                          keyboardType: 'number',
                          icon: Icons.confirmation_number_outlined,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'الرجاء إدخال الكمية';
                            }
                          },
                        ),
                        RoundedTextField(
                          hintText: 'تاريخ الإنتهاء',
                          readOnly: true,
                          onTap: () {
                            showDatePicker(
                              textDirection: TextDirection.rtl,
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050, 01, 01),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.fromSwatch(
                                      primarySwatch: Colors.orange,
                                      primaryColorDark: Colors.brown,
                                      accentColor: Colors.brown,
                                    ),
                                    dialogBackgroundColor: Colors.white,
                                  ),
                                  child: child,
                                );
                              },
                              cancelText: 'إلغاء',
                              confirmText: 'موافق',
                            ).then((value) {
                              if (value != null) {
                                controller.endDateController.text =
                                    '${value.year}-${value.month}-${value.day}';
                              }
                            });
                          },
                          controller: controller.endDateController,
                          icon: Icons.date_range_sharp,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'الرجاء إدخال تاريخ الإنتهاء';
                            } else if (value.toString() == 'تاريخ الإنتهاء') {
                              return 'الرجاء إدخال تاريخ الإنتهاء';
                            }
                          },
                        ),
                        RoundedTextField(
                          hintText: 'الملاحظات',
                          controller: controller.descriptionController,
                          icon: Icons.description,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) {
                            if (state == 'ADD') {
                              controller.validate(
                                  state: state, type: productType);
                            } else {
                              controller.validate(
                                  state: state, productId: model.id);
                            }
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        RoundedButton(
                            text: (state == 'ADD') ? 'حــفــظ' : 'تعديل المنتج',
                            press: () {
                              if (state == 'ADD') {
                                controller.validate(
                                    state: state, type: productType);
                              } else {
                                controller.validate(
                                    state: state, productId: model.id);
                              }
                            }),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
