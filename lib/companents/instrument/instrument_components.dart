import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
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

class InstrumentComponents {
  final GetController _getController = Get.put(GetController());

  final List locale =[{'name':'English','locale':const Locale('en','US')}, {'name':'Русский','locale':const Locale('ru','RU')}, {'name':'O‘zbekcha','locale':const Locale('uz','UZ')}, {'name':'Ўзбекча','locale':const Locale('oz','OZ')}];

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
                        Expanded(
                              child: ListView.builder(
                                  //itemCount: cat == 0 ? _getController.dropDownItemsCountries.length : _getController.dropDownItemsRegions.length,
                                  itemCount: cat == 0 ? _getController.dropDownItemsCountries.length : cat == 1 ? _getController.dropDownItemsRegions.length : _getController.dropDownItemsCities.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          setState(() {
                                            Get.back();
                                            cat == 0 ? _getController.changeDropDownItems(1, index) : cat == 1 ? _getController.changeDropDownItems(2, index) : _getController.changeDropDownItems(3, index);
                                            if (cat == 0) {
                                              ApiController().getRegions(_getController.countriesModel.value.countries![index].id!);
                                              print('Viloyatlar ro\'yxati: ${_getController.countriesModel.value.countries![index].id}');
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
                                                  if (cat == 0 && _getController.dropDownItemsCountries.length - 1 != index || cat == 1 && _getController.dropDownItemsRegions.length - 1 != index)
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

  void logOutDialog(BuildContext context) => Get.dialog(
        AlertDialog(
          title: TextLarge(text: 'Tasdiqlash', color: Theme.of(context).colorScheme.error),
          content: TextSmall(text: 'Hisobdan chiqishni xohlaysizmi?', color: Theme.of(context).colorScheme.onSurface,maxLines: 3),
          actions: [
            TextButton(
                onPressed: () => Get.back(),
                child: TextSmall(text: 'Bekor qilish', color: Theme.of(context).colorScheme.primary)
            ),
            TextButton(
                onPressed: () => {
                  Get.back(),
                  _getController.isRequest.value = true,
                  _getController.sec.value = 0,
                  Get.offAll(() => LoginPage())
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
                                itemCount: locale.length,
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
                                                        TextSmall(text: locale[index]['name'], color: Theme.of(context).colorScheme.onSurface, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
                                                        const Spacer(),
                                                        if (locale[index]['locale'].toString() == _getController.language.toString())
                                                          Icon(TablerIcons.circle_check, color: Theme.of(context).colorScheme.onSurface),
                                                        if (locale[index]['locale'].toString() != _getController.language.toString())
                                                          Icon(TablerIcons.circle, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5))
                                                      ]
                                                  ),
                                                  SizedBox(height: Get.height * 0.01)
                                                ]
                                              ),
                                              onTap: (){
                                                updateLanguage(locale[index]['locale']);
                                                Get.back();
                                              }
                                          ),
                                          if (index != locale.length - 1)
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

}