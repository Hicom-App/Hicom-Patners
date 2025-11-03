import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/switches/views/scan_switch_view.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../companents/custom_app_bar.dart';
import '../../../companents/filds/search_text_field.dart';
import '../../../companents/filds/text_small.dart';
import '../../../controllers/get_controller.dart';
import '../../../models/sample/project_model.dart';
import '../../../models/sample/switch_model.dart';
import '../../../resource/colors.dart';
import '../controllers/switches_controller.dart';
import '../widgets/switch_card.dart';

class SwitchListView extends GetView<SwitchesController> {
  final int projectId;

  SwitchListView({super.key, required this.projectId});

  final GetController _getController = Get.put(GetController());

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

  ProjectModel? get _currentProject => controller.projects.firstWhereOrNull((p) => p.id == projectId);

  void _showEditSwitchDialog(BuildContext context, SwitchModel switchItem) {
    final TextEditingController nameController = TextEditingController(text: switchItem.name);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        insetPadding: EdgeInsets.symmetric(vertical: 26.r, horizontal: 26.r),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: TextSmall(text: 'Switch-ni tahrirlash', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 17.sp),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: Get.width),
                TextFormField(
                  controller: nameController,
                  decoration: _getTextFieldDecoration('Switch nomi'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Switch nomini kiriting';
                    }
                    return null;
                  }
                )
              ]
            )
          )
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: TextSmall(text: 'Bekor qilish', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12.sp)),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.white, backgroundColor: AppColors.blue, padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))),
            child: TextSmall(text: 'Saqlash', color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)
          )
        ]
      )
    );
  }

  void _showDeleteConfirmation(BuildContext context, SwitchModel switchItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: TextSmall(text: 'O‘chirishni tasdiqlash', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 17.sp),
        content: TextSmall(text: '${switchItem.name} switch-ni o‘chirishni xohlaysizmi?', color: AppColors.black70, fontWeight: FontWeight.bold, fontSize: 12.sp, maxLines: 3),
        actions: [
          TextButton(onPressed: () => Get.back(), child: TextSmall(text: 'Bekor qilish', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12.sp)),
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(foregroundColor: AppColors.white, backgroundColor: AppColors.red, padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))),
            child: TextSmall(text: 'O‘chirish', color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)
          )
        ]
      )
    );
  }

  void _shareSwitch(BuildContext context, SwitchModel switchItem) => Fluttertoast.showToast(msg: '${switchItem.name} ulashildi', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: AppColors.blue, textColor: AppColors.white);

  Widget _buildPortDiagram(int portCount, bool isOnline) {
    const int portsPerRow = 8;
    final int rowCount = (portCount / portsPerRow).ceil();

    // Ekran kengligiga qarab dinamik o‘lchamlar
    final double screenWidth = ScreenUtil().screenWidth;
    final double panelAir = screenWidth > 400 ? 10.w : 5.w; // Katta ekran: 10.w, kichik: 5.w
    final double portGapX = screenWidth > 400 ? 3.w : 3.w; // Katta ekran: 3.w, kichik: 2.w (oldin 1.w edi)
    final double rowGapY = 4.h;

    // Port o‘lchamini dinamik hisoblash
    final double maxItemWidth = screenWidth > 400 ? 32.w : 26.w;
    final double minItemWidth = screenWidth > 400 ? 22.w : 14.w; // Kichik ekranlarda 14.w ga tushirdik
    final double totalPortWidth = (screenWidth - panelAir - 70.w) / portsPerRow; // Bufer 65.w dan 70.w ga
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

    // Portlarni 8 tadan qatorlarga bo‘lamiz
    final List<List<int>> portRows = List.generate(rowCount, (r) {
      final start = r * portsPerRow + 1;
      final end = (start + portsPerRow - 1).clamp(1, portCount);
      return [for (int i = start; i <= end; i++) i];
    });

    // ---- 4 PORT MAXSUS HOLATI ----
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

    // ---- 8/16/24/48 PORT ----
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
              if (rowCount > 1)
                buildItem(asset: assetForRow(1), label: 'L1', color: colorForPanelIcon())
            ]
          ),
          SizedBox(width: panelAir),
          // Portlar
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: _currentProject?.name ?? 'Switchlar ro‘yxati'.tr, subtitle: 'Tarmoq kommutatorlarini boshqaring'.tr, isBack: true, isCenter: false, icon: Iconsax.scan_barcode, suffixOnTap: () => Get.to(() => ScanSwitchView(title: 'Switchni qoshish'.tr)), titleSize: 24.sp, subtitleSize: 14.sp),
        backgroundColor: AppColors.white,
        body: Obx(() {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final switches = _currentProject?.switches ?? [];
          if (switches.isEmpty) {
            return const Center(child: Text('Switchlar topilmadi'));
          }
          return Column(
              children: [
                Container(padding: EdgeInsets.only(top: 16.h,bottom: 8.r, left: 16.r, right: 16.r), child: SearchTextField(controller: _getController.searchController, color: AppColors.greys, onChanged: (value) {}, margin: 0)),
                Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 16,bottom: 16.r, left: 16.r, right: 16.r),
                itemCount: switches.length,
                itemBuilder: (context, index) {
                  final switchItem = switches[index];
                  return GestureDetector(
                    onTap: () => controller.navigateToSwitch(switchItem.id),
                    child: Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [BoxShadow(color: AppColors.greys, blurRadius: 15.r, spreadRadius: 5.r, offset: const Offset(0, 0))]
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 12.h),
                              SwitchCard(switchModel: switchItem, onTap: () => controller.navigateToSwitch(switchItem.id), isSwitchExpanded: true),
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
                    )
                  );
                }
              )
            )
          ]
        );
      })
    );
  }
}
