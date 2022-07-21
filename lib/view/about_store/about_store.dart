import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/about_store_view_model.dart';
import 'package:medicine_app/model/abot_store_model.dart';
import 'package:medicine_app/view/about_store/edit_about_store.dart';
import 'package:medicine_app/view/widgets/custom_alert_switch.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';

class AboutStore extends GetWidget<AboutStoreViewModel> {
  final String storeId;
  final bool storeState;

  AboutStore({this.storeId, this.storeState});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.2,
            child: Image.asset(
              'assets/images/about2.jpg',
              height: size.height * 0.2,
              width: size.width,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(storeId)
                .collection('details')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                AboutStoreModel aboutStore;
                if (snapshot.data.docs.length > 0) {
                  aboutStore = AboutStoreModel.fromJson(
                      snapshot.data.docs[0].data(), storeId);
                } else {
                  aboutStore = new AboutStoreModel(storeId: storeId);
                }
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          title: 'تفاصيل الشركة',
                          fontWeight: FontWeight.bold,
                          padding: EdgeInsets.only(right: 10.0),
                          color: fourthColor,
                        ),
                        (controller.isThisStoreIsMe(storeId: storeId))
                            ? IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: fourthColor,
                                  size: 20.0,
                                ),
                                onPressed: () => Get.to(() => EditAboutStore(
                                      model: aboutStore,
                                    )),
                              )
                            : Container(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 15.0),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(children: [
                            TableCell(
                                child: CustomText(
                              title: 'الوصف :',
                              color: unActiveColor,
                            )),
                            TableCell(
                                child: CustomText(
                              title:
                                  (aboutStore.description.toString().isEmpty ||
                                          aboutStore.description == null)
                                      ? 'لايوجد'
                                      : aboutStore.description.toString(),
                              color: unActiveColor,
                            )),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: CustomText(
                              title: 'الموقع :',
                              color: unActiveColor,
                            )),
                            TableCell(
                                child: CustomText(
                              title: (aboutStore.address.toString().isEmpty ||
                                      aboutStore.address == null)
                                  ? 'لايوجد'
                                  : aboutStore.address.toString(),
                              color: unActiveColor,
                            )),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: Row(
                              children: [
                                CustomText(
                                  title: 'حالة البيع :',
                                  color: unActiveColor,
                                ),
                                (controller.isThisStoreIsMe(storeId: storeId))
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          size: 15.0,
                                          color: fourthColor,
                                        ),
                                        onPressed: () => showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CustomAlertSwitch(
                                                  value: storeState,
                                                )),
                                      )
                                    : Container(),
                              ],
                            )),
                            TableCell(
                                child: CustomText(
                              title: storeState ? 'متاح' : 'موقف',
                              color: unActiveColor,
                            )),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: CustomText(
                              title: 'الحسابات المصرفية :',
                              color: unActiveColor,
                            )),
                            TableCell(
                                child: CustomText(
                              title: (aboutStore.bankAccounting
                                          .toString()
                                          .isEmpty ||
                                      aboutStore.bankAccounting == null)
                                  ? 'لايوجد'
                                  : aboutStore.bankAccounting.toString(),
                              color: unActiveColor,
                            )),
                          ]),
                          TableRow(children: [
                            TableCell(
                                child: CustomText(
                              title: 'للتواصل :',
                              color: unActiveColor,
                            )),
                            TableCell(
                                child: CustomText(
                              title: (aboutStore.phoneNumber1
                                          .toString()
                                          .isEmpty ||
                                      aboutStore.phoneNumber1 == null)
                                  ? ''
                                  : aboutStore.phoneNumber1.toString() +
                                      '\n' +
                                      '${(aboutStore.phoneNumber2.toString().isEmpty || aboutStore.phoneNumber2 == null) ? '' : aboutStore.phoneNumber2.toString()}',
                              color: unActiveColor,
                            )),
                          ]),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Container();
              } else {
                return Container();
              }
            },
          )
        ],
      ),
    );
  }
}
