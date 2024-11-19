import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../controllers/get_controller.dart';

class TextFieldRegister extends StatelessWidget {
  final Color fillColor;
  final String hint;
  final IconData? icons;
  final bool? mack;
  final TextEditingController controller;
  final bool? errorIndex;
  final double? height;

  TextFieldRegister({super.key, required this.fillColor, required this.hint, this.icons, this.mack, required this.controller, this.errorIndex, this.height});
  final mackFormater = MaskTextInputFormatter(mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? 43.sp,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            border: Border.all(color: errorIndex == true ? AppColors.red : AppColors.white, width: 1)
        ),
        child: TextField(
            controller: controller,
            keyboardType: mack == true ? TextInputType.number : TextInputType.text,
            textInputAction: TextInputAction.next,
            inputFormatters: (mack ?? false) ? [mackFormater] : [],
            onChanged: (value) {
              if (controller == _getController.cardNumberController) {
                _getController.cardNumberText.value = _getController.cardNumberController.text;
              } else if (controller == _getController.nameController) {
                _getController.cardNameText.value = _getController.nameController.text;
              }
            },
            decoration: InputDecoration(
                filled: true,
                isDense: true,
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                fillColor: fillColor,
                hintText: hint.tr,
                hintStyle: TextStyle(color: AppColors.black.withOpacity(0.5), fontSize: 13.sp),
                prefixIcon: icons != null ? Padding(padding: EdgeInsets.all(Get.height * 0.013), child: Icon(icons, color: Theme.of(context).colorScheme.onSurface)) : null, suffixIcon: _getController.searchController.text.isNotEmpty ? IconButton(onPressed: () {_getController.searchController.clear();}, icon: Icon(TablerIcons.x, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), size: 15.sp)) : const SizedBox(height: 0, width: 0)
            )
        )
    );
  }
}