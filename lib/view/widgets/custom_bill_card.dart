import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/core/view_model/bill_model_view.dart';

import 'custom_text.dart';

class CustomBillCard extends GetWidget<BillModelView> {
  final String title;
  final Function onTap;
  final String accountType;
  final String billId;
  final String userId;
  final String storeId;
  final String clientId;

  CustomBillCard(
      {this.title,
      this.onTap,
      this.accountType,
      this.billId,
      this.userId,
      this.clientId,
      this.storeId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: ListTile(
          title: CustomText(
            title: title,
            fontSize: 19.0,
          ),
          leading: Icon(Icons.receipt_long),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          trailing: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.print,
                      color: kPrimaryColor,
                    ),
                    onPressed: () => controller.printBill(
                        storeId: storeId, clientId: clientId,billID: billId)),
                (UserStorage().getUserInfo().accountType == 'SUPPLIER' &&
                        accountType == 'SUPPLIER')
                    ? IconButton(
                        icon: Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.red,
                        ),
                        onPressed: () => controller.deleteBill(
                            userId: userId, billId: billId))
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
