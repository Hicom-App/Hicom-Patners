/*
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import '../../companents/custom_app_bar.dart';
import '../../companents/filds/search_text_field.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/home/chashe_image.dart';
import '../../companents/home/empty_component.dart';
import '../../companents/refresh_component.dart';
import '../../companents/skletons/guarantee_skeleton.dart';
import '../../controllers/get_controller.dart';

class GuaranteePage extends StatefulWidget {
  const GuaranteePage({super.key});

  @override
  State<GuaranteePage> createState() => _GuaranteePageState();
}

class _GuaranteePageState extends State<GuaranteePage> {
  final GetController _getController = Get.find<GetController>();
  late RefreshController _localRefreshController;
  late ScrollController _localScrollController;

  @override
  void initState() {
    super.initState();
    _localRefreshController = RefreshController(initialRefresh: false);
    _localScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  @override
  void dispose() {
    _localRefreshController.dispose();
    _localScrollController.dispose();
    // Key ni tozalash – duplicate oldini olish uchun
    if (_getController.warrantyId.value != null) {
      _getController.warrantyKeys.remove(_getController.warrantyId.value);
      _getController.hasScrolledToId.value = false;
    }
    super.dispose();
  }

  void getData() {
    _getController.clearWarrantyModel();
    _getController.clearSortedWarrantyModel();
    ApiController().getWarrantyProducts(filter: 'c.active=1');
    _localRefreshController.refreshCompleted();
    _localRefreshController.loadComplete();
    if (_getController.guaranteeSearchController.text.isNotEmpty) {
      _getController.guaranteeSearchController.clear();
    }
  }

  String getMonth(String date) => const {"01": "yan", "02": "fev", "03": "mar", "04": "ap", "05": "may", "06": "iyn", "07": "iyl", "08": "avg", "09": "sen", "10": "okt", "11": "noy", "12": "dek"}[date] ?? "";

  @override
  Widget build(BuildContext context) {
    print('================================================================${_getController.warrantyId.value}================================================================');
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
      appBar: CustomAppBar(title: 'Kafolat Muddatlari'.tr, isBack: true, isCenter: true),
      body: RefreshComponent(
        refreshController: _localRefreshController,
        scrollController: _localScrollController,
        color: AppColors.black,
        onRefresh: () => getData(),
        child: Obx(() {
          final sortedWarrantyList = _getController.warrantyModel.value.result != null && _getController.warrantyModel.value.result!.isNotEmpty
              ? List.from(_getController.warrantyModel.value.result!)
              : [];
          sortedWarrantyList.sort((a, b) => DateTime.parse(a.dateCreated.toString()).compareTo(DateTime.parse(b.dateCreated.toString())));
          final groupedWarranty = _getController.warrantyModel.value.result != null && _getController.warrantyModel.value.result!.isNotEmpty
              ? _getController.warrantyModel.value.result!.fold<Map<String, List<dynamic>>>({}, (grouped, warranty) {
            String formattedDate = DateFormat('dd.MM.yyyy').format(DateTime.parse(warranty.warrantyStart.toString()));
            if (!grouped.containsKey(formattedDate)) {
              grouped[formattedDate] = [];
            }
            grouped[formattedDate]!.add(warranty);
            return grouped;
          })
              : {};
          // Scroll logic – Key ni faqat bir marta yaratish
          if (_getController.warrantyId.value != null && !_getController.hasScrolledToId.value && _getController.warrantyModel.value.result != null && _getController.warrantyModel.value.result!.isNotEmpty) {
            final targetWarranty = sortedWarrantyList.firstWhereOrNull((warranty) => warranty.id == _getController.warrantyId.value);
            if (targetWarranty != null && !_getController.warrantyKeys.containsKey(_getController.warrantyId.value)) {
              _getController.warrantyKeys[_getController.warrantyId.value!] = GlobalKey();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final keyContext = _getController.warrantyKeys[_getController.warrantyId.value!]?.currentContext;
                if (keyContext != null) {
                  Scrollable.ensureVisible(
                    keyContext,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                  );
                }
                _getController.hasScrolledToId.value = true;
              });
            } else {
              _getController.hasScrolledToId.value = true;
            }
          }

          return Column(
            children: [
              SizedBox(height: Get.height * 0.01),
              SearchTextField(
                color: Colors.grey.withOpacity(0.2),
                onChanged: (value) {
                  if (value.isEmpty) {
                    ApiController().getWarrantyProducts(filter: 'c.active=1');
                  } else if (_getController.guaranteeSearchController.text.isNotEmpty) {
                    ApiController().getWarrantyProducts(filter: 'c.active=1 AND name CONTAINS "${_getController.guaranteeSearchController.text}"');
                  }
                },
                controller: _getController.guaranteeSearchController,
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
                      if (warrantiesForDate.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20.h),
                            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.015),
                            child: TextSmall(
                              text: _getController.getDateFormat(dateKey),
                              color: AppColors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          ...warrantiesForDate.map((warranty) {
                            final key = (_getController.warrantyId.value != null && warranty.id == _getController.warrantyId.value) ? _getController.warrantyKeys[_getController.warrantyId.value!] : null;
                            return GestureDetector(
                              onTap: () => _getController.warrantyId.value = null,
                              child: Container(
                                key: key,
                                padding: EdgeInsets.only(left: 11.w, top: 8.h, bottom: 9.h),
                                margin: EdgeInsets.only(bottom: 15.h),
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.grey.withOpacity(0.15),
                                      blurRadius: 20.r,
                                      spreadRadius: 18.r,
                                      offset: const Offset(0, 0),
                                    ),
                                    if (_getController.warrantyId.value == warranty.id)
                                      BoxShadow(
                                        color: AppColors.black.withAlpha(100),
                                        blurRadius: 15.r,
                                        spreadRadius: 1.r,
                                        offset: const Offset(0, 4),
                                      ),
                                  ],
                                  borderRadius: BorderRadius.circular(18.r),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 15.w),
                                          width: Get.width * 0.36,
                                          height: Get.height * 0.13,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(20.r)),
                                            child: CacheImage(
                                              keys: warranty.id.toString(),
                                              url: warranty.photoUrl ?? '',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    child: TextSmall(
                                                      text: warranty.name.toString(),
                                                      color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18.sp,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (mounted) {  // Yangi: Mounted check – dispose dan keyin xato oldini olish
                                                        InstrumentComponents().deleteWarrantyDialog(context, warranty.id!.toInt());
                                                      }
                                                    },
                                                    child: Icon(Icons.delete, color: AppColors.red, size: 24.sp),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                ],
                                              ),
                                              SizedBox(height: 12.h),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 75.w,
                                                    child: TextSmall(
                                                      text: '${'Kategoriya'.tr}:',
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 11.sp,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.225,
                                                    child: TextSmall(
                                                      text: _getController.getCategoryName(warranty.categoryId),
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 11.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 75.w,
                                                    child: TextSmall(
                                                      text: '${'Qo‘shilgan'.tr}:',
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 11.sp,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.225,
                                                    child: TextSmall(
                                                      text: DateFormat('dd.MM.yyyy').format(DateTime.parse(warranty.dateCreated.toString())),
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 11.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 75.w,
                                                    child: TextSmall(
                                                      text: '${'Kafolat'.tr}:',
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 11.sp,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.225,
                                                    child: TextSmall(
                                                      text: DateFormat('dd.MM.yyyy').format(DateTime.parse(warranty.warrantyExpire.toString())),
                                                      color: AppColors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 11.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 6.h),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 80.w,
                                                    padding: const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                                                    decoration: BoxDecoration(
                                                      color: DateTime.now().isAfter(DateTime.parse(warranty.warrantyExpire.toString())) ? AppColors.red : AppColors.green,
                                                      borderRadius: BorderRadius.circular(11.r),
                                                    ),
                                                    child: Center(
                                                      child: TextSmall(
                                                        text: DateTime.now().isAfter(DateTime.parse(warranty.warrantyExpire.toString())) ? 'Faol emas'.tr : 'Faol'.tr,
                                                        color: DateTime.now().isAfter(DateTime.parse(warranty.warrantyExpire.toString())) ? AppColors.white : AppColors.white,
                                                        fontSize: 11.sp,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (mounted) {  // Yangi: Mounted check – dispose dan keyin xato oldini olish
                                                        InstrumentComponents().archiveWarrantyDialog(context, warranty.id!.toInt());
                                                      }
                                                    },
                                                    child: Icon(EneftyIcons.archive_add_bold, color: AppColors.black70, size: 23.sp),
                                                  ),
                                                  SizedBox(width: 14.w),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            );
                          }),
                        ],
                      );
                    },
                  ),
                )
              else if (_getController.warrantyModel.value.result == null)
                const GuaranteeSkeleton()
              else
                const EmptyComponent(),
            ],
          );
        }),
      ),
    );
  }
}*/




