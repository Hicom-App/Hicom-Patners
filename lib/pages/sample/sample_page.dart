import 'dart:io';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/sample/qr_scan_page.dart';
import '../../controllers/api_controller.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> with SingleTickerProviderStateMixin {
  final GetController _getController = Get.put(GetController());

  @override
  void initState() {
    super.initState();
    _getController.controllerConvex = TabController(length: 5, vsync: this);
    _getController.changeWidgetOptions();
    ApiController().getProfile(isWorker: false);
    ApiController().getCategories();
  }

  @override
  void dispose() {
    _getController.controllerConvex.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _getController.changeIndex(index);
    _getController.searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerEnableOpenDragGesture: false,
        body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if(_getController.index.value == 0) {
                exit(0);
              } else {
                _getController.changeIndex(0);
                _getController.controllerConvex.animateTo(0);
              }
            },
            child: Obx(() => IndexedStack(index: _getController.index.value, children: _getController.widgetOptions))
            //child: Obx(() => _getController.widgetOptions.elementAt(_getController.index.value))
        ),
        extendBody: true,
        bottomNavigationBar: ConvexAppBar(
            controller: _getController.controllerConvex,
            style: TabStyle.fixedCircle,
            cornerRadius: 25.r,
            color: AppColors.black70,
            backgroundColor: AppColors.white,
            shadowColor: AppColors.grey,
            elevation: 7.sp,
            activeColor: AppColors.red,
            initialActiveIndex: 0,
            height: Platform.isAndroid ? 70.sp : 50.sp,
            items: [
              const TabItem(icon: EneftyIcons.home_bold),
              const TabItem(icon: EneftyIcons.profile_bold),
              TabItem(
                  icon: Container(
                      decoration: BoxDecoration(borderRadius: Platform.isAndroid ? BorderRadius.all(Radius.circular(4000.r)) : null, shape: Platform.isIOS ? BoxShape.circle : BoxShape.rectangle, color: AppColors.white),
                      child: Container(
                          margin: EdgeInsets.all(5.r),
                          decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                          child: IconButton(icon: Icon(EneftyIcons.scan_barcode_bold, color: AppColors.white, size: 30.sp), onPressed: () => Get.to(QRViewExample()))
                      )
                  )
              ),
              const TabItem(icon: EneftyIcons.box_3_bold),
              const TabItem(icon: EneftyIcons.chart_2_bold)
            ],
            //onTap: (int i) => _onItemTapped(i >= 3 ? i - 1 : i)
            onTap: _onItemTapped
        )
    );
  }
}
