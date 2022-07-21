import 'package:get/get.dart';
import 'package:medicine_app/core/services/user_storage.dart';

class ProductCardViewModel extends GetxController {
  bool isAllowedToSeePrice({storeId}) {
    try {
      var userDetails = UserStorage().getUserInfo();
      // to check if everything is right
      if (userDetails.id != null &&
          userDetails.id.isNotEmpty &&
          userDetails.accountType.isNotEmpty) {
        if (userDetails.accountType == 'ADMIN' ||
            userDetails.accountType == 'CLIENT' ||
            userDetails.accountType == 'SUPPLIER' &&
                userDetails.id == storeId) {
          return true;
        }
      }
      // if the userDetails is null then it will not show the price
      // because the anonymous user can not see the price only 3 can see:
      // 1 - ADMIN
      // 2 - CLIENT
      // 3 - SUPPLIER owner
      return false;
    } catch (e) {
      return false;
    }
  }
}
