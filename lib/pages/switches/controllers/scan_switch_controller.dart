import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../controllers/api_controller.dart';
import '../../../controllers/get_controller.dart';
import '../../../resource/colors.dart';
import '../controllers/switches_controller.dart';
import '../../../models/sample/switch_model.dart';

class ScanSwitchController extends GetxController {
  final MobileScannerController cameraController = MobileScannerController(autoStart: false);
  final GetController _getController = Get.put(GetController());
  final RxBool isScanning = false.obs;
  final RxBool isTorchOn = false.obs; // Lamp holati
  final RxBool isProcessing = false.obs;
  final RxList<SwitchModel> scanHistory = <SwitchModel>[].obs;
  bool _isStarting = false;
  final GlobalKey scannerKey = GlobalKey();
  final Map<String, DateTime> lastScanTimes = {};

  @override
  void onInit() {
    cameraController.start();
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isScanning.value) {
        _startScanner();
      }
    });
  }

  Future<void> _startScanner() async {
    if (_isStarting) return;
    _isStarting = true;
    try {
      await cameraController.start();
      isScanning.value = true;
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Skanerni ishga tushirishda xato: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.red,
        textColor: AppColors.white,
      );
    }
  }

  // Toggle ichida:
  Future<void> toggleScanner() async {
    if (_isStarting) return;
    if (isScanning.value) {
      isScanning.value = false;
      await cameraController.stop();
      isProcessing.value = false;
    } else {
      // Bu joyda widget allaqachon build bo'lgan — start qilish xavfsiz
      _isStarting = true;
      try {
        await cameraController.start();
        isScanning.value = true;
      } finally {
        _isStarting = false;
      }
    }
  }

  // Lampani yoqib-o'chirish funksiyasi
  Future<void> toggleTorch() async {
    try {
      await cameraController.toggleTorch();
      isTorchOn.value = !isTorchOn.value;
    } catch (e) {
      print("Torch toggle error: $e");
      Fluttertoast.showToast(msg: "Lampani boshqarishda xato", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: AppColors.red, textColor: AppColors.white);
    }
  }

  Future<void> handleScanResult(BuildContext context, BarcodeCapture capture) async {
    if (isProcessing.value) return;
    if (capture.barcodes.isNotEmpty) {
      final String? scannedData = capture.barcodes.first.rawValue;
      if (scannedData != null) {
        final now = DateTime.now();
        final lastScan = lastScanTimes[scannedData];
        if (lastScan != null && now.difference(lastScan).inSeconds < 2) {
          return; // Debounce: skip if scanned within 2 seconds
        }
        isProcessing.value = true;
        try {
          _getController.codeController.text = scannedData;
          await ApiController().addWarrantyProduct(scannedData, context);
          lastScanTimes[scannedData] = now;
        } catch (e) {
          Fluttertoast.showToast(
            msg: "Xato: $e",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: AppColors.red,
            textColor: AppColors.white,
          );
        } finally {
          isProcessing.value = false;
        }
      }
    }
  }

  @override
  void onClose() {
    // Lamp o'chirilganligi haqida ishonch hosil qilish
    if (isTorchOn.value) {
      cameraController.toggleTorch();
    }
    cameraController.dispose();
    super.onClose();
  }
}