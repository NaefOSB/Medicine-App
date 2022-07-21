import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/core/services/process_management.dart';
import 'package:medicine_app/core/services/user_storage.dart';
import 'package:medicine_app/core/view_model/home_page_view_model.dart';
import 'package:medicine_app/view/about_us/character_listing_screen.dart';
import 'package:medicine_app/view/auth/edit_account.dart';
import 'package:medicine_app/view/auth/sign_in/login_screen.dart';
import 'package:medicine_app/view/auth/sign_up/sign_up.dart';
import 'package:medicine_app/view/users/manage_users.dart';
import 'package:medicine_app/view/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_admin_alert.dart';
import 'new_row.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  HomePageViewModel controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      child: Padding(
        padding: EdgeInsets.only(top: 50, left: 40, bottom: 70),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                CustomText(
                  title: (UserStorage().getUserInfo().name != null &&
                          UserStorage().getUserInfo().name.isNotEmpty)
                      ? UserStorage().getUserInfo().name
                      : 'مرحبا بك',
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.21,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                NewRow(
                  text: (controller.getUserAccountType() == 'UNAUTHENTICATED')
                      ? 'تسجيل الدخول'
                      : 'تسجيل الخروج',
                  icon: (controller.getUserAccountType() == 'UNAUTHENTICATED')
                      ? Icons.login
                      : Icons.logout,
                  onTap: () {
                    controller.closeDrawer();
                    if (controller.getUserAccountType() == 'UNAUTHENTICATED') {
                      Get.to(() => SignIn());
                    } else {
                      controller.signOut();
                    }
                  },
                ),
                (controller.isUserAdmin())
                    ? SizedBox(
                        height: 20,
                      )
                    : Container(),
                (controller.isUserAdmin())
                    ? NewRow(
                        text: 'إنشاء حساب',
                        icon: Icons.perm_contact_calendar,
                        onTap: () {
                          controller.closeDrawer();
                          showDialog(
                              context: context,
                              builder: (context) => CustomAdminAlert(
                                    onPress1: () {
                                      Get.back();
                                      Get.to(() => SignUp(
                                            state: 'SUPPLIER',
                                          ));
                                    },
                                    onPress2: () {
                                      Get.back();
                                      Get.to(() => SignUp(
                                            state: 'CLIENT',
                                          ));
                                    },
                                    onPress3: () {
                                      Get.back();
                                      Get.to(() => SignUp(
                                            state: 'ADMIN',
                                          ));
                                    },
                                  ));
                        },
                      )
                    : Container(),
                (controller.getUserAccountType() == 'UNAUTHENTICATED')
                    ? Container()
                    : SizedBox(
                        height: 20,
                      ),
                (controller.getUserAccountType() == 'UNAUTHENTICATED')
                    ? Container()
                    : NewRow(
                        text: 'تعديل حسابي',
                        icon: Icons.edit,
                        onTap: () {
                          controller.closeDrawer();
                          ProcessManagement.requiredLoginAlert(
                              toPage: EditAccount());
                        },
                      ),
                (controller.isUserAdmin())
                    ? SizedBox(
                        height: 20,
                      )
                    : Container(),
                (controller.isUserAdmin())
                    ? NewRow(
                        text: 'إدارة الحسابات',
                        icon: FontAwesomeIcons.usersCog,
                        onTap: () {
                          controller.closeDrawer();
                          Get.to(() => ManageUsers());
                        },
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                NewRow(
                  text: 'خدمة العملاء',
                  icon: FontAwesomeIcons.headset,
                  onTap: () async {
                    controller.closeDrawer();
                    var whatsappUrl = "whatsapp://send?phone=+967716026208";
                    await canLaunch(whatsappUrl)
                        ? launch(whatsappUrl)
                        : print(
                            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                NewRow(
                  text: 'عن التطبيق',
                  icon: FontAwesomeIcons.questionCircle,
                  onTap: () {
                    controller.closeDrawer();
                    Get.to(() => CharacterListingScreen());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
