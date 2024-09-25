import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:rive/rive.dart' hide Image;
import '../resource/colors.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> with TickerProviderStateMixin {
  AnimationController? _signInAnimationController;

  late RiveAnimationController _btnController;

  @override
  void initState() {
    super.initState();
    _signInAnimationController = AnimationController(
        duration: const Duration(milliseconds: 360),
        upperBound: 1,
        vsync: this);
    _btnController = OneShotAnimation("active", autoplay: false);

    const sprinDesc = SpringDescription(mass: 0.1, stiffness: 40, damping: 5);

    _btnController.isActiveChanged.addListener(() {
      if (!_btnController.isActive) {
        final springAnim = SpringSimulation(sprinDesc, 0, 1, 0);
        _signInAnimationController?.animateWith(springAnim);
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
            child: OverflowBox(
              maxWidth: double.infinity,
              child: Transform.translate(
                offset: const Offset(200, 100),
                child: Image.asset(
                  'assets/spline.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: const RiveAnimation.asset('assets/shapes.riv'),
          ),
          AnimatedBuilder(
            animation: _signInAnimationController!,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.translationValues(
                    0, -50 * _signInAnimationController!.value, 0),
                child: child,
              );
            },
            child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 80, 40, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 260,
                        child: const Text(
                          'Hicom mobil patnerlik ilovasi',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "Hicom — bu kamutatorlar va boshqa elektronika buyumlarining savdosini oshirishga qaratilgan patnerlik ilovasi. Siz bu ilova yordamida mahsulotlar bo'yicha ma'lumotlarga ega bo'lasiz va hamkorlar bilan ishlash imkoniyatiga ega bo'lasiz.",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.7)),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          _btnController.isActive = true;
                        },
                        child: Container(
                          width: 236,
                          height: 64,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 10),
                                )
                              ]),
                          child: Stack(children: [
                            RiveAnimation.asset(
                              'assets/button.riv',
                              fit: BoxFit.cover,
                              controllers: [_btnController],
                            ),
                            Center(
                                child: Transform.translate(
                                  offset: const Offset(4, 4),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.arrow_forward_rounded),
                                      SizedBox(width: 8),
                                      Text(
                                        'Boshlash',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ))
                          ]),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _signInAnimationController!,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned.fill(
                        child: IgnorePointer(
                          ignoring: true,
                          child: Opacity(
                            opacity: 0.4 * _signInAnimationController!.value,
                            child: Container(
                              color: RiveAppTheme.shadow,
                            ),
                          ),
                        )),

                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}