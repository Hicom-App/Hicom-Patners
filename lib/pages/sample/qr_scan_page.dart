import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../companents/filds/text_large.dart';
import '../../controllers/get_controller.dart';

class QRViewExample extends StatelessWidget {
  QRViewExample({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,surfaceTintColor: Colors.transparent,
          title: TextLarge(text: 'QR Kodni Skaynerlash'.tr, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color:Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill),
              onPressed: () => Get.back()
          ),
          actions: [
            Obx(() => IconButton(icon: Icon(_getController.cameraFacing.value == CameraFacing.front ? EneftyIcons.repeate_one_bold : EneftyIcons.repeat_circle_bold, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill), onPressed: _getController.toggleCamera)),
            Obx(() => IconButton(icon: Icon(_getController.isLampOn.value ? EneftyIcons.lamp_slash_bold : EneftyIcons.lamp_on_bold, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill), onPressed: _getController.toggleLamp))
        ]
      ),
      body: Obx(() => QRView(
          overlay: QrScannerOverlayShape(borderColor: Colors.white, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: MediaQuery.of(context).size.width * 0.8),
          key: _getController.qrKey,
          cameraFacing: _getController.cameraFacing.value,
          onQRViewCreated: _getController.onQRViewCreated)
      )
    );
  }
}