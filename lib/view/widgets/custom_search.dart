import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine_app/constant.dart';

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide.none,
);

class CustomSearch extends StatefulWidget {
  TextEditingController searchController;
  Function onChanged;
  Function onIconPressed;

  CustomSearch(
      {this.searchController,
      this.onChanged,
      this.onIconPressed});

  @override
  _CustomSearchState createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Form(
        child: TextFormField(
          controller: widget.searchController,
          onSaved: (value) {},
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText:"اكتب للفلترة .." ,
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            errorBorder: outlineInputBorder,
            prefixIcon: Padding(
                padding: const EdgeInsets.all(14),
                child: IconButton(
                  icon: (widget.searchController.text.isNotEmpty)
                      ? Icon(Icons.clear)
                      : SvgPicture.asset("assets/icons/Search.svg"),
                  onPressed: widget.onIconPressed,
                )),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 16.0 / 2),
              child: SizedBox(
                width: 48,
                height: 48,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    onPressed: () {},
                    child: SvgPicture.asset("assets/icons/Filter.svg")),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
