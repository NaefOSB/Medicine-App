import 'package:get/get.dart';

class StoresViewModel extends GetxController {
  bool hasData = false;

  void isHavingData() {
    hasData = true;
    update();
  }

  void isHavingNoData() {
    hasData = false;
    update();
  }
}
