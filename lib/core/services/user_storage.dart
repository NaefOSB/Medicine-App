import 'package:get_storage/get_storage.dart';
import 'package:medicine_app/model/user_information.dart';

class UserStorage {
  static GetStorage _getStorage;

  factory UserStorage() => UserStorage._internal();

  UserStorage._internal();

  init() {
    _getStorage ??= GetStorage();
  }

  String read(String key) {
    return _getStorage?.read(key);
  }

  void write(String key, dynamic value) {
    _getStorage.write(key, value);
  }

  setUserInfo(UserInformation userInformation) async {
    await init();
    write('userId', userInformation.id);
    write('name', userInformation.name);
    write('accountType', userInformation.accountType);
    write('storeName', userInformation.storeName);
    write('saleState', userInformation.saleState);
  }

  UserInformation getUserInfo() {
    _getStorage = GetStorage();
    String userId = read('userId');
    String name = read('name');
    String accountType = read('accountType');
    String storeName = read('storeName');
    String saleState = read('saleState').toString();
    UserInformation user = UserInformation(
        id: userId,
        name: name,
        accountType: accountType,
        storeName: storeName,
        saleState: saleState);
    return user;
  }

  void clearAll() async {
    await init();
    await _getStorage.erase();
  }
}