import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:intl/intl.dart';
import '../../companents/custom_app_bar.dart';
import '../../companents/filds/search_text_field.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/home/chashe_image.dart';
import '../../companents/home/empty_component.dart';
import '../../companents/refresh_component.dart';
import '../../companents/skletons/guarantee_skeleton.dart';
import '../../controllers/get_controller.dart';

class GuaranteePage extends StatefulWidget {
  const GuaranteePage({super.key});

  @override
  State<GuaranteePage> createState() => _GuaranteePageState();
}

class _GuaranteePageState extends State<GuaranteePage> {
  final GetController _getController = Get.find<GetController>();
  late RefreshController _localRefreshController;
  late ScrollController _localScrollController;

  @override
  void initState() {
    super.initState();
    _localRefreshController = RefreshController(initialRefresh: false);
    _localScrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  @override
  void dispose() {
    _localRefreshController.dispose();
    _localScrollController.dispose();
    if (_getController.warrantyId.value != null) {
      _getController.warrantyKeys.remove(_getController.warrantyId.value);
      _getController.hasScrolledToId.value = false;
    }
    super.dispose();
  }

  void getData() {
    _getController.clearWarrantyModel();
    _getController.clearSortedWarrantyModel();
    ApiController().getWarrantyProducts(filter: 'c.active=1');
    _localRefreshController.refreshCompleted();
    _localRefreshController.loadComplete();
    if (_getController.guaranteeSearchController.text.isNotEmpty) {
      _getController.guaranteeSearchController.clear();
    }
  }

  String getMonth(String date) => const {"01": "yan", "02": "fev", "03": "mar", "04": "ap", "05": "may", "06": "iyn", "07": "iyl", "08": "avg", "09": "sen", "10": "okt", "11": "noy", "12": "dek"}[date] ?? "";

  @override
  Widget build(BuildContext context) {
    //print('================================================================${_getController.warrantyId.value}================================================================');
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
      appBar: CustomAppBar(title: 'Kafolat Muddatlari'.tr, isBack: true, isCenter: true),
      body: RefreshComponent(
        refreshController: _localRefreshController,
        scrollController: _localScrollController,
        color: AppColors.black,
        onRefresh: () => getData(),
        child: Obx(() {
          final sortedWarrantyList = _getController.warrantyModel.value.result != null && _getController.warrantyModel.value.result!.isNotEmpty
              ? List.from(_getController.warrantyModel.value.result!)
              : [];
          sortedWarrantyList.sort((a, b) => DateTime.parse(a.dateCreated.toString()).compareTo(DateTime.parse(b.dateCreated.toString())));
          final groupedWarranty = _getController.warrantyModel.value.result != null && _getController.warrantyModel.value.result!.isNotEmpty
              ? _getController.warrantyModel.value.result!.fold<Map<String, List<dynamic>>>({}, (grouped, warranty) {
            String formattedDate = DateFormat('dd.MM.yyyy').format(DateTime.parse(warranty.warrantyStart.toString()));
            if (!grouped.containsKey(formattedDate)) {
              grouped[formattedDate] = [];
            }
            grouped[formattedDate]!.add(warranty);
            return grouped;
          })
              : {};
          // Scroll logic – Key ni faqat bir marta yaratish
          if (_getController.warrantyId.value != null && !_getController.hasScrolledToId.value && _getController.warrantyModel.value.result != null && _getController.warrantyModel.value.result!.isNotEmpty) {
            final targetWarranty = sortedWarrantyList.firstWhereOrNull((warranty) => warranty.id == _getController.warrantyId.value);
            if (targetWarranty != null && !_getController.warrantyKeys.containsKey(_getController.warrantyId.value)) {
              _getController.warrantyKeys[_getController.warrantyId.value!] = GlobalKey();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final keyContext = _getController.warrantyKeys[_getController.warrantyId.value!]?.currentContext;
                if (keyContext != null) {
                  Scrollable.ensureVisible(keyContext, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut, alignment: 0.4);
                }
                _getController.hasScrolledToId.value = true;
              });
            } else {
              _getController.hasScrolledToId.value = true;
            }
          }

          return Column(
            children: [
              SizedBox(height: Get.height * 0.01),
              SearchTextField(
                color: AppColors.greys.withAlpha(150),
                onChanged: (value) {
                  if (value.isEmpty) {
                    ApiController().getWarrantyProducts(filter: 'c.active=1');
                  } else if (_getController.guaranteeSearchController.text.isNotEmpty) {
                    ApiController().getWarrantyProducts(filter: 'c.active=1 AND name CONTAINS "${_getController.guaranteeSearchController.text}"');
                  }
                },
                controller: _getController.guaranteeSearchController
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
                      if (warrantiesForDate.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20.h),
                            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.015),
                            child: TextSmall(text: _getController.getDateFormat(dateKey), color: AppColors.black70, fontWeight: FontWeight.w400)
                          ),
                          ...warrantiesForDate.map((warranty) {
                            final key = (_getController.warrantyId.value != null && warranty.id == _getController.warrantyId.value) ? _getController.warrantyKeys[_getController.warrantyId.value!] : null;
                            return GestureDetector(
                                onTap: () => _getController.warrantyId.value = null,
                                child: Container(
                                  key: key,
                                  padding: EdgeInsets.only(left: 11.w, top: 8.h, bottom: 9.h),
                                  margin: EdgeInsets.only(bottom: 15.h),
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(color: AppColors.grey.withAlpha(30), blurRadius: 20.r, spreadRadius: 18.r, offset: const Offset(0, 0)),
                                      if (_getController.warrantyId.value == warranty.id)
                                        BoxShadow(color: AppColors.black.withAlpha(100), blurRadius: 15.r, spreadRadius: 1.r, offset: const Offset(0, 4))
                                    ],
                                    borderRadius: BorderRadius.circular(18.r)
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(right: 15.w),
                                            width: Get.width * 0.36,
                                            height: Get.height * 0.13,
                                            child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(20.r)), child: CacheImage(keys: warranty.id.toString(), url: warranty.photoUrl ?? '', fit: BoxFit.cover))
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Flexible(child: TextSmall(text: warranty.name.toString(), color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 18.sp, maxLines: 1, overflow: TextOverflow.ellipsis)),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (mounted) {  // Yangi: Mounted check – dispose dan keyin xato oldini olish
                                                          InstrumentComponents().deleteWarrantyDialog(context, warranty.id!.toInt());
                                                        }
                                                      },
                                                      child: Icon(Icons.delete, color: AppColors.red, size: 24.sp),
                                                    ),
                                                    SizedBox(width: 10.w)
                                                  ]
                                                ),
                                                SizedBox(height: 12.h),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 75.w, child: TextSmall(text: '${'Kategoriya'.tr}:', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp)),
                                                    SizedBox(width: Get.width * 0.225, child: TextSmall(text: _getController.getCategoryName(warranty.categoryId), color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 11.sp))
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
                                                      decoration: BoxDecoration(color: DateTime.now().isAfter(DateTime.parse(warranty.warrantyExpire.toString())) ? AppColors.red : AppColors.green, borderRadius: BorderRadius.circular(11.r)),
                                                      child: Center(
                                                        child: TextSmall(
                                                          text: DateTime.now().isAfter(DateTime.parse(warranty.warrantyExpire.toString())) ? 'Faol emas'.tr : 'Faol'.tr,
                                                          color: DateTime.now().isAfter(DateTime.parse(warranty.warrantyExpire.toString())) ? AppColors.white : AppColors.white,
                                                          fontSize: 11.sp
                                                        )
                                                      )
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (mounted) {  // Yangi: Mounted check – dispose dan keyin xato oldini olish
                                                          InstrumentComponents().archiveWarrantyDialog(context, warranty.id!.toInt());
                                                        }
                                                      },
                                                      child: Icon(EneftyIcons.archive_add_bold, color: AppColors.black70, size: 23.sp),
                                                    ),
                                                    SizedBox(width: 14.w)
                                                  ]
                                                )
                                              ]
                                            )
                                          )
                                        ]
                                      )
                                    ]
                                  )
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
