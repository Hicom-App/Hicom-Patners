import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/instrument/shake_widget.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isTitleVisible = false;
  bool fullImage = false;

  final GetController _getController = Get.put(GetController());

  @override
  void initState() {
    super.initState();
    _getController.nameController.text = _getController.profileInfoModel.value.result!.first.firstName!;
    _getController.surNameController.text = _getController.profileInfoModel.value.result!.first.lastName!;
    _getController.streetController.text = _getController.profileInfoModel.value.result!.first.address!;

    ApiController().getRegions(int.parse(_getController.profileInfoModel.value.result!.first.countryId.toString()));
    ApiController().getCities(int.parse(_getController.profileInfoModel.value.result!.first.regionId.toString()));
    _getController.image.value = File('');
    _getController.formattedDate.value = DateFormat('dd.MM.yyyy').format(DateTime.parse(_getController.profileInfoModel.value.result!.first.birthday!));
    _scrollController.addListener(() {
      setState(() {
        double offset = _scrollController.offset;
        _isTitleVisible = offset > 100;
        if (offset < -200) {
          fullImage = true;
        } else if (offset > 100){
          fullImage = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Suratni moslashtiring',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false
          ),
          IOSUiSettings(title: 'Suratni moslashtiring')
        ]
      );

      setState(() {
        _getController.image.value = File(croppedFile!.path);
        debugPrint(_getController.image.value.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
        body: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                  expandedHeight: fullImage ? 280.sp : 280.sp,
                  pinned: true,
                  elevation: 1,
                  backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                  surfaceTintColor: AppColors.white,
                  shadowColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                  foregroundColor: AppColors.white,
                  leading: const SizedBox(),
                  flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return FlexibleSpaceBar(
                            centerTitle: true,
                            title: AnimatedOpacity(
                              opacity: _isTitleVisible ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextSmall(text: _getController.profileInfoModel.value.result?.first.firstName ?? '', color: Colors.black, fontWeight: FontWeight.bold),
                                    SizedBox(width: 5.w),
                                    TextSmall(text: _getController.profileInfoModel.value.result?.first.lastName ?? '', color: Colors.black, fontWeight: FontWeight.w500)
                                  ]
                              )
                            ),
                            background: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 40.h),
                                  Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(width: 15.w),
                                        TextButton(onPressed: Get.back, child: TextSmall(text: 'Bekor qilish'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        TextButton(
                                            onPressed: () {
                                              if (_getController.nameController.text.isEmpty) {
                                                _getController.shakeKey[0].currentState?.shake();
                                                _getController.changeErrorInput(0, true);
                                                _getController.tapTimes(() =>_getController.changeErrorInput(0, false),1);
                                              } else if (_getController.surNameController.text.isEmpty) {
                                                _getController.shakeKey[1].currentState?.shake();
                                                _getController.changeErrorInput(1, true);
                                                _getController.tapTimes(() =>_getController.changeErrorInput(1, false),1);
                                              } else if (_getController.formattedDate.value == DateFormat('dd.MM.yyyy').format(DateTime.now())) {
                                                _getController.shakeKey[2].currentState?.shake();
                                                _getController.changeErrorInput(2, true);
                                                _getController.tapTimes(() =>_getController.changeErrorInput(2, false),1);
                                              } else if (_getController.regionsModel.value.regions == null || _getController.dropDownItemsRegions.isEmpty) {
                                                _getController.shakeKey[5].currentState?.shake();
                                                _getController.changeErrorInput(5, true);
                                                _getController.tapTimes(() =>_getController.changeErrorInput(5, false),1);
                                              } else if (_getController.citiesModel.value.cities == null || _getController.dropDownItemsCities.isEmpty) {
                                                _getController.shakeKey[6].currentState?.shake();
                                                _getController.changeErrorInput(6, true);
                                                _getController.tapTimes(() =>_getController.changeErrorInput(6, false),1);
                                              } else {
                                                ApiController().updateProfiles();
                                              }
                                              },
                                            child: TextSmall(text: 'Tayyor'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold)),
                                        SizedBox(width: 15.w)
                                      ]
                                  ),
                                  SizedBox(height: 15.h),
                                  Container(
                                      height: 150.w, width: 150.w,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.grey, spreadRadius: 5, blurRadius: 15, offset: Offset(0, 0))]),
                                      child: ClipOval(
                                          /*child: FadeInImage(
                                              image: _getController.image.value.path == ''
                                                  ? NetworkImage(_getController.profileInfoModel.value.result!.first.photoUrl ?? 'https://avatars.mds.yandex.net/i?id=04a44da22808ead8020a647bb3f768d2_sr-7185373-images-thumbs&n=13')
                                                  : AssetImage(_getController.image.value.path),
                                              placeholder: const AssetImage('assets/images/logo_back.png'),
                                              imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image:AssetImage('assets/images/avatar.png'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                              fit: BoxFit.cover
                                          )*/
                                        child: CachedNetworkImage(
                                            filterQuality: FilterQuality.high,
                                            imageUrl: _getController.profileInfoModel.value.result!.first.photoUrl ?? 'https://avatars.mds.yandex.net/i?id=04a44da22808ead8020a647bb3f768d2_sr-7185373-images-thumbs&n=13',
                                            placeholder: (context, url) => Image.asset('assets/images/logo_back.png', fit: BoxFit.cover),
                                            errorWidget: (context, url, error) => Image.asset('assets/images/logo_back.png', fit: BoxFit.cover)
                                        )
                                      )
                                  ),
                                  SizedBox(height: 25.h),
                                  TextButton(onPressed: () {_pickImage();}, child: TextSmall(text: 'Yangi rasm joylash'.tr, color: AppColors.blue, fontWeight: FontWeight.w500))
                                ]
                            )
                        );
                      }
                  )
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                        padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 12.h),
                        child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ShakeWidget(
                                  key: _getController.shakeKey[0],
                                  shakeOffset: 5,
                                  shakeCount: 15,
                                  shakeDuration: const Duration(milliseconds: 500),
                                  shakeDirection: Axis.horizontal,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 15.w),
                                      decoration: BoxDecoration(border: Border.all(color: _getController.errorInput[0] ? AppColors.red : AppColors.white, width: 1), borderRadius: BorderRadius.circular(15.r), color: Colors.grey.withOpacity(0.2)),
                                      child: TextField(
                                          controller: _getController.nameController,
                                          textInputAction: TextInputAction.next,
                                          style: const TextStyle(fontFamily: 'Schyler'),
                                          decoration: InputDecoration(hintText: 'Ism'.tr, hintStyle: TextStyle(color: AppColors.black.withOpacity(0.5), fontSize: 16.sp, fontFamily: 'Schyler'), border: InputBorder.none)
                                      )
                                  )
                              ),
                              ShakeWidget(
                                  key: _getController.shakeKey[1],
                                  shakeOffset: 5,
                                  shakeCount: 15,
                                  shakeDuration: const Duration(milliseconds: 500),
                                  shakeDirection: Axis.horizontal,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 15.w),
                                      margin: EdgeInsets.only(top: 10.h),
                                      decoration: BoxDecoration(border: Border.all(color: _getController.errorInput[1] ? AppColors.red : AppColors.white, width: 1), color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(15.r)),
                                      child: TextField(
                                          controller: _getController.surNameController,
                                          textInputAction: TextInputAction.done,
                                          style: const TextStyle(fontFamily: 'Schyler'),
                                          decoration: InputDecoration(hintText: 'Familiya'.tr, hintStyle: TextStyle(color: AppColors.black.withOpacity(0.5), fontSize: 16.sp, fontFamily: 'Schyler'), border: InputBorder.none)
                                      )
                                  )
                              ),
                              _buildListTile(title: _getController.dropDownItem[_getController.dropDownItems[0]].toString(), onTap: () {
                                if (FocusManager.instance.primaryFocus != null) FocusManager.instance.primaryFocus?.unfocus();
                                InstrumentComponents().bottomBuildLanguageDialog(context,'Foydalanuvchi turi'.tr,'0');
                              }),
                              ShakeWidget(
                                  key: _getController.shakeKey[4],
                                  shakeOffset: 5,
                                  shakeCount: 15,
                                  shakeDuration: const Duration(milliseconds: 500),
                                  shakeDirection: Axis.horizontal,
                                  child: _buildListTile(title: _getController.dropDownItemsCountries.isNotEmpty ? _getController.dropDownItemsCountries[_getController.dropDownItems[1]].toString() : 'Mamlakat'.tr, onTap: () {
                                    if (FocusManager.instance.primaryFocus != null) FocusManager.instance.primaryFocus?.unfocus();
                                    _getController.countriesModel.value.countries == null ? null : InstrumentComponents().bottomSheetsCountries(context,'Mamlakat'.tr,0);})
                              ),
                              ShakeWidget(
                                  key: _getController.shakeKey[5],
                                  shakeOffset: 5,
                                  shakeCount: 15,
                                  shakeDuration: const Duration(milliseconds: 500),
                                  shakeDirection: Axis.horizontal,
                                  child: _buildListTile(title:  _getController.dropDownItemsRegions.isNotEmpty ? _getController.dropDownItemsRegions[_getController.dropDownItems[2]].toString() : 'Viloyatingizni Tanlang'.tr, onTap: () {
                                    if (FocusManager.instance.primaryFocus != null) FocusManager.instance.primaryFocus?.unfocus();
                                    _getController.regionsModel.value.regions == null ? null : InstrumentComponents().bottomSheetsCountries(context,'Viloyat'.tr,1);})
                              ),
                              ShakeWidget(
                                  key: _getController.shakeKey[6],
                                  shakeOffset: 5,
                                  shakeCount: 15,
                                  shakeDuration: const Duration(milliseconds: 500),
                                  shakeDirection: Axis.horizontal,
                                  child: _buildListTile(title: _getController.dropDownItemsCities.isNotEmpty ? _getController.dropDownItemsCities[_getController.dropDownItems[3]].toString() : 'Shaharingizni Tanlang'.tr, onTap: () {
                                    if (FocusManager.instance.primaryFocus != null) FocusManager.instance.primaryFocus?.unfocus();
                                    _getController.citiesModel.value.cities == null ? null : InstrumentComponents().bottomSheetsCountries(context,'Shahar'.tr,2);})
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 10.h),
                                  padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 15.w),
                                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(15.r)),
                                  child: TextField(
                                      controller: _getController.streetController,
                                      textInputAction: TextInputAction.done,
                                      style: const TextStyle(fontFamily: 'Schyler'),
                                      decoration: InputDecoration(hintText: '123 dom. 18-uy'.tr, hintStyle: TextStyle(color: AppColors.grey, fontSize: 16.sp), border: InputBorder.none)
                                  )
                              ),
                              SizedBox(height: 5.h),
                              ShakeWidget(
                                  key: _getController.shakeKey[2],
                                  shakeOffset: 5,
                                  shakeCount: 15,
                                  shakeDuration: const Duration(milliseconds: 500),
                                  shakeDirection: Axis.horizontal,
                                  child: Container(
                                      margin: EdgeInsets.only(top: 5.h),
                                      decoration: BoxDecoration(border: _getController.errorInput[2] ? Border.all(color: AppColors.red) : null, borderRadius: BorderRadius.circular(20.r), color: Colors.grey.withOpacity(0.2)),
                                      child: ListTile(
                                          onTap: () {
                                            if (FocusManager.instance.primaryFocus != null) FocusManager.instance.primaryFocus?.unfocus();
                                            _getController.showCupertinoDatePicker(context);
                                          },
                                          hoverColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          title: TextSmall(text: 'Tug‘ilgan sana'.tr, color: AppColors.black),
                                          trailing: TextSmall(text: _getController.formattedDate.value.toString(), color: AppColors.black70)
                                      )
                                  )
                              ),
                              SizedBox(height: 300.h)
                            ]
                        ))
                    )
                  ])
              )
            ]
        )
    );
  }

  Container _buildListTile({required String title, required VoidCallback onTap, color}) {
    color ??= AppColors.black;
    return Container(
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: Colors.grey.withOpacity(0.2)),
        child: ListTile(onTap: onTap, hoverColor: Colors.transparent, focusColor: Colors.transparent, titleTextStyle: const TextStyle(fontFamily: 'Schyler'), title: TextSmall(text: title, color: color), trailing: Icon(EneftyIcons.arrow_down_outline, color: color))
    );
  }
}