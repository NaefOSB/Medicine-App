class CartProductModel {
  int id;
  String productId;
  String storeId;
  String storeName;
  String name;
  String image;
  String price;
  double quantity;
  String description;
  String bonus;
  String currency;

  CartProductModel(
      {this.id,
      this.productId,
      this.storeId,
      this.storeName,
      this.name,
      this.image,
      this.price,
      this.quantity,
      this.description,
      this.bonus,
      this.currency});

  CartProductModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    id = map['id'];
    productId = map['productId'].toString();
    name = map['name'].toString();
    image = map['image'].toString();
    price = map['price'].toString();
    quantity = map['quantity'];
    description = map['description'].toString();
    storeId = map['storeId'].toString();
    storeName = map['storeName'].toString();
    bonus = map['bonus'].toString();
    currency = map['currency'].toString();
  }

  toJson() {
    return {
      'id': id,
      'productId': productId,
      'storeId': storeId,
      'storeName': storeName,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'description': description,
      'bonus': bonus,
      'currency': currency
    };
  }
}
