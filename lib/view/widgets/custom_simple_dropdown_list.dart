import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/view_model/product_view_model.dart';
import 'package:medicine_app/view/widgets/dropdown_button.dart';
import 'custom_text.dart';

class CustomSimpleDropDownList extends StatefulWidget {
  final List element;
  final TextEditingController controller;
  final String selectedValue;
  final bool canDropDown;
  final String productId;

  CustomSimpleDropDownList(
      {this.element,
      this.controller,
      this.selectedValue,
      this.productId,
      this.canDropDown = true});

  @override
  _CustomSimpleDropDownListState createState() =>
      _CustomSimpleDropDownListState();
}

class _CustomSimpleDropDownListState extends State<CustomSimpleDropDownList> {
  ProductViewModel controller = Get.put(ProductViewModel());
  bool isStretchedDropDown = false;
  String displayText = '';
  var groupValue;

  @override
  void initState() {
    widget.controller.text = displayText;
    groupValue = null;
    if (widget.selectedValue.isNotEmpty) {
      displayText = widget.selectedValue;
      for (int i = 0; i < widget.element.length; i++) {
        if (widget.selectedValue == widget.element[i].toString()) {
          groupValue = widget.element[i];
          widget.controller.text = widget.element[i].toString();
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (!widget.canDropDown)
          ? null
          : () {
              setState(() {
                isStretchedDropDown = !isStretchedDropDown;
              });
            },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(color: fourthColor)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: CustomText(
                                title: '$displayText',
                                color: Colors.grey.shade700,
                                alignment: Alignment.center,
                              )),
                        ),
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
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      var row = widget.element[index];
                      return RadioListTile(
                          title: CustomText(
                            title: row,
                            color: Colors.black87,
                            alignment: Alignment.center,
                          ),
                          value: row,
                          groupValue: groupValue,
                          onChanged: (val) {
                            setState(() {
                              groupValue = val;
                              displayText = row;
                              widget.controller.text = row;
                              isStretchedDropDown = !isStretchedDropDown;
                              controller.changeVisibility(
                                  productId: widget.productId, value: val);
                            });
                          });
                    },
                  ),

                  // ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
