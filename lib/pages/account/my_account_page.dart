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
                  expandedHeight: fullImage ? 400.sp : 250.sp,
                  pinned: true,
                  elevation: 1,
                  backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                  surfaceTintColor: AppColors.white,
                  shadowColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                  foregroundColor: AppColors.white,
                  leading: const SizedBox(),
                  flexibleSpace: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        var top = constraints.biggest.height;
                        var scaleFactor = (top - _minAvatarSize) / (_maxAvatarSize - _minAvatarSize);
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
                            background: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                      width: fullImage ? Get.width : _avatarSize,
                                      height: fullImage ? Get.height : _avatarSize,
                                      child: Transform.scale(
                                          scale: scaleFactor.clamp(0.0, 1.0),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(fullImage ? 100.0 : 300.0),
                                              child: Image.network(
                                                  'https://i.pinimg.com/564x/2f/57/8d/2f578d07945132849b05fbdaf78cba38.jpg',
                                                  height: fullImage ? Get.height : _avatarSize,
                                                  width: fullImage ? Get.width : _avatarSize,
                                                  fit: fullImage ?  BoxFit.none : BoxFit.cover
                                              )
                                          )
                                      )
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      child: fullImage
                                          ? const SizedBox()
                                          : Container(
                                          width: Get.width,
                                          height: 80.h,
                                          alignment: Alignment.center,
                                          child: const TextSmall(text: 'Yangi rasm bergilash', color: AppColors.blue, fontWeight: FontWeight.bold),
                                      )
                                  ),
                                  Positioned(
                                      top: 50.h,
                                      right: 15.w,
                                      child:  GlassmorphicContainer(
                                          width: 80.w,
                                          height: 35.h,
                                          blur: 20,
                                          alignment: Alignment.center,
                                          border: 0,
                                          linearGradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Theme.of(context).brightness == Brightness.light ? AppColors.white.withOpacity(0.1) : AppColors.black.withOpacity(0.1),
                                                Theme.of(context).brightness == Brightness.light ? AppColors.white.withOpacity(0.3) : AppColors.black.withOpacity(0.3)
                                              ],
                                              stops: const [0.1, 1]),
                                          borderGradient: LinearGradient(
                                              begin: Alignment.center,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Theme.of(context).brightness == Brightness.light ? AppColors.white.withOpacity(0.9) : AppColors.black.withOpacity(0.9),
                                                Theme.of(context).brightness == Brightness.light ? AppColors.white.withOpacity(0.9) : AppColors.black.withOpacity(0.9)
                                              ]
                                          ),
                                          borderRadius: 30,
                                          child: TextButton(onPressed: Get.back, child: TextSmall(text: 'Tayyor'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold))
                                      )
                                  ),
                                  Positioned(
                                      top: 50.h,
                                      left: 15.w,
                                      child:  GlassmorphicContainer(
                                          width: 100.w,
                                          height: 35.h,
                                          blur: 20,
                                          alignment: Alignment.center,
                                          border: 0,
                                          linearGradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Theme.of(context).brightness == Brightness.light ? AppColors.white.withOpacity(0.1) : AppColors.black.withOpacity(0.1),
                                                Theme.of(context).brightness == Brightness.light ? AppColors.white.withOpacity(0.3) : AppColors.black.withOpacity(0.3)
                                              ],
                                              stops: const [0.1, 1]),
                                          borderGradient: LinearGradient(
                                              begin: Alignment.center,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Theme.of(context).brightness == Brightness.light ? AppColors.white.withOpacity(0.9) : AppColors.black.withOpacity(0.9),
                                                Theme.of(context).brightness == Brightness.light ? AppColors.white.withOpacity(0.9) : AppColors.black.withOpacity(0.9)
                                              ]
                                          ),
                                          borderRadius: 30,
                                          child: TextButton(onPressed: Get.back, child: TextSmall(text: 'Bekor qilish'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold))
                                      )
                                  )
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
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 10.h,bottom: 5.h),
                                  margin: EdgeInsets.only(bottom: 5.h,top: 10.h),
                                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(20.r)),
                                  child: Column(
                                      children: [
                                        TextField(
                                            controller: _getController.nameController,
                                            textInputAction: TextInputAction.search,
                                            decoration: InputDecoration(
                                                hintText: 'Ism'.tr,
                                                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 16.sp),
                                                border: InputBorder.none
                                            )
                                        ),
                                        const Divider(),
                                        TextField(
                                            controller: _getController.surNameController,
                                            textInputAction: TextInputAction.search,
                                            decoration: InputDecoration(
                                                hintText: 'Familya'.tr,
                                                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 16.sp),
                                                border: InputBorder.none
                                            )
                                        )
                                      ]
                                  )
                              ),
                              _buildListTile(title: 'Sotuvchi', onTap: () {  }, icon: EneftyIcons.briefcase_bold),
                              _buildListTile(title: 'O‘zbekiston', onTap: () {  }, icon: EneftyIcons.global_bold),
                              _buildListTile(title: 'Qo‘qon shaxar', onTap: () {  }, icon: EneftyIcons.map_bold),
                              _buildListTileDelete(title: 'Qaysidur ko‘cha 12-uy', onTap: () {  }, icon: EneftyIcons.home_hashtag_bold),
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
                              _buildListTileDelete(icon:  EneftyIcons.profile_delete_bold,color: Colors.red, title: 'Hisobni o`chirish', onTap: (){
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
  Container _buildListTileDelete({required IconData icon, required String title, required VoidCallback onTap, color}) {
    color ?? (color = Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white);
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        margin: EdgeInsets.only(top: 13.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Colors.grey.withOpacity(0.2)),
        child: ListTile(
            onTap: onTap,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            leading: Icon(icon, color: color),
            title: Text(title, style: TextStyle(fontSize: 14.sp, color: color)),
            //trailing: Icon(Icons.chevron_right, color: color)
        )
    );
  }

  Container _buildListTile({required IconData icon, required String title, required VoidCallback onTap, color}) {
    color ??= Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white;
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        margin: EdgeInsets.only(top: 13.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: Colors.grey.withOpacity(0.2)),
        child: ListTile(
            onTap: onTap,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            leading: Icon(icon, color: color),
            title: Text(title, style: TextStyle(fontSize: 14, color: color)),
            trailing: Icon(EneftyIcons.arrow_down_outline, color: color)
        )
    );
  }
}