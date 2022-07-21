import 'package:flutter/material.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/view/widgets/dropdown_button.dart';
import 'package:medicine_app/view/widgets/text_field_container.dart';
import 'custom_text.dart';

class CustomDropDownList extends StatefulWidget {
  final String hintText;
  final bool hasError;
  final String errorText;
  final IconData icon;
  final List element;
  final TextEditingController controller;

  CustomDropDownList(
      {this.icon,
      this.hintText,
      this.hasError = false,
      this.errorText,
      this.element,
      this.controller});

  @override
  _CustomDropDownListState createState() => _CustomDropDownListState();
}

class _CustomDropDownListState extends State<CustomDropDownList> {
  bool isStretchedDropDown = false;
  String displayText;
  bool isExist = false;

  var groupValue;

  @override
  void initState() {
    displayText = widget.hintText;
    if (widget.controller.text.isEmpty) {
      // to allow the edit
      widget.controller.text = displayText;
    }
    groupValue = null;
    if (widget.controller.text.isNotEmpty) {
      for (int i = 0; i < widget.element.length; i++) {
        if (widget.controller.text.toString() == widget.element[i].toString()) {
          groupValue = widget.element[i];
          displayText = widget.element[i];
        }
      }
    }
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
                            child: ListView.builder(
                              itemCount: widget.element.length,
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                var row = widget.element[index];
                                return RadioListTile(
                                    title: CustomText(
                                      title: row,
                                      color: Colors.black87,
                                    ),
                                    value: row,
                                    groupValue: groupValue,
                                    onChanged: (val) {
                                      setState(() {
                                        groupValue = val;
                                        displayText = row;
                                        widget.controller.text = row;
                                        isStretchedDropDown =
                                            !isStretchedDropDown;
                                      });
                                    });
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
