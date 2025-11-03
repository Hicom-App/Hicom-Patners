import 'package:enefty_icons/enefty_icons.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' hide Marker;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../companents/filds/text_large.dart';
import '../../../companents/filds/text_small.dart';
import '../../../companents/home/chashe_image.dart';
import '../../../companents/instrument/instrument_components.dart';
import '../../../companents/refresh_component.dart';
import '../../../controllers/get_controller.dart';
import '../../../resource/colors.dart';
import '../controllers/partners_controller.dart';

class PartnersDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PartnersDetailController());
  }
}

class PartnersDetailController extends GetxController {
  final List list = ['Du'.tr, 'Se'.tr, 'Ch'.tr, 'Pa'.tr, 'Ju'.tr, 'Sh'.tr, 'Ya'.tr];

  final galleryIndex = 0.obs;
  final pageController = PageController();


  String formatDistance(int meters) {
    if (meters < 1000) return '${meters.round()} m';
    final km = meters / 1000.0;
    return '${km < 10 ? km.toStringAsFixed(1) : km.toStringAsFixed(0)} km';
  }

  Future<void> callPhone(phone) async {
    final uri = Uri.parse('tel:${phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> openMaps(lat, lng, address) async {
    final url = (lat != null && lng != null)
        ? 'https://www.google.com/maps/search/?api=1&query=$lat,$lng'
        : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void jumpToImage(int i) {
    galleryIndex.value = i;
    pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}


class PartnersDetailView extends GetView<PartnersDetailController> {
  final int index;
  final String magazineStatus;
  PartnersDetailView(this.index, this.magazineStatus, {super.key});

  final GetController _getController = Get.put(GetController());
  final PartnersController _partnersController = Get.put(PartnersController());


  @override
  Widget build(BuildContext context) {
    _getController.fullText.value = true;
    final p = _getController.partnerModels.value.result?[index];


    return Scaffold(
      backgroundColor: AppColors.white,
      body: RefreshComponent(
          refreshController: _getController.refreshPartnerDetailController,
          scrollController: _getController.scrollPartnerDetailController,
          enablePullUp: false,
          onLoading: null,
          color: AppColors.black,
          physics: const ClampingScrollPhysics(),
          child: Obx(() => Column(
              children: [
              SizedBox(
                  height: Get.height * 0.37,
                  width: Get.width,
                  child: Column(
                      children: [
                        SizedBox(
                            width: Get.width,
                            child: AppBar(
                                surfaceTintColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: AppColors.blue,
                                backgroundColor: Colors.grey.shade200,
                                centerTitle: true,
                                elevation: 0,
                                title: TextLarge(text: 'Do‘kon haqida', color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 20.sp)
                            )
                        ),
                        Expanded(
                            child: InkWell(
                                onTap: (){
                                  if (p.photoUrl!.isNotEmpty) {
                                    Get.to(() => Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: PhotoView(
                                            filterQuality: FilterQuality.high,
                                            minScale: PhotoViewComputedScale.contained * 0.8,
                                            maxScale: PhotoViewComputedScale.covered * 1.8,
                                            initialScale: PhotoViewComputedScale.contained,
                                            basePosition: Alignment.center,
                                            imageProvider: NetworkImage(p.photoUrl.toString())
                                        )),
                                        transition: Transition.fadeIn
                                    );
                                  }
                                },
                                child: SizedBox(width: Get.width, child: CacheImage(keys: p!.photoUrl.toString(), url: p.photoUrl.toString(), fit: BoxFit.cover))
                            )
                        )
                      ]
                  )
              ),
              Container(
                  width: Get.width,
                  constraints: BoxConstraints(minHeight: Get.height * 0.63),
                  padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.h),
                  //decoration: BoxDecoration(boxShadow: [BoxShadow(color: AppColors.greys, offset: const Offset(0, -10), blurRadius: 20.r)], color: AppColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r))),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextLarge(text: p.name.toString(), color: AppColors.blue, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 30.sp),
                        SizedBox(height: Get.height * 0.02),
                        Container(
                            width: Get.width,
                            height: 55.h,
                            decoration: BoxDecoration(color: AppColors.greys, borderRadius: BorderRadius.circular(10.r)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextSmall(text: 'Baho', color: AppColors.black70, fontSize: 10.sp),
                                            Row(
                                                children: [
                                                  if(p.rating != 0)
                                                  Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp, size: 15.sp),
                                                  SizedBox(width: Get.width * 0.01),
                                                  TextSmall(text: p.rating == 0 ? '-': p.rating!.toStringAsFixed(1), color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 15)
                                                ]
                                            )
                                          ]
                                      )
                                  ),
                                  const VerticalDivider(color: Colors.grey, thickness: 1, width: 20, indent: 10, endIndent: 10),
                                  Center(
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextSmall(text: 'Holat', color: AppColors.black70, fontSize: 10.sp),
                                            SizedBox(width: Get.width * 0.01),
                                            TextSmall(text: magazineStatus, color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 12.sp),
                                          ]
                                      )
                                  ),
                                  const VerticalDivider(color: Colors.grey, thickness: 1, width: 20, indent: 10, endIndent: 10),
                                  Center(
                                      child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextSmall(text: 'Masofa', color: AppColors.black70, fontSize: 10.sp),
                                            SizedBox(width: Get.width * 0.01),
                                            TextSmall(text: p.distance, color: AppColors.black, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 12.sp),
                                          ]
                                      )
                                  )
                                ]
                            )
                        ),
                        SizedBox(height: Get.height * 0.02),
                        const TextSmall(text: 'Tavsif', color: AppColors.blue, fontWeight: FontWeight.bold),
                        Container(
                            width: Get.width,
                            padding: EdgeInsets.only(top: Get.height * 0.01),
                            child: p.description != ''
                                ? Column(
                                children: [
                                  AnimatedSize(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      child: SizedBox(
                                          height: _getController.fullText.value ? null : 105.h,
                                          child: FadingEdgeScrollView.fromScrollView(
                                              gradientFractionOnEnd: 0.5,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  controller: _getController.scrollControllerOk,
                                                  itemCount: 1,
                                                  itemBuilder: (context, index) {
                                                    final description = p.description;
                                                    return Html(data: description ?? '-', style: {'body': Style(fontFamily: 'Schyler')});
                                                  })
                                          )
                                      )
                                  ),
                                  InkWell(
                                      onTap: () {
                                        _getController.fullText.value = !_getController.fullText.value;
                                      },
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            TextSmall(text: 'Batafsil', color: AppColors.blue, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 14.sp),
                                            Icon(_getController.fullText.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: AppColors.blue, size: Theme.of(context).iconTheme.size)
                                          ]
                                      )
                                  )
                                ]
                            ) : const SizedBox()
                        ),
                        const Divider(color: Colors.grey, thickness: 1),
                        SizedBox(height: Get.height * 0.01),
                        const TextSmall(text: 'Baholash', color: AppColors.blue, fontWeight: FontWeight.bold),
                        SizedBox(height: Get.height * 0.01),
                        RatingBar.builder(
                            initialRating: p.rating?.toDouble() ?? 4,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 20.sp,
                            itemPadding:
                            EdgeInsets.symmetric(horizontal: 5.sp),
                            unratedColor: AppColors.grey,
                            itemBuilder: (context, _) => const Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp),
                            onRatingUpdate: (rating) {
                              _getController.ratings = rating;
                              InstrumentComponents().addRate(context, true, p.id ?? 0);
                            }),
                        SizedBox(height: Get.height * 0.01),
                        const TextSmall(text: 'Ish vaqti', color: AppColors.blue, fontWeight: FontWeight.bold),
                        SizedBox(height: Get.height * 0.01),
                        Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
                            decoration: BoxDecoration(border: Border.all(color: AppColors.black70, width: 0.3), borderRadius: BorderRadius.circular(10.r)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextSmall(text: 'Ish vaqti', color: AppColors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                                    child: TextSmall(text: '${p.workingDays != null && p.workingDays!.length > _partnersController.currentWeekday ? p.workingDays![_partnersController.currentWeekday].openTime.toString().substring(0,5) : ''} - ${p.workingDays != null && p.workingDays!.length > _partnersController.currentWeekday ? p.workingDays![_partnersController.currentWeekday].closeTime.toString().substring(0,5) : ''}', color: AppColors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                  ),
                                  TextSmall(text: 'Hafta kunlari', color: AppColors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                                  SizedBox(height: Get.height * 0.01),
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: [
                                            for (int day = 0; day < 7; day++)
                                              Builder(
                                                  builder: (context) {
                                                    final int weekday = day + 1;
                                                    final bool isActive = p.workingDays != null && p.workingDays!.any((wd) => wd.weekday == weekday);
                                                    return Container(
                                                      margin: EdgeInsets.only(right: 5.sp),
                                                      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                                                      decoration: BoxDecoration(
                                                          color: isActive ? AppColors.blue : AppColors.white,
                                                          borderRadius: BorderRadius.circular(10.r),
                                                          border: Border.all(color: AppColors.blue, width: 0.3)
                                                      ),
                                                      child: TextSmall(
                                                          text: controller.list[day],
                                                          color: isActive ? AppColors.white : AppColors.blue,
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w600,
                                                          maxLines: 4
                                                      ),
                                                    );
                                                  }
                                              )
                                          ]
                                      )
                                  )
                                ]
                            )
                        ),
                        SizedBox(height: Get.height * 0.01),
                        const TextSmall(text: 'Aloqa', color: AppColors.blue, fontWeight: FontWeight.bold),
                        SizedBox(height: Get.height * 0.01),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10.r)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextSmall(text: '${'Tel'.tr}: ${p.phone}', color: AppColors.black, fontSize: 14.sp, fontWeight: FontWeight.bold),
                            ]
                          )
                        ),
                        SizedBox(height: Get.height * 0.01),
                        const Divider(),
                        SizedBox(height: Get.height * 0.01),
                        const TextSmall(text: 'Manzil', color: AppColors.blue, fontWeight: FontWeight.bold),
                        SizedBox(height: Get.height * 0.01),
                        _MapPreview(address: p.address.toString(), onTap: () => controller.openMaps(p.lat,p.lng, p.address), latLng: LatLng( p.lng!,p.lat!)),
                        SizedBox(height: Get.height * 0.15)
                      ]
                  )
              )
            ]
          ))
      )
    );
  }
}


