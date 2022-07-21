import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/auth_view_model.dart';
import 'package:medicine_app/view/widgets/dropdown_button.dart';
import 'package:medicine_app/view/widgets/text_field_container.dart';

import 'custom_text.dart';

class CustomDropDown extends StatefulWidget {
  final String hintText;
  final bool hasError;
  final String errorText;
  final IconData icon;
  final bool isList;
  final stream;
  final TextEditingController controller;

  CustomDropDown(
      {this.icon,
      this.hintText,
      this.hasError = false,
      this.errorText,
      this.isList = false,
      this.stream,
      this.controller,});

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  AuthViewModel controller = Get.put(AuthViewModel());
  bool isStretchedDropDown = false;
  String displayText;
  bool isExist = false;

  var groupValue;

  @override
  void initState() {
    displayText = widget.hintText;
    widget.controller.text = displayText;
    super.initState();
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
                                  if (widget.isList) {
                                    return ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var row = snapshot.data.docs[index];
                                        bool isChecked = false;
                                        if (controller
                                                .selectedListIndex.length >
                                            0) {
                                          for (int i = 0;
                                              i <
                                                  controller
                                                      .selectedListIndex.length;
                                              i++) {
                                            if (row.id ==
                                                controller.selectedListIndex[i]
                                                    ['id']) {
                                              isChecked = true;
                                            }
                                          }
                                        }
                                        return Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: StatefulBuilder(
                                            builder: (context, internalState) {
                                              return CheckboxListTile(
                                                  value: isChecked,
                                                  title: CustomText(
                                                    title:
                                                        row['name'].toString(),
                                                    color: Colors.black87,
                                                  ),
                                                  onChanged: (val) {
                                                    try {
                                                      isExist = false;
                                                      internalState(() {
                                                        isChecked = val;
                                                        // to prevent the repetition
                                                        for (int i = 0;
                                                            i <
                                                                controller
                                                                    .selectedListIndex
                                                                    .length;
                                                            i++) {
                                                          if (controller
                                                                      .selectedListIndex[
                                                                  i]['id'] ==
                                                              row.id) {
                                                            isExist = true;
                                                            controller
                                                                .selectedListIndex
                                                                .remove(controller
                                                                    .selectedListIndex[i]);
                                                            for (int i = 0;
                                                                i <
                                                                    controller
                                                                        .selectedListIndex
                                                                        .length;
                                                                i++) {
                                                              if (i ==
                                                                  controller
                                                                          .selectedListIndex
                                                                          .length -
                                                                      1) {
                                                                displayText =
                                                                    controller
                                                                            .selectedListIndex[i]
                                                                        [
                                                                        'name'];
                                                              } else {
                                                                displayText =
                                                                    controller.selectedListIndex[i]
                                                                            [
                                                                            'name'] +
                                                                        ' , ';
                                                              }
                                                            }

                                                            if (controller
                                                                    .selectedListIndex
                                                                    .length ==
                                                                0) {
                                                              displayText =
                                                                  'نوع النشاط';
                                                            }
                                                          }
                                                        }
                                                        // if the selected item is new
                                                        if (!isExist) {
                                                          // to add the selected item in the list
                                                          if (controller
                                                                  .selectedListIndex
                                                                  .length ==
                                                              0) {
                                                            controller
                                                                    .selectedListIndex =
                                                                new List<
                                                                    Map<String,
                                                                        String>>();
                                                          }
                                                          controller
                                                              .selectedListIndex
                                                              .add({
                                                            'id': row.id,
                                                            'name': row['name']
                                                          });
                                                          print(controller
                                                              .selectedListIndex
                                                              .length);

                                                          //   to add the selected item in displayText
                                                          if (displayText ==
                                                              'نوع النشاط') {
                                                            displayText =
                                                                row['name']
                                                                    .toString();
                                                          } else {
                                                            displayText += ' , ' +
                                                                row['name']
                                                                    .toString();
                                                          }
                                                        }

                                                        // to pass the ids of categories to controller
                                                        List categories =
                                                            new List();
                                                        controller
                                                            .selectedListIndex
                                                            .forEach((element) {
                                                          categories.add(
                                                              element['id']);
                                                        });

                                                        widget.controller.text =
                                                            categories
                                                                .toString();
                                                      });
                                                    } catch (e) {}
                                                  });
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  }
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
