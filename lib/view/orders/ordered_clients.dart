import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/services/process_management.dart';
import 'package:medicine_app/view/bill/bills.dart';
import 'package:medicine_app/view/widgets/bottom_bar.dart';
import 'package:medicine_app/view/widgets/category_card.dart';
import 'package:medicine_app/view/widgets/custom_floating_button.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';

class OrderedClients extends StatelessWidget {
  var stream;
  var accountType;
  var supplierId;

  OrderedClients({this.stream, this.accountType, this.supplierId});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: CustomText(
            title: (accountType == 'CLIENT') ? 'طلباتي' : 'طلبات العملاء',
            alignment: Alignment.center,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: fourthColor,
          ),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 15.0),
            Container(
              padding: EdgeInsets.only(right: 10.0, top: 50.0,left: 10.0),
              width: MediaQuery.of(context).size.width - 30.0,
              height: MediaQuery.of(context).size.height - 50.0,
              child: StreamBuilder(
                stream: stream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data.docs.length > 0) {
                    final stores = snapshot.data.docs;

                    return GridView.count(
                      crossAxisCount: 3,
                      primary: false,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 15.0,
                      childAspectRatio: 0.6,
                      children: <Widget>[
                        for (int i = 0; i < stores.length; i++) ...{
                          CustomCard(
                              name: stores[i]['storeName'].toString(),
                              imgPathTag: stores[i]['storeName'].toString(),
                              imgPath: 'assets/images/store.png',
                              onTap: () => Get.to(() => Bills(
                                    targetId: stores[i].id,
                                    accountType: accountType,
                                    supplierId: supplierId,
                                  ))),
                        }
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return CustomText(
                      title: 'حدث خطأ',
                      alignment: Alignment.center,
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: CustomFloatingButton(
          text: 'طلباتي',
          onPressed: () =>ProcessManagement.adminAndSupplierRequests(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomBar(
          state: 'MYORDERS',
        ),
      ),
    );
  }
}
