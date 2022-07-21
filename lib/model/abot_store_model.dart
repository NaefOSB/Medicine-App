class AboutStoreModel {
  String storeId;
  String description;
  String address;
  String bankAccounting;
  String phoneNumber1;
  String phoneNumber2;

  AboutStoreModel(
      {this.storeId,
      this.description,
      this.address,
      this.bankAccounting,
      this.phoneNumber1,
      this.phoneNumber2});

  AboutStoreModel.fromJson(Map<dynamic, dynamic> map, String storeId) {
    if (map == null) {
      return;
    }

    this.storeId = storeId;
    description = map['description'].toString();
    address = map['address'].toString();
    bankAccounting = map['bankAccounting'].toString();
    phoneNumber1 = map['phoneNumber1'].toString();
    phoneNumber2 = map['phoneNumber2'].toString();
  }
}
