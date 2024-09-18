import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../controllers/get_controller.dart';
import 'instrument/custom_header.dart';

class RefreshComponent extends StatelessWidget {

  final Widget child;
  final RefreshController refreshController;
  final ScrollController scrollController;
  const RefreshComponent({super.key, required this.child, required this.refreshController, required this.scrollController});

  void _getData() {
    refreshController.refreshCompleted();
  }

  void _onLoading() async {
    refreshController.refreshCompleted();
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        physics: const BouncingScrollPhysics(),
        header: const CustomRefreshHeader(),
        footer: const CustomRefreshFooter(),
        onLoading: _onLoading,
        onRefresh: _getData,
        controller: refreshController,
        scrollController: scrollController,
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: child
        )
    );
  }
}