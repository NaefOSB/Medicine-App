import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/view/home_page/initialize_page.dart';
import 'package:medicine_app/view/single_store/single_store.dart';

class HomePageViewModel extends GetxController {
  double xOffset = 0;
  double yOffset = 0;

  bool isDrawerOpen = false;

  getFloatingButtonText() {
    var userDetails = UserStorage().getUserInfo();
    if (userDetails.id != null &&
        userDetails.id.isNotEmpty &&
        userDetails.accountType.isNotEmpty) {
      if (userDetails.accountType == 'SUPPLIER') {
        return 'متجري';
      } else {
        return 'الرئيسية';
      }
    } else {
      return 'الرئيسية';
    }
  }

  floatingButtonProcess() {
    var userDetails = UserStorage().getUserInfo();
    var floatingButtonText = getFloatingButtonText();
    if (floatingButtonText == 'متجري' &&
        userDetails.id != null &&
        userDetails.id.isNotEmpty) {
      //  to navigate the supplier to his store
      Get.to(() => SingleStore(
            storeID: userDetails.id,
            storeName: userDetails.storeName,
            saleState: userDetails.saleState.toLowerCase() == 'true',
          ));
    } else {}
  }

  onDrawerPressed() {
    if (isDrawerOpen) {
      xOffset = 0;
      yOffset = 0;
      isDrawerOpen = false;
    } else {
      xOffset = 290;
      yOffset = 80;
      isDrawerOpen = true;
    }
    update();
  }

  closeDrawer() {
    xOffset = 0;
    yOffset = 0;
    isDrawerOpen = false;
    update();
  }

  isUserAdmin() {
    try {
      var userDetails = UserStorage().getUserInfo();
      if (userDetails.id != null &&
          userDetails.id.isNotEmpty &&
          userDetails.accountType.isNotEmpty) {
        return (userDetails.accountType == 'ADMIN');
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  getUserAccountType() {
    try {
      var userDetails = UserStorage().getUserInfo();
      if (userDetails.id != null &&
          userDetails.id.isNotEmpty &&
          userDetails.accountType.isNotEmpty) {
        return userDetails.accountType;
      } else {
        return 'UNAUTHENTICATED';
      }
    } catch (e) {
      return 'UNAUTHENTICATED';
    }
  }

  signOut() async {
    // isDrawerOpen = false;
    await FirebaseAuth.instance.signOut();
    UserStorage().clearAll();
    Get.offAll(() => InitializePage());
  }
}
