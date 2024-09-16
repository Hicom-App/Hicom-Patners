import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rive/rive.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/instrument/custom_header.dart';
import '../../controllers/get_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

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
                //height: Get.height * 0.7,
                child:Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: AppColors.white),
                      child: SizedBox(
                        height: Get.height * 0.35,
                        width: Get.width,
                        /*child: ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                            child: const RiveAnimation.asset('assets/shapes.riv', fit: BoxFit.cover),
                          ),
                        */
                        child: Stack(
                          children: [
                            Positioned.fill(child: ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), child: const RiveAnimation.asset('assets/shapes.riv', fit: BoxFit.cover))),
                            Positioned.fill(
                                child: Center(
                                  child: SizedBox(
                                      width: Get.width,
                                      height: Get.height * 0.15,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics: const BouncingScrollPhysics(),
                                          padding: EdgeInsets.only(left: Get.width * 0.05),
                                          itemBuilder: (context, index) => Container(
                                              decoration: BoxDecoration(
                                                  color: AppColors.white,
                                                  borderRadius: BorderRadius.all(Radius.circular(20.r))
                                              ),
                                              child: SizedBox(
                                                height: Get.height * 0.15,
                                                width: Get.width * 0.35,
                                                child: Column(
                                                    children: [
                                                      TextLarge(text: 'Test'.tr, color: Theme.of(context).colorScheme.secondary, fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize),
                                                    ]),
                                              )
                                          ),
                                          itemCount: 3
                                      )
                                  )
                                )
                            )
                          ]
                        )
                      )
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3)
                          )
                        ]),
                      child: SizedBox(
                        height: Get.height * 0.8,
                        width: Get.width,
                        child: Column(
                          children: [
                            TextLarge(text: 'Test'.tr, color: Theme.of(context).colorScheme.secondary, fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize),
                            SizedBox(height: Get.height * 0.01),
                            TextSmall(text: 'Test'.tr, color: Theme.of(context).colorScheme.secondary),
                            SizedBox(height: Get.height * 0.01),
                            SizedBox(height: Get.height * 0.01),
                            SizedBox(height: Get.height * 0.01),
                            SizedBox(height: Get.height * 0.01),
                            SizedBox(height: Get.height * 0.01),
                            SizedBox(height: Get.height * 0.01)
                          ]),
                      )
                    )
                  ],
                )
            )
          )
      ),
    );
  }
}