class UserInformation {
  final String id;
  final String name;
  final String storeName; // the name of store
  final String accountType; // admin ,client,or supplier
  final List<String> activityType; // one or more of category
  final String city;
  final String address;
  final String phoneNumber;
  final String email;
  final String password;
  final String saleState; // if supplier

  UserInformation(
      {this.id = '',
      this.name = '',
      this.storeName = '',
      this.accountType = '',
      this.activityType,
      this.city = '',
      this.address = '',
      this.phoneNumber = '',
      this.email = '',
      this.password = '',
      this.saleState});
}
