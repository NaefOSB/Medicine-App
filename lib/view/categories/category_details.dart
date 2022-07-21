import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/view/home_page/initialize_page.dart';
import 'package:medicine_app/view/stores/stores.dart';
import 'package:medicine_app/view/widgets/bottom_bar.dart';

class CategoryDetails extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  CategoryDetails({this.categoryId, this.categoryName});

  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
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
            icon: Icon(Icons.arrow_back, color: Color(0xFF545D68)),
            onPressed: () => Get.back(),
          ),
          title: Text('${widget.categoryName}',
              style: TextStyle(
                  fontSize: 20.0,
                  color: fourthColor,
                  fontWeight: FontWeight.bold)),
        ),
        body: ListView(
          padding: EdgeInsets.only(left: 20.0),
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height - 50.0,
                width: double.infinity,
                child: Stores(
                  categoryId: widget.categoryId,
                )),
          ],
        ),
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
