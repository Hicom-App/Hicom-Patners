import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/partners/views/partners_detail_view.dart';
import 'package:latlong2/latlong.dart';
import '../../../companents/custom_app_bar.dart';
import '../../../companents/filds/search_text_field.dart';
import '../../../companents/filds/text_small.dart';
import '../../../companents/utils/responsive.dart';
import '../../../controllers/api_controller.dart';
import '../../../controllers/get_controller.dart';
import '../../../models/sample/partner_model.dart';
import '../../../models/sample/partner_models.dart';
import '../../../resource/colors.dart';
import '../controllers/partners_controller.dart';
import '../widgets/partner_card.dart';


class PartnersView extends GetView<PartnersController> {
  PartnersView({super.key});

  final GetController _getController = Get.put(GetController());


  void _showPartnerDialog(BuildContext context, dynamic partner, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final todayWorkingDay = controller.getTodayWorkingDay(partner.workingDays);
        final bool isOpenToday = todayWorkingDay?.isOpen == 1;
        final Color statusColor = todayWorkingDay != null ? (isOpenToday ? AppColors.green : AppColors.red) : AppColors.red;
        final String statusText = todayWorkingDay != null ? (isOpenToday ? 'Ochiq'.tr : 'Yopiq'.tr) : 'Yopiq'.tr;
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                width: 40.sp,
                height: 40.sp,
                decoration: BoxDecoration(color: AppColors.blue.withAlpha(50), borderRadius: BorderRadius.circular(8)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _getController.partnerModels.value.result![index].photoUrl.toString(),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(EneftyIcons.shop_bold, size: 20.sp, color: AppColors.blue)
                  )
                )
              ),
              const SizedBox(width: 12),
              Expanded(child: TextSmall(text: partner.name ?? 'Noma’lum do‘kon', fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.black)),
              IconButton(icon: Icon(Icons.close, size: 20.sp, color: AppColors.black70), onPressed: () => Navigator.pop(context))
            ]
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16.sp, color: AppColors.black70),
                    SizedBox(width: 8.w),
                    SizedBox(width: Get.size.width * 0.6, child: TextSmall(text: '${'Taxminan'.tr} ${_getController.partnerModels.value.result![index].distance} ${'uzoqlikda'.tr}', fontSize: 14.sp, color: AppColors.black70, overflow: TextOverflow.ellipsis, maxLines: 2))
                  ]
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16.sp, color: statusColor),
                    SizedBox(width: 8.w),
                    TextSmall(text: statusText, fontSize: 14.sp, color: statusColor, fontWeight: FontWeight.w500),
                  ]
                ),
                SizedBox(height: 8.h),
                TextSmall(text: partner.description ?? '', fontSize: 14.sp, color: AppColors.black70, overflow: TextOverflow.ellipsis, maxLines: 10),
              ]
            )
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.to(() => PartnersDetailView(index, partner.workingDays != null && partner.workingDays!.length > controller.currentWeekday ?  partner.workingDays![controller.currentWeekday].isOpen == 1 ? 'Ochiq' : 'Yopiq' : '-', ));
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: TextSmall(text: 'To‘liq ma’lumot'.tr, fontSize: 14, color: Colors.white)
            )
          ]
        );
      }
    );
  }

  void _showStyledMapMenu(BuildContext context) {
    showMenu<dynamic>(  // <dynamic> qo'shildi – tur mosligini ta'minlash uchun
      context: context,
      color: AppColors.white,
      position: RelativeRect.fromLTRB(16.h, 350.sp, 0, 0),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: <PopupMenuEntry<dynamic>>[  // Ro'yxatni explicit tip bilan belgilash
        PopupMenuItem(
          value: false,
          enabled: true,
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(color: AppColors.blue.withAlpha(30), shape: BoxShape.circle),
                child: Icon(Icons.map, color: AppColors.blue, size: 24.sp)
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextSmall(text: 'Sxema'.tr, fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
                    TextSmall(text: 'Oddiy ko‘cha xaritasi'.tr, fontSize: 12, color: AppColors.black70)
                  ]
                )
              ),
              if (!controller.isHybridStyle) Icon(Icons.circle, color: AppColors.blue, size: 14.sp)
            ]
          )
        ),
        PopupMenuDivider(height: 1.h, color: AppColors.greys),
        PopupMenuItem(
          value: true,
          enabled: true,
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(color: AppColors.blue.withAlpha(30), shape: BoxShape.circle),
                child: Icon(Icons.satellite, color: AppColors.blue, size: 24.sp)
              ),
              SizedBox(width: 12.w),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextSmall(text:'Giprit', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.black),
                    TextSmall(text:'Sun’iy yo‘ldosh + ko‘chalar', fontSize: 12, color: AppColors.black70)
                  ]
                )
              ),
              if (controller.isHybridStyle) Icon(Icons.circle, color: AppColors.blue, size: 14.sp)
            ]
          )
        )
      ]
    ).then((value) {
      if (value != null) {
        controller.changeMapStyle(value);  // Bool qiymatni uzatish
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PartnersController>()) {Get.lazyPut(() => PartnersController());}
    return Obx(() => Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: CustomAppBar(title: 'Hamkorlar'.tr, subtitle: 'Yaqin atrofdagi dokonlar'.tr, isBack: false, isCenter: false, icon: controller.viewMode == ViewMode.list ? EneftyIcons.map_bold : LucideIcons.list, suffixOnTap: () {controller.toggleViewMode();}, titleSize: 24.sp, subtitleSize: 15.sp),
        body: Obx(() => controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : controller.viewMode == ViewMode.list
            ? _buildListViewFullPage(context, controller.setSearchQuery)
            : _buildMapView(context)
        )
    ));
  }

  Widget _buildListViewFullPage(BuildContext context, Function(String) setSearchQuery) {
    return Stack(
      children: [
        SingleChildScrollView(
            controller: controller.scrollController,  // Controller dan oling
            child: Column(
                children: [
                  const SizedBox(height: 16),
                  SearchTextField(controller: _getController.searchController, color: AppColors.greys.withAlpha(150), onChanged: (value) => setSearchQuery(value)),
                  const SizedBox(height: 16),
                  const SearchAndFilters(),
                  Container(
                      height: _getController.partnerModels.value.result != null && _getController.partnerModels.value.result!.isNotEmpty ? null : Get.height * 0.6,
                      padding: const EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 100.sp, top: 10),
                      child: _getController.partnerModels.value.result != null && _getController.partnerModels.value.result!.isNotEmpty
                          ? Column(children: _getController.partnerModels.value.result!.asMap().entries.map((entry) => PartnerCards(partner: _getController.partnerModels.value, index: entry.key, isNearest: entry.value == controller.nearest)).toList())
                          : Center(child: TextSmall(text: 'Ma’lumotlar yo‘q'.tr, color: AppColors.black70, fontWeight: FontWeight.bold)
                      )
                  )
                ]
            )
        ),
        Obx(() => AnimatedPositioned(
          bottom: 100,
          right: 20,
          duration: const Duration(milliseconds: 300),
          child: Visibility(
            visible: controller.showScrollToTop.value,  // Controller dan oling
            child: FloatingActionButton(
              shape: const CircleBorder(),
              mini: true,
              onPressed: () => controller.scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
              backgroundColor: AppColors.blue,
              child: Icon(Icons.arrow_upward, color: AppColors.white, size: 20.sp)
            )
          )
        ))
      ]
    );
  }

  Widget _buildMapView(BuildContext context) =>
      Stack(
          children: [
            SizedBox(
                width: Get.width,
                height: Get.height * 0.8,
                child: FlutterMap(
                    mapController: controller.animatedMapController.mapController,
                    options: MapOptions(
                        initialCenter: controller.selectedLocation.value,
                        initialZoom: controller.currentZoom.value,
                        onPositionChanged: (position, bool hasGesture) {
                          controller.selectedLocation.value = position.center;
                          controller.currentZoom.value = position.zoom;
                          },
                        onMapReady: () {
                          controller.isMapReady.value = true;
                          controller.getCurrentLocation();
                        }),
                    children: [
                      if (controller.isHybridStyle)
                        TileLayer(urlTemplate: 'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', userAgentPackageName: 'partner.hicom.uz'),
                      if (controller.isHybridStyle)
                        TileLayer(urlTemplate: 'https://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Transportation/MapServer/tile/{z}/{y}/{x}', userAgentPackageName: 'partner.hicom.uz'),
                      if (controller.isHybridStyle)
                        TileLayer(urlTemplate: 'https://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}', userAgentPackageName: 'partner.hicom.uz'),
                      if (!controller.isHybridStyle)
                        TileLayer(urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c'], userAgentPackageName: 'partner.hicom.uz'),
                      Obx(() {
                        final result = _getController.partnerModels.value.result;
                        final shopMarkers = <Marker>[];
                        if (result != null && result.isNotEmpty) {
                          for (var entry in result.asMap().entries) {
                            final partner = entry.value;
                            final index = entry.key;
                            if (partner.lat == null || partner.lng == null || partner.name == null) {
                              continue;
                            }
                            final point = LatLng(partner.lng!.toDouble(), partner.lat!.toDouble());
                            shopMarkers.add(
                                Marker(
                                    width: 30.0,
                                    height: 30.0,
                                    point: point,
                                    child: GestureDetector(
                                        onTap: () {
                                          //controller.updateLocation(point);
                                          _showPartnerDialog(context, partner, index);
                                          },
                                        child: Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(color:AppColors.greys, borderRadius: BorderRadius.circular(8)),
                                            child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Icon(EneftyIcons.shop_bold, size: 32.sp, color: AppColors.blue))
                                        )
                                    )
                                )
                            );
                          }
                          print('Qoshilgan markerlar soni: ${shopMarkers.length}'); // Debug
                        }
                        return MarkerLayer(
                            markers: [
                              if (controller.currentLocation.value.latitude != 0.0 && controller.currentLocation.value.longitude != 0.0)
                                Marker(
                                    width: 20.0,
                                    height: 20.0,
                                    point: controller.currentLocation.value,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.blue,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                            boxShadow: [BoxShadow(color: AppColors.grey.withAlpha(400), spreadRadius: 10, blurRadius: 1)]
                                        )
                                    )
                                ),
                              ...shopMarkers
                            ]
                        );
                      })
                    ]
                )
            ),
            Obx(() => Container(width: Get.width, height: 135.h, padding: const EdgeInsets.all(16), child: NearestPartnerCard(partner: _getController.partnerModels.value))),
            Positioned(
                right: 16.h,
                bottom: 100,
                child: Column(
                    children: [
                      IconButton(
                          icon: Icon(LucideIcons.plus, color: AppColors.white, size: Responsive.scaleFont(18, context)),
                          onPressed: () => controller.zoomIn(),
                          style: IconButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.cardRadius)))
                      ),
                      const SizedBox(height: AppDimensions.paddingSmall),
                      IconButton(
                          icon: Icon(LucideIcons.minus, color: AppColors.white, size: Responsive.scaleFont(18, context)),
                          onPressed: () => controller.zoomOut(),
                          style: IconButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.cardRadius)))
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      IconButton(
                          style: IconButton.styleFrom(backgroundColor: AppColors.blue, shape: const CircleBorder()),
                          icon: Icon(LucideIcons.locate, color: AppColors.white,size: 24.0.sp),
                          tooltip: 'Joriy joylashuvni aniqlash'.tr,
                          onPressed: () async {
                            await controller.getCurrentLocation();
                          })
                    ]
                )
            ),
            Positioned(
                right: 16.h,
                top: 140,
                child: Column(
                    children: [
                      IconButton(
                          icon: Icon(LucideIcons.layers_2, color: AppColors.white, size: Responsive.scaleFont(24, context)),
                          onPressed: () {_showStyledMapMenu(context);},
                          style: IconButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.cardRadius)))
                      )
                    ]
                )
            )
          ]
      );
}


