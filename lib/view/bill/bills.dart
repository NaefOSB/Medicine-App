import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/core/view_model/bill_model_view.dart';
import 'package:medicine_app/view/bill/bill_details.dart';
import 'package:medicine_app/view/widgets/custom_bill_card.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Bills extends StatelessWidget {
  String targetId;
  String accountType;
  String supplierId;

  Bills({this.targetId, this.accountType, this.supplierId});


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<BillModelView>(
      init: BillModelView(),
      builder:(controller) => Directionality(
          textDirection: TextDirection.rtl,
          child: ModalProgressHUD(
            inAsyncCall: controller.isLoading,
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                title: Text(
                  'قائمة الطلبات',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: fourthColor,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: fourthColor,
                  ),
                  onPressed: () => Get.back(),
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                // backgroundColor: backgroundColor,
                elevation: 0,
                toolbarHeight: size.height * 0.12,
              ),
              body: StreamBuilder(
                // targetId is the id of SUPPLIER if the current user is CLIENT
                // targetId is the id of CLIENT if the current user is SUPPLIER

                stream: (accountType == 'CLIENT')
                    ? FirebaseFirestore.instance
                        .collection('orders')
                        .doc(targetId)
                        .collection('requests')
                        .doc(UserStorage().getUserInfo().id)
                        .collection(UserStorage().getUserInfo().id)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('orders')
                        .doc((accountType == 'ADMIN')
                            ? supplierId
                            : UserStorage().getUserInfo().id)
                        .collection('requests')
                        .doc(targetId)
                        .collection(targetId)
                        .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data.docs.length > 0) {
                    final bills = snapshot.data.docs;

                    return ListView.builder(
                      itemCount: bills.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CustomBillCard(
                          title: ' الطلب رقم ${bills[index].id.toString()}',
                          accountType: accountType,
                          billId: bills[index].id.toString(),
                          userId:targetId,
                          storeId: _getStoreId(),
                          clientId:(accountType == 'CLIENT')
                              ? UserStorage().getUserInfo().id
                              : targetId,

                          onTap: () => Get.to(() => BillDetails(
                                billNumber: bills[index].id.toString(),
                                storeId: _getStoreId(),
                                userId: (accountType == 'CLIENT')
                                    ? UserStorage().getUserInfo().id
                                    : targetId,
                              )),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return CustomText(
                      title: 'حدث خطأ',
                      alignment: Alignment.center,
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          )),
    );
  }

  String _getStoreId() {
    if (accountType == 'SUPPLIER') {
      return UserStorage().getUserInfo().id;
    } else if (accountType == 'ADMIN') {
      return supplierId;
    } else {
      return targetId;
    }
  }
}
