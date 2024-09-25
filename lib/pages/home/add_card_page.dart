import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_large.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class AddCardPage extends StatelessWidget {
  AddCardPage({super.key});

  final GetController _getController = Get.put(GetController());
  final mackFormater = MaskTextInputFormatter(mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kartaga o`tkazmalar'.tr),
        ),
        body: RefreshComponent(
          refreshController: _getController.refreshAddCardController,
          scrollController: _getController.scrollAddCardController,
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Container(
                  width: Get.width,
                  margin: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: TextSmall(text: 'Karta ma`lumotlari'.tr, color: AppColors.black, fontWeight: FontWeight.w500)
              ),
              Container(
                  width: Get.width,
                  height: Get.height * 0.22,
                  margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h,bottom: 20.h),
                  padding: EdgeInsets.only(left: 25.w, right: 20.w, top: 10.h, bottom: 10.h),
                  decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20.r),
                      image: DecorationImage(image: NetworkImage(_getController.listCardBackImage[_getController.cardBackIndex.value]), fit: BoxFit.cover)
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: Get.height * 0.05),
                        Row(
                          children: [
                            if(_getController.cardNumberText.value.toString().contains('9860') || _getController.cardNumberText.value.toString().contains('6262') || _getController.cardNumberText.value.toString().contains('9861'))
                              SizedBox(
                                  height: 70.h,
                                  width: 70.w,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: FadeInImage(
                                          image: const NetworkImage('https://yt3.googleusercontent.com/ytc/AIdro_l_peMiKFSyyS_s4U7M4vsx_vel0cyoCGrWP50n8udhig=s900-c-k-c0x00ffffff-no-rj'),
                                          placeholder: const NetworkImage('https://yt3.googleusercontent.com/ytc/AIdro_l_peMiKFSyyS_s4U7M4vsx_vel0cyoCGrWP50n8udhig=s900-c-k-c0x00ffffff-no-rj'),
                                          imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://frankfurt.apollo.olxcdn.com/v1/files/9qe84l7hvjln2-UZ/image;s=3024x3024'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                          fit: BoxFit.cover
                                      )
                                  )
                              )
                            else if (_getController.cardNumberText.value.toString().contains('8600') || _getController.cardNumberText.value.toString().contains('5614') || _getController.cardNumberText.value.toString().contains('4578'))
                              SizedBox(
                                  height: 70.h,
                                  width: 70.w,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: FadeInImage(
                                          image: const NetworkImage('https://is5-ssl.mzstatic.com/image/thumb/Purple116/v4/c0/47/2b/c0472b79-e642-28bf-cfb6-627739dda3f9/AppIcon-0-0-1x_U007emarketing-0-0-0-8-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/1200x630wa.png'),
                                          placeholder: const NetworkImage('https://is5-ssl.mzstatic.com/image/thumb/Purple116/v4/c0/47/2b/c0472b79-e642-28bf-cfb6-627739dda3f9/AppIcon-0-0-1x_U007emarketing-0-0-0-8-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/1200x630wa.png'),
                                          imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://is5-ssl.mzstatic.com/image/thumb/Purple116/v4/c0/47/2b/c0472b79-e642-28bf-cfb6-627739dda3f9/AppIcon-0-0-1x_U007emarketing-0-0-0-8-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/1200x630wa.png'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                          fit: BoxFit.cover
                                      )
                                  )
                              )
                            else if (_getController.cardNumberText.value.toString().contains('4'))
                                SizedBox(
                                    height: 70.h,
                                    width: 70.w,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20.r),
                                        child: FadeInImage(
                                            image: const NetworkImage('https://avatars.mds.yandex.net/i?id=08b8f5e1b46a108dbe80990532ef179c545f5609-8219723-images-thumbs&n=13'),
                                            placeholder: const NetworkImage('https://avatars.mds.yandex.net/i?id=08b8f5e1b46a108dbe80990532ef179c545f5609-8219723-images-thumbs&n=13'),
                                            imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://avatars.mds.yandex.net/i?id=08b8f5e1b46a108dbe80990532ef179c545f5609-8219723-images-thumbs&n=13'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                            fit: BoxFit.cover
                                        )
                                    )
                                )
                              else if (_getController.cardNumberText.value.toString().contains('5'))
                                  SizedBox(
                                      height: 70.h,
                                      width: 70.w,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20.r),
                                          child: FadeInImage(
                                              image: const NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Mastercard_2019_logo.svg/1200px-Mastercard_2019_logo.svg.png'),
                                              placeholder: const NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Mastercard_2019_logo.svg/1200px-Mastercard_2019_logo.svg.png'),
                                              imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Mastercard_2019_logo.svg/1200px-Mastercard_2019_logo.svg.png'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                              fit: BoxFit.contain
                                          )
                                      )
                                  )
                                else if (_getController.cardNumberText.value.toString().contains('62'))
                                    SizedBox(
                                        height: 70.h,
                                        width: 70.w,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20.r),
                                            child: FadeInImage(
                                                image: const NetworkImage('https://avatars.mds.yandex.net/i?id=a44d7e8e8e9c34df5ae2416acf41d853_l-5384577-images-thumbs&n=13'),
                                                placeholder: const NetworkImage('https://avatars.mds.yandex.net/i?id=a44d7e8e8e9c34df5ae2416acf41d853_l-5384577-images-thumbs&n=13'),
                                                imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://avatars.mds.yandex.net/i?id=a44d7e8e8e9c34df5ae2416acf41d853_l-5384577-images-thumbs&n=13'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                                fit: BoxFit.cover
                                            )
                                        )
                                    )
                                else
                                    SizedBox(
                                        height: 70.h, width: 70.w),
                            SizedBox(width: 20.w),
                            TextLarge(text: _getController.cardNumberText.value, color: AppColors.white, fontWeight: FontWeight.w500),
                          ],
                        ),
                        SizedBox(height: Get.height * 0.03),
                        SizedBox(
                          width: Get.width,
                          child:TextSmall(textAlign: TextAlign.end, text: _getController.cardNameText.value, color: AppColors.white, fontWeight: FontWeight.w500),
                        )
                      ]
                  )
              ),
              SizedBox(
                  height: 50.h,
                  width: Get.width,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _getController.listCardBackImage.length,
                      itemBuilder: (context, index) => GestureDetector(
                          onTap: () => _getController.changeCardBackIndex(index),
                          child: Container(
                              width: 50.w,
                              height: 50.h,
                              margin: EdgeInsets.only(left: 10.w),
                              decoration: BoxDecoration(
                                  color: AppColors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(200.r),
                                  image: DecorationImage(image: NetworkImage(_getController.listCardBackImage[index]), fit: BoxFit.cover)
                              )
                          )
                      )
                  )
              ),
              Container(
                width: Get.width,margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                child: TextSmall(text: 'Karta raqami'.tr, color: AppColors.black, fontWeight: FontWeight.w500),
              ),
              Container(
                  width: Get.width,
                  margin: EdgeInsets.only(top: Get.height * 0.01,left: Get.width * 0.04, right: Get.width * 0.04,bottom: Get.height * 0.01),
                  height: Get.height * 0.05,
                  padding: EdgeInsets.only(right: Get.width * 0.01,left: Get.width * 0.03),
                  decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.5), borderRadius: BorderRadius.circular(20.r)),
                  child: TextField(
                      controller: _getController.nameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.black),
                      inputFormatters: [mackFormater],
                      onChanged: (value) {
                        _getController.cardNumberText.value = value;
                      },
                      decoration: InputDecoration(
                          hintText: 'Karta raqami',
                          hintStyle: TextStyle(color: AppColors.black.withOpacity(0.5), fontSize: Get.width * 0.04),
                          border: InputBorder.none
                      )
                  )
              ),
              Container(
                width: Get.width,margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                child: TextSmall(text: 'Karta egasining ishmi familiyasi'.tr, color: AppColors.black, fontWeight: FontWeight.w500),
              ),
              Container(
                  width: Get.width,
                  margin: EdgeInsets.only(top: Get.height * 0.01,left: Get.width * 0.04, right: Get.width * 0.04,bottom: Get.height * 0.01),
                  height: Get.height * 0.05,
                  padding: EdgeInsets.only(right: Get.width * 0.01,left: Get.width * 0.03),
                  decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.5), borderRadius: BorderRadius.circular(20.r)),
                  child: TextField(
                      controller: _getController.searchController,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(color: AppColors.black),
                      onChanged: (value) {
                        _getController.cardNameText.value = value;
                      },
                      decoration: InputDecoration(
                          hintText: 'F.I.O',
                          hintStyle: TextStyle(color: AppColors.black.withOpacity(0.5), fontSize: Get.width * 0.04),
                          border: InputBorder.none
                      )
                  )
              ),
              Container(
                  width: Get.width,
                  margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h,),
                  padding: EdgeInsets.only(left: 25.w, right: 20.w, top: 10.h, bottom: 10.h),
                  decoration: BoxDecoration(
                      color: AppColors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20.r)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(EneftyIcons.info_circle_bold, color: AppColors.red, size: 25.h),
                      SizedBox(width: 20.w),
                      SizedBox(
                          width: Get.width * 0.65,
                          child: TextSmall(text: 'Ushbu sahifada +998995340313 raqamga biriktirilgan bank kartalarni qo\'shish mumkin. Agar boshqa bank kartasini qo\'shish kerak bo\'lsa, pastdagi telefon raqamini o\'zgartirish funksiyasidan foydalanish mumkin.'.tr,
                              color: AppColors.black, fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              maxLines: 200)
                      )
                    ],
                  )
              ),
              Container(
                  margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 50.h, top: 30.h),
                  width: Get.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      backgroundColor: AppColors.blue,
                      padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                    ),
                    onPressed: () => Get.back(),
                    child: TextSmall(text: 'Qo\'shish'.tr, color: AppColors.white),
                  )
              )
            ],
          ))
        )
    );
  }
}