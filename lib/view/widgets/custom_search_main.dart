import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine_app/constant.dart';

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);

class CustomSearchMain extends StatelessWidget {
  Function onPressed;
  bool isDrawerOpen;

  CustomSearchMain({this.onPressed, this.isDrawerOpen});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          child: TextFormField(
            textAlign: TextAlign.center,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'تطبيق الأدوية',
              hintStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              border: outlineInputBorder,
              enabledBorder: outlineInputBorder,
              focusedBorder: outlineInputBorder,
              errorBorder: outlineInputBorder,
              prefixIcon: Padding(
                  padding: const EdgeInsets.all(14),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      "assets/icons/m3.svg",
                      color: kPrimaryColor,
                    ),
                  )),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0 / 2),
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                        child: IconButton(
                      icon: Icon(
                        isDrawerOpen ? Icons.arrow_forward_ios : Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: onPressed,
                    )),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
