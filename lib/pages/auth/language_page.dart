import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_large.dart';
import '../../companents/language_select_item.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import 'login_page.dart';

class LanguagePage extends StatelessWidget {
  LanguagePage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    print(_getController.languageIndex.toString());
   return Scaffold(
       body: Scaffold(
           body: SingleChildScrollView(
               child: Container(
                   width: Get.width,
                   height: Get.height,
                   decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/fon.png'), fit: BoxFit.fitWidth)),
                   child: Stack(
                       children: [
                         Positioned.fill(child: Image.asset('assets/images/fon.png', fit: BoxFit.fitWidth)),
                         Positioned(
                             top: 0,
                             child: AnimatedContainer(
                                 width: Get.width,
                                 height: Get.height * 0.4,
                                 duration: const Duration(milliseconds: 500),
                                 curve: Curves.easeInOut,
                                 decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r), bottomRight: Radius.circular(20.r)), image: const DecorationImage(image: AssetImage('assets/images/bar.png'), fit: BoxFit.cover), boxShadow: const [BoxShadow(color: AppColors.grey, spreadRadius: 5, blurRadius: 16, offset: Offset(0, 3))])
                             )
                         ),
                         Positioned.fill(
                             child: Column(
                                 children: [
                                   const Spacer(),
                                   SizedBox(height: 360.h),
                                   const TextLarge(text: 'Tilni tanlang', color: AppColors.black, fontWeight: FontWeight.bold),
                                   for (var i = 0; i < _getController.locale.length; i++)
                                     LanguageSelectItem(index: i, selectedIndex: _getController.languageIndex, text: _getController.locale[i]['name'], onTap: () {
                                       _getController.saveLanguage(_getController.locale[i]['locale']);
                                     }),
                                   const Spacer(),
                                   Row(
                                       mainAxisAlignment: MainAxisAlignment.end,
                                       crossAxisAlignment: CrossAxisAlignment.end,
                                       children: [
                                         Container(
                                             height: 40.h,
                                             margin: EdgeInsets.only(bottom: Get.height * 0.06),
                                             child: ElevatedButton(
                                                 style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), bottomLeft: Radius.circular(12.r)))),
                                                 onPressed: () {
                                                   Get.to(() => const LoginPage(), transition: Transition.fadeIn);
                                                 },
                                                 child: Icon(Icons.arrow_forward, color: AppColors.white, size: 30.sp)
                                             )
                                         )
                                       ]
                                   ),
                                   SizedBox(height: 50.h)
                                 ]
                             )
                         )
                       ]
                   )
               )
           )
       )
   );
  }
}