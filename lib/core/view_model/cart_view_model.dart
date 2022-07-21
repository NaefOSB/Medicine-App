import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/core/services/database/cart_database_helper.dart';
import 'package:medicine_app/core/services/process_management.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/model/cart_product_model.dart';
import 'package:medicine_app/view/widgets/custom_alert.dart';

class CartViewModel extends GetxController {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  bool loading = false;

  List<CartProductModel> _cartProductModel = List<CartProductModel>();

  List<CartProductModel> get cartProductModel => _cartProductModel;

  CartProductModel oldCart = CartProductModel();

  CartViewModel() {
    getAllCartProducts();
  }

  isProcessLoading() {
    loading = true;
    update();
  }

  isProcessNotLoading() {
    loading = false;
    update();
  }

  bool isUserLogin() {
    try {
      var user = UserStorage().getUserInfo();
      if (user.id != null && user.id.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  addProductToCart(
      CartProductModel model, productQuantity, visibility, salesState) async {
    // to check if user is login or not
    bool authenticated = isUserLogin();
    if (authenticated) {
      // to check if the store allow to sales or not
      if (salesState) {
        // if this store allow to sale
        var isAllowedToCart = checkIfProductQuantityAllowed(
            orderQuantity: model.quantity,
            productQuantity: productQuantity,
            visibility: visibility);
        if (isAllowedToCart) {
          bool isExist = await isProductExist(productId: model.productId);
          if (!isExist) {
            // to add new product to the cart
            var dbHelper = CartDatabaseHelper.db;
            await dbHelper.insert(model);
            await getAllCartProducts();
          } else {
            //  to edit the quantity of a product because it's already in the cart to prevent repetition
            oldCart.quantity = oldCart.quantity + model.quantity;
            await updateCartProduct(model: oldCart);
          }
          Get.snackbar(
            'عملية ناجحة',
            'تم ترحيل الطلب إلى السله، الرجاء تأكيد الطلب',
          );

          update();
        }
      } else {
        // if this store does not allow to sale
        showDialog(
          context: Get.context,
          builder: (context) => CustomAlert(
            title: 'عملية موقفة',
            content: 'المعذرة، الطلبات الان موقفة الرجاء المحاولة لاحقاً',
            firstButtonText: 'موافق',
            onPressed1: () => Get.back(),
          ),
        );
      }
    } else {
      ProcessManagement.requiredLoginAlert();
    }
  }

  bool checkIfProductQuantityAllowed(
      {productQuantity, orderQuantity, visibility}) {
    try {
      if (visibility == 'غير متوفر') {
        showDialog(
            context: Get.context,
            builder: (context) => CustomAlert(
                  title: 'المنتج موقف ',
                  content:
                      'هذا المنتج موقف حالياً من قبل صاحب المحل، الرجاء المحاول لاحقاً',
                  onPressed1: () => Get.back(),
                  firstButtonText: 'موافق',
                ));
        return false;
      } else {
        double proQuantity = double.parse(productQuantity.toString());
        double ordQuantity = double.parse(orderQuantity.toString());
        if (proQuantity != null && proQuantity > 0) {
          // to limit the quantity bigger than zero
          if (proQuantity < ordQuantity) {
            //  the exist quantity is less than the order quantity
            showDialog(
                context: Get.context,
                builder: (context) => CustomAlert(
                      title: 'خطأ في الكمية',
                      content:
                          'لا تتوفر هذه الكمية حاليا الرجاء المحاولة لاحقا، او طلب كمية اقل !!',
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
                      content:
                          'لا تتوفر اي كمية حاليا الرجاء المحاولة لاحقا !!',
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
    } catch (e) {
      print('--------------------------');
      print(e);
      showDialog(
          context: Get.context,
          builder: (context) => CustomAlert(
                title: 'خطأ في الكمية',
                content: 'حدث خطأ غير متوقع الرجاء المحاولة لاحقاً !!',
                onPressed1: () => Get.back(),
                firstButtonText: 'موافق',
              ));
      return false;
    }
  }

  getAllCartProducts() async {
    try {
      var dbHelper = CartDatabaseHelper.db;
      _cartProductModel = await dbHelper.getAllProducts();
      update();
    } catch (e) {
      print(e);
    }
  }

  deleteSingleProduct({int id}) async {
    var dbHelper = CartDatabaseHelper.db;
    await dbHelper.deleteSingleProduct(id);
    await getAllCartProducts();
    update();
  }

  clearCart() async {
    var dbHelper = CartDatabaseHelper.db;
    await dbHelper.deleteAllProduct();
    _cartProductModel.clear();
    update();
  }

  updateCartProduct({CartProductModel model}) async {
    var dbHelper = CartDatabaseHelper.db;
    await dbHelper.updateProduct(model);
    await getAllCartProducts();
    update();
  }

  Future<bool> isProductExist({productId}) async {
    await getAllCartProducts();
    for (int i = 0; i < cartProductModel.length; i++) {
      if (productId == cartProductModel[i].productId) {
        oldCart = cartProductModel[i];
        return true;
      }
    }
    return false;
  }

  Future<int> getBillNumber() async {
    // to get the bill number
    var bill = await _firebaseFirestore.collection('billNumber').get();
    if (bill.docs.length > 0) {
      int billNumber = int.parse(bill.docs[0]['billNumber'].toString());
      billNumber++;
      await _firebaseFirestore
          .collection('billNumber')
          .doc('billNumber')
          .update({'billNumber': billNumber});
      return billNumber;
    } else {
      return 0;
    }
  }

  sendRequestToFirebase() async {
    try {
      // to check if the cart not empty
      if (_cartProductModel.length > 0) {
        isProcessLoading();
        int billNumber = await getBillNumber();
        var userId = UserStorage().getUserInfo().id;
        if (userId != null && userId.isNotEmpty && billNumber != 0) {
          await setUserToStoreClientList(billNumber: billNumber);
          // to add the request to the firebase
          for (int i = 0; i < _cartProductModel.length; i++) {
            var request = _cartProductModel[i];

            // to add the request to the firebase
            await _firebaseFirestore
                .collection('orders')
                .doc(request.storeId)
                .collection('requests')
                .doc('$userId')
                .collection('$userId')
                .doc('$billNumber')
                .collection('$billNumber')
                .add({
              'bonus': request.bonus,
              'bonusNumber': 0,
              'name': request.name,
              'price': request.price,
              'orderedQuantity': request.quantity,
              'productId': request.productId,
              'storeId': request.storeId,
              'orderDate': DateTime.now(),
              'state': 'waiting',
              'isAccepted': false,
              'isRejected': false,
              'currency': request.currency
            });
          }

          //  to clear the cart
          await clearCart();
          isProcessNotLoading();
        }
        isProcessNotLoading();
      }
    } catch (e) {
      isProcessNotLoading();
      print('------------------');
      print(e);
    }
  }

  setUserToStoreClientList({int billNumber}) async {
    try {
      // to add the user to the store in CLIENTS array
      // to let the user know which store does he act with it

      // to get all stores that the user ordered from
      List<String> stores = [];
      _cartProductModel.forEach((store) => stores.add(store.storeId));

      // to remove the repetition
      stores = stores.toSet().toList();

      var userDetails = UserStorage().getUserInfo();
      String userId = userDetails.id;

      for (int i = 0; i < stores.length; i++) {
        // to check if the store is already exist in order collection to avoid error about 'update' method
        DocumentSnapshot docSnapshot = await _firebaseFirestore
            .collection('orders')
            .doc('${stores[i]}')
            .get();
        if (docSnapshot.exists) {
          // just here will add the user id to the store to let him know that he acts with this store
          await _firebaseFirestore
              .collection('orders')
              .doc('${stores[i]}')
              .update({
            'CLIENTS': FieldValue.arrayUnion([userId])
          });
        } else {
          // here will create a new document that has the id of the store and will add CLIENTS array and will add
          // the user id

          var storeDetails = await _firebaseFirestore
              .collection('users')
              .doc(stores[i].toString())
              .get();
          if (storeDetails != null) {
            await _firebaseFirestore
                .collection('orders')
                .doc('${stores[i]}')
                .set({
              'CLIENTS': FieldValue.arrayUnion([userId]),
              'storeName': storeDetails['storeName']
            });
          }
        }

        // to add storeName + billDate to avoid error in returning data from orders collection
        for (int i = 0; i < stores.length; i++) {
          // to add the storeName to the user id document
          await _firebaseFirestore
              .collection('orders')
              .doc(stores[i])
              .collection('requests')
              .doc('$userId')
              .set({
            'storeName': (userDetails.accountType == 'ADMIN')
                ? userDetails.name
                : userDetails.storeName
          });

          //   to add the date of order to bill document to avoid error not exist because empty document
          await _firebaseFirestore
              .collection('orders')
              .doc(stores[i])
              .collection('requests')
              .doc('$userId')
              .collection('$userId')
              .doc('$billNumber')
              .set({'billDate': DateTime.now()});
        }
      }
    } catch (e) {
      print('---------------');
      print(e);
    }
  }
}
