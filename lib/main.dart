import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hicom_patners/pages/sample/splash_screen.dart';
import 'package:hicom_patners/resource/srting.dart';

import 'controllers/dependency.dart';
import 'controllers/get_controller.dart';

main() async {
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark
    )
  );
  runApp(MyApp());
  DependencyInjection.init();
}


class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GetController _getController = Get.put(GetController());
  @override
  Widget build(BuildContext context) {
    _getController.setHeightWidth(context);
    /*return ScreenUtilInit(
        designSize: Size(_getController.width.value, _getController.height.value),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Hicom',
            translations: LocaleString(),
            locale: GetController().language,
            home: SplashScreen(),
          );
        });*/
    return ScreenUtilInit(
        designSize: Size(_getController.width.value, _getController.height.value),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return AdaptiveTheme(
              debugShowFloatingThemeButton: false,
              initial: AdaptiveThemeMode.light,
              light: ThemeData.light(useMaterial3: true),
              dark: ThemeData.dark(useMaterial3: true),
              builder: (theme, lightTheme) => GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Hicom',
                theme: theme,
                translations: LocaleString(),
                locale: GetController().language,
                darkTheme: lightTheme,
                home: SplashScreen(),
              )
          );
        },
    );
  }
}