import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:hicom_patners/models/sample/project_model.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../companents/custom_app_bar.dart';
import '../controllers/switch_detail_controller.dart';
import '../controllers/switches_controller.dart';
import '../widgets/switch_card.dart';

class SwitchDetailView extends GetView<SwitchDetailController> {
  SwitchDetailView({super.key});

  Widget _buildPortDiagram(int portCount, bool isOnline) {
    const int portsPerRow = 8;
    final int rowCount = (portCount / portsPerRow).ceil();

    final double screenWidth = ScreenUtil().screenWidth;
    final double panelAir = screenWidth > 400 ? 10.w : 5.w;
    final double portGapX = screenWidth > 400 ? 3.w : 3.w;
    final double rowGapY = 4.h;

    final double maxItemWidth = screenWidth > 400 ? 32.w : 26.w;
    final double minItemWidth = screenWidth > 400 ? 22.w : 14.w;
    final double totalPortWidth = (screenWidth - panelAir - 70.w) / portsPerRow;
    final double itemW = totalPortWidth.clamp(minItemWidth, maxItemWidth);
    final double itemH = itemW * 0.9;
    final double labelFont = screenWidth > 400 ? 9.sp : 6.sp;

    String assetForRow(int rowIndex) => ((rowIndex + 1) % 2 == 1) ? 'assets/svg_assets/port_top.svg' : 'assets/svg_assets/port_bottom.svg';

    Color colorForPort(int oneBasedIndex) {
      final active = (oneBasedIndex % 2 == 0) && isOnline;
      return active ? AppColors.green : AppColors.black70;
    }

    Color colorForPanelIcon() => isOnline ? AppColors.green : AppColors.black70;

    Widget buildItem({required String asset, required String label, required Color color}) {
      return SizedBox(
        width: itemW,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(asset, alignment: Alignment.center, width: itemW, height: itemH, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
            SizedBox(height: 2.h),
            TextSmall(text: label, color: AppColors.black, fontSize: labelFont)
          ]
        )
      );
    }

    final List<List<int>> portRows = List.generate(rowCount, (r) {
      final start = r * portsPerRow + 1;
      final end = (start + portsPerRow - 1).clamp(1, portCount);
      return [for (int i = start; i <= end; i++) i];
    });

