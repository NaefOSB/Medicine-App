import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/cart_view_model.dart';
import 'package:medicine_app/view/product/product_card.dart';
import 'package:medicine_app/view/widgets/bottom_bar.dart';
import 'package:medicine_app/view/widgets/custom_floating_button.dart';
import 'package:medicine_app/view/widgets/custom_search.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MyCart extends StatefulWidget {
  @override
  _MyCartState createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<CartViewModel>(
        init: CartViewModel(),
        builder: (controller) => ModalProgressHUD(
          inAsyncCall: controller.loading,
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              centerTitle: true,
              title: Text('سلتي',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: fourthColor,
                      fontWeight: FontWeight.bold)),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height - 50.0,
              width: double.infinity,
              color: backgroundColor,
              child: (controller.cartProductModel.length > 0)
                  ? ListView(
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Container(
                              padding: EdgeInsets.only(right: 15.0, left: 20.0),
                              child: CustomSearch(
                                searchController: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    print(value);
                                  });
                                },
                              )),
                        ),
                        GridView.count(
                          padding: EdgeInsets.only(
                              right: 15.0, left: 20.0, bottom: 30.0),
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          primary: false,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 15.0,
                          childAspectRatio: 0.6,
                          children: <Widget>[
                            for (int i = 0;
                                i < controller.cartProductModel.length;
                                i++) ...{
                              ProductCard(
                                name: controller.cartProductModel[i].name
                                    .toString(),
                                price: controller.cartProductModel[i].price
                                    .toString(),
                                imgPath: controller.cartProductModel[i].image
                                    .toString(),
                                quantityState: controller
                                    .cartProductModel[i].quantity
                                    .toString(),
                                tag: controller.cartProductModel[i].productId +
                                    '$i',
                                isCart: true,
                                onDelete: () {
                                  controller.deleteSingleProduct(
                                      id: controller.cartProductModel[i].id);
                                },
                                currency:
                                    controller.cartProductModel[i].currency,
                                onTap: () {},
                              ),
                            },
                          ],
                        ),
                      ],
                    )
                  : Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Container(
                        height: size.height * 0.5,
                        width: size.height * 0.5,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                          'assets/images/empty_cart.png',
                        ))),
                      )),
            ),
            floatingActionButton: CustomFloatingButton(
              text: (controller.cartProductModel.length > 0) ? 'ترحيل' : 'سلتي',
              onPressed: () => controller.sendRequestToFirebase(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomBar(
              state: 'CART',
            ),
          ),
        ),
      ),
    );
  }
}
