class ProductModel {
  String id;
  String name;
  String price;
  String quantity;
  String description;
  String storeID;
  String storeName;
  String type;
  String endDate;
  String bonus;
  String visibility;
  String currency;
  String categoryId;

  ProductModel(
      {this.id,
      this.name,
      this.price,
      this.quantity,
      this.description,
      this.storeID,
      this.storeName,
      this.type,
      this.endDate,
      this.bonus,
      this.visibility,
      this.currency,
      this.categoryId});

  ProductModel.fromJson(Map<dynamic, dynamic> map, String productID) {
    if (map == null) {
      return;
    }

    id = productID;
    name = map['name'].toString();
    price = map['price'].toString();
    quantity = map['quantity'].toString();
    description = map['description'].toString();
    storeID = map['storeID'].toString();
    storeName = map['storeName'].toString();
    type = map['type'].toString();
    endDate = map['endDate'].toString();
    bonus = map['bonus'].toString();
    visibility = map['visibility'].toString();
    currency = map['currency'].toString();
    categoryId = map['categoryId'].toString();
  }
}
