import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'firebase_options.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(alert: true, badge: true, sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('Foydalanuvchi ruxsat berdi');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('Foydalanuvchi vaqtinchalik ruxsat berdi');
    } else {
      debugPrint('Foydalanuvchi ruxsat bermadi');
    }
  }

  requestNotificationPermissions();
  try {
    if (Platform.isAndroid) {
      await InitNotification.initialize();
    }
  } catch (e) {
    debugPrint(e.toString());
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