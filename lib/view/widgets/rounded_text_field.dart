import 'package:flutter/material.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/view/widgets/text_field_container.dart';

class RoundedTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final String keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final Function validator;
  final bool isPassword;
  final bool readOnly;
  final Function onTap;
  final Function onFieldSubmitted;

  const RoundedTextField(
      {Key key,
      this.hintText = '',
      this.icon = Icons.person,
      this.onChanged,
      this.controller,
      this.keyboardType = 'text',
      this.textInputAction = TextInputAction.next,
      this.validator,
      this.readOnly = false,
      this.onTap,
      this.onFieldSubmitted,
      this.isPassword = false})
      : super(key: key);

  @override
  _RoundedTextFieldState createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  bool obscureText;

  @override
  void initState() {
    obscureText = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        textAlign: TextAlign.center,
        controller: widget.controller,
        validator: widget.validator,
        onChanged: widget.onChanged,
        cursorColor: kPrimaryColor,
        obscureText: obscureText,
        keyboardType: getKeyboardType(widget.keyboardType),
        textInputAction: widget.textInputAction,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: kPrimaryColor,
          ),
          suffixIcon: (widget.isPassword)
              ? IconButton(
                  icon: Icon(
                      (obscureText) ? Icons.visibility_off : Icons.visibility),
                  color: kPrimaryColor,
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                      // widget.textEditingController.text =
                      //     widget.textEditingController.text;
                    });
                  },
                )
              : Icon(
                  Icons.clear,
                  color: Colors.transparent,
                ),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: secondColor),
          border: InputBorder.none,
        ),
        style: TextStyle(color: secondColor),
      ),
    );
  }

  TextInputType getKeyboardType(type) {
    switch (type) {
      case 'text':
        return TextInputType.text;
      case 'phone':
        return TextInputType.phone;
      case 'email':
        return TextInputType.emailAddress;
      case 'number':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}
