import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '../../controllers/get_controller.dart';

class SearchTextField extends StatelessWidget{
  final Color color;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  SearchTextField({super.key, required this.color, this.onChanged, this.onSubmitted});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60.sp,
        padding: EdgeInsets.only(right: 5.sp),
        margin: EdgeInsets.only(right: 25.w,left: 25.w, top: 3.h),
        child: TextField(
            controller: _getController.searchController,
            textInputAction: TextInputAction.search,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
                filled: true,
                isDense: true,
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15.r)),
                fillColor: color,
                hintText: 'Qidirish'.tr,
                hintStyle: TextStyle(fontFamily: 'Schyler', color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 18.sp),
                prefixIcon: Padding(padding: EdgeInsets.all(Get.height * 0.013), child: Icon(EneftyIcons.search_normal_2_outline, color: Theme.of(context).colorScheme.onSurface)),
                suffixIcon: _getController.searchController.text.isNotEmpty ? IconButton(onPressed: () {
                  onChanged!('');
                  _getController.searchController.clear();
                },
                  icon: Icon(TablerIcons.x, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), size: 20.sp),) : const SizedBox(height: 0, width: 0)
            )
        )
    );
  }

}