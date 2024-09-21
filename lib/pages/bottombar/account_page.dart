import 'package:enefty_icons/enefty_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import '../../resource/colors.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isTitleVisible = false;
  double _avatarSize = 120.0;
  final double _minAvatarSize = 50.0;
  final double _maxAvatarSize = 160.0;
  bool fullImage = false;

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
        slivers: [
          SliverAppBar(
            expandedHeight: fullImage ? 400.0 : 250.0,
            pinned: true,
            elevation: 1,
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            shadowColor: AppColors.white,
            foregroundColor: AppColors.white,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var top = constraints.biggest.height;
                var scaleFactor = (top - _minAvatarSize) / (_maxAvatarSize - _minAvatarSize);
                return FlexibleSpaceBar(
                  title: AnimatedOpacity(
                    opacity: _isTitleVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: const Text(
                      "Dilshojdon Haydarov",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
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
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: fullImage
                            ? GlassmorphicContainer(
                            width: Get.width,
                            height: Get.height * 0.08,
                            blur: 20,
                            alignment: Alignment.center,
                            border: 0,
                            linearGradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.black.withOpacity(0.1),
                                AppColors.black.withOpacity(0.3),
                              ],
                              stops: const [0.1, 1]),
                            borderGradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.black.withOpacity(0.9),
                                AppColors.black.withOpacity(0.9),
                              ],
                            ),
                            borderRadius: 0,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Dilshodjon Haydarov', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.white)),
                                SizedBox(height: 4),
                                Text('+998 99 534 03 13', style: TextStyle(color: AppColors.white))
                              ]
                          )
                        )
                            : SizedBox(
                          width: Get.width,
                          height: Get.height * 0.08,
                          child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Dilshodjon Haydarov', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.black)),
                                SizedBox(height: 4),
                                Text('+998 99 534 03 13', style: TextStyle(color: AppColors.black,))
                              ]
                          )
                        )
                      ),
                      Positioned(
                        top: Get.height * 0.06,
                        right: Get.width * 0.02,
                        child:  GlassmorphicContainer(
                            width: Get.width * 0.18,
                            height: Get.height * 0.04,
                            blur: 20,
                            alignment: Alignment.center,
                            border: 0,
                            linearGradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFffffff).withOpacity(0.1),
                                const Color(0xFFFFFFFF).withOpacity(0.05),
                              ],
                              stops: const [0.1, 1]),
                            borderGradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFffffff).withOpacity(0.5),
                                const Color((0xFFFFFFFF)).withOpacity(0.5),
                              ],
                            ),
                            borderRadius: 30,
                            child: const Text('Tahrir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.black))
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
                      _buildListTile(
                          icon: EneftyIcons.profile_bold, title: 'Profilim', onTap: () {}),
                      _buildListTile(
                          icon: EneftyIcons.wallet_2_bold,
                          title: 'Hamyon',
                          onTap: () {}),
                      _buildListTile(
                          icon: EneftyIcons.bookmark_2_bold,
                          title: 'Saqlanganlar',
                          onTap: () {}),
                      _buildListTile(
                          icon: EneftyIcons.setting_3_bold,
                          title: 'Sozlamalar',
                          onTap: () {}),
                      _buildListTile(
                          icon: EneftyIcons.notification_bold,
                          title: 'Bildirishnomalar',
                          onTap: () {}),
                      _buildListTile(
                          icon: Icons.help,
                          title: 'Yordam',
                          onTap: () {}),
                      _buildListTile(
                          icon: EneftyIcons.info_circle_bold,
                          title: 'Batafsil',
                          onTap: () {}),
                      _buildListTile(
                          icon: EneftyIcons.login_bold,color: Colors.red, title: 'Chiqish',
                          onTap: () {
                            InstrumentComponents().logOutDialog(context);
                          }
                      ),
                      SizedBox(height: Get.height * 0.5),

                    ]
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }

  Container _buildListTile({required IconData icon, required String title, required VoidCallback onTap, color = Colors.black}) {
    return Container(
      //padding: const EdgeInsets.symmetric(vertical: 8.0),
      margin: const EdgeInsets.only(top: 13.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: color
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: color
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: color,
          )
      )
    );
  }
}