class _MapPreview extends StatelessWidget {
  final String address;
  final VoidCallback onTap;
  final LatLng latLng;

  _MapPreview({required this.address, required this.onTap, required this.latLng});

  final MapController _localMapController = MapController();
  final double _initialZoom = 15.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,  // Butun preview ustiga bosganda ishlaydi
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(border: Border.all(color: AppColors.greys), borderRadius: BorderRadius.circular(14), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: SizedBox(
                width: Get.width,
                height: Get.height * 0.4,
                child: Stack(
                  children: [
                    IgnorePointer(
                      ignoring: true,
                      child: FlutterMap(
                        mapController: _localMapController,
                        options: MapOptions(
                          initialCenter: latLng,
                          initialZoom: _initialZoom,
                          interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                          onMapReady: () {
                            _localMapController.move(latLng, _initialZoom);
                          }
                        ),
                        children: [
                          TileLayer(urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c'], userAgentPackageName: 'partner.hicom.uz'),
                          MarkerLayer(markers: [Marker(width: 20.0, height: 20.0, point: latLng, child: Icon(Icons.location_on, color: AppColors.red, size: 40.sp))])
                        ]
                      )
                    )
                  ]
                )
              )
            ),
            const Divider(height: 1, color: AppColors.greys),
            Padding(padding: const EdgeInsets.all(12), child: TextSmall(text: address, maxLines: 2, overflow: TextOverflow.ellipsis, fontSize: 14.sp, color: AppColors.black))
          ]
        )
      )
    );
  }
}