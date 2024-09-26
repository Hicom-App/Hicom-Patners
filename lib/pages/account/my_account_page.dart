import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:hicom_patners/pages/account/settings_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/instrument/instrument_components.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import '../home/notification_page.dart';
import '../home/transfer_to_wallet.dart';
import 'arxiv_page.dart';
import 'favorites_page.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isTitleVisible = false;
  double _avatarSize = 120.0;
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
    return Scaffold(
        backgroundColor: AppColors.white,
        body: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                  expandedHeight: fullImage ? 400.0 : 250.0,
                  pinned: true,
                  elevation: 1,
                  backgroundColor: AppColors.white,
                  surfaceTintColor: AppColors.white,
                  shadowColor: AppColors.white,
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
                                          height: Get.height * 0.08,
                                          alignment: Alignment.center,
                                          child: const TextSmall(text: 'Yangi rasm bergilash', color: AppColors.blue, fontWeight: FontWeight.bold),
                                      )
                                  ),
                                  Positioned(
                                      top: Get.height * 0.06,
                                      right: Get.width * 0.02,
                                      child:  GlassmorphicContainer(
                                          width: Get.width * 0.2,
                                          height: Get.height * 0.05,
                                          blur: 20,
                                          alignment: Alignment.center,
                                          border: 0,
                                          linearGradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                const Color(0xFFffffff).withOpacity(0.1),
                                                const Color(0xFFFFFFFF).withOpacity(0.05)
                                              ],
                                              stops: const [0.1, 1]),
                                          borderGradient: LinearGradient(
                                              begin: Alignment.center,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                const Color(0xFFffffff).withOpacity(0.5),
                                                const Color((0xFFFFFFFF)).withOpacity(0.5)
                                              ]
                                          ),
                                          borderRadius: 30,
                                          child: TextButton(onPressed: Get.back, child: const Text('Tayyor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)))
                                          //child: const Text('Tayyor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black))
                                      )
                                  ),
                                  Positioned(
                                      top: Get.height * 0.06,
                                      left: Get.width * 0.02,
                                      child:  GlassmorphicContainer(
                                          width: Get.width * 0.31,
                                          height: Get.height * 0.05,
                                          blur: 20,
                                          alignment: Alignment.center,
                                          border: 0,
                                          linearGradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                const Color(0xFFffffff).withOpacity(0.1),
                                                const Color(0xFFFFFFFF).withOpacity(0.05)
                                              ],
                                              stops: const [0.1, 1]),
                                          borderGradient: LinearGradient(
                                              begin: Alignment.center,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                const Color(0xFFffffff).withOpacity(0.5),
                                                const Color((0xFFFFFFFF)).withOpacity(0.5)
                                              ]
                                          ),
                                          borderRadius: 30,
                                          child: TextButton(onPressed: Get.back, child: const Text('Bekor qilish', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black)))
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
                        color: AppColors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 10.h,bottom: 10.h),
                                    margin: EdgeInsets.only(bottom: 10.h,top: 10.h),
                                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(20.0)),
                                    child: Column(
                                      children: [
                                        TextField(
                                            controller: _getController.searchController,
                                            textInputAction: TextInputAction.search,
                                            decoration: InputDecoration(
                                                hintText: 'Ism'.tr,
                                                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: Get.width * 0.04),
                                                border: InputBorder.none
                                            )
                                        ),
                                        const Divider(),
                                        TextField(
                                            controller: _getController.searchController,
                                            textInputAction: TextInputAction.search,
                                            decoration: InputDecoration(
                                                hintText: 'Familya'.tr,
                                                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: Get.width * 0.04),
                                                border: InputBorder.none
                                            )
                                        )
                                      ]
                                    )
                                  ),
                                  _buildListTile(title: 'Sotuvchi', onTap: () {  }, icon: EneftyIcons.briefcase_bold),
                                  SizedBox(height: Get.height)
                                ]
                              )
                            ]
                        )
                    )
                  ])
              )
            ]
        )
    );
  }
  Container _buildListTile({required IconData icon, required String title, required VoidCallback onTap, color = Colors.black}) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        margin: const EdgeInsets.only(top: 13.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.grey.withOpacity(0.2)
        ),
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