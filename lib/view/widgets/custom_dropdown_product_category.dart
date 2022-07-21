import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/core/view_model/auth_view_model.dart';
import 'package:medicine_app/view/widgets/dropdown_button.dart';
import 'package:medicine_app/view/widgets/text_field_container.dart';

import 'custom_text.dart';

class CustomDropDownProductCategory extends StatefulWidget {
  final String hintText;
  final bool hasError;
  final String errorText;
  final IconData icon;
  final stream;
  final TextEditingController controller;

  CustomDropDownProductCategory({
    this.icon,
    this.hintText,
    this.hasError = false,
    this.errorText,
    this.stream,
    this.controller,
  });

  @override
  _CustomDropDownProductCategoryState createState() =>
      _CustomDropDownProductCategoryState();
}

class _CustomDropDownProductCategoryState
    extends State<CustomDropDownProductCategory> {
  AuthViewModel controller = Get.put(AuthViewModel());
  bool isStretchedDropDown = false;
  String displayText='';
  bool isExist = false;

  var groupValue;

  @override
  void initState() {
    if (widget.controller.text.isEmpty) {
      displayText = widget.hintText;
      widget.controller.text = displayText;
    } else {
      getSelectedValue();
    }
    super.initState();
  }

  getSelectedValue() async {
    var selectedCategory = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserStorage().getUserInfo().id)
        .collection('categories')
        .get();
    if (selectedCategory.docs.length > 0) {
      for (int i = 0; i < selectedCategory.docs.length; i++) {
        if (selectedCategory.docs[i].id.toString() ==
            widget.controller.text.toString()) {
          setState(() {
            groupValue = selectedCategory.docs[i].id;
            displayText = selectedCategory.docs[i]['name'].toString();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isStretchedDropDown = !isStretchedDropDown;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(27))),
                    child: Column(
                      children: [
                        Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              minHeight: 45,
                              minWidth: double.infinity,
                            ),
                            alignment: Alignment.center,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    widget.icon,
                                    color: kPrimaryColor,
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Column(
                                          children: [
                                            CustomText(
                                              title: displayText,
                                              color: Colors.grey.shade700,
                                              alignment: Alignment.center,
                                            ),
                                            Visibility(
                                                visible: widget.hasError,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: CustomText(
                                                    title: widget.errorText,
                                                    color: Colors.red.shade700,
                                                    fontSize: 11.0,
                                                  ),
                                                )),
                                          ],
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Icon(
                                        isStretchedDropDown
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward,
                                        color: kPrimaryColor),
                                  )
                                ],
                              ),
                            )),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: ExpandedSection(
                            expand: isStretchedDropDown,
                            height: 100,
                            child: StreamBuilder(
                              stream: widget.stream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    padding: EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var row = snapshot.data.docs[index];

                                      return RadioListTile(
                                          title: CustomText(
                                            title: row['name'].toString(),
                                            color: Colors.black87,
                                          ),
                                          value: row.id,
                                          groupValue: groupValue,
                                          onChanged: (val) {
                                            setState(() {
                                              groupValue = val;
                                              displayText =
                                                  row['name'].toString();
                                              widget.controller.text =
                                                  row.id.toString();
                                              isStretchedDropDown =
                                                  !isStretchedDropDown;
                                            });
                                          });
                                    },
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),

                            // ),
                          ),
                        )
                      ],
                    ),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