class NearestPartnerCard extends GetView<PartnersController> {
  final PartnerModels partner;

  NearestPartnerCard({super.key, required this.partner});

  final GetController _getController = Get.put(GetController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final todayWorkingDay = controller.getTodayWorkingDay(controller.nearest?.workingDays);
      final bool isOpenToday = todayWorkingDay?.isOpen == 1;
      final Color statusColor = todayWorkingDay != null ? (isOpenToday ? AppColors.green : AppColors.red) : AppColors.red;
      final String statusText = todayWorkingDay != null ? (isOpenToday ? 'Ochiq'.tr : 'Yopiq'.tr) : 'Yopiq'.tr;

      final nearest = controller.nearest;
      if (nearest == null) {
        return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)), child: const Center(child: CircularProgressIndicator()));
      }
      return InkWell(
        onTap: () => Get.to(() => PartnersDetailView(_getController.partnerModels.value.result!.indexOf(nearest), nearest.workingDays != null && nearest.workingDays!.length > controller.currentWeekday ?  nearest.workingDays![controller.currentWeekday].isOpen == 1 ? 'Ochiq'.tr : 'Yopiq'.tr : '-', )),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.white, border: Border.all(color: Colors.blue[200]!), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Container(width: 45, height: 45, decoration: BoxDecoration(color: Colors.blue[100], borderRadius: BorderRadius.circular(8)), child: Center(child: Icon(LucideIcons.globe, size: 25, color: Colors.blue[600]))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.navigation, size: 16, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        TextSmall(text: 'Eng yaqin do‘kon'.tr, fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.blue)
                      ]
                    ),
                    TextSmall(text: nearest.name ?? 'Noma’lum do‘kon'.tr, fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                    Row(
                        children: [
                          Icon(Icons.location_on, size: 16.sp, color: AppColors.black70),
                          SizedBox(width: 4.w),
                          TextSmall(text: '${nearest.distance} ${'uzoqlikda'.tr}', fontSize: 14, color: AppColors.greys2),
                          SizedBox(width: 16.w),
                          Icon(Icons.access_time, size: 16.sp, color: statusColor),
                          SizedBox(width: 4.w),
                          Expanded(child:  TextSmall(text: statusText, fontSize: 14.sp, color: statusColor, overflow: TextOverflow.ellipsis),)
                        ]
                    )
                  ]
                )
              ),
              Icon(Icons.chevron_right, color: AppColors.blue, size: 20.sp)
            ]
          )
        )
      );
    });
  }
}

