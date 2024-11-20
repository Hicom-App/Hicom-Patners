import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/resource/colors.dart';
import '../controllers/get_controller.dart';

class SearchFields extends StatelessWidget {
  final Function(String) onChanged;
  SearchFields({super.key, required this.onChanged});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
        margin: EdgeInsets.only(left: Get.width * 0.15, top: Get.height * 0.01, right: Get.width * 0.03),
        height: Get.height * 0.05,
        padding: EdgeInsets.only(right: Get.width * 0.01),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1), borderRadius: BorderRadius.circular(13.r)),
        child: TextField(
            controller: _getController.searchController,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            style: const TextStyle(fontFamily : 'Schyler'),
            decoration: InputDecoration(
                hintText: 'Qidirish'.tr,
                hintStyle: TextStyle(color: AppColors.black.withOpacity(0.5), fontFamily : 'Schyler', fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
                prefixIcon: Padding(padding: EdgeInsets.all(1.sp), child: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface,size: Theme.of(context).iconTheme.fill)),
                border: InputBorder.none
            )
        )
    ));
  }
}