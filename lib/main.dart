import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medicine_app/constant.dart';
import 'package:medicine_app/utils/binging.dart';
import 'package:medicine_app/view/home_page/initialize_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: Binding(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Cairo', primaryColor: kPrimaryColor),
      title: 'أدويتك',
      home: InitializePage(),
    );
  }
}
