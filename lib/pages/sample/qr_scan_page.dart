import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../controllers/get_controller.dart';

class QRViewExample extends StatelessWidget {
  QRViewExample({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          title: TextSmall(text: 'QR Kodni Skaynerlash'.tr, color: AppColors.black, fontWeight: FontWeight.w500),
          leading: IconButton(icon: Icon(Icons.arrow_back, color:Theme.of(context).colorScheme.onSurface), onPressed: () => Get.back()),
          actions: [
            IconButton(icon: const Icon(EneftyIcons.repeat_circle_bold, color: AppColors.black), onPressed: _getController.toggleCamera),
            Obx(() => IconButton(icon: Icon(_getController.isLampOn.value ? EneftyIcons.lamp_slash_bold : EneftyIcons.lamp_on_bold, color: AppColors.black), onPressed: _getController.toggleLamp))
        ]
      ),
      body: Obx(() => QRView(
          overlay: QrScannerOverlayShape(
              borderColor: AppColors.blue,
              borderRadius: 16,
              borderLength: 40,
              borderWidth: 10,
              cutOutSize: Get.width * 0.8,
            cutOutBottomOffset: Get.height * 0.05,
          ),
          key: _getController.qrKey,
          cameraFacing: _getController.cameraFacing.value,
          onQRViewCreated: (controller) => _getController.onQRViewCreated(controller, context)
        )
      )
    );
  }
}