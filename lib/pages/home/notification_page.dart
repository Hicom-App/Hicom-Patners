import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Obunalar'.tr),
      ),
      body: Center(
        child: Text('Obunalar'.tr),
      ),
    );
  }
}