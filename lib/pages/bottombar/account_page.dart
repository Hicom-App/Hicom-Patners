import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:hicom_patners/pages/account/my_account_page.dart';
import '../../controllers/get_controller.dart';
import '../account/arxiv_page.dart';
import '../account/favorites_page.dart';
import '../account/notification_page.dart';
import '../account/settings_page.dart';
import '../home/transfer_to_wallet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ScrollController _scrollController = ScrollController();
  final GetController _getController = Get.put(GetController());
  double _imageHeight = 0.28;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _imageHeight = 0.28 - (_scrollController.offset / 1000);
        if (_imageHeight < 0.15) _imageHeight = 0.15;
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Obx(() => Column(
            children: [
              AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: Get.height * _imageHeight, // Dynamically adjust height
                  width: Get.width,
                  child: Stack(
                      children: [
                        Positioned.fill(
                            child: Container(
                                margin: EdgeInsets.only(bottom: Get.height * 0.03),
                                child: ImageFiltered(
                                    imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                    child: FadeInImage(
                                        image: NetworkImage(_getController.profileInfoModel.value.result!.first.photoUrl ?? 'https://avatars.mds.yandex.net/i?id=04a44da22808ead8020a647bb3f768d2_sr-7185373-images-thumbs&n=13'),
                                        placeholder: const AssetImage('assets/images/logo_back.png'),
                                        imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image:AssetImage('assets/images/logo_back.png'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                        fit: BoxFit.cover
                                    )
                                )
                            )
                        ),
                        Positioned(
                            bottom: 0,
                            child: Container(
                                width: Get.width,
                                height: Get.height * 0.1,
                                decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)))
                            )
                        ),
                        Positioned(
                            bottom: Get.height * 0.03,
                            width: Get.width,
                            child: Center(
                                child: InkWell(
                                    onTap: () {
                                      Get.to(() => Scaffold(
                                          backgroundColor: Colors.transparent,
                                          body: PhotoView(
                                            filterQuality: FilterQuality.high,
                                            minScale: PhotoViewComputedScale.contained * 0.8,
                                            maxScale: PhotoViewComputedScale.covered * 1.8,
                                            initialScale: PhotoViewComputedScale.contained,
                                            basePosition: Alignment.center,
                                            imageProvider: NetworkImage(_getController.profileInfoModel.value.result!.first.photoUrl ?? 'https://avatars.mds.yandex.net/i?id=04a44da22808ead8020a647bb3f768d2_sr-7185373-images-thumbs&n=13'),
                                          )
                                      ), transition: Transition.fadeIn);
                                    },
                                    child: SizedBox(
                                        width: 130.w,
                                        height: 130.h,
                                        child: Container(
                                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 30, offset: Offset(0, 20))]),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(500.r),
                                                child: FadeInImage(
                                                    image: NetworkImage(_getController.profileInfoModel.value.result!.first.photoUrl ?? 'https://avatars.mds.yandex.net/i?id=04a44da22808ead8020a647bb3f768d2_sr-7185373-images-thumbs&n=13'),
                                                    placeholder: const AssetImage('assets/images/logo_back.png'),
                                                    imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image:AssetImage('assets/images/logo_back.png'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                                    fit: BoxFit.cover
                                                )
                                            )
                                        )
                                    )
                                )
                            )
                        )
                      ]
                  )
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextSmall(text: _getController.profileInfoModel.value.result?.first.firstName ?? '', color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                    SizedBox(width: 5.w),
                    TextSmall(text: _getController.profileInfoModel.value.result?.first.lastName ?? '', color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20)
                  ]
              ),
              TextSmall(text: _getController.profileInfoModel.value.result?.first.phone ?? '', color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15),
              _buildListTile(
                  context: context,
                  icon: Icons.person,
                  title: 'Profilim',
                  onTap: () {
                    ApiController().getCountries();
                    Get.to(() => const MyAccountPage(), transition: Transition.fadeIn);
                  }
              ),
              _buildListTile(
                context: context,
                icon: Icons.wallet,
                title: 'Hamyon',
                onTap: () => Get.to(() => TransferToWallet(index: 1), transition: Transition.downToUp),
              ),
              _buildListTile(
                context: context,
                icon: Icons.bookmark,
                title: 'Saqlanganlar',
                onTap: () => Get.to(() => ArxivPage(), transition: Transition.downToUp),
              ),
              _buildListTile(
                context: context,
                icon: Icons.favorite,
                title: 'Sevimlilar',
                onTap: () => Get.to(() => FavoritesPage(), transition: Transition.downToUp),
              ),
              _buildListTile(
                context: context,
                icon: Icons.settings,
                title: 'Sozlamalar',
                onTap: () => Get.to(() => SettingsPage(), transition: Transition.downToUp),
              ),
              _buildListTile(
                context: context,
                icon: Icons.notifications,
                title: 'Bildirishnomalar',
                onTap: () => Get.to(() => const NotificationPage(), transition: Transition.downToUp),
              ),
              _buildListTile(
                context: context,
                icon: Icons.help,
                title: 'Yordam',
                onTap: () => launchUrl(Uri.parse('https://hicom.uz/'), mode: LaunchMode.externalApplication),
              ),
              _buildListTile(
                context: context,
                icon: Icons.info,
                title: 'Batafsil',
                onTap: () => launchUrl(Uri.parse('https://hicom.uz/'), mode: LaunchMode.externalApplication),
              ),
              _buildListTile(
                context: context,
                icon: Icons.info_outline,
                title: 'Ilova haqida',
                onTap: () => launchUrl(Uri.parse('https://hicom.uz/'), mode: LaunchMode.externalApplication),
              ),
              _buildListTile(
                context: context,
                icon: Icons.logout,
                color: Colors.red,
                title: 'Chiqish',
                onTap: () => InstrumentComponents().logOutDialog(context),
              ),
              SizedBox(height: 20.h),
              TextSmall(text: 'Ilova versiyasi: 1.0.0', color: Colors.black, fontSize: 12.sp),
              SizedBox(height: Get.height * 0.2)
            ]
        ))
      )
    );
  }

  Container _buildListTile({required BuildContext context, required IconData icon, required String title, required VoidCallback onTap, Color? color}) {
    color ??= Colors.black;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.grey.withOpacity(0.2)),
      child: ListTile(onTap: onTap, leading: Icon(icon, color: color), title: Text(title, style: TextStyle(fontSize: 16.sp)), trailing: Icon(Icons.chevron_right, color: color))
    );
  }
}
