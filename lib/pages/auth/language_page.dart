import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_large.dart';
import '../../companents/language_select_item.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import '../sample/sample_page.dart';
import 'login_page.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  LanguagePageState createState() => LanguagePageState();
}

class LanguagePageState extends State<LanguagePage> with SingleTickerProviderStateMixin {
  final GetController _getController = Get.put(GetController());
  final FocusNode _focusNode = FocusNode();
  bool isKeyboardVisible = false;
  bool animateTextFields = false;

  @override
  void initState() {
    super.initState();
    _startDelayedAnimation();
  }

  void _startDelayedAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () => setState(() => animateTextFields = true));
    animateTextFields = false;
  }


  @override
  Widget build(BuildContext context) {
    isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    if (!isKeyboardVisible) {
      _startDelayedAnimation();
    }
    return GestureDetector(
        onTap: () {
          isKeyboardVisible = false;
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            body: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is UserScrollNotification) {
                    FocusScope.of(context).unfocus();
                  }
                  return true;
                },
                child: SingleChildScrollView(
                    child: Container(
                        width: _getController.width.value,
                        height: _getController.height.value,
                        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/fon.png'), fit: BoxFit.fitWidth)),
                        child: Stack(
                            children: [
                              Positioned.fill(child: Image.asset('assets/images/fon.png', fit: BoxFit.fitWidth)),
                              Positioned(
                                  top: 0,
                                  child: AnimatedContainer(
                                      width: _getController.width.value,
                                      height: isKeyboardVisible ? _getController.height.value * 0.22 : _getController.height.value * 0.4,
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r), bottomRight: Radius.circular(20.r)), image: const DecorationImage(image: AssetImage('assets/images/bar.png'), fit: BoxFit.cover), boxShadow: const [BoxShadow(color: AppColors.grey, spreadRadius: 5, blurRadius: 16, offset: Offset(0, 3))])
                                  )
                              ),
                              Positioned.fill(
                                  child: Column(
                                      children: [
                                        SizedBox(height: Get.height * 0.46),
                                        TextLarge(text: 'Tilni tanlang'.tr, color: AppColors.black, fontWeight: FontWeight.bold),
                                        for (var i = 0; i < _getController.locale.length; i++)
                                          LanguageSelectItem(index: i, selectedIndex: _getController.languageIndex, text: _getController.locale[i]['name'], onTap: () {
                                            _getController.saveLanguage(_getController.locale[i]['locale']);
                                          }),
                                        const Spacer(),
                                      ]
                                  )
                              ),
                              AnimatedPositioned(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                  bottom: isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom + 20.h : Get.height * 0.106,
                                  right: 0,
                                  child: AnimatedSlide(
                                      offset: animateTextFields ? const Offset(0, 0) : const Offset(0, 1.0),
                                      duration: Duration(milliseconds: animateTextFields ? 550 : 400),
                                      curve: Curves.easeInOut,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor:  AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), bottomLeft: Radius.circular(12.r)))),
                                          //onPressed: () {Get.to(() => const LoginPage(), transition: Transition.fadeIn);},
                                          onPressed: () => Get.offAll(() => const SamplePage(), transition: Transition.fadeIn),
                                          child: Icon(Icons.arrow_forward, color: AppColors.white, size: 30.sp)
                                      )
                                  )
                              )
                            ]
                        )
                    )
                )
            )
        )
    );
  }
}
