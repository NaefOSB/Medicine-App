import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medicine_app/core/services/process_management.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/core/view_model/home_page_view_model.dart';
import 'package:medicine_app/view/widgets/bottom_bar.dart';
import 'package:medicine_app/view/categories/categories.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/view/widgets/custom_floating_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    ProcessManagement.checkIfUserExist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageViewModel>(
      init: HomePageViewModel(),
      builder: (controller) => Directionality(
          textDirection: TextDirection.rtl,
          child: AnimatedContainer(
            transform: Matrix4.translationValues(
                controller.xOffset, controller.yOffset, 0)
              ..scale(controller.isDrawerOpen ? 0.85 : 1.00)
              ..rotateZ(controller.isDrawerOpen ? -50 : 0),
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: controller.isDrawerOpen
                  ? BorderRadius.circular(40)
                  : BorderRadius.circular(0),
            ),
            child: Scaffold(
              backgroundColor: backgroundColor,
              body: Container(
                height: MediaQuery.of(context).size.height - 50.0,
                width: double.infinity,
                child: Categories(),
              ),
              floatingActionButton: CustomFloatingButton(
                text: controller.getFloatingButtonText(),
                onPressed: () => controller.floatingButtonProcess(),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomBar(
                state: 'HOME',
              ),
            ),
          )),
    );
  }
}
