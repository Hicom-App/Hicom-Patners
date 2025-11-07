import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/switches/views/switch_add_view.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../companents/filds/text_small.dart';
import '../../../resource/colors.dart';
import '../controllers/scan_switch_controller.dart';

class ScanSwitchView extends StatefulWidget {
  final String title;
  const ScanSwitchView({super.key, required this.title});

  @override
  ScanSwitchViewState createState() => ScanSwitchViewState();
}

class ScanSwitchViewState extends State<ScanSwitchView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final ScanSwitchController controller = Get.put(ScanSwitchController());

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this,)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(width: Get.width, height: Get.height),
              MobileScanner(controller: controller.cameraController, onDetect: (barcodes) => controller.handleScanResult(context, barcodes), fit: BoxFit.cover,),
              CustomPaint(size: Size(Get.width, Get.height), painter: DimmedOverlayPainter(scanAreaSize: 270.w, scanAreaOffset: Offset(0, 0.h))),
              Center(child: SizedBox(width: 270.w, height: 270.w, child: CustomPaint(painter: ScannerOverlayPainter(animationValue: _animationController.value)))),
              Center(child: SizedBox(width: 270.w, height: 270.w, child: const ScanAnimationWidget())),
              const Center(child: PulsingDot()),
              Positioned(
                bottom: 100.h,
                left: 0,
                right: 0,
                child: Center(
                  child: InkWell(
                    onTap: () => Get.to(SwitchAddView()),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(color: AppColors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(12.r)),
                        child: TextSmall(text: 'QR kodni ramka ichiga joylashtiring', color: AppColors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)
                    )
                  )
                )
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: SizedBox(
                  width: Get.width,
                  child: AppBar(
                    backgroundColor: AppColors.blackTransparent,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: AppColors.white,
                    title: TextSmall(text: widget.title, color: AppColors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                    actions: [
                      Obx(() => IconButton(
                        onPressed: () => controller.toggleTorch(),
                        icon: AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: Icon(controller.isTorchOn.value ? EneftyIcons.lamp_on_bold : EneftyIcons.lamp_slash_bold, key: ValueKey(controller.isTorchOn.value), color: controller.isTorchOn.value ? Colors.yellow : AppColors.white, size: 24.r))
                      ))
                    ]
                  )
                )
              )
            ]
          )
        );
      }
    );
  }
}

// Scan animatsiya widget - yuqoridan pastga harakat qiluvchi chiziq
class ScanAnimationWidget extends StatefulWidget {
  const ScanAnimationWidget({super.key});

  @override
  ScanAnimationWidgetState createState() => ScanAnimationWidgetState();
}

class ScanAnimationWidgetState extends State<ScanAnimationWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _animationController.repeat(reverse: true); // Ikki yo'nalishli takrorlash
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: _animation, builder: (context, child) => CustomPaint(painter: ScanLinePainter(_animation.value), size: Size(270.w, 270.w)));
}

// Scan line painter - animatsiyali chiziq
class ScanLinePainter extends CustomPainter {
  final double animationValue;
  ScanLinePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final gradient = LinearGradient(colors: [Colors.transparent, Colors.white.withOpacity(0.8), Colors.white, Colors.white.withOpacity(0.8), Colors.transparent], stops: const [0.0, 0.2, 0.5, 0.8, 1.0]).createShader(Rect.fromLTWH(0, 0, size.width, 4.h));
    paint.shader = gradient;
    final y = (size.height - 40.h) * animationValue + 20.h;
    final rect = RRect.fromRectAndRadius(Rect.fromLTWH(20.w, y, size.width - 40.w, 3.h), Radius.circular(2.r));
    canvas.drawRRect(rect, paint);
    final glowPaint = Paint()..color = Colors.white.withOpacity(0.3)..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.r);
    canvas.drawRRect(rect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Pulsing dot - markazda miltillayotgan nuqta
class PulsingDot extends StatefulWidget {
  const PulsingDot({super.key});

  @override
  PulsingDotState createState() => PulsingDotState();
}

class PulsingDotState extends State<PulsingDot> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: _pulseAnimation, builder: (context, child) => Container(width: 8.w, height: 8.w, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(_pulseAnimation.value), boxShadow: [BoxShadow(color: Colors.white.withOpacity(_pulseAnimation.value * 0.5), blurRadius: 8.r, spreadRadius: 2.r)])));
}

