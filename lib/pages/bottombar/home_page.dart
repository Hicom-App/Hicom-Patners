import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../companents/instrument/custom_header.dart';
import '../../controllers/get_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final GetController _getController = Get.put(GetController());

  void _getData() {
    _getController.refreshLibController.refreshCompleted();
  }

  void _onLoading() async {
    _getController.refreshLibController.refreshCompleted();
    _getController.refreshLibController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          physics: const BouncingScrollPhysics(),
          header: const CustomRefreshHeader(),
          footer: const CustomRefreshFooter(),
          onLoading: _onLoading,
          onRefresh: _getData,
          controller: _getController.refreshLibController,
          scrollController: _getController.scrollController,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: Get.height * 0.7,
                child: Center(
                  child: Text('Sample'.tr)
                )
            )
          )
      ),
    );
  }
}