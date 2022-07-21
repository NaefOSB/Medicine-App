import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/model/invoice_details_model.dart';
import 'package:medicine_app/model/invoice_header_model.dart';
import 'package:medicine_app/view/reporting/pdf_api.dart';
import 'package:medicine_app/view/reporting/pdf_invoice_api.dart';
import 'package:medicine_app/view/reporting/utils.dart';
import 'package:medicine_app/view/widgets/custom_alert.dart';

class BillModelView extends GetxController {
  bool isLoading = false;

  isProcessLoading() {
    isLoading = true;
    update();
  }

  isProcessNotLoading() {
    isLoading = false;
    update();
  }

  deleteBill({userId, billId}) async {
    try {
      showDialog(
          context: Get.context,
          builder: (context) => CustomAlert(
                title: 'عملية حذف فاتورة',
                content:
                    'هل أنت متأكد من انك تريد حذف هذه الفاتورة بشكل نهائي ؟!!',
                contentAlignment: Alignment.center,
                firstButtonText: 'لا',
                secondButtonText: 'نعم',
                hasSecondButton: true,
                onPressed1: () => Get.back(),
                onPressed2: () async {
                  isProcessLoading();
                  Get.back();
                  await FirebaseFirestore.instance
                      .collection('orders')
                      .doc('${UserStorage().getUserInfo().id}')
                      .collection('requests')
                      .doc('$userId')
                      .collection('$userId')
                      .doc('$billId')
                      .delete();
                  isProcessNotLoading();
                },
              ));
    } catch (e) {
      isProcessNotLoading();
      print(e);
    }
  }

  Future<InvoiceHeaderModel> getInvoiceHeader({storeId, clientId}) async {
    try {
      var storeDetails = await FirebaseFirestore.instance
          .collection('users')
          .doc(storeId)
          .get();
      var clientDetails = await FirebaseFirestore.instance
          .collection('users')
          .doc(clientId)
          .get();

      if (storeDetails != null &&
          storeDetails['storeName'] != null &&
          clientDetails != null) {
        //  TO GIVE THE INVOICE THE HEADER DATA
        InvoiceHeaderModel header = InvoiceHeaderModel(
            storeName: storeDetails['storeName'],
            storeAddress: storeDetails['address'],
            clientName: clientDetails['userName'],
            clientAddress: clientDetails['address'],
            storePhoneNumber: storeDetails['phoneNumber']);
        return header;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  printBill({storeId, clientId, billID}) async {
    List<InvoiceDetailsModel> invoice = List<InvoiceDetailsModel>();
    InvoiceHeaderModel header;

    var bill = await FirebaseFirestore.instance
        .collection('orders')
        .doc('$storeId')
        .collection('requests')
        .doc('$clientId')
        .collection('$clientId')
        .doc('$billID')
        .collection('$billID')
        .get();

    if (bill != null && bill.docs.length > 0) {
      header = await getInvoiceHeader(storeId: storeId, clientId: clientId);
      header.invoiceNumber = billID;
      Timestamp timestamp = bill.docs[0]['orderDate'];
      DateTime time =
          DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
      // DateTime date = bill.docs[0]['orderDate'].toDate();
      // header.invoiceDate = bill.docs[0]['orderDate'].toDate();
      header.invoiceDate = Utils.formatDate(time);
      for (int i = 0; i < bill.docs.length; i++) {
        invoice.add(InvoiceDetailsModel.fromJson(bill.docs[i].data()));
      }

      // to make to report
      final pdfFile =
          await PdfInvoiceApi.generate(invoice: invoice, header: header);

      // to open pdf file
      PdfApi.openFile(pdfFile);
    }
  }
}
