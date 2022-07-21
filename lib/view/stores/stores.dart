import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/stores_view_model.dart';
import 'package:medicine_app/view/single_store/single_store.dart';
import 'package:medicine_app/view/widgets/category_card.dart';
import 'package:medicine_app/view/widgets/custom_search.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';

class Stores extends StatefulWidget {
  final String categoryId;

  Stores({this.categoryId});

  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  TextEditingController _searchController = TextEditingController();
  StoresViewModel controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: ListView(
          children: <Widget>[
            GetBuilder<StoresViewModel>(
              builder: (controller) => (controller.hasData)
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                          padding: EdgeInsets.only(
                              right: 15.0, top: 15.0, bottom: 15.0),
                          child: CustomSearch(
                            searchController: _searchController,
                            onChanged: (value) {
                              setState(() {
                                print(value);
                              });
                            },
                            onIconPressed: () {
                              if (_searchController.text.isNotEmpty) {
                                setState(() {
                                  _searchController.clear();
                                });
                              }
                            },
                          )),
                    )
                  : Container(),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('accountType', isEqualTo: 'SUPPLIER')
                  .where('accountCategory', arrayContains: widget.categoryId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data.docs.length > 0) {
                  controller.isHavingData();
                  final stores = snapshot.data.docs;

                  return Container(
                      padding: EdgeInsets.only(right: 15.0),
                      width: MediaQuery.of(context).size.width - 30.0,
                      height: MediaQuery.of(context).size.height - 50.0,
                      child: GridView.count(
                        crossAxisCount: 3,
                        primary: false,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 15.0,
                        childAspectRatio: 0.6,
                        children: <Widget>[
                          for (int i = 0; i < stores.length; i++) ...{
                            // to filter the stores
                            if (stores[i]['storeName']
                                .toString()
                                .contains(_searchController.text)) ...{
                              CustomCard(
                                name: stores[i]['storeName'].toString(),
                                imgPath: 'assets/images/store.png',
                                imgPathTag: 'assets/icons/company$i.png',
                                onTap: () => Get.to(() => SingleStore(
                                      storeID: stores[i].id,
                                      storeName:
                                          stores[i]['storeName'].toString(),
                                      saleState: stores[i]['saleState'],
                                    )),
                              ),
                            },
                          }
                        ],
                      ));
                } else if (snapshot.hasError) {
                  return Container();
                } else {
                  controller.isHavingNoData();
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/empty_store.png'),
                        CustomText(
                          title: 'لاتوجد اي محلات ..',
                          alignment: Alignment.center,
                          color: fourthColor,
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 15.0)
          ],
        ));
  }
}
