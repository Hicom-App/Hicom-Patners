import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../../companents/filds/text_large.dart';
import '../../../companents/filds/text_small.dart';
import '../../../companents/instrument/shake_widget.dart';
import '../../../controllers/get_controller.dart';
import '../../../resource/colors.dart';
import '../../sample/sample_page.dart';

class CreatePasscodePage extends StatelessWidget {
  CreatePasscodePage({super.key}) {_checkBiometricAvailability();
  }
  final GetController _getController = Get.put(GetController());
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _checkBiometricAvailability() async {
    try {
      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      _getController.hasFingerprint.value = availableBiometrics.contains(BiometricType.fingerprint);
      _getController.hasFaceID.value = availableBiometrics.contains(BiometricType.face);
    } catch (e) {
      print('Error checking biometrics: $e');
    }
  }

  Future<void> _authenticate(BuildContext context) async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Unlock with your fingerprint or face',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      if (authenticated) {
        Get.offAll(() => SamplePage());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed!')),
        );
      }
    } catch (e) {
      print('Error authenticating: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _onNumberTap(String number) {
    if (_getController.enteredPasscode.value.length < 4) {
      _getController.enteredPasscode.value += number;
    }
    if (_getController.enteredPasscode.value.length == 4) {
      if (_getController.isCreatingPasscode.value) {
        if (_getController.firstPasscode.value.isEmpty) {
          _getController.firstPasscode.value = _getController.enteredPasscode.value;
          _getController.enteredPasscode.value = '';
        } else if (_getController.firstPasscode.value == _getController.enteredPasscode.value) {
          _showBiometricDialog(); // Show biometric dialog here
        } else {
          _getController.shakeKey[9].currentState?.shake();
          _getController.changeErrorInput(0, true);
          _getController.tapTimes(() {
            _getController.changeErrorInput(0, false);
            _getController.enteredPasscode.value = '';
            _getController.firstPasscode.value = '';
          }, 1);
        }
      }
    }
  }

  void _showBiometricDialog() {
    Get.defaultDialog(
      backgroundColor: AppColors.white,
      titlePadding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
      title: 'Biometrik autentifikatsiyadan foydalanasizmi?',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      middleText: 'Barmoq izi skaneri yoki yuz identifikatoridan foydalanmoqchimisiz?',
      confirm: Container(
          height: 42.h,
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: AppColors.blue),
        child: TextButton(
          onPressed: () async {
            _getController.savePassCode(_getController.enteredPasscode.value);
            _getController.saveBiometrics(true);
            await _authenticate(Get.context!);
          },
          child: TextSmall(text: 'Ha'.tr, color: AppColors.white, fontWeight: FontWeight.bold)
        )
      ),
      cancel: Container(
        height: 42.h,
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: AppColors.red),
        child: TextButton(
          onPressed: () {
            _getController.savePassCode(_getController.enteredPasscode.value);
            _getController.saveBiometrics(false);
            Get.offAll(() => SamplePage());
          },
          child: TextSmall(text: 'Yo`q'.tr, color: AppColors.white, fontWeight: FontWeight.bold),
        )
      )
    );
  }

  void _onDeleteTap() {
    if (_getController.enteredPasscode.value.isNotEmpty) {
      _getController.enteredPasscode.value =
          _getController.enteredPasscode.value.substring(0, _getController.enteredPasscode.value.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => Container(
            width: Get.width,
            height: Get.height,
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/fon.png'), fit: BoxFit.fitWidth)),
            child: Stack(
                children: [
                  Positioned.fill(child: Image.asset('assets/images/fon.png', fit: BoxFit.fitWidth)),
                  Positioned(top: 0, child: AnimatedContainer(width: Get.width, height: Get.height * 0.2, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut, decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r), bottomRight: Radius.circular(20.r)), image: const DecorationImage(image: AssetImage('assets/images/bar.png'), fit: BoxFit.cover), boxShadow: const [BoxShadow(color: AppColors.grey, spreadRadius: 5, blurRadius: 16, offset: Offset(0, 3))]),)),
                  Positioned(width: Get.width, top: Get.height * 0.11, child: Center(child: TextLarge(text: 'Create Passcode'.tr, color: AppColors.white, fontWeight: FontWeight.bold),)),
                  Positioned.fill(
                      top: Get.height * 0.3,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShakeWidget(
                                key: _getController.shakeKey[9],
                                shakeOffset: 5,
                                shakeCount: 15,
                                shakeDuration: const Duration(milliseconds: 500),
                                shakeDirection: Axis.horizontal,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(4, (index) {
                                      return Obx(() => Icon(
                                        index < _getController.enteredPasscode.value.length ? Icons.circle : Icons.circle_outlined,
                                        size: 20,
                                        color: _getController.errorInput[0] ? Colors.red : _getController.errorField.value ? Colors.green : Colors.black,
                                      ));
                                    })
                                )
                            ),
                            SizedBox(height: 15.h),
                            TextSmall(text: _getController.firstPasscode.value.isEmpty ? 'Enter new passcode'.tr : 'Re-enter new passcode'.tr, color: AppColors.black),
                            SizedBox(height: 25.h),
                            Expanded(
                                child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(horizontal: 60),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1),
                                    itemCount: 12,
                                    itemBuilder: (context, index) {
                                      if (index == 9) {
                                        return IconButton(
                                          icon: Icon(
                                            _getController.hasFingerprint.value ? Icons.fingerprint : _getController.hasFaceID.value ? Icons.face : null,
                                            size: 28,
                                          ),
                                          onPressed: () => _showBiometricDialog(),
                                        );
                                      } else if (index == 10) {
                                        return _buildNumberButton('0');
                                      } else if (index == 11) {
                                        return IconButton(
                                          icon: const Icon(Icons.backspace_outlined, size: 28),
                                          onPressed: _onDeleteTap,
                                        );
                                      } else {
                                        return _buildNumberButton((index + 1).toString());
                                      }
                                    }
                                )
                            )
                          ]
                      )
                  )
                ]
            )
        ))
    );
  }

  Widget _buildNumberButton(String number) => ElevatedButton(onPressed: () => _onNumberTap(number), style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, overlayColor: Colors.transparent, foregroundColor: Colors.transparent, surfaceTintColor: Colors.transparent, shadowColor: Colors.transparent, elevation: 0), child: Text(number, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.black)));
}
