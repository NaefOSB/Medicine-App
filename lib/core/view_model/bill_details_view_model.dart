import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/view/widgets/custom_alert.dart';

class BillDetailsViewModel extends GetxController {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final String accept = 'قبول الطلبات';
  final String reject = 'رفض الطلبات';
  final String unReject = 'إلغاء الرفض';

  bool isLoading = false;
  double sharedProductQuantity = 0.0;

  // states that used to determine the state of the order
  final String waitingState = 'waiting';
  final String acceptState = 'accepted';
  final String rejectedState = 'rejected';
  final String _state = 'state';
  final String _isAccepted = 'isAccepted';
  final String _isRejected = 'isRejected';

  String selectedTextButton = '';
  TabController tabController;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    selectedTextButton = accept;
    super.onInit();
  }

  changeButtonText(int index) {
    switch (index) {
      case 0:
        {
          selectedTextButton = accept;
          break;
        }
      case 1:
        {
          selectedTextButton = reject;
          break;
        }
      case 2:
        {
          selectedTextButton = unReject;
          break;
        }
    }
    update();
  }

  isProcessLoading() {
    isLoading = true;
    update();
  }

  isProcessNotLoading() {
    isLoading = false;
    update();
  }

  rejectSingleProduct(
      {userId, requestId, billId, productId, orderQuantity,bonus=0}) async {
    try {
      var userDetails = UserStorage().getUserInfo();
      if (tabController.index == 0 || tabController.index == 1) {
        isProcessLoading();
        if (tabController.index == 1) {
          //  ONLY IF THE PRODUCT IS ALREADY ACCEPTED
          //  TO RETURN THE QUANTITY TO THE PRODUCTS COLLECTION
          await returnQuantity(
              productId: productId, returnedQuantity: orderQuantity,bonus: bonus);
        }
        await _firebaseFirestore
            .collection('orders')
            .doc(userDetails.id)
            .collection('requests')
            .doc(userId)
            .collection(userId)
            .doc(billId)
            .collection(billId)
            .doc(requestId)
            .update({
          '$_state': rejectedState,
          '$_isAccepted': false,
          '$_isRejected': true,
        });
        isProcessNotLoading();
      } else if (tabController.index == 2) {
        //   to move the product to waiting state
        isProcessLoading();
        await _firebaseFirestore
            .collection('orders')
            .doc(userDetails.id)
            .collection('requests')
            .doc(userId)
            .collection(userId)
            .doc(billId)
            .collection(billId)
            .doc(requestId)
            .update({
          '$_state': waitingState,
          '$_isAccepted': false,
          '$_isRejected': false,
        });
        isProcessNotLoading();
      }
    } catch (e) {
      print(e);
    }
  }

  acceptAllBill({userId, billId}) async {
    try {
      var userDetails = UserStorage().getUserInfo();
      if (userDetails.id.isNotEmpty) {
        isProcessLoading();
        // to get the bill documents
        var billDetails = await _firebaseFirestore
            .collection('orders')
            .doc(userDetails.id)
            .collection('requests')
            .doc(userId)
            .collection(userId)
            .doc(billId)
            .collection(billId)
            .where(_state, isEqualTo: waitingState)
            .where(_isAccepted, isEqualTo: false)
            .where(_isRejected, isEqualTo: false)
            .get();

        if (billDetails != null && billDetails.docs.length > 0) {
          for (int i = 0; i < billDetails.docs.length; i++) {
            // TO GET THE BONUS TO ADD IT TO THE QUANTITY
            int bonus = getBonus(
                orderQuantity: billDetails.docs[i]['orderedQuantity'],
                bonus: billDetails.docs[i]['bonus']);
            // TO CHECK THE QUANTITY OF THE PRODUCT
            bool _isAllowed = await quantityAllowToAccept(
                productId: billDetails.docs[i]['productId'],
                orderQuantity: billDetails.docs[i]['orderedQuantity'],
                bonus: bonus);
            if (_isAllowed) {
              // TO CHANGE THE QUANTITY OF PRODUCT
              double finalQuantity = changedQuantity(
                  quantity: sharedProductQuantity,
                  orderedQ: billDetails.docs[i]['orderedQuantity']);
              await _firebaseFirestore
                  .collection('products')
                  .doc(billDetails.docs[i]['productId'])
                  .update({
                'quantity': '${finalQuantity - bonus}'
              });

              // TO ACCEPT THE SINGLE REQUEST
              await _firebaseFirestore
                  .collection('orders')
                  .doc(userDetails.id)
                  .collection('requests')
                  .doc(userId)
                  .collection(userId)
                  .doc(billId)
                  .collection(billId)
                  .doc(billDetails.docs[i].id)
                  .update({
                '$_state': acceptState,
                '$_isAccepted': true,
                '$_isRejected': false,
                'bonusNumber': bonus
              });
            }
          }
        }
      }
      isProcessNotLoading();
    } catch (e) {
      isProcessNotLoading();
      print(e);
    }
  }

  getBonus({orderQuantity, bonus}) {
    try {
      if (bonus != null && bonus.toString().isNotEmpty) {
        double ordQ = double.parse(orderQuantity.toString());
        double bon = double.parse(bonus.toString());
        int result = (ordQ * (bon / 100)).toInt();
        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  double changedQuantity({orderedQ, quantity}) {
    try {
      double ordQ = double.parse(orderedQ.toString());
      double proQuantity = double.parse(quantity.toString());
      return (proQuantity - ordQ);
    } catch (e) {
      return 0.0;
    }
  }

  rejectAllBill({userId, billId}) async {
    try {
      var userDetails = UserStorage().getUserInfo();
      if (userDetails.id != null && userDetails.id.isNotEmpty) {
        isProcessLoading();
        // to get the bill documents
        var billDetails = await _firebaseFirestore
            .collection('orders')
            .doc(userDetails.id)
            .collection('requests')
            .doc(userId)
            .collection(userId)
            .doc(billId)
            .collection(billId)
            .where(_state, isEqualTo: acceptState)
            .where(_isAccepted, isEqualTo: true)
            .where(_isRejected, isEqualTo: false)
            .get();
        if (billDetails != null && billDetails.docs.length > 0) {
          for (int i = 0; i < billDetails.docs.length; i++) {
            // TO RETURN THE QUANTITY THAT ALREADY TAKE IT FROM PRODUCTS
            await returnQuantity(
                productId: billDetails.docs[i]['productId'],
                returnedQuantity: billDetails.docs[i]['orderedQuantity'],
              bonus: billDetails.docs[i]['bonusNumber'],
            );

            await _firebaseFirestore
                .collection('orders')
                .doc(userDetails.id)
                .collection('requests')
                .doc(userId)
                .collection(userId)
                .doc(billId)
                .collection(billId)
                .doc(billDetails.docs[i].id)
                .update({
              '$_state': rejectedState,
              '$_isAccepted': false,
              '$_isRejected': true,
            });
          }
        }
      }
      isProcessNotLoading();
    } catch (e) {
      print(e);
    }
  }

  unRejectAllBill({userId, billId}) async {
    try {
      var userDetails = UserStorage().getUserInfo();
      if (userDetails.id.isNotEmpty) {
        isProcessLoading();
        // to get the bill documents
        var billDetails = await _firebaseFirestore
            .collection('orders')
            .doc(userDetails.id)
            .collection('requests')
            .doc(userId)
            .collection(userId)
            .doc(billId)
            .collection(billId)
            .where(_state, isEqualTo: rejectedState)
            .where(_isAccepted, isEqualTo: false)
            .where(_isRejected, isEqualTo: true)
            .get();
        if (billDetails != null && billDetails.docs.length > 0) {
          for (int i = 0; i < billDetails.docs.length; i++) {
            await _firebaseFirestore
                .collection('orders')
                .doc(userDetails.id)
                .collection('requests')
                .doc(userId)
                .collection(userId)
                .doc(billId)
                .collection(billId)
                .doc(billDetails.docs[i].id)
                .update({
              '$_state': waitingState,
              '$_isAccepted': false,
              '$_isRejected': false,
            });
          }
        }
      }
      isProcessNotLoading();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> quantityAllowToAccept(
      {productId, orderQuantity, int bonus}) async {
    try {
      sharedProductQuantity = 0.0;
      var product = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();
      if (product != null &&
          product['quantity'] != null &&
          product['quantity'].toString().isNotEmpty) {
        double proQuantity = double.parse(product['quantity'].toString());
        double ordQuantity = double.parse(orderQuantity.toString());

        // to pass the real product quantity to method 'acceptAllBill'
        sharedProductQuantity = proQuantity;
        // -------------------------

        if (proQuantity != null && proQuantity > 0) {
          // to limit the quantity bigger than zero
          if (proQuantity < ordQuantity) {
            //  the exist quantity is less than the order quantity
            showDialog(
                context: Get.context,
                builder: (context) => CustomAlert(
                      title: 'خطأ في الكمية',
                      content: 'كمية الطلب اكبر من الكمية المتوفر حالياً!!',
                      onPressed1: () => Get.back(),
                      firstButtonText: 'موافق',
                    ));
          } else if (proQuantity > ordQuantity &&
              proQuantity < (ordQuantity + bonus)) {
            showDialog(
                context: Get.context,
                builder: (context) => CustomAlert(
                      title: 'خطأ في الكمية',
                      content:
                          'لايوجد بونص كافي لهذه العملية الرجاء إضافة كمية!!',
                      onPressed1: () => Get.back(),
                      firstButtonText: 'موافق',
                    ));
          } else if (proQuantity >= ordQuantity) {
            //  here you can add the product to the cart
            return true;
          }
        } else {
          if (proQuantity == 0) {
            //  there's no quantity exist
            showDialog(
                context: Get.context,
                builder: (context) => CustomAlert(
                      title: 'خطأ في الكمية',
                      content: 'لا تتوفر اي كمية حاليا لهذا المنتج !!',
                      onPressed1: () => Get.back(),
                      firstButtonText: 'موافق',
                    ));
          } else {
            //  some error happen
            showDialog(
                context: Get.context,
                builder: (context) => CustomAlert(
                      title: 'خطأ في الكمية',
                      content: 'حدث خطأ غير متوقع الرجاء المحاولة لاحقاً !!',
                      onPressed1: () => Get.back(),
                      firstButtonText: 'موافق',
                    ));
          }
        }
        return false;
      }
      return false;
    } catch (e) {
      print('------------ quantityAllowToAccept');
      return false;
    }
  }

  floatingButtonProcess({userId, billId}) async {
    switch (tabController.index) {
      case 0:
        {
          await acceptAllBill(userId: userId, billId: billId);
          break;
        }
      case 1:
        {
          await rejectAllBill(userId: userId, billId: billId);
          break;
        }
      case 2:
        {
          await unRejectAllBill(userId: userId, billId: billId);
          break;
        }
    }
  }

  Future<void> returnQuantity({productId, returnedQuantity, bonus=0}) async {
    var product =
        await _firebaseFirestore.collection('products').doc(productId).get();
    if (product != null && product['quantity'] != null) {
      double quantity = double.parse(product['quantity'].toString());
      double retQuantity = double.parse(returnedQuantity.toString());
      quantity += retQuantity;
      int bon = 0;
      if(bonus.toString().isNotEmpty){
        bon = bonus;
      }
      quantity +=bon;
      await _firebaseFirestore
          .collection('products')
          .doc(productId)
          .update({'quantity': quantity});
    }
  }
}
