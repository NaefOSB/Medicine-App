import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/services/process_management.dart';
import 'package:medicine_app/core/view_model/security_view_model.dart';
import 'package:medicine_app/view/cart/my_cart.dart';
import 'package:medicine_app/view/home_page/home_page.dart';
import 'package:medicine_app/view/home_page/initialize_page.dart';

class BottomBar extends GetWidget<SecurityViewModel> {
  String state;

  BottomBar({this.state});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.transparent,
        elevation: 9.0,
        clipBehavior: Clip.antiAlias,
        child: Container(
            height: 50.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
                color: Colors.white),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width / 2 - 40.0,
                    child: IconButton(
                      icon: Icon((state == 'CART')
                          ? Icons.home
                          : Icons.add_shopping_cart),
                      color: unActiveColor,
                      onPressed: () => (state == 'CART')
                          ? Get.offAll(() => InitializePage())
                          : controller.checkIfUserLogin(toPage: MyCart()),
                    ),
                  ),
                  Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width / 2 - 40.0,
                    child: IconButton(
                        icon: Icon((state == 'MYORDERS')
                            ? Icons.home
                            : Icons.shopping_basket),
                        color: Color(0xFF676E79),
                        onPressed: () => (state == 'MYORDERS')
                            ? Get.offAll(() => InitializePage())
                            : ProcessManagement.bottomNavigatorOrders()),
                  ),
                ])));
  }
}
