/*
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../companents/filds/search_text_field.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/home/chashe_image.dart';
import '../../companents/home/empty_component.dart';
import '../../companents/instrument/instrument_components.dart';
import '../../companents/refresh_component.dart';
import '../../companents/skletons/guarantee_skeleton.dart';
import '../../controllers/api_controller.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';


class ArxivPage extends StatelessWidget {
  ArxivPage({super.key});

  final GetController _getController = Get.put(GetController());

  void getData() {
    _getController.clearWarrantyModel();
    _getController.clearSortedWarrantyModel();
    //ApiController().getWarrantyProducts(filter: 'c.is_archived=1');
    ApiController().getWarrantyProduct(filter: 'c.active=1');
    _getController.refreshArchiveController.refreshCompleted();
    _getController.refreshArchiveController.loadComplete();
    if(_getController.searchController.text.isNotEmpty){
      _getController.searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    _getController.clearWarrantyModel();
    _getController.clearSortedWarrantyModel();
    ApiController().getWarrantyProduct(filter: 'c.active=1');
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: TextSmall(text: 'Arxivlangan tovarlar'.tr, color: AppColors.black, fontWeight: FontWeight.w500, maxLines: 1)
        ),
        body: RefreshComponent(
            refreshController: _getController.refreshArchiveController,
            scrollController: _getController.scrollArchiveController,
            color: AppColors.black,
            onRefresh: () => getData(),
            child: Obx(() {
              final groupedWarranty = _getController.warrantyModel.value.result != null && _getController.warrantyModel.value.result!.isNotEmpty ? _getController.warrantyModel.value.result!.fold<Map<String, List<dynamic>>>({}, (grouped, warranty) {
                String formattedDate = DateFormat('dd.MM.yyyy').format(DateTime.parse(warranty.warrantyStart.toString()));
                if (!grouped.containsKey(formattedDate)) {
                  grouped[formattedDate] = [];
                }
                grouped[formattedDate]!.add(warranty);
                return grouped;
              }) : {};
              return Column(
                  children: [
                    SizedBox(height: Get.height * 0.01),
                    SearchTextField(
                        color: Colors.grey.withOpacity(0.2),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            getData();
                            return;
                          }
                          else if (_getController.searchController.text.isNotEmpty && _getController.searchController.text.length > 3) {
                            ApiController().getWarrantyProduct(filter: 'c.active=1 AND name CONTAINS "${_getController.searchController.text}"');
                          }
                        }
                    ),
                    if (_getController.warrantyModel.value.result != null && _getController.warrantyModel.value.result!.isNotEmpty)
                      Container(
                          width: Get.width,
                          margin: EdgeInsets.only(left: 25.w, right: 25.w, top: 15.h, bottom: 15.h),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: groupedWarranty.keys.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                String dateKey = groupedWarranty.keys.elementAt(index);
                                List<dynamic> warrantiesForDate = groupedWarranty[dateKey]!;

                                if (warrantiesForDate.isEmpty) {return const SizedBox.shrink();}
                                return Column(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(bottom: 20.h),
                                          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.015),
                                          child: TextSmall(text: _getController.getDateFormat(dateKey), color: AppColors.black.withOpacity(0.6), fontWeight: FontWeight.w400)
                                      ),
                                      ...warrantiesForDate.map((warranty) {
                                        return Container(
                                            padding: EdgeInsets.only(left: 15.w, top: 8.h, bottom: 9.h),
                                            margin: EdgeInsets.only(bottom: 15.h),
                                            width: Get.width,
                                            decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.light ? Colors.white : AppColors.black70, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 20.r, spreadRadius: 18.r, offset: const Offset(0, 0))], borderRadius: BorderRadius.circular(18.r)),
                                            child: Column(
                                                children: [
                                                  Row(
                                                      children: [
                                                        Container(
                                                            margin: EdgeInsets.only(right: 15.w),
                                                            width: Get.width * 0.36,
                                                            height: Get.height * 0.13,
                                                            child: Stack(
                                                                children: [
                                                                  Positioned(width: 2, height: Get.height * 0.11, child: Center(child: Container(alignment: Alignment.center, width: 2.w, height: Get.height * 0.09, decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.all(Radius.circular(10.r)), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), blurRadius: 6.r, blurStyle: BlurStyle.outer, spreadRadius: 1.r, offset: const Offset(0, 10))])))),
                                                                  Positioned(right: 0, width: 2, height: Get.height * 0.11, child: Center(child: Container(alignment: Alignment.center, width: 2.w, height: Get.height * 0.09, decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.all(Radius.circular(20.r)), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), blurRadius: 6.r, blurStyle: BlurStyle.outer, spreadRadius: 1.r, offset: const Offset(0, 10))])))),
                                                                  Positioned.fill(child: Container(decoration: const BoxDecoration(color: AppColors.white), child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(20.r)), child: CacheImage(keys: warranty.id.toString(), url: warranty.photoUrl ?? '', fit: BoxFit.cover))))
                                                                ]
                                                            )
                                                        ),
                                                        Expanded(
                                                            child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        SizedBox(width: 110.w, child: TextSmall(text: warranty.name.toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)),
                                                                        const Spacer(),
                                                                        InkWell(onTap: () => InstrumentComponents().deleteWarrantyDialog(context,warranty.id!.toInt()), child: Icon(Icons.delete, color: AppColors.red, size: 20.sp)),
                                                                        SizedBox(width: 12.w),
                                                                      ]
                                                                  ),
                                                                  SizedBox(height: 12.h),
                                                                  Row(
                                                                      children: [
                                                                        SizedBox(width: 75.w, child: TextSmall(text: '${'Kategoriya'.tr}:', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp)),
                                                                        SizedBox(width: Get.width * 0.225, child: TextSmall(text: _getController.getCategoryName(warranty.categoryId!.toInt()), color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 11.sp))
                                                                      ]
                                                                  ),
                                                                  Row(
                                                                      children: [
                                                                        SizedBox(width: 75.w, child: TextSmall(text: '${'Qo‘shilgan'.tr}:', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp)),
                                                                        SizedBox(width: Get.width * 0.225, child: TextSmall(text: DateFormat('dd.MM.yyyy').format(DateTime.parse(warranty.dateCreated.toString())), color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 11.sp))
                                                                      ]
                                                                  ),
                                                                  Row(
                                                                      children: [
                                                                        SizedBox(width: 75.w, child: TextSmall(text: '${'Kafolat'.tr}:', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp)),
                                                                        SizedBox(width: Get.width * 0.225, child: TextSmall(text: DateFormat('dd.MM.yyyy').format(DateTime.parse(warranty.warrantyExpire.toString())), color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 11.sp))
                                                                      ]
                                                                  ),
                                                                  SizedBox(height: 6.h),
                                                                  Row(
                                                                      children: [
                                                                        Container(
                                                                            width: 80.w,
                                                                            padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                                                            decoration: BoxDecoration(color: DateTime.now().isAfter(DateTime.parse(_getController.warrantyModel.value.result![index].warrantyExpire.toString())) ? AppColors.red : AppColors.green, borderRadius: BorderRadius.circular(11.r)),
                                                                            child: Center(child: TextSmall(text:DateTime.now().isAfter(DateTime.parse(_getController.warrantyModel.value.result![index].warrantyExpire.toString())) ? 'Faol emas'.tr : 'Faol'.tr, color: DateTime.now().isAfter(DateTime.parse(_getController.warrantyModel.value.result![index].warrantyExpire.toString())) ? AppColors.white : AppColors.white, fontSize: 11.sp))
                                                                        ),
                                                                        const Spacer(),
                                                                        InkWell(onTap: () => ApiController().archiveWarrantyProduct(warranty.id!.toInt(), isArchived: false), child: Icon(EneftyIcons.archive_minus_bold, color: index == 1 ? AppColors.black70 : AppColors.black70, size: 21.sp)),
                                                                        SizedBox(width: 11.w)
                                                                      ]
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                      ]
                                                  )
                                                ]
                                            )
                                        );
                                      })
                                    ]
                                );
                              }
                          )
                      )
                    else if (_getController.warrantyModel.value.result == null || _getController.warrantyModel.value.result!.isNotEmpty)
                      const GuaranteeSkeleton()
                    else
                      const EmptyComponent()
                  ]
              );
            }
            )
        )
    );
  }
}
*/

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../companents/filds/search_text_field.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/home/chashe_image.dart';
import '../../companents/home/empty_component.dart';
import '../../companents/instrument/instrument_components.dart';
import '../../companents/refresh_component.dart';
import '../../companents/skletons/guarantee_skeleton.dart';
import '../../controllers/api_controller.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class ArxivPage extends StatelessWidget {
  ArxivPage({super.key});

  final GetController _getController = Get.put(GetController());

  void _fetchInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getController.clearWarrantyModel();
      _getController.clearSortedWarrantyModel();
      ApiController().getWarrantyProduct(filter: 'c.active=1');
      _getController.refreshArchiveController.refreshCompleted();
      _getController.refreshArchiveController.loadComplete();
    });
  }

  void _onSearch(String value) {
    if (value.isEmpty) {
      _fetchInitialData();
    } else {
      ApiController().getWarrantyProduct(filter: 'c.active=1 AND name CONTAINS "$value"',);
    }
  }

  @override
  Widget build(BuildContext context) {
    _fetchInitialData();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: TextSmall(text: 'Arxivlangan tovarlar'.tr, color: AppColors.black, fontWeight: FontWeight.w500, maxLines: 1)
      ),
      body: RefreshComponent(
        refreshController: _getController.refreshArchiveController,
        scrollController: _getController.scrollArchiveController,
        color: AppColors.black,
        onRefresh: () => _fetchInitialData(),
        child: Obx(() {
          final groupedWarranty = _getController.warrantyModel.value.result != null &&
              _getController.warrantyModel.value.result!.isNotEmpty
              ? _getController.warrantyModel.value.result!.fold<Map<String, List<dynamic>>>({}, (grouped, warranty) {
                String formattedDate = DateFormat('dd.MM.yyyy').format(
                  DateTime.parse(warranty.warrantyStart.toString()),
                );
                grouped.putIfAbsent(formattedDate, () => []).add(warranty);
                return grouped;
              }
          ) : {};
          return Column(
            children: [
              SizedBox(height: Get.height * 0.01),
              SearchTextField(color: Colors.grey.withOpacity(0.2), onChanged: _onSearch, controller: _getController.archiveSearchController),
              if (_getController.warrantyModel.value.result != null && _getController.warrantyModel.value.result!.isNotEmpty)
                Container(
                    width: Get.width,
                    margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: groupedWarranty.keys.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          String dateKey = groupedWarranty.keys.elementAt(index);
                          List<dynamic> warrantiesForDate = groupedWarranty[dateKey]!;
                          if (warrantiesForDate.isEmpty) return const SizedBox.shrink();
                          return Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(bottom: 20.h),
                                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.015),
                                    child: TextSmall(text: _getController.getDateFormat(dateKey), color: AppColors.black.withOpacity(0.6), fontWeight: FontWeight.w400)
                                ),
                                ...warrantiesForDate.map((warranty) {
                                  return Container(
                                padding: EdgeInsets.only(left: 15.w, top: 8.h, bottom: 9.h),
                                margin: EdgeInsets.only(bottom: 15.h),
                                width: Get.width,
                                decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.light ? Colors.white : AppColors.black70, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 20.r, spreadRadius: 18.r, offset: const Offset(0, 0))], borderRadius: BorderRadius.circular(18.r)),
                                child: Column(
                                    children: [
                                      Row(
                                          children: [
                                            Container(
                                                margin: EdgeInsets.only(right: 15.w),
                                                width: Get.width * 0.36,
                                                height: Get.height * 0.13,
                                                child: Stack(
                                                    children: [
                                                      Positioned(width: 2, height: Get.height * 0.11, child: Center(child: Container(alignment: Alignment.center, width: 2.w, height: Get.height * 0.09, decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.all(Radius.circular(10.r)), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), blurRadius: 6.r, blurStyle: BlurStyle.outer, spreadRadius: 1.r, offset: const Offset(0, 10))])))),
                                                      Positioned(right: 0, width: 2, height: Get.height * 0.11, child: Center(child: Container(alignment: Alignment.center, width: 2.w, height: Get.height * 0.09, decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.all(Radius.circular(20.r)), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), blurRadius: 6.r, blurStyle: BlurStyle.outer, spreadRadius: 1.r, offset: const Offset(0, 10))])))),
                                                      Positioned.fill(child: Container(decoration: const BoxDecoration(color: AppColors.white), child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(20.r)), child: CacheImage(keys: warranty.id.toString(), url: warranty.photoUrl ?? '', fit: BoxFit.cover))))
                                                    ]
                                                )
                                            ),
                                            Expanded(
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            SizedBox(width: 110.w, child: TextSmall(text: warranty.name.toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)),
                                                            const Spacer(),
                                                            InkWell(onTap: () => InstrumentComponents().deleteWarrantyDialog(context,warranty.id!.toInt()), child: Icon(Icons.delete, color: AppColors.red, size: 20.sp)),
                                                            SizedBox(width: 12.w),
                                                          ]
                                                      ),
                                                      SizedBox(height: 12.h),
                                                      Row(
                                                          children: [
                                                            SizedBox(width: 75.w, child: TextSmall(text: '${'Kategoriya'.tr}:', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp)),
                                                            SizedBox(width: Get.width * 0.225, child: TextSmall(text: _getController.getCategoryName(warranty.categoryId!.toInt()), color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 11.sp))
                                                          ]
                                                      ),
                                                      Row(
                                                          children: [
                                                            SizedBox(width: 75.w, child: TextSmall(text: '${'Qo‘shilgan'.tr}:', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp)),
                                                            SizedBox(width: Get.width * 0.225, child: TextSmall(text: DateFormat('dd.MM.yyyy').format(DateTime.parse(warranty.dateCreated.toString())), color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 11.sp))
                                                          ]
                                                      ),
                                                      Row(
                                                          children: [
                                                            SizedBox(width: 75.w, child: TextSmall(text: '${'Kafolat'.tr}:', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp)),
                                                            SizedBox(width: Get.width * 0.225, child: TextSmall(text: DateFormat('dd.MM.yyyy').format(DateTime.parse(warranty.warrantyExpire.toString())), color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 11.sp))
                                                          ]
                                                      ),
                                                      SizedBox(height: 6.h),
                                                      Row(
                                                          children: [
                                                            Container(
                                                                width: 80.w,
                                                                padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                                                decoration: BoxDecoration(color: DateTime.now().isAfter(DateTime.parse(_getController.warrantyModel.value.result![index].warrantyExpire.toString())) ? AppColors.red : AppColors.green, borderRadius: BorderRadius.circular(11.r)),
                                                                child: Center(child: TextSmall(text:DateTime.now().isAfter(DateTime.parse(_getController.warrantyModel.value.result![index].warrantyExpire.toString())) ? 'Faol emas'.tr : 'Faol'.tr, color: DateTime.now().isAfter(DateTime.parse(_getController.warrantyModel.value.result![index].warrantyExpire.toString())) ? AppColors.white : AppColors.white, fontSize: 11.sp))
                                                            ),
                                                            const Spacer(),
                                                            InkWell(onTap: () => ApiController().archiveWarrantyProduct(warranty.id!.toInt(), isArchived: false), child: Icon(EneftyIcons.archive_minus_bold, color: index == 1 ? AppColors.black70 : AppColors.black70, size: 21.sp)),
                                                            SizedBox(width: 11.w)
                                                          ]
                                                      )
                                                    ]
                                                )
                                            )
                                          ]
                                      )
                                    ]
                                )
                            );
                                })
                              ]
                          );
                        }
                    )
                )
              else if (_getController.warrantyModel.value.result == null)
                const GuaranteeSkeleton()
              else
                const EmptyComponent()
            ]
          );
        })
      )
    );
  }
}
