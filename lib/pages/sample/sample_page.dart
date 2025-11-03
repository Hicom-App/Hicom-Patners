import 'dart:io';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../controllers/api_controller.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import '../partners/controllers/partners_controller.dart';
import '../switches/views/scan_switch_view.dart';


class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> with SingleTickerProviderStateMixin {
  final GetController _getController = Get.put(GetController());
  final PartnersController _controller = Get.put(PartnersController());

  @override
  void initState() {
    super.initState();
    _getController.changeWidgetOptions();
    _getController.controllerConvex = TabController(length: 5, vsync: this);
    ApiController().getProfile(isWorker: false);
    ApiController().getCategories();
  }

  @override
  void dispose() {
    _getController.controllerConvex?.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _getController.changeIndex(index);
    print('index: $index');
    if (index == 3){
      //_getController.clearWarrantyModel();
      //_getController.clearSortedWarrantyModel();
      //ApiController().getWarrantyProducts(filter: 'c.active=1');
      _controller.initializeApp();
    }
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
                _getController.controllerConvex?.animateTo(0);
              }
            },
            child: Obx(() => IndexedStack(index: _getController.index.value, children: _getController.widgetOptions))
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
              const TabItem(icon: Iconsax.home_1),
              const TabItem(icon: Iconsax.hierarchy_square_2),
              TabItem(
                  icon: Container(
                      decoration: BoxDecoration(borderRadius: Platform.isAndroid ? BorderRadius.all(Radius.circular(4000.r)) : null, shape: Platform.isIOS ? BoxShape.circle : BoxShape.rectangle, color: AppColors.white),
                      child: Container(
                          margin: EdgeInsets.all(5.r),
                          decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                          child: IconButton(highlightColor: AppColors.blackTransparent, icon: Icon(Iconsax.scan_barcode, color: AppColors.white, size: 30.sp), onPressed: () => Get.to(ScanSwitchView(title: 'QR Kodni Skaynerlash'.tr,)))
                      )
                  )
              ),
              TabItem(icon: Iconsax.shop),
              const TabItem(icon: Iconsax.chart_21)
            ],
            onTap: _onItemTapped
        )
    );
  }
}
