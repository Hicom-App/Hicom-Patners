import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:glyph/glyph.dart';
import 'package:hicom_patners/pages/sample/qr_scan_page.dart';

import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
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
        /*appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            backgroundColor: AppColors.greys,
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill), onPressed: () => Scaffold.of(context).openDrawer());
              }
            ),
            title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextLarge(text: _getController.fullName.value.toString(), color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1),
                  TextSmall(text: 'ID: ${_getController.id.value.toString()}', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1)
                ]
            ),
            actions: [
              IconButton(icon: Icon(Icons.notifications, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back())
            ]
        ),*/
        body: Obx(() => _getController.widgetOptions.elementAt(_getController.index.value)),
        extendBody: true,
        bottomNavigationBar: Obx(() => Card(
            color: AppColors.white,
            elevation: 5,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            margin: EdgeInsets.only(bottom: Get.height * 0.03, left: Get.width * 0.04, right: Get.width * 0.04),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: Icon(I.material.home, color: _getController.index.value == 0 ? AppColors.red : AppColors.black70, size: Theme.of(context).iconTheme.fill), onPressed: () => _onItemTapped(0)),
                  IconButton(icon: Icon(I.cupertino.personFill, color: _getController.index.value == 1 ? AppColors.red : AppColors.black70, size: Theme.of(context).iconTheme.fill), onPressed: () => _onItemTapped(1)),
                  Container(
                    margin: EdgeInsets.all(5.r),
                    decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
                    child: IconButton(icon: Icon(Icons.qr_code, color: AppColors.white, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.to(QRViewExample())),
                  ),
                  IconButton(icon: Icon(I.cupertino.cubeBoxFill, color: _getController.index.value == 2 ? AppColors.red : AppColors.black70, size: Theme.of(context).iconTheme.fill), onPressed: () => _onItemTapped(2)),
                  IconButton(icon: Icon(Icons.insert_chart, color: _getController.index.value == 3 ? AppColors.red : AppColors.black70, size: Theme.of(context).iconTheme.fill), onPressed: () => _onItemTapped(3))
                ]
            )
        ))
    );
  }
}
