import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import '../home/category_page.dart';
import '../home/detail_page.dart';

class AccountPage extends StatelessWidget {
  AccountPage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshComponent(
            scrollController: _getController.scrollAccountController,
            refreshController: _getController.refreshAccountController,
            child: Column(
                children: [
                  SizedBox(
                      height: Get.height * 0.31,
                      width: Get.width,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: 120.w,
                                height: 120.h,
                                margin: EdgeInsets.only(bottom: Get.height * 0.02, top: Get.height * 0.05),
                                decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(300),
                                    child: FadeInImage(
                                        image: const NetworkImage('https://instagram.ftas5-1.fna.fbcdn.net/v/t51.2885-19/454375063_487532617318545_4417457106582834069_n.jpg?_nc_ht=instagram.ftas5-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=xnBuUpf17dgQ7kNvgFYiQoo&edm=ALGbJPMBAAAA&ccb=7-5&oh=00_AYAi2FaCRf-T3jGomSQSrzKbQc-atAqn_5Og6KN_EluJNA&oe=66F1EF5F&_nc_sid=7d3ac5'),
                                        placeholder: const NetworkImage('https://instagram.ftas5-1.fna.fbcdn.net/v/t51.2885-19/454375063_487532617318545_4417457106582834069_n.jpg?_nc_ht=instagram.ftas5-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=xnBuUpf17dgQ7kNvgFYiQoo&edm=ALGbJPMBAAAA&ccb=7-5&oh=00_AYAi2FaCRf-T3jGomSQSrzKbQc-atAqn_5Og6KN_EluJNA&oe=66F1EF5F&_nc_sid=7d3ac5'),
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Container(
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(image: NetworkImage('https://instagram.ftas5-1.fna.fbcdn.net/v/t51.2885-19/454375063_487532617318545_4417457106582834069_n.jpg?_nc_ht=instagram.ftas5-1.fna.fbcdn.net&_nc_cat=109&_nc_ohc=xnBuUpf17dgQ7kNvgFYiQoo&edm=ALGbJPMBAAAA&ccb=7-5&oh=00_AYAi2FaCRf-T3jGomSQSrzKbQc-atAqn_5Og6KN_EluJNA&oe=66F1EF5F&_nc_sid=7d3ac5'), fit: BoxFit.cover),
                                                  shape: BoxShape.circle
                                              )
                                          );
                                        },
                                        fit: BoxFit.cover
                                    )
                                )
                            ),
                            TextLarge(text: 'Dilshodjon Haydarov'.tr, color: AppColors.black, fontWeight: FontWeight.bold),
                            TextSmall(text: '+998 99 534 03 13'.tr, color: AppColors.black, fontWeight: FontWeight.w400),
                          ]
                      )
                  ),
                  Container(
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), boxShadow: [
                      BoxShadow(
                          color: AppColors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3)
                      )
                    ]),
                    child: Column(
                        children: [
                          SizedBox(
                              width: Get.width,
                              height: Get.height * 0.81
                          ),
                        ]),
                  )
                ]
            )
        )
    );
  }
}