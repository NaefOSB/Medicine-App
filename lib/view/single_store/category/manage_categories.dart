import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/core/view_model/single_store_category_view_model.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';

class ManageSingleStoreCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'إدارة الأقسام',
            style: TextStyle(color: fourthColor, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(UserStorage().getUserInfo().id)
              .collection('categories')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data.docs.length > 0) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final category = snapshot.data.docs[index];
                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    title: CustomText(
                      title: '${category['name']}',
                    ),
                    leading: Icon(FontAwesomeIcons.tag),
                    trailing: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: GetBuilder<SingleStoreCategoryViewModel>(
                        init: SingleStoreCategoryViewModel(),
                        builder: (controller) => Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 18.0,
                              ),
                              onPressed: () =>
                                  controller.moveCategoryToEditPage(
                                      categoryId: category.id,
                                      categoryName: category['name']),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 18.0,
                              ),
                              onPressed: () => controller.deleteCategory(
                                  categoryId: category.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return CustomText(
                alignment: Alignment.center,
                title: 'حدث خطأ، الرجاء المحاولة لاحقاً',
                color: fourthColor,
              );
            } else if (!snapshot.hasData || snapshot.data.docs.length == 0) {
              return CustomText(
                alignment: Alignment.center,
                title: 'لاتوجد اي بيانات حالياً ..',
                color: fourthColor,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
