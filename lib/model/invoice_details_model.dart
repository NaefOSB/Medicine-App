class InvoiceDetailsModel {
  String name;
  String bonus;
  String price;
  String orderedQuantity;
  String productId;
  String currency;
  String state;
  String storeId;
  int bonusNumber;
  bool isAccepted;
  bool isRejected;
  var orderDate;

  InvoiceDetailsModel(
      {this.name,
      this.bonus,
      this.price,
      this.orderedQuantity,
      this.bonusNumber,
      this.productId,
      this.currency,
      this.state,
      this.storeId,
      this.isAccepted,
      this.isRejected,
      this.orderDate});

  InvoiceDetailsModel.fromJson(Map<String, dynamic> map) {
    if (map == null) return;

    name = map['name'];
    bonus = map['bonus'].toString();
    price = map['price'].toString();
    orderedQuantity = map['orderedQuantity'].toString();
    productId = map['productId'];
    state = map['state'];
    currency = map['currency'];
    storeId = map['storeId'];
    isAccepted = map['isAccepted'];
    isRejected = map['isRejected'];
    bonusNumber = map['bonusNumber'];
    // orderDate = map['orderDate'];
  }
}
