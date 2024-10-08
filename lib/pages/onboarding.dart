import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/sample/sample_page.dart';
import 'package:rive/rive.dart' hide Image;
import '../controllers/get_controller.dart';
import '../resource/colors.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> with TickerProviderStateMixin {
  AnimationController? _signInAnimationController;

  late RiveAnimationController _btnController;
  final GetController _getController = Get.put(GetController());

  void open() => Get.offAll(() => SamplePage(), transition: Transition.zoom);

  @override
  void initState() {
    super.initState();
    _signInAnimationController = AnimationController(duration: const Duration(milliseconds: 360), upperBound: 1, vsync: this);
    _btnController = OneShotAnimation("active", autoplay: false);

    const sprintDesc = SpringDescription(mass: 0.1, stiffness: 40, damping: 5);

    _btnController.isActiveChanged.addListener(() {
      if (!_btnController.isActive) {
        final springAnim = SpringSimulation(sprintDesc, 0, 1, 0);
        _signInAnimationController?.animateWith(springAnim);
        _getController.tapTimes(open,1);
      }
    });
  }

  @override
  void dispose() {
    _signInAnimationController?.dispose();
    _btnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: OverflowBox(maxWidth: double.infinity, child: Transform.translate(offset: const Offset(200, 100), child: Image.asset('assets/spline.png', fit: BoxFit.cover)))
          ),
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: const RiveAnimation.asset('assets/shapes.riv')
          ),
          AnimatedBuilder(
            animation: _signInAnimationController!,
            builder: (context, child) {
              return Transform(transform: Matrix4.translationValues(0, -50 * _signInAnimationController!.value, 0), child: child);
            },
            child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 260.w, child: Text('Hicom mobil patnerlik ilovasi', style: TextStyle(fontFamily: 'Poppins', fontSize: 40.sp, fontWeight: FontWeight.bold))),
                      Text("Hicom — bu kamutatorlar va boshqa elektronika buyumlarining savdosini oshirishga qaratilgan patnerlik ilovasi. Siz bu ilova yordamida mahsulotlar bo'yicha ma'lumotlarga ega bo'lasiz va hamkorlar bilan ishlash imkoniyatiga ega bo'lasiz.", style: TextStyle(fontFamily: 'Inter', fontSize: 15.sp, color: Colors.black.withOpacity(0.7))),
                      SizedBox(height: 16.h),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          _btnController.isActive = true;
                        },
                        child: Container(
                          width: 236.w,
                          height: 64.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 10))
                              ]
                          ),
                          child: Stack(children: [
                            RiveAnimation.asset('assets/button.riv', fit: BoxFit.cover, controllers: [_btnController]),
                            Center(
                                child: Transform.translate(
                                  offset: const Offset(4, 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.arrow_forward_rounded),
                                      SizedBox(width: 8.w),
                                      Text('Boshlash', style: TextStyle(fontSize: 16.sp, fontFamily: 'Inter', fontWeight: FontWeight.bold))
                                    ]
                                  )
                                )
                            )
                          ])
                        )
                      )
                    ]
                  )
                )
            )
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _signInAnimationController!,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned.fill(child: IgnorePointer(ignoring: true, child: Opacity(opacity: 0.4 * _signInAnimationController!.value, child: Container(color: RiveAppTheme.shadow))))
                  ]
                );
              }
            )
          )
        ]
      )
    );
  }
}