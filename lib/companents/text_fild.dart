import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/sample/qr_scan_page.dart';
import 'filds/text_small.dart';

class TextFields extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final bool isQrCode;
  final bool? isEnabled;
  final bool? isPassword;
  final int? maxLengthCharacters;
  const TextFields({super.key,required this.title, required this.hintText, required this.controller, this.isQrCode = false, this.isEnabled, this.isPassword = false, required this.maxLengthCharacters});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSmall(text: title, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400),
          SizedBox(height: Get.height * 0.01),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TextField(
              controller: controller,
              cursorColor: Theme.of(context).colorScheme.onSurface,
              enabled: isEnabled ?? true,
              obscureText: isPassword ?? false,
              minLines: 1,
              maxLines: 1,
              maxLength: maxLengthCharacters,
              decoration: InputDecoration(
                  counterText: '',
                  fillColor: Colors.grey.withOpacity(0.1),
                  filled: true,
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  alignLabelWithHint: true,
                  suffixIcon: isQrCode ? IconButton(onPressed: () => Get.to(QRViewExample()), icon: Icon(Icons.qr_code, color: Theme.of(context).colorScheme.onSurface)) : null,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: Get.width * 0.03),
                  hintText: 'Kiriting'.tr,
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize)
              ),
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,),
                textAlignVertical: TextAlignVertical.center
            )
          )
        ]
      )
    );
  }
}