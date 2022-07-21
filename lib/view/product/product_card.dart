import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/product_card_view_model.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';

class ProductCard extends GetWidget<ProductCardViewModel> {
  final String name;
  final price;
  final String currency;
  final Function onTap;
  final Function onDelete;
  final String imgPath;
  final String quantityState;
  final bool isCart;
  final String tag;
  final String storeId;

  ProductCard(
      {this.name,
      this.price,
      this.currency,
      this.onTap,
      this.imgPath,
      this.quantityState,
      this.onDelete,
      this.tag,
      this.isCart = false,
      this.storeId});

  ProductCardViewModel controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: InkWell(
            onTap: onTap,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3.0,
                          blurRadius: 5.0)
                    ],
                    color: Colors.white),
                child: Stack(
                  children: [
                    (isCart)
                        ? Positioned(
                            child: Container(
                              height: 20,
                              width: 20,
                              child: InkWell(
                                onTap: onDelete,
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.redAccent,
                                  size: 18.0,
                                ),
                              ),
                            ),
                            top: 5,
                            left: 5,
                          )
                        : Container(),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Hero(
                                tag: tag,
                                child: Container(
                                    height: 55.0,
                                    width: 55.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(imgPath),
                                            fit: BoxFit.contain)))),
                          ),
                          SizedBox(height: 5.0),
                          (controller.isAllowedToSeePrice(storeId: storeId))
                              ? Text(
                                  '$price ${(currency != null ? currency : '')}',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontFamily: 'Cairo',
                                      fontSize: 14.0))
                              : Container(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Text(name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: secondColor,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: 8.0,
                              left: 8.0,
                              top: 5.0,
                            ),
                            child: Container(
                                color: Color(0xFFEBEBEB), height: 1.0),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: CustomText(
                              title: '$quantityState',
                              color: kPrimaryColor3,
                              alignment: Alignment.center,
                              fontSize: 12.0,
                            ),
                          ),
                        ]),
                  ],
                ))));
  }
}