// Search and Filters Widget
class SearchAndFilters extends GetView<PartnersController> {
  const SearchAndFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Barchasi filter
          Obx(() => GestureDetector(
              onTap: () => controller.setCategory('Barchasi'),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: controller.selectedCategory == 'Barchasi' && !controller.showOnlyOpen && !controller.sortByRating && controller.sortBy == 'distance' && controller.selectedCountry.isEmpty && controller.selectedRegion.isEmpty && controller.selectedDistrict.isEmpty ? AppColors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                      color: controller.selectedCategory == 'Barchasi' && !controller.showOnlyOpen && !controller.sortByRating && controller.sortBy == 'distance' && controller.selectedCountry.isEmpty && controller.selectedRegion.isEmpty && controller.selectedDistrict.isEmpty ? AppColors.blue : Colors.grey[200]),
                  child: TextSmall(text: 'Barchasi'.tr, fontSize: 14.sp, fontWeight: FontWeight.w500, color: controller.selectedCategory == 'Barchasi' && !controller.showOnlyOpen && !controller.sortByRating && controller.sortBy == 'distance' && controller.selectedCountry.isEmpty && controller.selectedRegion.isEmpty && controller.selectedDistrict.isEmpty ? AppColors.white : AppColors.black))
          )),
          Obx(() => GestureDetector(
              onTap: () => controller.toggleShowOnlyOpen(),  // Filter/sort chaqirish
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: controller.showOnlyOpen ? AppColors.blue : Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: controller.showOnlyOpen ? AppColors.blue : Colors.grey[200],  // Active holatda ko'k rang
                  ),
                  child: Row(
                      children: [
                        Icon(EneftyIcons.clock_2_bold, size: 16, color: controller.showOnlyOpen ? AppColors.white : AppColors.black),
                        const SizedBox(width: 8),
                        TextSmall(text: 'Ochiq'.tr, fontSize: 14.sp, fontWeight: FontWeight.w500, color: controller.showOnlyOpen ? AppColors.white : AppColors.black)
                      ]
                  )
              )
          )),
          // Reyting filter
          Obx(() => GestureDetector(
            onTap: () => controller.toggleSortByRating(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: controller.sortByRating ? AppColors.blue : Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  color: controller.sortByRating ? AppColors.blue : Colors.grey[200]
              ),
              child: Row(
                children: [
                  Icon(EneftyIcons.arrow_3_bold, size: 16, color: controller.sortByRating ? AppColors.white : AppColors.black),
                  const SizedBox(width: 8),
                  TextSmall(text: 'Reyting'.tr, fontSize: 14.sp, fontWeight: FontWeight.w500, color: controller.sortByRating ? AppColors.white : AppColors.black)
                ]
              )
            )
          )),
          // Filter menu
          Obx(() => GestureDetector(
            onTap: () => _showFilterDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(border: Border.all(color: controller.isFiltersApplied ? AppColors.blue : Colors.grey), borderRadius: BorderRadius.circular(12), color: controller.isFiltersApplied ? AppColors.blue : Colors.grey[200]),
              child: Row(
                children: [
                  Icon(EneftyIcons.filter_bold, size: 16, color: controller.isFiltersApplied ? AppColors.white : AppColors.black),
                  const SizedBox(width: 8),
                  TextSmall(text: 'Filter'.tr, fontSize: 14.sp, fontWeight: FontWeight.w500, color: controller.isFiltersApplied ? AppColors.white : AppColors.black)
                ]
              )
            )
          ))
        ]
      )
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8, // Soya qo'shish
            backgroundColor: Colors.white,
            child: Container(
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, maxHeight: MediaQuery.of(context).size.height * 0.6),
                padding: const EdgeInsets.all(24),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextSmall(text: 'Filter va saralash', fontSize: 20.sp, fontWeight: FontWeight.w700),
                            IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close, color: Colors.grey[600]))
                          ]
                      ),
                      SizedBox(height: 16, width: Get.width),
                      // Content
                      Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFilterSection('Davlat', _buildCountryFilter()),
                                    const SizedBox(height: 24),
                                    _buildFilterSection('Viloyat', _buildRegionFilter()),
                                    const SizedBox(height: 24),
                                    Obx(() => controller.selectedRegion.isNotEmpty && controller.districts.isNotEmpty ? _buildFilterSection('Tuman', _buildDistrictFilter()) : const SizedBox.shrink()),
                                    Obx(() => controller.selectedRegion.isNotEmpty && controller.districts.isNotEmpty ? const SizedBox(height: 24) : const SizedBox.shrink()),
                                    const SizedBox(height: 32)
                                  ]
                              )
                          )
                      ),
                      // Button
                      Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Har doim o'rtada
                          children: [
                            Container(
                                decoration: BoxDecoration(color: controller.isFiltersApplied ? AppColors.blue : Colors.grey[200],borderRadius: BorderRadius.circular(12)),
                                child: ElevatedButton(
                                    onPressed: controller.isFiltersApplied ? () {
                                      controller.clearAllFilters();
                                      Get.back();
                                    } : null, // Disabled holatda onPressed null
                                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32), backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                    child: TextSmall(text: 'Tozalash', fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white)
                                )
                            )
                          ]
                      )),
                      const SizedBox(height: 16)
                    ]
                )
            )
        )
    );
  }

  Widget _buildCountryFilter() {
    return Obx(() => Container(
      width: double.infinity,
      height: 50.h,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(12), color: Colors.grey[50]),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            menuMaxHeight: 250.h,
            value: controller.selectedCountry.isEmpty ? null : controller.selectedCountry,
            dropdownColor: AppColors.white,
            focusColor: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            elevation: 6,
            hint: Row(children: [Icon(Icons.public, size: 20.sp, color: AppColors.black70), const SizedBox(width: 8), TextSmall(text: 'Davlatni tanlang', fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColors.black70)]),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down, color: AppColors.blue, size: 20.sp),
            items: controller.countries.map((country) => DropdownMenuItem<String>(value: country == 'Barcha davlatlar' ? '' : country, child: TextSmall(text: country, fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColors.black))).toList(),
            onChanged: (value) => controller.setCountry(value ?? '')
        )
      )
    ));
  }


  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSmall(text: title, fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.black70),
        const SizedBox(height: 12),
        content
      ]
    );
  }

  Widget _buildRegionFilter() {
    return Obx(() => Column(
      children: [
        Container(
          width: double.infinity,
          height: 50.h,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                menuMaxHeight: 250.h,
                value: controller.selectedRegion.isEmpty ? null : controller.selectedRegion,
                hint: TextSmall(text: 'Viloyatni tanlang', fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColors.black70, maxLines: 1, overflow: TextOverflow.ellipsis),
                isExpanded: true,
                dropdownColor: AppColors.white,
                focusColor: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                elevation: 6,
                items: [
                  DropdownMenuItem<String>(value: '', child: TextSmall(text: 'Barcha viloyatlar', fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColors.black70, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ...controller.regions.map((region) {return DropdownMenuItem<String>(value: region, child: TextSmall(text: region, fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColors.black, maxLines: 1, overflow: TextOverflow.ellipsis));})
                ],
                onChanged: (value) {
                  print(value.toString());
                  controller.setRegion(value.toString());
              }
            )
          )
        )
      ]
    ));
  }

  Widget _buildDistrictFilter() {
    return Container(
      width: double.infinity,
      height: 50.h,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
              menuMaxHeight: 250.h,
              value: controller.selectedDistrict.isEmpty ? null : controller.selectedDistrict,
              hint: TextSmall(text: 'Tumanni tanlang', fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColors.black70, maxLines: 1, overflow: TextOverflow.ellipsis),
              dropdownColor: AppColors.white,
              focusColor: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              elevation: 6,
              isExpanded: true,
              items: [
                DropdownMenuItem<String>(value: '', child: TextSmall(text: 'Barcha tumanlar', fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColors.black70, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ...controller.districts.map((district) => DropdownMenuItem<String>(value: district, child: TextSmall(text: district, fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColors.black, maxLines: 1, overflow: TextOverflow.ellipsis)))
              ],
              onChanged: (value) => controller.setDistrict(value ?? '')
          )
      )
    );
  }
}