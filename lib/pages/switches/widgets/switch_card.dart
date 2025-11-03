import 'dart:ffi';

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../companents/filds/text_small.dart';
import '../../../models/sample/switch_model.dart';
import '../../../resource/colors.dart';

class SwitchCard extends StatefulWidget {
  final SwitchModel switchModel;
  final VoidCallback onTap;
  final bool isSwitchExpanded;

  const SwitchCard({super.key, required this.switchModel, required this.onTap, required this.isSwitchExpanded});

  @override
  SwitchCardState createState() => SwitchCardState();
}

class SwitchCardState extends State<SwitchCard> {

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

  void showSwitchSettingsDialog(BuildContext context, SwitchModel switchModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.white,
          insetPadding: EdgeInsets.symmetric(vertical: 36.r, horizontal: 36.r),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextSmall(text: 'Switch sozlamalari', fontWeight: FontWeight.bold, fontSize: 18.sp, color: AppColors.black),
                    const Spacer(),
                    IconButton(icon: Icon(Icons.close, size: 20.sp, color: AppColors.black70), onPressed: () => Navigator.pop(context))
                  ]
                ),
                SizedBox(height: 20.h),
                _buildActionButton(
                    context: context,
                    icon: EneftyIcons.edit_bold,
                    label: 'Tahrirlash',
                    color: AppColors.blue,
                    onTap: () {
                      Get.back();
                      _showEditSwitchDialog(context, switchModel);
                    }
                ),
                SizedBox(height: 12.h),
                _buildActionButton(
                    context: context,
                    icon: EneftyIcons.trash_bold,
                    label: 'O‘chirish',
                    color: AppColors.red,
                    onTap: () {
                      Get.back();
                      _showDeleteConfirmation(context, switchModel);
                    }
                ),
                SizedBox(height: 12.h),
                const Divider(),
                SizedBox(height: 12.h),
                _buildActionButton(
                  context: context,
                  icon: EneftyIcons.refresh_bold,
                  label: 'Reboot',
                  //color: AppColors.blue,
                  onTap: () {
                    _showConfirmationDialog(context, title: 'Switchni qayta ishga tushirish', message: 'Switchni qayta ishga tushirishni tasdiqlaysizmi? Bu jarayon barcha ulanishlarni uzishi mumkin.', onConfirm: () {});
                  }
                ),
                SizedBox(height: 12.h),
                _buildActionButton(
                  context: context,
                  icon: EneftyIcons.clock_bold,
                  label: 'Timing Restart',
                  //color: AppColors.yellow,
                  onTap: () {
                    _showConfirmationDialog(
                      context,
                      title: 'Timingni qayta boshlash',
                      message: 'Timingni qayta boshlashni tasdiqlaysizmi? Bu sozlamalarni qayta sozlashi mumkin.',
                      onConfirm: () {}
                    );
                  }
                ),
                SizedBox(height: 12.h),
                _buildActionButton(
                  context: context,
                  icon: EneftyIcons.rotate_left_bold,
                  label: 'Reset',
                  //color: AppColors.red,
                  onTap: () {
                    _showConfirmationDialog(
                      context,
                      title: 'Switchni qayta o‘rnatish',
                      message: 'Switchni qayta o‘rnatishni tasdiqlaysizmi? Bu barcha sozlamalarni o‘chirib tashlaydi.',
                      onConfirm: () {}
                    );
                  }
                ),
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      foregroundColor: AppColors.black,
                    ),
                    child: TextSmall(
                      text: 'Yopish',
                      fontSize: 14.sp,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, {required String title, required String message, required VoidCallback onConfirm}) {
    showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          insetPadding: EdgeInsets.symmetric(vertical: 46.r, horizontal: 46.r),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          title: TextSmall(text: title, fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColors.black),
          content: TextSmall(text: message, fontSize: 12.sp, color: AppColors.black70),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: TextSmall(text: 'Bekor qilish', fontSize: 14.sp, color: AppColors.black70),
            ),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
              child: TextSmall(text: 'Tasdiqlash', fontSize: 14.sp, color: AppColors.white),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton({required BuildContext context, required IconData icon, required String label, Color? color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), border: Border.all(color: AppColors.grey, width: 0.3.w)),
        child: Row(
          children: [
            Icon(icon, size: 24.sp, color: color ?? AppColors.black70),
            SizedBox(width: 12.w),
            TextSmall(text: label, fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.black)
          ]
        )
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.isSwitchExpanded ? 0 : 16, left: widget.isSwitchExpanded ? 0 : 16, right: widget.isSwitchExpanded ? 0 : 16),
      padding: widget.isSwitchExpanded ? EdgeInsets.only(top: 4, bottom: 4, left: 16, right: !widget.isSwitchExpanded ? 16 : 5) : const EdgeInsets.all(16),
      decoration: BoxDecoration(color: widget.isSwitchExpanded ? AppColors.white : AppColors.greys, borderRadius: BorderRadius.circular(8)),
      child: !widget.isSwitchExpanded
          ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(top: 2),
                                child: Icon(Icons.wifi, size: 16, color: widget.switchModel.isOnline ? Colors.green : Colors.red)
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.switchModel.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 14)),
                                      const SizedBox(height: 4),
                                      Text(widget.switchModel.model, style: TextStyle(fontSize: 13.sp, color: AppColors.black70)),
                                      const SizedBox(height: 4),
                                      Row(
                                          children: [
                                            Icon(Icons.access_time, size: 12.sp, color: AppColors.black70),
                                            const SizedBox(width: 4),
                                            Text('Ishlash vaqti: ${widget.switchModel.uptime}', style: TextStyle(fontSize: 12.sp, color: AppColors.black70))
                                          ]
                                      )
                                    ]
                                )
                            )
                          ]
                      )
                  ),
                  // Status and Action
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: widget.switchModel.isOnline ? Colors.green[50] : Colors.red[50], border: Border.all(color: widget.switchModel.isOnline ? Colors.green : Colors.red), borderRadius: BorderRadius.circular(12)),
                            child: Text(widget.switchModel.status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: widget.switchModel.isOnline ? Colors.green : Colors.red,))
                        ),
                        const SizedBox(height: 8)
                      ]
                  )
                ]
            )
          ]
      )
          : Row(
          children: [
            Container(margin: const EdgeInsets.only(top: 2), child: Icon(Icons.wifi, size: 16, color: widget.switchModel.isOnline ? Colors.green : Colors.red)),
            const SizedBox(width: 12),
            Expanded(child: Text(widget.switchModel.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 14))),
            const SizedBox(width: 12),
            IconButton(onPressed: () => showSwitchSettingsDialog(context, widget.switchModel), highlightColor: AppColors.blue.shade50, icon: Icon(EneftyIcons.setting_2_bold, size: 20.sp, color: AppColors.blue))
        ]
      )
    );
  }
}