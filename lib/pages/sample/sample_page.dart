import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/sample/qr_scan_page.dart';

import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class SamplePage extends StatelessWidget {
  SamplePage({super.key});

  final GetController _getController = Get.put(GetController());

  void _onItemTapped(int index) {
    _getController.changeIndex(index);
    _getController.changeWidgetOptions();
    _getController.searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    _getController.changeWidgetOptions();
    return Scaffold(
        drawerEnableOpenDragGesture: false,
        body: Obx(() => _getController.widgetOptions.elementAt(_getController.index.value)),
        extendBody: true,
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          cornerRadius: 25.r,
          color: AppColors.black70,
          backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
          shadowColor: AppColors.grey,
          elevation: 7.sp,
          activeColor: AppColors.red,
          initialActiveIndex: 0,
          height: 48.h,
          items: [
            const TabItem(icon:EneftyIcons.home_bold),
            const TabItem(icon: EneftyIcons.profile_bold),
            TabItem(icon: Container(
              decoration: const BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
              child: Container(
                  margin: EdgeInsets.all(5.r),
                  decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                  child: IconButton(icon: Icon(EneftyIcons.scan_barcode_bold, color: AppColors.white, size: 30.sp), onPressed: () => Get.to(QRViewExample()))
              )
            )),
            const TabItem(icon: EneftyIcons.box_3_bold),
            const TabItem(icon: EneftyIcons.chart_2_bold),
          ],
          onTap: (int i) => _onItemTapped(i >= 3 ? i-1 : i),
        )
    );
  }
}
