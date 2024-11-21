import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import '../../../companents/instrument/shake_widget.dart';
import '../../../controllers/get_controller.dart';
import '../../../resource/colors.dart';

class ChangePasscodePage extends StatelessWidget {
  ChangePasscodePage({super.key});

  final GetController _getController = Get.put(GetController());


  void _onDeleteTap() {
    if (_getController.enteredPasscode.value.isNotEmpty) {
      _getController.enteredPasscode.value = _getController.enteredPasscode.value.substring(0, _getController.enteredPasscode.value.length - 1);
    }
  }

  void _onNumberTap(String number) {
    final enteredPasscode = _getController.enteredPasscode.value;

    if (enteredPasscode.length < 4) {
      _getController.enteredPasscode.value += number;
    }

    if (_getController.enteredPasscode.value.length == 4) {
      if (_getController.firstPasscode.value.isEmpty) {
        // Eski parolni tasdiqlash
        if (_getController.checkPassCode(_getController.enteredPasscode.value)) {
          _getController.errorField.value = true;
          _getController.tapTimes(() {
            _getController.firstPasscode.value = _getController.enteredPasscode.value;
            _getController.enteredPasscode.value = '';
            _getController.errorField.value = false;
          }, 1);
        } else {
          _showError();
        }
      } else if (_getController.secondPasscode.value.isEmpty) {
        // Yangi parolni kiritish
        _getController.errorField.value = true;
        _getController.tapTimes(() {
          _getController.ok.value = true;
          _getController.secondPasscode.value = _getController.enteredPasscode.value;
          _getController.enteredPasscode.value = '';
          _getController.errorField.value = false;
        }, 1);
      } else if (_getController.ok.value == true) {
        if (_getController.secondPasscode.value == _getController.enteredPasscode.value) {
          _getController.errorField.value = true;
          _getController.tapTimes(() {
            _getController.savePassCode(_getController.secondPasscode.value);
            _getController.errorField.value = false;
            _getController.secondPasscode.value = '';
            _getController.firstPasscode.value = '';
            _getController.enteredPasscode.value = '';
            Get.back();
          }, 1);
        } else {
          _showError();
        }
      }
    }
  }

  void _showError() {
    _getController.shakeKey[9].currentState?.shake();
    _getController.changeErrorInput(0, true);
    _getController.tapTimes(() {
      _getController.changeErrorInput(0, false);
      _getController.enteredPasscode.value = '';
    }, 1);
  }

  @override
  Widget build(BuildContext context) {
    _getController.enteredPasscode.value = '';
    _getController.firstPasscode.value = '';
    _getController.secondPasscode.value = '';
    _getController.ok.value = false;
    return Column(children: [
      Container(
        height: Get.height * 0.005,
        width: Get.width * 0.2,
        margin: EdgeInsets.only(top: Get.height * 0.02, bottom: Get.height * 0.03),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface, borderRadius: BorderRadius.circular(10.r))
      ),
      SizedBox(height: Get.height * 0.1),
      ShakeWidget(
        key: _getController.shakeKey[9],
        shakeOffset: 5,
        shakeCount: 15,
        shakeDuration: const Duration(milliseconds: 500),
        shakeDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) =>Obx(() => Icon(index < _getController.enteredPasscode.value.length ? Icons.circle : Icons.circle_outlined, size: 20, color: _getController.errorInput[0] ? Colors.red : _getController.errorField.value ? Colors.green : Colors.black)))
        )
      ),
      SizedBox(height: 25.h),
      Obx(() => TextSmall(text: _getController.firstPasscode.value.isEmpty ? 'Joriy parolni kiriting'.tr : _getController.secondPasscode.value.isEmpty ? 'Yangi parolni kiriting'.tr : 'Parolni qayta kiriting'.tr, color: AppColors.black)),
      SizedBox(height: 25.h),
      Expanded(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 60),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            if (index == 9) {
              return const SizedBox();
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
          },
        ),
      ),
    ]);
  }

  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      onPressed: () => _onNumberTap(number),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        overlayColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      child: TextSmall(
        text: number,
        color: AppColors.black,
        fontWeight: FontWeight.bold,
        fontSize: 24.sp,
      ),
    );
  }
}
