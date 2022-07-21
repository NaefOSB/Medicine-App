import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/home_page_view_model.dart';
import 'package:medicine_app/view/categories/category_details.dart';
import 'package:medicine_app/view/widgets/custom_search_main.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';
import '../widgets/category_card.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ListView(
        children: <Widget>[
          GetBuilder<HomePageViewModel>(
            init: HomePageViewModel(),
            builder: (controller) => Container(
                height: MediaQuery.of(context).size.height * 0.18,
                alignment: Alignment.bottomCenter,
                // color: kPrimaryColor.withOpacity(0.8),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: CustomSearchMain(
                  isDrawerOpen: controller.isDrawerOpen,
                  onPressed: () => controller.onDrawerPressed(),
                )),
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0, right: 20.0),
            child: CustomText(
              title: 'اقسامنا',
              color: kPrimaryColor3,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            padding: EdgeInsets.only(right: 15.0, left: 15.0),
            width: MediaQuery.of(context).size.width - 30.0,
            height: MediaQuery.of(context).size.height - 50.0,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data.docs.length > 0) {
                  final categories = snapshot.data.docs;

                  return GridView.count(
                    crossAxisCount: 3,
                    primary: false,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: 0.6,
                    children: <Widget>[
                      for (int i = 0; i < categories.length; i++) ...{
                        CustomCard(
                          name: categories[i]['name'].toString(),
                          imgPath: categories[i]['imgUrl'],
                          isImageFromInternet: true,
                          onTap: () => Get.to(() => CategoryDetails(
                                categoryName: categories[i]['name'].toString(),
                                categoryId: categories[i].id,
                              )),
                        ),
                      }
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container();
                }
              },
            ),
          ),
          // SizedBox(height: 15.0)
        ],
      ),
    );
  }
}
