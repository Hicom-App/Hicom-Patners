import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hicom_patners/pages/sample/splash_screen.dart';
import 'package:hicom_patners/resource/srting.dart';
import 'controllers/dependency.dart';
import 'controllers/firebase_api.dart';
import 'controllers/get_controller.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
  if (Platform.isAndroid) {
    await InitNotification.initialize();
  }
  runApp(MyApp());
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GetController _getController = Get.put(GetController());
  @override
  Widget build(BuildContext context) {
    _getController.setHeightWidth(context);
    return ScreenUtilInit(
        designSize: Size(_getController.width.value, _getController.height.value),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Hicom',
            theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Schyler'),
            translations: LocaleString(),
            locale: GetController().language,
            home: SplashScreen()
          );
        }
    );
  }
}