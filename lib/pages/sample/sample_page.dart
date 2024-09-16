import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
        appBar: AppBar(
          surfaceTintColor: Colors.white,
            shadowColor: Colors.white,
            foregroundColor: Colors.white,
            backgroundColor: Colors.white,
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
        ),
        body: Obx(() => _getController.widgetOptions.elementAt(_getController.index.value)),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Obx(() => Text(_getController.fullName.value.toString())),
                accountEmail: Obx(() => Text('ID: ${_getController.id.value.toString()}')),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
                )
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  _onItemTapped(0);
                }
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(1);
                }
              ),
              ListTile(
                leading: Icon(Icons.analytics),
                title: Text('Analytics'),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(2);
                }
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  _onItemTapped(3);
                }
              )
            ]
          )
        ),
        bottomNavigationBar: Obx(() => BottomAppBar(
            height: Get.height * 0.1,
            color: Colors.transparent,
            elevation: 0,
            child: Container(
                height: Get.height * 0.1,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.error.withOpacity(0.5), borderRadius: BorderRadius.all(Radius.circular(19.r))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(icon: Icon(Icons.home, color: _getController.index.value == 0 ? AppColors.white : AppColors.black70, size: Theme.of(context).iconTheme.fill), onPressed: () => _onItemTapped(0)),
                      IconButton(icon: Icon(Icons.person, color: _getController.index.value == 1 ? AppColors.white : AppColors.black70, size: Theme.of(context).iconTheme.fill), onPressed: () => _onItemTapped(1)),
                      Container(
                        padding: EdgeInsets.all(5.r),
                        decoration: const BoxDecoration(color: AppColors.primaryColor2, shape: BoxShape.circle),
                        child: IconButton(icon: Icon(Icons.qr_code, color: AppColors.white, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.to(QRViewExample())),
                      ),
                      IconButton(icon: Icon(Icons.analytics, color: _getController.index.value == 2 ? AppColors.white : AppColors.black70, size: Theme.of(context).iconTheme.fill), onPressed: () => _onItemTapped(2)),
                      IconButton(icon: Icon(Icons.settings, color: _getController.index.value == 3 ? AppColors.white : AppColors.black70, size: Theme.of(context).iconTheme.fill), onPressed: () => _onItemTapped(3))
                    ]
                )
            )
        ))
    );
  }
}
