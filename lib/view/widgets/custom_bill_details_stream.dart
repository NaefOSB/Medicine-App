import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/bill_details_view_model.dart';
import 'package:medicine_app/view/product/product_card.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';

class CustomBillDetailsStream extends GetWidget<BillDetailsViewModel> {
  String storeId;
  String billNumber;
  String userId;
  String state;
  bool isAccepted;
  bool isRejected;
  bool isStoreAdmin;
  TextEditingController textController;

  CustomBillDetailsStream(
      {this.storeId,
      this.billNumber,
      this.userId,
      this.state,
      this.isAccepted,
      this.isRejected,
      this.isStoreAdmin,
      this.textController});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(right: 15.0, left: 20.0),
      width: size.width - 30.0,
      height: size.height - 50.0,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(storeId)
            .collection('requests')
            .doc(userId)
            .collection(userId)
            .doc(billNumber)
            .collection(billNumber)
            .where('state', isEqualTo: state)
            .where('isAccepted', isEqualTo: isAccepted)
            .where('isRejected', isEqualTo: isRejected)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.docs.length > 0) {
            final products = snapshot.data.docs;
            return GridView.count(
              crossAxisCount: 3,
              primary: false,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 15.0,
              childAspectRatio: 0.6,
              children: <Widget>[
                for (int i = 0; i < products.length; i++) ...{
                  if (products[i]['name']
                          .toString()
                          .contains(textController.text) ||
                      products[i]['price']
                          .toString()
                          .contains(textController.text) ||
                      products[i]['orderedQuantity']
                          .toString()
                          .contains(textController.text)) ...{
                    ProductCard(
                      name: '${products[i]['name']}',
                      price: products[i]['price'].toString(),
                      isCart: isStoreAdmin,
                      currency: products[i]['currency'],
                      onDelete: () => controller.rejectSingleProduct(
                          userId: userId,
                          billId: billNumber,
                          requestId: products[i].id,
                          productId: products[i]['productId'],
                          orderQuantity: products[i]['orderedQuantity'],
                        bonus: products[i]['bonusNumber']),
                      imgPath: 'assets/images/products.png',
                      tag: 'assets/images/product_${products[i].id}.png',
                      quantityState: '${products[i]['orderedQuantity']}',
                    ),
                  }
                },
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: EdgeInsets.only(bottom: size.height * 0.20),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return CustomText(
              title: 'لاتوجد اي منتجات',
              alignment: Alignment.center,
              color: fourthColor,
              padding: EdgeInsets.only(bottom: size.height * 0.20),
            );
          }
        },
      ),
    );
  }
}
