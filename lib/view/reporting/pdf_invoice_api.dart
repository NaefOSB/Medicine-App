import 'dart:io';
import 'package:flutter/services.dart';
import 'package:medicine_app/model/invoice_details_model.dart';
import 'package:medicine_app/model/invoice_header_model.dart';
import 'package:medicine_app/view/reporting/pdf_api.dart';
import 'package:medicine_app/view/reporting/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(
      {List<InvoiceDetailsModel> invoice, InvoiceHeaderModel header}) async {
    final pdf = Document();

    //new
    var arabicFont =
        Font.ttf(await rootBundle.load("assets/fonts/HacenTunisia.ttf"));

    pdf.addPage(
      MultiPage(
        textDirection: TextDirection.rtl,
        theme: ThemeData.withFont(
          base: arabicFont,
        ),

        // ---------- HEADER----------
        header: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: buildHeader(header: header),
        ),
        build: (context) => [
          SizedBox(height: 10),
          // ----------- TITLE --------------
          Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                child: buildTitle(),
              )),
          if (invoice.length <= 12) ...{
            buildInvoice(invoice),
          } else ...{
            // TABLE TITLE
            Container(
              decoration: BoxDecoration(
                  color: PdfColor.fromHex('e0e0e0'),
                  border: Border.all(
                    color: PdfColors.grey,
                  )),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text('الأجمالي')),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text('السعر')),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text('البونص')),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text('الكمية')),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text('أسم المنتج')),
                  ]),
            ),

            //  TABLE ROWS
            for (int i = 0; i < invoice.length; i++) ...{
              Container(
                decoration: BoxDecoration(
                  border: (i == 0)
                      ? Border(
                          bottom: BorderSide(color: PdfColor.fromHex('545454')),
                        )
                      : Border(
                          bottom: BorderSide(color: PdfColor.fromHex('545454')),
                        ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                              '${(getTotlePrice(price: invoice[i].price, quantity: invoice[i].orderedQuantity))}')),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text('${invoice[i].price}')),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text('${invoice[i].bonus}')),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text('${invoice[i].orderedQuantity}')),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text('${invoice[i].name}')),
                    ]),
              ),
            },
          },
          SizedBox(height: 10.0),
          buildTotal(invoice)
        ],

        footer: (context) => buildFooter(header),

        // pageFormat: PdfPageFormat.roll57
        maxPages: 100,
      ),
    );

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static getTotlePrice({price, quantity}) {
    double pri = double.parse(price);
    double quan = double.parse(quantity);
    return pri * quan;
  }

  static Widget buildHeader({InvoiceHeaderModel header}) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Row(children: [
                  RichText(
                      text: TextSpan(
                    text: '${header.clientName}',
                  )),
                  SizedBox(width: 20),
                  RichText(
                      text: TextSpan(
                    text: 'العميل',
                  )),
                ]),
                Row(children: [
                  RichText(
                      text: TextSpan(
                    text: '${header.clientAddress}',
                  )),
                  SizedBox(width: 20),
                  RichText(
                      text: TextSpan(
                    text: 'الموقع',
                  )),
                ]),
                Row(children: [
                  RichText(
                      text: TextSpan(
                    text: '${header.invoiceNumber}',
                  )),
                  SizedBox(width: 20),
                  RichText(
                      text: TextSpan(
                    text: 'رقم الفاتورة',
                  )),
                ]),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Row(children: [
                  RichText(
                      text: TextSpan(
                    text: '${header.storeName}',
                  )),
                  SizedBox(width: 20),
                  RichText(
                      text: TextSpan(
                    text: 'المحل',
                  )),
                ]),
                Row(children: [
                  RichText(
                      text: TextSpan(
                    text: '${header.storeAddress}',
                  )),
                  SizedBox(width: 20),
                  RichText(
                      text: TextSpan(
                    text: 'الموقع',
                  )),
                ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(
                        text: '${header.invoiceDate}',
                      )),
                      SizedBox(width: 20),
                      RichText(
                          text: TextSpan(
                        text: 'تاريخ الفاتورة',
                      )),
                    ]),
              ]),
            ],
          ),
        ),
      );

  static Widget buildTitle() => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'فاتورة طلب شراء',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(height: 0.8 * PdfPageFormat.cm),
                RichText(text: TextSpan(text: 'تفاصيل الطلب ')),
                SizedBox(height: 0.8 * PdfPageFormat.cm),
              ],
            ),
          ]),
        ),
      );

  static String getState(String state) {
    switch (state) {
      case 'waiting':
        {
          return 'منتظرة';
        }
      case 'accepted':
        {
          return 'مقبولة';
        }
      case 'rejected':
        {
          return 'مرفوضة';
        }
    }
    return '';
  }

  static Widget buildInvoice(List<InvoiceDetailsModel> invoice) {
    final headers = [
      'الإجمالي',
      'الحالة',
      'السعر',
      'البونص',
      'الكمية',
      'أسم المنتج'
    ];
    final data = invoice.map((item) {
      // final total = item.unitPrice * item.quantity * (1 + item.vat);
      final total =
          double.parse(item.price) * double.parse(item.orderedQuantity);

      return [
        '${item.currency} ${total.toStringAsFixed(2)}',
        '${getState(item.state)}',
        item.price,
        (item.bonusNumber == 0 || item.bonusNumber.toString().isEmpty)
            ? ''
            : '${item.bonusNumber}',
        item.orderedQuantity,
        '${item.name}'
      ];
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Table.fromTextArray(
        headers: headers,
        data: data,
        // border: null,
        border: TableBorder(
          horizontalInside: BorderSide(color: PdfColors.grey500),
          left: BorderSide(color: PdfColors.grey500),
          right: BorderSide(color: PdfColors.grey500),
          top: BorderSide(color: PdfColors.grey500),
          bottom: BorderSide(color: PdfColors.grey500),
        ),
        // headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: BoxDecoration(color: PdfColors.grey300),
        cellHeight: 30,
        cellAlignments: {
          0: Alignment.center,
          1: Alignment.center,
          2: Alignment.center,
          3: Alignment.center,
          4: Alignment.center,
          5: Alignment.center,
        },
      ),
    );
  }

  static bool isMultiCurrency(List<InvoiceDetailsModel> invoice) {
    bool isMultiCurrency = false;
    var currency = invoice[0].currency;
    for (int i = 0; i < invoice.length; i++) {
      if (invoice[i].currency != currency) {
        isMultiCurrency = true;
        break;
      }
    }

    return isMultiCurrency;
  }

  static Widget buildTotal(List<InvoiceDetailsModel> invoice) {
    bool isInvoiceMultiCurrency = isMultiCurrency(invoice);
    List<String> currencies = [];
    // this list will hold the total of single currency of currency list index
    List<double> totalPrices = [];
    double netTotal = 0.0;

    if (isInvoiceMultiCurrency) {
      // to get all currencies in the invoice
      for (int i = 0; i < invoice.length; i++) {
        if (!currencies.contains(invoice[i].currency)) {
          currencies.add(invoice[i].currency);
        }
      }

      // to get the total of single currency
      for (int i = 0; i < currencies.length; i++) {
        // to move to every single product
        var totalOfSingleCurrency = 0.0;
        for (int j = 0; j < invoice.length; j++) {
          if (invoice[j].currency == currencies[i]) {
            totalOfSingleCurrency += (double.parse(invoice[j].price) *
                double.parse(invoice[j].orderedQuantity));
          }
        }
        totalPrices.add(totalOfSingleCurrency);
      }
    } else {
      netTotal = invoice
          .map((item) =>
              double.parse(item.price) * double.parse(item.orderedQuantity))
          .reduce((item1, item2) => item1 + item2);
    }

    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText2(
                  title: '${invoice.length}',
                  value: 'عدد المنتجات ',
                  unite: true,
                ),
                Divider(),
                if (!isInvoiceMultiCurrency) ...{
                  buildText2(
                    title:
                        '${invoice[0].currency} ${netTotal.toStringAsFixed(2)}',
                    value: 'إجمالي السعر ',
                    unite: true,
                    size: 14,
                  )
                } else ...{
                  for (int i = 0; i < currencies.length; i++) ...{
                    buildText2(
                      title:
                          '${currencies[i]} ${totalPrices[i].toStringAsFixed(2)}',
                      value: 'إجمالي السعر ',
                      unite: true,
                      size: 14,
                    )
                  },
                },
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
          Spacer(flex: 6),
        ],
      ),
    );
  }

  static Widget buildFooter(InvoiceHeaderModel footer) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'العنوان', value: footer.storeAddress),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'للتواصل ', value: footer.storePhoneNumber),
        ],
      );

  static buildSimpleText({
    String title,
    String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Text(title, style: style),

        RichText(
            text: TextSpan(
          text: value,
        )),
        SizedBox(width: 2 * PdfPageFormat.mm),
        RichText(
            text: TextSpan(
          text: title,
        )),
        // Text(value),
      ],
    );
  }

  static buildText2({
    String title,
    String value,
    double width = double.infinity,
    double size,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    // final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: RichText(
                  text: TextSpan(
                    text: title,
                  ),
                  textDirection: TextDirection.rtl)),
          RichText(
              text: TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: size,
                  )),
              textDirection: TextDirection.rtl),
          // Text(value, style: unite ? style : null),
        ],
      ),
    );
  }

  static getTableRows({List<InvoiceDetailsModel> invoice}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(children: []),
    );
  }
}
