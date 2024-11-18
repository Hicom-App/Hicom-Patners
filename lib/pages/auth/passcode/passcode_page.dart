import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:hicom_patners/companents/instrument/shake_widget.dart';
import 'package:hicom_patners/pages/sample/sample_page.dart';
import 'package:local_auth/local_auth.dart';
import '../../../companents/filds/text_large.dart';
import '../../../controllers/get_controller.dart';
import '../../../resource/colors.dart';

class PasscodePage extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();
  final GetController _getController = Get.put(GetController());

  PasscodePage({super.key}) {_checkBiometricAvailability();}

  Future<void> _checkBiometricAvailability() async {
    try {
      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
      _getController.hasFingerprint.value = availableBiometrics.contains(BiometricType.fingerprint) ? true : false;
      _getController.hasFaceID.value = availableBiometrics.contains(BiometricType.face) ? true : false;
    } catch (e) {
      print('Error checking biometrics: $e');
    }
  }

  Future<void> _authenticate(BuildContext context) async {
    if (!_getController.getBiometrics()) return;
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
      if (_getController.checkPassCode(_getController.enteredPasscode.value)) {
        _getController.errorField.value = true;
        _getController.errorFieldOk.value = true;
        _getController.tapTimes(() {
          _getController.errorFieldOk.value = false;
          _getController.errorField.value = false;
          Get.offAll(() => SamplePage());
        }, 1);
      } else {
        _getController.shakeKey[9].currentState?.shake();
        _getController.changeErrorInput(0, true);
        _getController.tapTimes(() {
          _getController.changeErrorInput(0, false);
          _getController.enteredPasscode.value = '';
        }, 1);
      }
    }
  }

  void _onDeleteTap() {
    if (_getController.enteredPasscode.value.isNotEmpty) {
      _getController.enteredPasscode.value = _getController.enteredPasscode.value.substring(0, _getController.enteredPasscode.value.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    _authenticate(context);
    return Scaffold(
        body: Container(
            width: Get.width,
            height: Get.height,
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/fon.png'), fit: BoxFit.fitWidth)),
            child: Stack(
                children: [
                  Positioned.fill(child: Image.asset('assets/images/fon.png', fit: BoxFit.fitWidth)),
                  Positioned(top: 0, child: AnimatedContainer(width: Get.width, height: Get.height * 0.2, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut, decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r), bottomRight: Radius.circular(20.r)), image: const DecorationImage(image: AssetImage('assets/images/bar.png'), fit: BoxFit.cover), boxShadow: const [BoxShadow(color: AppColors.grey, spreadRadius: 5, blurRadius: 16, offset: Offset(0, 3))]))),
                  Positioned(width: Get.width, top: Get.height * 0.11, child: Center(child: TextLarge(text: 'Parolni kiriting'.tr, color: AppColors.white, fontWeight: FontWeight.bold),)),
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
                            SizedBox(height: 40.h),
                            Expanded(
                                child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(horizontal: 60),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1),
                                    itemCount: 12,
                                    itemBuilder: (context, index) {
                                      if (index == 9) {
                                        return _getController.getBiometrics()
                                            ? Obx(() => IconButton(icon: Icon(
                                            _getController.hasFingerprint.value == true
                                                ? Icons.fingerprint
                                                : _getController.hasFaceID.value == true
                                                ? Icons.face
                                                : null,
                                            size: 28),
                                            onPressed: () => _authenticate(context)))
                                            : const SizedBox();
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
                            ),
                            TextButton(onPressed: () {
                              _getController.deletePassCode();
                            }, child: TextSmall(text: 'Parolni unutdingizmi?'.tr, color: AppColors.black)),
                            SizedBox(height: 30.h)
                          ]
                      )
                  )
                ]
            )
        )
    );
  }

  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      onPressed: () => _onNumberTap(number),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, overlayColor: Colors.transparent, foregroundColor: Colors.transparent, surfaceTintColor: Colors.transparent, shadowColor: Colors.transparent, elevation: 0),
      child: Text(number, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.black))
    );
  }
}
