import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_large.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../companents/instrument/custom_header.dart';
import '../../controllers/get_controller.dart';

class SamplePage extends StatelessWidget {

  SamplePage({super.key});

  final GetController _getController = Get.put(GetController());

  void _getData() {
    _getController.refreshLibController.refreshCompleted();
  }

  void _onLoading() async {
    _getController.refreshLibController.refreshCompleted();
    _getController.refreshLibController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextLarge(text: _getController.fullName.value.toString(), color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1),
            TextSmall(text: 'ID: ${_getController.id.value.toString()}', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.notifications, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
        ],
      ),
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          physics: const BouncingScrollPhysics(),
          header: const CustomRefreshHeader(),
          footer: const CustomRefreshFooter(),
          onLoading: _onLoading,
          onRefresh: _getData,
          controller: _getController.refreshLibController,
          scrollController: _getController.scrollController,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: Get.height * 0.7,
                child: Center(
                  child: Text('Sample'.tr)
                )
            )
          )
      ),
      bottomNavigationBar: BottomAppBar(
        height: Get.height * 0.12,
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          height: Get.height * 0.1,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.error.withOpacity(0.5), borderRadius: BorderRadius.all(Radius.circular(19.r))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //home, profile, Qr button, analiz, settings
              IconButton(icon: Icon(Icons.home, color: AppColors.black70, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
              IconButton(icon: Icon(Icons.person, color: AppColors.black70, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
              Container(
                padding: EdgeInsets.all(5.r),
                decoration: const BoxDecoration(color: AppColors.primaryColor2, shape: BoxShape.circle),
                child: IconButton(icon: Icon(Icons.qr_code, color: AppColors.white, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
              ),
              IconButton(icon: Icon(Icons.analytics, color: AppColors.black70, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
              IconButton(icon: Icon(Icons.settings, color: AppColors.black70, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
            ],
          ),
        ),
      )
    );
  }
}