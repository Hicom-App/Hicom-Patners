import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:webview_all/webview_all.dart';

class WebPage extends StatelessWidget{
  final String title;
  final String url;
  const WebPage({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: TextSmall(text: title, color: AppColors.black,  fontWeight: FontWeight.w400),
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.arrow_back, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back())
        ),
        body: Center(child: Webview(url: url))
    );
  }
}