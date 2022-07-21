import 'package:flutter/material.dart';
import 'package:medicine_app/view/home_page/home_page.dart';
import 'package:medicine_app/view/widgets/custom_drawer.dart';

class InitializePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [CustomDrawer(), HomePage()],
      ),
    );
  }
}
