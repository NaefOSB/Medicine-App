import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/core/view_model/cart_view_model.dart';
import 'package:medicine_app/core/view_model/product_card_view_model.dart';
import 'package:medicine_app/core/view_model/product_view_model.dart';
import 'package:medicine_app/model/cart_product_model.dart';
import 'package:medicine_app/model/product_model.dart';
import 'package:medicine_app/view/home_page/initialize_page.dart';
import 'package:medicine_app/view/widgets/custom_text_quantity.dart';
import 'package:medicine_app/view/product/manage_product.dart';
import 'package:medicine_app/view/widgets/bottom_bar.dart';
import 'package:medicine_app/view/widgets/custom_simple_dropdown_list.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProductDetails extends GetWidget<ProductViewModel> {
  final String imgPath;
  final ProductModel model;
  final bool salesState;

  ProductDetails({this.imgPath, this.model, this.salesState});

  ProductCardViewModel productCardViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ProductViewModel>(
      builder: (controller) => ModalProgressHUD(
        inAsyncCall: controller.isLoading,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
                onPressed: () => Get.back(),
              ),
              title: Text(
                'تفاصيل المنتج',
                style: TextStyle(
                  color: fourthColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              actions: [
                (UserStorage().getUserInfo().id == model.storeID)
                    ? IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: kPrimaryColor3,
                        ),
                        onPressed: () => Get.to(() => ManageProduct(
                              state: 'EDIT',
                              model: model,
                              productType: model.type,
                            )),
                      )
                    : Container()
              ],
            ),
            body: ListView(children: [
              SizedBox(height: size.height * 0.1),
              Hero(
                  tag: imgPath,
                  child: Image.asset(imgPath,
                      height: 150.0, width: 100.0, fit: BoxFit.contain)),
              SizedBox(height: size.height * 0.03),
              (productCardViewModel.isAllowedToSeePrice(storeId: model.storeID))
                  ? Center(
                      child: Text(
                          '${model.price} ${(model.currency != null) ? model.currency : ''}',
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor)),
                    )
                  : Container(),
              SizedBox(height: size.height * 0.015),
              // Product Name
              CustomText(
                title: '${model.name}',
                color: secondColor,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                alignment: Alignment.center,
              ),
              SizedBox(height: size.height * 0.03),

              Center(
                child: Container(
                  width: size.width - 50.0,
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Table(
                    children: [
                      TableRow(children: [
                        TableCell(
                            child: CustomText(
                          title: 'البوينص :',
                          color: descriptionColor,
                        )),
                        TableCell(
                            child: CustomText(
                          title: (model.bonus == null ||
                                  model.bonus.toString().isEmpty)
                              ? 'لايوجد'
                              : '${model.bonus}%',
                          color: descriptionColor,
                        ))
                      ]),
                      if (UserStorage().getUserInfo().id == model.storeID) ...{
                        TableRow(children: [
                          TableCell(
                              child: CustomText(
                            title: 'الكمية :',
                            color: descriptionColor,
                          )),
                          TableCell(
                              child: CustomText(
                            title: (model.quantity == null ||
                                    model.quantity.toString().isEmpty)
                                ? '0'
                                : '${model.quantity}',
                            color: descriptionColor,
                          ))
                        ]),
                      },
                      TableRow(children: [
                        TableCell(
                            child: CustomText(
                          title: 'تاريخ الإنتهاء :',
                          color: descriptionColor,
                        )),
                        TableCell(
                            child: CustomText(
                          title: (model.endDate == null ||
                                  model.endDate.toString().isEmpty)
                              ? 'غير محدد'
                              : '${model.endDate}',
                          color: descriptionColor,
                        ))
                      ]),
                      TableRow(children: [
                        TableCell(
                            child: CustomText(
                          title: 'الملاحظات :',
                          color: descriptionColor,
                        )),
                        TableCell(child: Container()),
                      ]),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('${model.description}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.0, color: descriptionColor)),
              ),
              // for order quantity & product state
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 170.0,
                      child: CustomSimpleDropDownList(
                        element: controller.productStateList,
                        controller: controller.productStateController,
                        selectedValue: model.visibility,
                        productId: model.id,
                        canDropDown:
                            (UserStorage().getUserInfo().id == model.storeID),
                      ),
                    ),
                    CustomTextQuantity(
                      controller: controller.orderedQuantityController,
                      hintText: 'عدد الكمية',
                      onChange: (value) {
                        controller.quantityValidate(value);
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.03),

              Center(
                  child: GetBuilder<CartViewModel>(
                init: CartViewModel(),
                builder: (cartController) => InkWell(
                  child: Container(
                      width: size.width - 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color:
                              (UserStorage().getUserInfo().id == model.storeID)
                                  ? kPrimaryColor2
                                  : kPrimaryColor),
                      child: Center(
                        child: CustomText(
                          title:
                              (UserStorage().getUserInfo().id == model.storeID)
                                  ? 'حذف المنتج'
                                  : 'إضافة إلى السلة',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          alignment: Alignment.center,
                        ),
                      )),
                  onTap: () {
                    if (UserStorage().getUserInfo().id == model.storeID) {
                      controller.validateDeletionButton(model: model);
                    } else {
                      // for add to the cart
                      cartController.addProductToCart(
                          CartProductModel(
                              productId: '${model.id}',
                              storeId: '${model.storeID}',
                              storeName: '${model.storeName}',
                              name: '${model.name}',
                              image: '$imgPath',
                              price: '${model.price}',
                              quantity: (controller
                                      .orderedQuantityController.text.isEmpty)
                                  ? 1.0
                                  : double.parse(controller
                                      .orderedQuantityController.text
                                      .toString()),
                              description: '${model.description}',
                              bonus: '${model.bonus}',
                              currency: '${model.currency}'),
                          model.quantity,
                          model.visibility,
                          salesState);
                    }
                  },
                ),
              )),
              SizedBox(height: size.height * 0.06),
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Get.offAll(() => InitializePage()),
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.home),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomBar(),
          ),
        ),
      ),
    );
  }
}