// Dimmed overlay painter - faqat ramka tashqarisini xiralashtiradi
class DimmedOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final Offset scanAreaOffset;

  DimmedOverlayPainter({required this.scanAreaSize, this.scanAreaOffset = Offset.zero});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.6);
    final fullScreenPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final center = Offset(size.width / 2, size.height / 2) + scanAreaOffset;
    final scanRect = Rect.fromCenter(center: center, width: scanAreaSize, height: scanAreaSize);
    final scanPath = Path()..addRRect(RRect.fromRectAndRadius(scanRect, Radius.circular(ScreenUtil().setWidth(20))));
    fullScreenPath.fillType = PathFillType.evenOdd;
    fullScreenPath.addPath(scanPath, Offset.zero);
    canvas.drawPath(fullScreenPath, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom ramka painter
class ScannerOverlayPainter extends CustomPainter {
  final double animationValue;
  ScannerOverlayPainter({required this.animationValue});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.white..strokeWidth = ScreenUtil().setWidth(5)..style = PaintingStyle.stroke;
    final pulsePaint = Paint()..color = AppColors.white.withOpacity(0.3 + (0.5 * animationValue))..style = PaintingStyle.stroke..strokeWidth = ScreenUtil().setWidth(6)..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.r);
    final cornerLength = ScreenUtil().setWidth(40);
    final radius = ScreenUtil().setWidth(20);
    // Top-left
    canvas.drawPath(Path()..moveTo(0, radius)..quadraticBezierTo(0, 0, radius, 0)..lineTo(cornerLength, 0), paint);
    canvas.drawPath(Path()..moveTo(0, radius)..lineTo(0, cornerLength), paint);
    canvas.drawPath(Path()..moveTo(0, radius)..quadraticBezierTo(0, 0, radius, 0)..lineTo(cornerLength, 0), pulsePaint);
    canvas.drawPath(Path()..moveTo(0, radius)..lineTo(0, cornerLength), pulsePaint);
    // Top-right
    canvas.drawPath(Path()..moveTo(size.width - cornerLength, 0)..lineTo(size.width - radius, 0)..quadraticBezierTo(size.width, 0, size.width, radius), paint);
    canvas.drawPath(Path()..moveTo(size.width, radius)..lineTo(size.width, cornerLength), paint);
    canvas.drawPath(Path()..moveTo(size.width - cornerLength, 0)..lineTo(size.width - radius, 0)..quadraticBezierTo(size.width, 0, size.width, radius), pulsePaint);
    canvas.drawPath(Path()..moveTo(size.width, radius)..lineTo(size.width, cornerLength), pulsePaint);

    // Bottom-left
    canvas.drawPath(Path()..moveTo(0, size.height - cornerLength)..lineTo(0, size.height - radius)..quadraticBezierTo(0, size.height, radius, size.height), paint);
    canvas.drawPath(Path()..moveTo(radius, size.height)..lineTo(cornerLength, size.height), paint);
    canvas.drawPath(Path()..moveTo(0, size.height - cornerLength)..lineTo(0, size.height - radius)..quadraticBezierTo(0, size.height, radius, size.height), pulsePaint);
    canvas.drawPath(Path()..moveTo(radius, size.height)..lineTo(cornerLength, size.height), pulsePaint);

    // Bottom-right
    canvas.drawPath(Path()..moveTo(size.width - cornerLength, size.height)..lineTo(size.width - radius, size.height)..quadraticBezierTo(size.width, size.height, size.width, size.height - radius), paint);
    canvas.drawPath(Path()..moveTo(size.width, size.height - radius)..lineTo(size.width, size.height - cornerLength), paint);
    canvas.drawPath(Path()..moveTo(size.width - cornerLength, size.height)..lineTo(size.width - radius, size.height)..quadraticBezierTo(size.width, size.height, size.width, size.height - radius), pulsePaint);
    canvas.drawPath(Path()..moveTo(size.width, size.height - radius)..lineTo(size.width, size.height - cornerLength), pulsePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}