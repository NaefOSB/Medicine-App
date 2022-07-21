class InvoiceHeaderModel {
  String storeName;
  String clientName;
  String storeAddress;
  String clientAddress;
  String storePhoneNumber;
  String invoiceNumber;
  String invoiceDate;

  InvoiceHeaderModel(
      {this.storeName,
      this.clientName,
      this.storeAddress,
      this.clientAddress,
      this.storePhoneNumber,
      this.invoiceNumber,
      this.invoiceDate});
}
