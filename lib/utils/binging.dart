import 'package:get/get.dart';
import 'package:medicine_app/core/view_model/about_store_view_model.dart';
import 'package:medicine_app/core/view_model/auth_view_model.dart';
import 'package:medicine_app/core/view_model/bill_details_view_model.dart';
import 'package:medicine_app/core/view_model/bill_model_view.dart';
import 'package:medicine_app/core/view_model/cart_view_model.dart';
import 'package:medicine_app/core/view_model/category_view_model.dart';
import 'package:medicine_app/core/view_model/edit_account_view_model.dart';
import 'package:medicine_app/core/view_model/home_page_view_model.dart';
import 'package:medicine_app/core/view_model/product_card_view_model.dart';
import 'package:medicine_app/core/view_model/product_view_model.dart';
import 'package:medicine_app/core/view_model/security_view_model.dart';
import 'package:medicine_app/core/view_model/stores_view_model.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthViewModel(), fenix: true);
    Get.lazyPut(() => CategoryViewModel(), fenix: true);
    Get.lazyPut(() => ProductViewModel(), fenix: true);
    Get.lazyPut(() => AboutStoreViewModel(), fenix: true);
    Get.lazyPut(() => EditAccountViewModel(), fenix: true);
    Get.lazyPut(() => CartViewModel(), fenix: true);
    Get.lazyPut(() => BillDetailsViewModel(), fenix: true);
    Get.lazyPut(() => BillModelView(), fenix: true);
    Get.lazyPut(() => SecurityViewModel(), fenix: true);
    Get.lazyPut(() => HomePageViewModel(), fenix: true);
    Get.lazyPut(() => StoresViewModel(), fenix: true);
    Get.lazyPut(() => ProductCardViewModel(), fenix: true);
  }
}
