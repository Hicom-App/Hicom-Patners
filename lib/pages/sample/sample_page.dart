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
        /*bottomNavigationBar: Obx(() => Card(
            color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.greysBack,
            elevation: 5,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            margin: EdgeInsets.only(bottom: Get.height * 0.03, left: Get.width * 0.04, right: Get.width * 0.04),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: Icon(EneftyIcons.home_bold, color: _getController.index.value == 0
                      ? AppColors.red
                      : Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white,
                      size: Theme.of(context).iconTheme.fill), onPressed: () => _onItemTapped(0)),
                  IconButton(icon: Icon(EneftyIcons.profile_bold,
                      color: _getController.index.value == 1
                          ? AppColors.red
                          : Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white,
                      size: Theme.of(context).iconTheme.fill), onPressed: () => _onItemTapped(1)),
                  Container(
                    margin: EdgeInsets.all(5.r),
                    decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                    child: IconButton(icon: Icon(EneftyIcons.scan_barcode_bold, color: AppColors.white, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.to(QRViewExample())),
                  ),
                  IconButton(icon: Icon(EneftyIcons.box_3_bold, color: _getController.index.value == 2 ? AppColors.red : Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white, size: Theme.of(context).iconTheme.fill), onPressed: () => _onItemTapped(2)),
                  IconButton(icon: Icon(EneftyIcons.chart_2_bold, color: _getController.index.value == 3 ? AppColors.red : Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.white, size: Theme.of(context).iconTheme.fill), onPressed: () => _onItemTapped(3))
                ]
            )
        ))*/

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
            TabItem(icon:EneftyIcons.home_bold),
            TabItem(icon: EneftyIcons.profile_bold),
            TabItem(icon: Container(decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle), child: IconButton(icon: Icon(EneftyIcons.scan_barcode_bold, color: AppColors.white, size: 35.sp), onPressed: () => Get.to(QRViewExample()))), title: 'Add'),
            TabItem(icon: EneftyIcons.box_3_bold),
            TabItem(icon: EneftyIcons.chart_2_bold),
          ],
          onTap: (int i) => print('click index=$i'),
        )

    );
  }
}
