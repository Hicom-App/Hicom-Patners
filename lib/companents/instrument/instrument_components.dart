import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '../../controllers/api_controller.dart';
import '../../controllers/get_controller.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/home/add_card_page.dart';
import '../../resource/colors.dart';
import '../filds/text_large.dart';
import '../filds/text_small.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InstrumentComponents {
  final GetController _getController = Get.put(GetController());


  updateLanguage(Locale locale){Get.updateLocale(locale);_getController.saveLanguage(locale);}

  bottomBuildLanguageDialog(BuildContext context,title,cat) => Get.bottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(10.0),left: Radius.circular(10.0))),
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                  height: Get.height * 0.7,
                  width: double.infinity,
                  child: Column(
                      children: [
                        Container(height: Get.height * 0.005, width: Get.width * 0.2, margin: EdgeInsets.only(top: Get.height * 0.02, bottom: Get.height * 0.03), decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface, borderRadius: BorderRadius.circular(10.0))),
                        TextLarge(text: title.toString(), color: Theme.of(context).colorScheme.onSurface, fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize),
                        SizedBox(height: Get.height * 0.02),
                        Expanded(
                              child: ListView.builder(
                                  itemCount: _getController.dropDownItem.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          setState(() {
                                            Get.back();
                                            _getController.changeDropDownItems(0, index);
                                          });
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03),
                                            child: Column(
                                                children: [
                                                  SizedBox(height: Get.height * 0.01),
                                                  Container(
                                                      height: Get.height * 0.04,
                                                      width: Get.width,
                                                      margin: EdgeInsets.only(bottom: Get.height * 0.01),
                                                      child: Center(
                                                          child: Row(
                                                              children: [
                                                                TextSmall(text: _getController.dropDownItem[index].tr, color: AppColors.black, fontWeight: FontWeight.w400),
                                                                const Spacer(),
                                                                if (_getController.dropDownItems[0] == index)
                                                                  Icon(TablerIcons.circle_check, color: Theme.of(context).colorScheme.onSurface)
                                                                else
                                                                  Icon(TablerIcons.circle, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))
                                                              ]
                                                          )
                                                      )
                                                  ),
                                                  if (_getController.dropDownItem.length - 1 != index)
                                                    const Divider()
                                                ]
                                            )
                                        )
                                    );
                                  }
                              )
                          )
                      ]
                  )
              );
            })
    );

  bottomSheetsCountries(BuildContext context,title,cat) => Get.bottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(10.0),left: Radius.circular(10.0))),
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: AppColors.white,
        StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                  height: Get.height * 0.7,
                  width: double.infinity,
                  child: Column(
                      children: [
                        Container(height: Get.height * 0.005, width: Get.width * 0.2, margin: EdgeInsets.only(top: Get.height * 0.02, bottom: Get.height * 0.03), decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface, borderRadius: BorderRadius.circular(10.0))),
                        TextLarge(text: title.toString(), color: Theme.of(context).colorScheme.onSurface, fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize),
                        SizedBox(height: Get.height * 0.02),
                        if (cat == 0 && _getController.countriesModel.value.countries == null || cat == 1 && _getController.regionsModel.value.regions == null || cat == 2 && _getController.citiesModel.value.cities == null)
                          Expanded(child: TextSmall(text: 'Yuklanmoqda...', color: Theme.of(context).colorScheme.onSurface, maxLines: 3),)
                        else
                        Expanded(
                              child: ListView.builder(
                                  itemCount: cat == 0 ? _getController.dropDownItemsCountries.length : cat == 1 ? _getController.dropDownItemsRegions.length : _getController.dropDownItemsCities.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          setState(() {
                                            Get.back();
                                            cat == 0 ? _getController.changeDropDownItems(1, index) : cat == 1 ? _getController.changeDropDownItems(2, index) : _getController.changeDropDownItems(3, index);
                                            if (cat == 0) {
                                              ApiController().getRegions(_getController.countriesModel.value.countries![index].id!).then((value) {
                                                if (_getController.regionsModel.value.regions != null && _getController.regionsModel.value.regions!.isNotEmpty) {
                                                  ApiController().getCities(_getController.regionsModel.value.regions!.first.id!);
                                                }
                                              });
                                              _getController.clearRegionsModel();
                                            }
                                            if (cat == 1) {
                                              ApiController().getCities(_getController.regionsModel.value.regions![index].id!);
                                              _getController.clearCitiesModel();
                                            }
                                          });
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03),
                                            child: Column(
                                                children: [
                                                  SizedBox(height: Get.height * 0.01),
                                                  Container(
                                                      height: Get.height * 0.04,
                                                      width: Get.width,
                                                      margin: EdgeInsets.only(bottom: Get.height * 0.01),
                                                      child: Center(
                                                          child: Row(
                                                              children: [
                                                                TextSmall(text: cat == 0 ? _getController.dropDownItemsCountries[index].tr : cat == 1 ? _getController.dropDownItemsRegions[index].tr : _getController.dropDownItemsCities[index].tr, color: AppColors.black, fontWeight: FontWeight.w400),
                                                                const Spacer(),
                                                                if (_getController.dropDownItems[cat == 0 ? 1 : cat == 1 ? 2 : 3] == index)
                                                                  Icon(TablerIcons.circle_check, color: Theme.of(context).colorScheme.onSurface)
                                                                else
                                                                  Icon(TablerIcons.circle, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))
                                                              ]
                                                          )
                                                      )
                                                  ),
                                                  if (cat == 0 && _getController.dropDownItemsCountries.length - 1 != index || cat == 1 && _getController.dropDownItemsRegions.length - 1 != index || cat == 2 && _getController.dropDownItemsCities.length - 1 != index)
                                                    const Divider()
                                                ]
                                            )
                                        )
                                    );
                                  }
                              )
                        )
                      ]
                  )
              );
            })
    );

  bottomSheetMeCards(BuildContext context) => Get.bottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      enableDrag: false,
      isScrollControlled: false,
      elevation: 10,
      backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
      StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                    boxShadow: [BoxShadow(color: Theme.of(context).brightness == Brightness.light ? AppColors.blackTransparent : AppColors.greys.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))]
                ),
                width: Get.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Get.height * 0.02),
                      Container(
                          padding: EdgeInsets.only(left: Get.width * 0.3, right: Get.width * 0.3),
                          margin: EdgeInsets.only(left: Get.width * 0.35, right: Get.width * 0.35),
                          width: Get.width,
                          height: 5.h,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                              color: Theme.of(context).brightness == Brightness.light ? AppColors.grey : AppColors.grey.withOpacity(0.5)
                          )
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 20.w),
                          TextLarge(text: 'Mening kartalarim'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400),
                          const Spacer(),
                          IconButton(onPressed: () => Get.back(), icon: Icon(EneftyIcons.rotate_right_outline, color: Theme.of(context).colorScheme.onSurface, size: 30)),
                          SizedBox(width: 20.w),
                        ],
                      ),
                      Container(
                          width: Get.width,
                          margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h,),
                          padding: EdgeInsets.only(left: 10.w, right: 15.w, top: 10.h, bottom: 10.h),
                          decoration: BoxDecoration(
                              color: AppColors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20.r),
                            image: DecorationImage(image: NetworkImage(_getController.listCardBackImage[0]), fit: BoxFit.cover)
                          ),
                          child: Row(
                              children: [
                                SizedBox(
                                    height: 70.h,
                                    width: 70.w,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(300.r),
                                        child: FadeInImage(
                                            image: const NetworkImage('https://yt3.googleusercontent.com/ytc/AIdro_l_peMiKFSyyS_s4U7M4vsx_vel0cyoCGrWP50n8udhig=s900-c-k-c0x00ffffff-no-rj'),
                                            placeholder: const NetworkImage('https://yt3.googleusercontent.com/ytc/AIdro_l_peMiKFSyyS_s4U7M4vsx_vel0cyoCGrWP50n8udhig=s900-c-k-c0x00ffffff-no-rj'),
                                            imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://hicom.uz/wp-content/uploads/2024/01/24Pro-600x600.png'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                            fit: BoxFit.cover
                                        )
                                    )
                                ),
                                SizedBox(width: 10.w),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextSmall(text: _getController.fullName.value, color: AppColors.white, fontWeight: FontWeight.w500),
                                      TextSmall(text: '9860 **** **** 8996'.tr, color: AppColors.white, fontWeight: FontWeight.w500)
                                    ]
                                ),
                                const Spacer(),
                                Icon(EneftyIcons.more_bold, color: AppColors.white, size: 30.sp)
                              ]
                          )
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Get.to(() => AddCardPage()),
                        child: Container(
                            width: Get.width,
                            margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h,bottom: 50.h),
                            padding: EdgeInsets.only(left: 10.w, right: 15.w, top: 15.h, bottom: 15.h),
                            decoration: BoxDecoration(
                              color: AppColors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(EneftyIcons.add_circle_bold,color: AppColors.blue, size: 30.sp),
                                  SizedBox(width: 5.w),
                                  const TextSmall(text: 'Karta qo`shish',color: AppColors.blue,)
                                ]
                            )
                        )
                      )
                    ]
                )
            );
          }
      )
  );

  bottomSheetAccountsDelete(BuildContext context) => Get.bottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(10.0),left: Radius.circular(10.0))),
      enableDrag: false,
      isScrollControlled: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              //height: Get.height * 0.3,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0))),
                width: Get.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(10.0),left: Radius.circular(10.0))),
                          title: TextLarge(text: 'Hisobni o‘chirish', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400),
                          centerTitle: false,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          elevation: 0,
                          leadingWidth: 0,
                          leading: Container(),
                          actions: [
                            IconButton(onPressed: () => Get.back(), icon: Icon(TablerIcons.x, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).buttonTheme.height))
                          ]
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Container(
                          padding: EdgeInsets.only(left: Get.width * 0.035, right: Get.width * 0.035),
                          width: Get.width,
                          child: TextSmall(text: 'delete log', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400,maxLines: 10)),
                      SizedBox(height: Get.height * 0.04),
                      Container(
                          padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03),
                          child: Obx(() => _getController.countdownDuration.value.inSeconds == 0
                              ? ElevatedButton(
                              onPressed: () async {
                                ApiController().deleteProfile();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              child:const Center(child: TextSmall(text: 'O‘chirishni tasdiqlang', color: AppColors.white, fontWeight: FontWeight.w400))
                          )
                              : ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.grey, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              child: Center(child: TextSmall(text: '${'O‘chirishni tasdiqlang'.tr} (${(_getController.countdownDuration.value.inSeconds % 60).toString()})', color: AppColors.white, fontWeight: FontWeight.w400)))
                          )
                      )
                    ]
                )
            );
          }
      )
  );

  void logOutDialog(BuildContext context) =>
      Get.dialog(
          AlertDialog(
              title: TextLarge(text: 'Tasdiqlash', color: Theme.of(context).colorScheme.error),
              content: TextSmall(text: 'Hisobdan chiqishni xohlaysizmi?', color: Theme.of(context).colorScheme.onSurface,maxLines: 3),
              actions: [
                TextButton(onPressed: () => Get.back(), child: TextSmall(text: 'Bekor qilish', color: Theme.of(context).colorScheme.primary)),
                TextButton(
                    onPressed: () => {
                      Get.back(),
                      ApiController().logout(),
                      _getController.logout(),
                      Get.offAll(() => const LoginPage(), transition: Transition.fadeIn)
                    },
                    child: TextSmall(text: 'Ha', color: Theme.of(context).colorScheme.primary)
                )
              ]
          )
      );

  void languageDialog(BuildContext context) => Get.bottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(10.0),left: Radius.circular(10.0))),
        enableDrag: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                  height: Get.height * 0.6,
                  width: double.infinity,
                  child: Column(
                      children: [
                        Container(
                            height: 5.h,
                            width: 100.w,
                            margin: EdgeInsets.only(top: 20.h, bottom: 30.h),
                            decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface, borderRadius: BorderRadius.circular(20.r))
                        ),
                        TextSmall(text: 'Tilni tanlang'.tr, color: Theme.of(context).colorScheme.onSurface),
                        SizedBox(height: Get.height * 0.04),
                        Expanded(
                            child: ListView.builder(
                                itemCount: _getController.locale.length,
                                itemBuilder: (context, index){
                                  return Container(
                                      height: Get.height * 0.06,
                                      width: double.infinity,
                                      padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                      child: Column(
                                        children: [
                                          InkWell(
                                              overlayColor: WidgetStateProperty.all(Colors.transparent),
                                              child: Column(
                                                children: [
                                                  Row(
                                                      children: [
                                                        TextSmall(text: _getController.locale[index]['name'], color: Theme.of(context).colorScheme.onSurface, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
                                                        const Spacer(),
                                                        if (_getController.locale[index]['locale'].toString() == _getController.language.toString())
                                                          Icon(TablerIcons.circle_check, color: Theme.of(context).colorScheme.onSurface),
                                                        if (_getController.locale[index]['locale'].toString() != _getController.language.toString())
                                                          Icon(TablerIcons.circle, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))
                                                      ]
                                                  ),
                                                  SizedBox(height: Get.height * 0.01)
                                                ]
                                              ),
                                              onTap: (){
                                                updateLanguage(_getController.locale[index]['locale']);
                                                Get.back();
                                              }
                                          ),
                                          if (index != _getController.locale.length - 1)
                                          const Divider()
                                        ],
                                      )
                                  );
                                }
                            )
                        )
                      ]
                  )
              );
            })
    );

  void addRate(BuildContext context) => Get.defaultDialog(
      backgroundColor: AppColors.white,
      barrierDismissible: false,
      titlePadding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
      title: 'Mahsulotni baxolang',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Get.height * 0.01),
          RatingBar.builder(
              initialRating: _getController.productsModelDetail.value.result!= null ? _getController.productsModelDetail.value.result!.first.rating!.toDouble() : 0,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 25.sp,
              itemPadding: EdgeInsets.symmetric(horizontal: 5.sp),
              unratedColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
              itemBuilder: (context, _) => const Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp),
              onRatingUpdate: (rating) {
                _getController.ratings = rating;
              }
          ),
          SizedBox(height: Get.height * 0.01),
          TextSmall(text: 'Izoh qoldiring', color: Theme.of(context).colorScheme.onSurface),
          SizedBox(height: Get.height * 0.01),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: TextField(
                controller: _getController.surNameController,
                keyboardType: TextInputType.multiline,
                maxLength: 162,
                maxLines: null, // TextField avtomatik kattalashadi, lekin 150.sp dan oshmaydi
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1))
                )
              )
          )
        ]
      ),
      confirm: Container(
          width: 120.w,
          height: 42.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: AppColors.blue),
          child: TextButton(
              onPressed: () async {
                ApiController().addReview(_getController.productsModelDetail.value.result!.first.id ?? 0);
              },
              child: TextSmall(text: 'Saqlash'.tr, color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 15.sp)
          )
      ),
      cancel: Container(
          width: 120.w,
          height: 42.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: AppColors.red),
          child: TextButton(
            onPressed: () {
              Get.back();
            },
            child: TextSmall(text: 'Bekor qilish'.tr, color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 15.sp)
          )
      )
  );

  //toast message
  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.blue,
        textColor: AppColors.white,
        fontSize: 16.sp
    );
  }
}