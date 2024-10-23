import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import '../../companents/filds/text_small.dart';
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
  double _avatarSize = 100.0;
  final double _minAvatarSize = 50.0;
  final double _maxAvatarSize = 160.0;
  bool fullImage = false;

  final GetController _getController = Get.put(GetController());

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        double offset = _scrollController.offset;
        _isTitleVisible = offset > 100; // Title ko‘rinadigan joy
        _avatarSize = (_maxAvatarSize - offset).clamp(_minAvatarSize, _maxAvatarSize + _maxAvatarSize);
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


  @override
  Widget build(BuildContext context) {
    _getController.nameController.text = _getController.fullName.value.substring(0, _getController.fullName.value.indexOf(' '));
    _getController.surNameController.text = _getController.fullName.value.substring(_getController.fullName.value.indexOf(' '));
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
        body: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                  expandedHeight: fullImage ? 260.sp : 260.sp,
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
                            title: AnimatedOpacity(
                                opacity: _isTitleVisible ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: const Text(
                                    "Dilshodjon Haydarov",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black
                                    )
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
                                        TextButton(onPressed: Get.back, child: TextSmall(text: 'Tayyor'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold)),
                                        SizedBox(width: 15.w)
                                      ]
                                  ),
                                  SizedBox(height: 10.h),
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(400.r),
                                      child: Image.network(
                                          'https://i.pinimg.com/564x/2f/57/8d/2f578d07945132849b05fbdaf78cba38.jpg',
                                          height: 150.h,
                                          width: 150.w,
                                          fit: BoxFit.cover
                                      )
                                  ),
                                  SizedBox(height: 10.h),
                                  TextButton(onPressed: Get.back, child: TextSmall(text: 'Yangi rasm joylash'.tr, color: AppColors.blue, fontWeight: FontWeight.w500)),
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
                        padding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 16.h),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.w),
                                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(15.r)),
                                  child: TextField(
                                      controller: _getController.nameController,
                                      textInputAction: TextInputAction.search,
                                      decoration: InputDecoration(
                                          hintText: 'Ism'.tr,
                                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 16.sp),
                                          border: InputBorder.none
                                      )
                                  )
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 10.w),
                                  margin: EdgeInsets.only(top: 10.h),
                                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(15.r)),
                                  child: TextField(
                                      controller: _getController.surNameController,
                                      textInputAction: TextInputAction.search,
                                      decoration: InputDecoration(
                                          hintText: 'Ism'.tr,
                                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 16.sp),
                                          border: InputBorder.none
                                      )
                                  )
                              ),
                              _buildListTile(title: 'Sotuvchi', onTap: () {  }),
                              _buildListTile(title: 'O‘zbekiston', onTap: () {  }),
                              _buildListTile(title: 'Qo‘qon shaxar', onTap: () {  }),
                              _buildListTileDelete(title: 'Qaysidur ko‘cha 12-uy', onTap: () {  }),
                              SizedBox(height: 5.h),
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  margin: EdgeInsets.only(top: 13.h),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Colors.grey.withOpacity(0.2)),
                                  child: ListTile(
                                      onTap: (){},
                                      hoverColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      title: TextSmall(text: 'Tug`ilgan sana', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white),
                                      trailing: TextSmall(text: '31 mar 2003', color: Theme.of(context).brightness == Brightness.light ? AppColors.black70 : AppColors.grey
                                      )
                                  )
                              ),
                              SizedBox(height: 5.h),
                              _buildListTileDelete(color: AppColors.red, title: 'Hisobni o`chirish', onTap: (){
                                _getController.deleteTimer();
                                InstrumentComponents().bottomSheetAccountsDelete(context);
                              }),
                              SizedBox(height: 500.h)
                            ]
                        )
                    )
                  ])
              )
            ]
        )
    );
  }
  Container _buildListTileDelete({ required String title, required VoidCallback onTap, color}) {
    color ?? (color = Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white);
    return Container(
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Colors.grey.withOpacity(0.2)),
        child: ListTile(
            onTap: onTap,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            title: Text(title, style: TextStyle(fontSize: 14.sp, color: color)),
        )
    );
  }

  Container _buildListTile({required String title, required VoidCallback onTap, color}) {
    color ??= Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white;
    return Container(
        margin: EdgeInsets.only(top: 10.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: Colors.grey.withOpacity(0.2)),
        child: ListTile(
            onTap: onTap,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            title: Text(title, style: TextStyle(fontSize: 14, color: color)),
            trailing: Icon(EneftyIcons.arrow_down_outline, color: color)
        )
    );
  }
}