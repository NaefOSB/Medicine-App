import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/view/home_page/initialize_page.dart';
import 'package:medicine_app/view/product/manage_product.dart';
import 'package:medicine_app/view/single_store/category/manage_categories.dart';
import 'package:medicine_app/view/single_store/single_store_details.dart';
import 'package:medicine_app/view/widgets/bottom_bar.dart';
import 'package:medicine_app/view/single_store/category/custom_single_store_category.dart';
import 'package:medicine_app/view/widgets/custom_alert.dart';
import 'package:medicine_app/view/widgets/custom_store_menu.dart';

class SingleStore extends StatefulWidget {
  final String storeID;
  final String storeName;
  final bool saleState;

  SingleStore({this.storeID, this.storeName, this.saleState = true});

  @override
  _SingleStoreState createState() => _SingleStoreState();
}

class _SingleStoreState extends State<SingleStore> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: fourthColor),
            onPressed: () => Get.back(),
          ),
          title: Text('${widget.storeName}',
              style: TextStyle(
                  fontSize: 20.0,
                  color: fourthColor,
                  fontWeight: FontWeight.bold)),
          actions: [
            (UserStorage().getUserInfo().id == widget.storeID)
                ? CustomStoreMenu()
                : Container(),
          ],
        ),
        body: Container(
            // padding: EdgeInsets.only(left: 20.0),
            height: MediaQuery.of(context).size.height - 50.0,
            width: double.infinity,
            child: SingleStoreDetails(
              storeID: widget.storeID,
              storeName: widget.storeName,
              saleState: widget.saleState,
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.offAll(() => InitializePage()),
          backgroundColor: kPrimaryColor,
          child: Icon(Icons.home),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}