    if (portCount == 4) {
      final String topAsset = assetForRow(0);
      final panelGroup = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildItem(asset: topAsset, label: 'L2', color: colorForPanelIcon()),
          SizedBox(width: portGapX),
          buildItem(asset: topAsset, label: 'SFP', color: colorForPanelIcon())
        ]
      );

      final portsGroup = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int p = 1; p <= 4; p++) ...[
            if (p > 1) SizedBox(width: portGapX),
            buildItem(asset: topAsset, label: '$p', color: colorForPort(p))
          ]
        ]
      );

      return Container(
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
        padding: EdgeInsets.only(top: 8.h, bottom: 6.h, left: 6.w, right: 6.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.black, width: 0.3.w)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            panelGroup,
            SizedBox(width: panelAir),
            portsGroup
          ]
        )
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
      padding: EdgeInsets.only(top: 8.h, bottom: 6.h, left: 6.w, right: 6.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.black, width: 0.3.w)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildItem(asset: assetForRow(0), label: 'L2', color: colorForPanelIcon()),
                  SizedBox(width: portGapX),
                  buildItem(asset: assetForRow(0), label: 'SFP', color: colorForPanelIcon())
                ]
              ),
              if (rowCount > 1) SizedBox(height: rowGapY),
              if (rowCount > 1)buildItem(asset: assetForRow(1), label: 'L1', color: colorForPanelIcon())
            ]
          ),
          SizedBox(width: panelAir),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(rowCount, (r) {
                final asset = assetForRow(r);
                final rowPorts = portRows[r];
                return Padding(
                  padding: EdgeInsets.only(top: r == 0 ? 0 : rowGapY),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < rowPorts.length; i++) ...[
                        if (i > 0) SizedBox(width: portGapX),
                        buildItem(asset: asset, label: '${rowPorts[i]}', color: colorForPort(rowPorts[i]))
                      ]
                    ]
                  )
                );
              })
            )
          )
        ]
      )
    );
  }


  InputDecoration _getTextFieldDecoration(String hintText) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.black70, fontSize: 14.sp, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.grey, width: 1.w)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.grey, width: 1.w)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.blue, width: 1.5.w)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.red, width: 1.w)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.red, width: 1.5.w)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)
    );
  }

  final SwitchesController controllers = Get.find<SwitchesController>();

  Widget weekDayInfo(text, selected) {
    return Container(
      margin: EdgeInsets.only(right: 5.sp),
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: selected ? AppColors.white : AppColors.blue,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.blue, width: 0.3),
      ),
      child: TextSmall(text: text, color: selected ? AppColors.blue : AppColors.white, fontSize: 11.sp, fontWeight: FontWeight.w600)
    );
  }

  void showPortStatusDescriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12.r)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextSmall(text: 'Port holatlari', fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.black),
                    const Spacer(),
                    IconButton(icon: Icon(Icons.close, size: 20.sp, color: AppColors.black70), onPressed: () => Navigator.pop(context))
                  ]
                ),
                SizedBox(height: 16.h),
                _buildStatusItem(title: 'Good', description: 'Port to‘liq faol, ma’lumot o‘tkazishda hech qanday muammo yo‘q.', color: AppColors.green),
                SizedBox(height: 12.h),
                _buildStatusItem(title: 'Normal', description: 'Port ishlaydi, ammo ba’zi kichik muammolar bo‘lishi mumkin.', color: AppColors.yellow),
                SizedBox(height: 12.h),
                _buildStatusItem(title: 'Poor', description: 'Port sekin ishlaydi yoki nosozliklar kuzatilmoqda.', color: AppColors.primaryColor),
                SizedBox(height: 12.h),
                _buildStatusItem(title: 'Disconnected', description: 'Port ulanmagan yoki faol emas.', color: Colors.black)
              ]
            )
          )
        );
      }
    );
  }

  void showPortDelayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12.r)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextSmall(text: 'Vaqtni bergilash', fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.black),
                    const Spacer(),
                    IconButton(icon: Icon(Icons.close, size: 20.sp, color: AppColors.black70), onPressed: () => Navigator.pop(context))
                  ]
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    //Vaqt rejimi Interval
                    TextSmall(text: 'Interval', fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColors.black),
                    const Spacer(),
                    TextSmall(text: 'Vaqt', fontWeight: FontWeight.bold, fontSize: 14.sp, color: AppColors.black),
                    SizedBox(width: 8.w),
                    Switch(
                      value: false,
                      activeColor: AppColors.blue,
                      activeTrackColor: AppColors.greys,
                      inactiveTrackColor: AppColors.greys,
                      inactiveThumbColor: AppColors.grey,
                      splashRadius: 10.r,
                      padding: EdgeInsets.all(4.5.sp),
                      activeThumbColor: AppColors.blue,
                      trackOutlineColor: WidgetStateProperty.all(AppColors.greys),
                      onChanged: (bool value) {}
                    )
                  ]
                ),
                SizedBox(height: 16.h),
                //Qayta ishga tushirish
                TextSmall(text: 'Qayta ishga tushirish', fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColors.black),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.grey, width: 0.3.w)),
                  child: Row(
                    children: [
                      //popup menu on and off
                      Container(
                        width: 80.w,
                        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.grey, width: 0.3.w)),
                        child: PopupMenuButton<String>(
                          initialValue: 'On',
                          onSelected: (String value) {},
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(value: 'On', child: Text('On')),
                            const PopupMenuItem<String>(value: 'Off', child: Text('Off'))
                          ],
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextSmall(text: 'Off', fontSize: 14.sp, color: AppColors.black),
                                Icon(Iconsax.arrow_down, color: AppColors.black70, size: 20.sp)
                              ]
                            )
                          )
                        )
                      ),

                      CupertinoButton(
                        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
                        child: TextSmall(text: 'Vaqtni tanlash', fontSize: 14.sp, color: AppColors.black),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => Container(
                              height: Get.height * 0.4,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: CupertinoColors.white),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: Get.back,
                                          style: TextButton.styleFrom(
                                              foregroundColor: AppColors.blue,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                                          ),
                                          child: TextSmall(text: 'Saqlash', fontSize: 14.sp, color: AppColors.blue, fontWeight: FontWeight.bold)
                                      )
                                    ]
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.33,
                                    child:CupertinoDatePicker(
                                        mode: CupertinoDatePickerMode.time,
                                        use24hFormat: true,
                                        initialDateTime: DateTime.tryParse('2025-09-20 00:00:00'),
                                        showTimeSeparator: false,
                                        minuteInterval: 1,
                                        showDayOfWeek: false,
                                        onDateTimeChanged: (DateTime newDateTime) {}
                                    )
                                  )
                                ]
                              )
                            )
                          );
                        },
                      ),
                    ],
                  )
                ),
                SizedBox(height: 16.h),
                TextSmall(text: 'Hafta kunlari', fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColors.black),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    weekDayInfo('Du',true),
                    weekDayInfo('Se',true),
                    weekDayInfo('Chor',false),
                    weekDayInfo('Pay',false),
                    weekDayInfo('Juma',false),
                    weekDayInfo('Shan',true),
                    weekDayInfo('Yak',false)
                  ]
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                            alignment: Alignment.center,
                            foregroundColor: AppColors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))
                        ),
                        child: TextSmall(text: 'Bekor qilish', color: AppColors.black, fontSize: 12.sp, fontWeight: FontWeight.w600)
                    ),
                    SizedBox(width: 8.w),
                    TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          alignment: Alignment.center,
                          foregroundColor: AppColors.blue,
                          backgroundColor: AppColors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))
                        ),
                        child: TextSmall(text: 'Saqlash', color: AppColors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)
                    )
                  ],
                )
              ]
            )
          )
        );
      },
    );
  }

  void showPortEditDialog(BuildContext context, port) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController danController = TextEditingController();
        final TextEditingController gachaController = TextEditingController();
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12.r)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextSmall(text: port, fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.black),
                    const Spacer(),
                    IconButton(icon: Icon(Icons.close, size: 20.sp, color: AppColors.black70), onPressed: () => Navigator.pop(context))
                  ]
                ),
                SizedBox(height: 16.h),
                TextSmall(text: 'Ishlash usuli', fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColors.black),
                SizedBox(height: 8.h),
                Container(
                    width: Get.width,
                    margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.grey, width: 0.3.w)),
                    child: PopupMenuButton<String>(
                        initialValue: 'On',
                        onSelected: (String value) {},
                        tooltip: 'Ishlash usuli',
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16.r)),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(value: '0', child: Text('Full 1000 M')),
                          const PopupMenuItem<String>(value: '1', child: Text('Full 100 M')),
                          const PopupMenuItem<String>(value: '1', child: Text('Half 100 M')),
                          const PopupMenuItem<String>(value: '1', child: Text('Full 10 M')),
                          const PopupMenuItem<String>(value: '1', child: Text('Half 10 M')),
                        ],
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextSmall(text: 'Full 1000 M', fontSize: 14.sp, color: AppColors.black),
                                  Icon(Iconsax.arrow_down, color: AppColors.black70, size: 20.sp)
                                ]
                            )
                        )
                    )
                ),
                SizedBox(height: 16.h),
                TextSmall(text: 'Port tezligi chegarasi', fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColors.black),
                SizedBox(height: 8.h),
                SizedBox(
                  width: Get.width,
                  height: 40.h,
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: Get.width * 0.35,
                        child: TextFormField(
                            controller: danController,
                            decoration: _getTextFieldDecoration('0M dan'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '0M dan';
                              }
                              return null;
                            }
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.35,
                        child: TextFormField(
                            controller: gachaController,
                            decoration: _getTextFieldDecoration('0M gacha'),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return '0M gacha';
                              }
                              return null;
                            }
                        ),
                      )
                    ],
                  )
                ),
                SizedBox(height: 26.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                            alignment: Alignment.center,
                            foregroundColor: AppColors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))
                        ),
                        child: TextSmall(text: 'Bekor qilish', color: AppColors.black, fontSize: 12.sp, fontWeight: FontWeight.w600)
                    ),
                    SizedBox(width: 8.w),
                    TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          alignment: Alignment.center,
                          foregroundColor: AppColors.blue,
                          backgroundColor: AppColors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))
                        ),
                        child: TextSmall(text: 'Saqlash', color: AppColors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)
                    )
                  ],
                )
              ]
            )
          )
        );
      },
    );
  }

  Widget _buildStatusItem({required String title, required String description, required Color color}) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.grey, width: 0.3.w)),
      child: Row(
        children: [
          SvgPicture.asset('assets/svg_assets/port_top.svg', width: 24.w, height: 24.h, colorFilter: ColorFilter.mode(color, BlendMode.srcIn),),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSmall(text: title, fontWeight: FontWeight.w600, fontSize: 14.sp, color: AppColors.black),
                SizedBox(height: 4.h, width: 8.w),
                TextSmall(text: description, fontSize: 12.sp, color: AppColors.black70, maxLines: 2)
              ]
            )
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SwitchDetailController());
    return Obx(() {
      ProjectModel? currentProject = controllers.projects.firstWhereOrNull((p) => p.id == 1);
      if (currentProject == null || currentProject.switches.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.blue),
              SizedBox(height: 16.h),
              TextSmall(text: 'Ma’lumotlar yuklanmoqda...', color: AppColors.black70, fontSize: 16.sp)
            ]
          )
        );
      }

      final switchItem = currentProject.switches[0];
      return DefaultTabController(
        length: 5,
        // 6 ta bo'lim: Port Status, Port Settings, VLAN, Port Mirror, DHCP Snooping, Settings
        child: Scaffold(
          /*appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            centerTitle: true,
            title: TextSmall(text: 'Switch haqida', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
            backgroundColor: AppColors.white,
            actions: [
              //devces info iconbutton
              IconButton(onPressed: () => showPortStatusDescriptionDialog(context), icon: const Icon(Icons.info_outline)),
            ],
          ),*/
            appBar: CustomAppBar(title: 'Switch haqida'.tr, isBack: true, isCenter: true, icon: Icons.info_outline, suffixOnTap: () => showPortStatusDescriptionDialog(context)),
          backgroundColor: AppColors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Qurilma ma'lumotlari
              Container(
                margin: EdgeInsets.only(bottom: 10.h, left: 16.w, right: 16.w, top: 16.h),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: AppColors.greys, blurRadius: 15.r, spreadRadius: 5.r, offset: const Offset(0, 0))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 12.h),
                    SwitchCard(switchModel: switchItem, onTap: () {}, isSwitchExpanded: true),
                    _buildPortDiagram(switchItem.portCount, switchItem.isOnline),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: TextSmall(text: 'MAC: 12321312312', color: AppColors.black, textAlign: TextAlign.left, fontSize: ScreenUtil().screenWidth > 400 ? 14.sp : 12.sp, overflow: TextOverflow.ellipsis, maxLines: 1)),
                          SizedBox(width: 10.w),
                          Flexible(child: TextSmall(text: 'HIG: adsads****fasdd', color: AppColors.black, textAlign: TextAlign.right, fontSize: ScreenUtil().screenWidth > 400 ? 14.sp : 12.sp, overflow: TextOverflow.ellipsis, maxLines: 1))
                        ]
                      )
                    )
                  ]
                )
              ),
              // TabBar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [BoxShadow(color: AppColors.greys, blurRadius: 15.r, spreadRadius: 5.r, offset: const Offset(0, 0))]
                ),
                child: TabBar(
                  isScrollable: true,
                  labelColor: AppColors.black,
                  unselectedLabelColor: AppColors.black,
                  indicator: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: AppColors.greys,
                    borderRadius: BorderRadius.circular(10.r)
                  ),
                  indicatorPadding: EdgeInsets.symmetric(vertical: 4.h),
                  labelPadding: EdgeInsets.symmetric(horizontal: 14.w),
                  indicatorSize: TabBarIndicatorSize.tab,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  //animationDuration: const Duration(milliseconds: 300),
                  tabs: const [
                    Tab(text: 'Port holati'),
                    Tab(text: 'Port sozlamalari'),
                    Tab(text: 'VLAN'),
                    //Tab(text: 'Port Mirror'),
                    Tab(text: 'DHCP Snooping'),
                    Tab(text: 'Sozlamalar'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        padding: EdgeInsets.all(16.r),
                        constraints: BoxConstraints(minHeight: Get.height * 0.52),
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [BoxShadow(color: AppColors.greys, blurRadius: 12.r, spreadRadius: 2.r, offset: const Offset(0, 2))]
                        ),
                        child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Port holati', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.black)),
                                  GestureDetector(onTap: () {}, child: Icon(EneftyIcons.setting_2_bold, color: AppColors.black70, size: 20.sp))
                                ]
                              ),
                              SizedBox(height: 16.h),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 16.w,
                                  dataRowHeight: 60.h,
                                  headingRowHeight: 40.h,
                                  dataRowColor: WidgetStateProperty.all(AppColors.white),
                                  decoration: BoxDecoration(border: Border.all(color: AppColors.greys), borderRadius: BorderRadius.circular(10.r)),
                                  columns: [
                                    DataColumn(
                                        tooltip: 'Port',
                                        headingRowAlignment: MainAxisAlignment.center,
                                        columnWidth: FixedColumnWidth(75.w),
                                        label: Text('Port', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                                    ),
                                    DataColumn(
                                      tooltip: 'TX',
                                      headingRowAlignment: MainAxisAlignment.center,
                                      label: Text('TX', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                                    ),
                                    DataColumn(
                                      headingRowAlignment: MainAxisAlignment.center,
                                      label: Text('RX', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                                    ),
                                    DataColumn(
                                      headingRowAlignment: MainAxisAlignment.center,
                                      label: Text('Quvvat', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                                    ),
                                    DataColumn(
                                      headingRowAlignment: MainAxisAlignment.center,
                                      label: Text('Holati', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                                    )
                                  ],
                                  rows: controller.portStatuses.asMap().entries.map((entry) {
                                    final port = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(Text('Port ${port['port']}', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))),
                                        DataCell(
                                            Text('${port['tx']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: AppColors.black70))
                                        ),
                                        DataCell(
                                            Text('${port['rx']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: AppColors.black70))
                                        ),
                                        DataCell(
                                            Text('${port['power']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, color: AppColors.black70))
                                        ),
                                        DataCell(
                                            Text('${port['status']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: port['status'] == 'Active' ? AppColors.green : AppColors.red))
                                        )
                                      ]
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),


                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        padding: EdgeInsets.all(16.r),
                        constraints: BoxConstraints(minHeight: Get.height * 0.52),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [BoxShadow(color: AppColors.greys, blurRadius: 12.r, spreadRadius: 2.r, offset: const Offset(0, 2))]
                        ),
                        child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Port sozlamalari', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.black)),
                                  GestureDetector(onTap: () {}, child: Icon(EneftyIcons.setting_2_bold, color: AppColors.black70, size: 20.sp))
                                ]
                              ),
                              SizedBox(height: 16.h),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 5.w,
                                  dataRowHeight: 60.h,
                                  headingRowHeight: 40.h,
                                  decoration: BoxDecoration(border: Border.all(color: AppColors.greys), borderRadius: BorderRadius.circular(10.r)),
                                  columns: [
                                    DataColumn(
                                        columnWidth: FixedColumnWidth(70.w),
                                        headingRowAlignment: MainAxisAlignment.center,
                                        label: Text('Port', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                                    ),
                                    DataColumn(
                                        headingRowAlignment: MainAxisAlignment.center,
                                        label: Text('POE', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                                    ),
                                    DataColumn(
                                        headingRowAlignment: MainAxisAlignment.center,
                                        label: Text('Extend', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                                    ),
                                    DataColumn(
                                        columnWidth: FixedColumnWidth(60.w),
                                        headingRowAlignment: MainAxisAlignment.center,
                                        label: Text('Timing', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                                    ),
                                    DataColumn(
                                        tooltip: 'Reboot',
                                        headingRowAlignment: MainAxisAlignment.center,
                                        label: Text('Reboot', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                                    )
                                  ],
                                  rows: controller.portSettings.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final port = entry.value;
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          TextButton(
                                            onPressed: () => showPortEditDialog(context, 'Port ${port['port']}'),
                                            style: TextButton.styleFrom(foregroundColor: AppColors.black, backgroundColor: AppColors.white, padding: const EdgeInsets.all(0)),
                                            child: Text('Port ${port['port']}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                                          )
                                        ),
                                        DataCell(
                                            Switch(
                                            value: port['poeEnabled'].value,
                                            activeColor: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.blue : AppColors.greys,
                                            activeTrackColor: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.greys : AppColors.greys.withAlpha(100),
                                            inactiveTrackColor: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.greys : AppColors.greys.withAlpha(100),
                                            inactiveThumbColor: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.grey : AppColors.grey.withAlpha(100),
                                            splashRadius: 10.r,
                                            padding: EdgeInsets.all(4.5.sp),
                                            activeThumbColor: AppColors.blue,
                                            trackOutlineColor: WidgetStateProperty.all(port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.greys: AppColors.grey.withAlpha(30)),
                                            onChanged: (value) => port['port'] != 'L2' && port['port'] != 'SFP' ? controller.togglePortSetting(index, 'poeEnabled') : null,
                                          )
                                        ),
                                        DataCell(
                                            Switch(
                                            value: port['extendEnabled'].value,
                                            activeColor: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.blue : AppColors.greys,
                                            activeTrackColor: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.greys : AppColors.greys.withAlpha(100),
                                            inactiveTrackColor: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.greys : AppColors.greys.withAlpha(100),
                                            inactiveThumbColor: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.grey : AppColors.grey.withAlpha(100),
                                            splashRadius: 10.r,
                                            padding: EdgeInsets.all(4.5.sp),
                                            activeThumbColor: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.blue : AppColors.grey,
                                            trackOutlineColor: WidgetStateProperty.all(port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.greys : AppColors.grey.withAlpha(30)),
                                            onChanged: (value) => port['port'] != 'L2' && port['port'] != 'SFP' ? controller.togglePortSetting(index, 'extendEnabled') : null,
                                          )
                                        ),
                                        DataCell(
                                          SizedBox(
                                            width: 100.w,
                                            child: IconButton(
                                                onPressed: (){
                                                  showPortDelayDialog(context);
                                                },
                                                icon: Icon(
                                                  index == 3 ? TablerIcons.time_duration_off : TablerIcons.time_duration_10,
                                                  color: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.blue : AppColors.grey,
                                                  size: 20.sp
                                                )
                                            )
                                          ),
                                        ),
                                        DataCell(
                                            TextButton.icon(
                                            onPressed: () => controller.rebootPort(index),
                                            icon: Icon(EneftyIcons.refresh_bold, color: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.red : AppColors.grey, size: 16.sp),
                                            label: Text('Reboot', style: TextStyle(color: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.red : AppColors.grey, fontSize: 12.sp)),
                                            style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h))
                                          )
                                        )
                                      ]
                                    );
                                  }).toList()
                                )
                              )
                            ]
                          )
                        )
                      )
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 10.h, bottom: 50.h, left: 16.w, right: 16.w),
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [BoxShadow(color: AppColors.greys, blurRadius: 15.r, spreadRadius: 5.r, offset: const Offset(0, 0))]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextSmall(text: 'VLAN', fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.black),
                              const Spacer(),
                              Icon(EneftyIcons.setting_2_bold, color: AppColors.black70, size: 20.sp)
                            ]
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextSmall(text: 'VLAN yoqish', fontSize: 14.sp),
                              Obx(() => Switch(
                                  value: controller.vlanEnabled.value,
                                  activeColor: AppColors.blue,
                                  activeTrackColor: AppColors.greys,
                                  inactiveTrackColor: AppColors.greys,
                                  inactiveThumbColor: AppColors.grey,
                                  splashRadius: 10.r,
                                  padding: EdgeInsets.all(4.5.sp),
                                  activeThumbColor: AppColors.blue,
                                  trackOutlineColor: WidgetStateProperty.all(AppColors.greys),
                                  onChanged: (value) => controller.toggleVlan())
                              )
                            ]
                          ),
                          SizedBox(height: 8.h),
                          TextSmall(
                            text: 'VLAN tarmoqni bo‘limlarga ajratib, xavfsizlik va boshqaruvni yaxshilash uchun ishlatiladi.',
                            fontSize: 12.sp,
                            color: AppColors.black70,
                            maxLines: 100,
                          ),
                        ]
                      )
                    ),

                    /*Container(
                      margin: EdgeInsets.only(top: 10.h, bottom: 50.h, left: 16.w, right: 16.w),
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [BoxShadow(color: AppColors.greys, blurRadius: 15.r, spreadRadius: 5.r, offset: const Offset(0, 0))]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextSmall(text: 'Port Mirror', fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.black),
                              const Spacer(),
                              Icon(EneftyIcons.setting_2_bold, color: AppColors.black70, size: 20.sp)
                            ]
                          ),
                          SizedBox(height: 12.h),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Capture Port',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.grey.withAlpha(100))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.grey.withAlpha(100))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.black, width: 1.w)),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                              labelStyle: TextStyle(color: AppColors.black70, fontSize: 12.sp)
                            ),
                            onChanged: (value) => controller.capturePort.value = value
                          ),
                          SizedBox(height: 12.h),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Captured Port',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.grey.withAlpha(100))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.grey.withAlpha(100))),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.black, width: 1.w)),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                              labelStyle: TextStyle(color: AppColors.black70, fontSize: 12.sp)
                            ),
                            onChanged: (value) => controller.capturedPort.value = value
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: controller.savePortMirror,
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)), padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h)),
                                child: TextSmall(text: 'Saqlash', color: AppColors.white, fontSize: 14.sp),
                              ),
                              ElevatedButton(
                                onPressed: controller.deletePortMirror,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.red,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h)
                                ),
                                child: TextSmall(text: 'O‘chirish', color: AppColors.white, fontSize: 14.sp)
                              )
                            ]
                          )
                        ]
                      )
                    ),*/

                    // DHCP Snooping
                    Container(
                      margin: EdgeInsets.only(top: 10.h, bottom: 50.h, left: 16.w, right: 16.w),
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [BoxShadow(color: AppColors.greys, blurRadius: 15.r, spreadRadius: 5.r, offset: const Offset(0, 0))]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextSmall(text: 'DHCP Snooping', fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.black),
                              const Spacer(),
                              Icon(EneftyIcons.setting_2_bold, color: AppColors.black70, size: 20.sp)
                            ]
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextSmall(text: 'DHCP Snooping yoqish', fontSize: 14.sp),
                              Obx(() => Switch(
                                value: controller.dhcpSnoopingEnabled.value,
                                activeColor: AppColors.blue,
                                activeTrackColor: AppColors.greys,
                                inactiveTrackColor: AppColors.greys,
                                inactiveThumbColor: AppColors.grey,
                                activeThumbColor: AppColors.blue,
                                trackOutlineColor: WidgetStateProperty.all(AppColors.greys),
                                onChanged: (value) => controller.toggleDhcpSnooping()
                              ))
                            ]
                          ),
                          SizedBox(height: 12.h),
                          DataTable(
                            columnSpacing: 16.w,
                            dataRowHeight: 60.h,
                            headingRowHeight: 40.h,
                            decoration: BoxDecoration(border: Border.all(color: AppColors.greys), borderRadius: BorderRadius.circular(10.r)),
                            columns: [
                              DataColumn(
                                columnWidth: FixedColumnWidth(MediaQuery.of(context).size.width * 0.42), // Ekran kengligining 50% si
                                headingRowAlignment: MainAxisAlignment.center,
                                label: Text('Port', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                              ),
                              DataColumn(
                                columnWidth: FixedColumnWidth(MediaQuery.of(context).size.width * 0.42), // Ekran kengligining 50% si
                                headingRowAlignment: MainAxisAlignment.center,
                                label: Text('POE', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp, color: AppColors.black))
                              )
                            ],
                            rows: controller.portSettings.asMap().entries.take(2).map((entry) {
                              final port = entry.value;
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Center(child: Text(port['port'], style: TextStyle(color: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.red : AppColors.black, fontSize: 12.sp), textAlign: TextAlign.center))
                                  ),
                                  DataCell(
                                    Center(child: Text('Disabled', style: TextStyle(color: port['port'] != 'L2' && port['port'] != 'SFP' ? AppColors.red : AppColors.black, fontSize: 12.sp), textAlign: TextAlign.center))
                                  )
                                ]
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16.h),
                          Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                            decoration: BoxDecoration(
                              color: AppColors.greys,
                              borderRadius: BorderRadius.circular(8.r)
                            ),
                            child: TextSmall(text: 'Explicacion:Solo adminate puertoLAN1/LAN2', color: AppColors.black, fontSize: 12.sp)
                          )
                        ]
                      )
                    ),
                    // Settings
                    SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top: 10.h, bottom: 50.h, left: 16.w, right: 16.w),
                        padding: EdgeInsets.all(16.r),
                        constraints: BoxConstraints(minHeight: Get.height * 0.52),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [BoxShadow(color: AppColors.greys, blurRadius: 15.r, spreadRadius: 5.r, offset: const Offset(0, 0))]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                TextSmall(text: 'Sozlamalar', fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.black),
                                const Spacer(),
                                Icon(EneftyIcons.setting_2_bold, color: AppColors.black70, size: 20.sp)
                              ]
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextSmall(text: 'DHCP yoqish', fontSize: 14.sp),
                                Obx(() => Switch(
                                  value: !controller.dhcpEnabled.value,
                                  activeColor: AppColors.blue,
                                  activeTrackColor: AppColors.greys,
                                  inactiveTrackColor: AppColors.greys,
                                  inactiveThumbColor: AppColors.grey,
                                  activeThumbColor: AppColors.blue,
                                  trackOutlineColor: WidgetStateProperty.all(AppColors.greys),
                                  onChanged: (value) => controller.toggleDhcp()
                                ))
                              ]
                            ),
                            SizedBox(height: 12.h),
                            Obx(() => !controller.dhcpEnabled.value
                                ? const SizedBox.shrink()
                                : Column(
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'IP manzil',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.greys.withOpacity(0.5))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.greys.withOpacity(0.5))),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.black, width: 1.w)),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                          labelStyle: TextStyle(color: AppColors.black70, fontSize: 12.sp)
                                        ),
                                        onChanged: (value) => controller.ipAddress.value = value
                                      ),
                                      SizedBox(height: 12.h),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'MAC manzil',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.greys.withOpacity(0.5))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.greys.withOpacity(0.5))),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.black, width: 1.w)),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                          labelStyle: TextStyle(color: AppColors.black70, fontSize: 12.sp)
                                        ),
                                        onChanged: (value) => controller.macAddress.value = value
                                      ),
                                      SizedBox(height: 12.h),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Gateway',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.greys.withOpacity(0.5))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.greys.withOpacity(0.5))),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.black, width: 1.w)),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                          labelStyle: TextStyle(color: AppColors.black70, fontSize: 12.sp)
                                        ),
                                        onChanged: (value) => controller.gateway.value = value
                                      ),
                                      SizedBox(height: 12.h),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'DNS',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.greys.withOpacity(0.5))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.greys.withOpacity(0.5))),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r), borderSide: BorderSide(color: AppColors.black, width: 1.w)),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                          labelStyle: TextStyle(color: AppColors.black70, fontSize: 12.sp)
                                        ),
                                        onChanged: (value) => controller.dns.value = value
                                      )
                                    ]
                                  )),
                            SizedBox(height: 16.h),
                            _buildSwitchRow('Storm Control', controller.stormControlEnabled),
                            _buildSwitchRow('Power Supply Adaptive', controller.powerSupplyAdaptiveEnabled),
                            _buildSwitchRow('Port Watchdog', controller.portWatchdogEnabled),
                            _buildSwitchRow('Automatic Port Extension', controller.autoPortExtensionEnabled),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: controller.saveSettings,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h)
                              ),
                              child: TextSmall(text: 'Saqlash', color: AppColors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)
                            )
                          ]
                        )
                      )
                    )
                  ]
                )
              )
            ]
          )
        )
      );
    });
  }

  Widget _buildSwitchRow(String label, RxBool value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextSmall(text: label, fontSize: 14.sp, color: AppColors.black70),
          Obx(() => Switch(
            value: value.value,
            activeColor: AppColors.blue,
            activeTrackColor: AppColors.greys,
            inactiveTrackColor: AppColors.greys,
            inactiveThumbColor: AppColors.grey,
            activeThumbColor: AppColors.blue,
            trackOutlineColor: WidgetStateProperty.all(AppColors.greys),
            onChanged: (newValue) => value.value = newValue
          ))
        ]
      )
    );
  }
}