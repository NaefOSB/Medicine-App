import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/model/product_model.dart';
import 'package:medicine_app/view/product/product_card.dart';
import 'package:medicine_app/view/product/product_details.dart';
import 'package:medicine_app/view/about_store/about_store.dart';
import 'package:medicine_app/view/widgets/custom_search.dart';
import 'package:medicine_app/view/widgets/custom_tabs.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';

class SingleStoreDetails extends StatefulWidget {
  final String storeID;
  final String storeName;
  final bool saleState;

  SingleStoreDetails({this.storeID, this.storeName, this.saleState});

  @override
  _SingleStoreDetailsState createState() => _SingleStoreDetailsState();
}

class _SingleStoreDetailsState extends State<SingleStoreDetails>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  TabController _tabController;
  bool _isSearchBoxShowing = true;
  int selectedTapIndex;
  String selectedTapId;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 2) {
          _isSearchBoxShowing = false;
        } else {
          _isSearchBoxShowing = true;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: backgroundColor,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 15.0),
          Visibility(
            visible: _isSearchBoxShowing,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Container(
                  padding: EdgeInsets.only(right: 15.0, left: 20.0),
                  child: CustomSearch(
                    searchController: _searchController,
                    onIconPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  )),
            ),
          ),
          CustomTabs(
            onTab: (index) {
              if (index == 2) {
                _isSearchBoxShowing = false;
              } else {
                _isSearchBoxShowing = true;
              }
            },
            tabController: _tabController,
            children: [
              // for products
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  padding: EdgeInsets.only(right: 15.0, left: 20.0),
                  width: size.width - 30.0,
                  height: size.height - 50.0,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: size.height * 0.01,
                            bottom: size.height * 0.02),
                        height: size.height * 0.05,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(widget.storeID)
                              .collection('categories')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snap) {
                            if (snap.hasData && snap.data.docs.length > 0) {
                              return ListView.builder(
                                itemCount: snap.data.docs.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedTapIndex = index;
                                        selectedTapId =
                                            snap.data.docs[index].id;
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(
                                        left: 15,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 13.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (index == selectedTapIndex)
                                            ? kPrimaryColor2
                                            : kPrimaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        snap.data.docs[index]['name'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (snap.hasError) {
                              return Container();
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('products')
                              .where('storeID', isEqualTo: '${widget.storeID}')
                              .where('type', isEqualTo: 'المنتجات')
                              .where('categoryId', isEqualTo: selectedTapId)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data.docs.length > 0) {
                              final products = snapshot.data.docs;
                              return GridView.count(
                                crossAxisCount: 3,
                                primary: false,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 15.0,
                                childAspectRatio: 0.6,
                                children: <Widget>[
                                  for (int i = 0; i < products.length; i++) ...{
                                    if (products[i]['name']
                                            .toString()
                                            .contains(_searchController.text) ||
                                        products[i]['price']
                                            .toString()
                                            .contains(_searchController.text) ||
                                        products[i]['visibility']
                                            .toString()
                                            .contains(
                                                _searchController.text)) ...{
                                      ProductCard(
                                        name: '${products[i]['name']}',
                                        price: products[i]['price'].toString(),
                                        currency:
                                            products[i]['currency'].toString(),
                                        imgPath: 'assets/images/products.png',
                                        tag:
                                            'assets/images/products${products[i].id}.png',
                                        quantityState:
                                            '${products[i]['visibility']}',
                                        storeId: widget.storeID,
                                        onTap: () =>
                                            Get.to(() => ProductDetails(
                                                  model: ProductModel.fromJson(
                                                      products[i].data(),
                                                      products[i].id),
                                                  imgPath:
                                                      'assets/images/products.png',
                                                  salesState: widget.saleState,
                                                )),
                                      ),
                                    }
                                  }
                                ],
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Container();
                            } else {
                              return CustomText(
                                title: 'لاتوجد اي منتجات',
                                alignment: Alignment.center,
                                color: fourthColor,
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // for offers
              Container(
                padding: EdgeInsets.only(right: 15.0, left: 20.0),
                width: size.width - 30.0,
                height: size.height - 50.0,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .where('storeID', isEqualTo: '${widget.storeID}')
                      .where('type', isEqualTo: 'العروض')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data.docs.length > 0) {
                      final offers = snapshot.data.docs;
                      return GridView.count(
                        crossAxisCount: 3,
                        primary: false,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 15.0,
                        childAspectRatio: 0.6,
                        children: <Widget>[
                          for (int i = 0; i < offers.length; i++) ...{
                            if (offers[i]['name']
                                    .toString()
                                    .contains(_searchController.text) ||
                                offers[i]['price']
                                    .toString()
                                    .contains(_searchController.text) ||
                                offers[i]['visibility']
                                    .toString()
                                    .contains(_searchController.text)) ...{
                              ProductCard(
                                  name: '${offers[i]['name']}',
                                  price: offers[i]['price'].toString(),
                                  imgPath: 'assets/images/offer.png',
                                  tag: 'assets/images/offer${offers[i].id}.png',
                                  quantityState: '${offers[i]['visibility']}',
                                  currency: offers[i]['currency'].toString(),
                                  storeId: widget.storeID,
                                  onTap: () => Get.to(() => ProductDetails(
                                        imgPath: 'assets/images/offer.png',
                                        model: ProductModel.fromJson(
                                            offers[i].data(), offers[i].id),
                                      ))),
                            }
                          }
                        ],
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Container();
                    } else {
                      return CustomText(
                        title: 'لاتوجد اي عروض',
                        alignment: Alignment.center,
                        color: fourthColor,
                      );
                    }
                  },
                ),
              ),
              // for about page
              AboutStore(
                storeId: widget.storeID,
                storeState: widget.saleState,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
