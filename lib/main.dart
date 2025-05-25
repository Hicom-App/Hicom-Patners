import 'package:disposable_cached_images/disposable_cached_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hicom_patners/pages/sample/splash_screen.dart';
import 'package:hicom_patners/resource/srting.dart';
import 'controllers/dependency.dart';
import 'controllers/firebase_api.dart';
import 'controllers/get_controller.dart';


/*main() async {
  WidgetsFlutterBinding.ensureInitialized();
  *//*FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  FlutterNativeSplash.remove();*//*
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));
  try{
    await InitNotification.initialize();
  }catch(e){
    debugPrint(e.toString());
  }
  await DisposableImages.init();
  runApp(DisposableImages(MyApp()));
  try{
    DependencyInjection.init();
  } catch(e){
    debugPrint(e.toString());
  }
}*/

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  FlutterNativeSplash.remove();
  
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));
  await InitNotification.initialize();
  await DisposableImages.init();
  Future(() async {
    try {
      DependencyInjection.init();
    } catch (e) {
      debugPrint(e.toString());
    }
  });

  runApp(DisposableImages(MyApp()));
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