import 'dart:async';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:hicom_patners/pages/home/category_page.dart';
import 'package:hicom_patners/pages/home/detail_page.dart';
import 'package:hicom_patners/pages/home/notification_page.dart';
import 'package:hicom_patners/resource/colors.dart';
import '../../companents/filds/search_text_field.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/home/chashe_image.dart';
import '../../companents/skletons/skeleton_category.dart';
import '../../companents/skletons/skeleton_products.dart';
import '../../companents/product_item.dart';
import '../../companents/product_items.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../home/checks_page.dart';
import '../home/transfer_to_wallet.dart';
import 'account_page.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});
  final GetController _getController = Get.put(GetController());

  final DebounceTimer _debounceTimer = DebounceTimer(milliseconds: 1000);
  Future<void> search(value) async {
    ApiController().getProducts(0, isFavorite: false, isCategory: true, filter: 'name CONTAINS "$value" OR category_name CONTAINS "$value"');
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: AppColors.white,
        body: Container(
            height: Get.height,
            width: Get.width,
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/background.png'), fit: BoxFit.cover)),
            child: RefreshComponent(
                color: AppColors.white,
                scrollController: _getController.scrollHomeController,
                refreshController: _getController.refreshHomeController,
                enablePullUp: false,
                onRefresh: () async {
                  _getController.searchController.clear();
                  _getController.refreshHomeController.refreshCompleted();
                  _getController.clearCategoriesProductsModel();
                  _getController.clearCategoriesAllProductsModel();
                  _getController.clearProductsModel();
                  _getController.clearCategoriesModel();
                  ApiController().getProfile(isWorker: false);
                  ApiController().getCategories(category: false);
                },
                physics: const ClampingScrollPhysics(),
                child: Obx(() => Column(
                    children: [
                      SizedBox(
                          height: Get.height * 0.352,
                          width: Get.width,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppBar(
                                    surfaceTintColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    centerTitle: false,
                                    automaticallyImplyLeading: false,
                                    title: InkWell(
                                      onTap: () => Get.to(() => const AccountPage()),
                                      focusColor: AppColors.blackTransparent,
                                      overlayColor: WidgetStateProperty.all(AppColors.blackTransparent),
                                      splashColor: AppColors.blackTransparent,
                                      highlightColor: AppColors.blackTransparent,
                                      child: Row(
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.white, width: 1)),
                                              child: CircleAvatar(
                                                  radius: 20.r,
                                                  backgroundColor: Colors.transparent,
                                                  child: ClipOval(
                                                      child: _getController.profileInfoModel.value.result != null && _getController.profileInfoModel.value.result!.isNotEmpty && _getController.profileInfoModel.value.result!.first.photoUrl.toString() != 'null'
                                                          ? Image.network(_getController.profileInfoModel.value.result!.first.photoUrl.toString(), fit: BoxFit.cover, width: 40.w, height: 40.w)
                                                          : Image.asset('assets/images/user.png', fit: BoxFit.cover, width: 40.w, height: 40.w
                                                      )
                                                  )
                                              )
                                          ),
                                          SizedBox(width: 10.w),
                                          Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                if (_getController.profileInfoModel.value.result != null && _getController.profileInfoModel.value.result!.isNotEmpty)
                                                  TextLarge(text: '${_getController.profileInfoModel.value.result != null ?  _getController.profileInfoModel.value.result!.first.firstName.toString() : ''} ${_getController.profileInfoModel.value.result != null ? _getController.profileInfoModel.value.result!.first.lastName.toString() : ''}', color: AppColors.white, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 18.sp)
                                                else
                                                  TextLarge(text: 'Mening profilim', color: AppColors.white, fontWeight: FontWeight.bold, maxLines: 1, fontSize: 18.sp),
                                                if (_getController.profileInfoModel.value.result != null && _getController.profileInfoModel.value.result!.isNotEmpty)
                                                  TextSmall(text: '${'ID'.tr}: ${_getController.profileInfoModel.value.result != null ? _getController.profileInfoModel.value.result!.first.id : ''}', color: AppColors.white, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 14.sp)
                                              ]
                                          )
                                        ]
                                      )
                                    ),
                                    actions: [
                                      InkWell(
                                          child: IconButton(
                                              icon: Icon(EneftyIcons.notification_bold, color: AppColors.white, size: Theme.of(context).iconTheme.fill),
                                              onPressed: () => Get.to(() => NotificationPage()),
                                              onLongPress: () => Clipboard.setData(ClipboardData(text: _getController.fcmToken))
                                          )
                                      )
                                    ]
                                ),
                                Column(
                                    children: [
                                      TextSmall(text: 'Jami hisoblangan'.tr, color: AppColors.white, fontWeight: FontWeight.bold),
                                      TextLarge(text: _getController.profileInfoModel.value.result != null ? '${_getController.getMoneyFormat(_getController.profileInfoModel.value.result!.first.cashbackCalculated!)} ${'so‘m'.tr}' : '0 ${'so‘m'.tr}',color: AppColors.white,fontWeight: FontWeight.bold),
                                    ]
                                ),
                                SizedBox(
                                    width: Get.width,
                                    height: 90.h,
                                    child: ListView.builder(
                                        itemCount: _getController.listTitle.length,
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        padding: EdgeInsets.only(left: 30.w, right: 30.w),
                                        itemBuilder: (context, index) => GestureDetector(
                                            onTap: () {
                                              if(index == 1 && _getController.token != null && _getController.token.isNotEmpty) {
                                                Get.to(() => TransferToWallet(index: index));
                                              }else if(index == 0 && _getController.token != null && _getController.token.isNotEmpty) {
                                                Get.to(() => ChecksPage());
                                              } else if(index == 2 || index == 3 && _getController.token != null && _getController.token.isNotEmpty) {
                                                Get.to(() => ChecksPage());
                                              }
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(13.r), color: Theme.of(context).brightness == Brightness.dark ? AppColors.black : AppColors.white, image: const DecorationImage(image: AssetImage('assets/images/foncard.jpg'), fit: BoxFit.fill)),
                                                margin: EdgeInsets.only(right: 10.w),
                                                child: SizedBox(
                                                    height: 100.h,
                                                    width: 178.w,
                                                    child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          TextSmall(text: _getController.listTitle[index].tr, color: AppColors.black, fontSize: 17.sp),
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                TextSmall(text: _getController.profileInfoModel.value.result != null ? index == 0 ? _getController.getMoneyFormat(_getController.profileInfoModel.value.result!.first.cashbackWaiting!) : index == 1 ? _getController.getMoneyFormat(_getController.profileInfoModel.value.result!.first.cashbackRemain!) : index == 2 ? _getController.getMoneyFormat(_getController.profileInfoModel.value.result!.first.cashbackWithdrawn!) : _getController.getMoneyFormat(_getController.profileInfoModel.value.result!.first.cashbackRejected!) : '0', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 17.sp),
                                                                TextSmall(text: ' ${'so‘m'.tr}', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 17.sp)
                                                              ]
                                                          )
                                                        ]
                                                    )
                                                )
                                            )
                                        )
                                    )
                                )
                              ]
                          )
                      ),
                      Container(
                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)), boxShadow: [BoxShadow(color: AppColors.black.withAlpha(10), spreadRadius: 3, blurRadius: 35, offset: const Offset(0, 0))]),
                          constraints: BoxConstraints(minHeight: Get.height * 0.6),
                          child: _getController.productsModel.value.result != null
                              ? Column(
                              children: [
                                SizedBox(height: 25.h),
                                SearchTextField(
                                  controller: _getController.searchController,
                                  color: AppColors.greys.withAlpha(150),
                                  onChanged: (value) {
                                    _getController.clearCategoriesProductsModel();
                                    _getController.clearCategoriesAllProductsModel();
                                    _getController.clearProductsModel();
                                    if (_getController.searchController.text.isEmpty) {
                                      _getController.searchController.clear();
                                      _getController.refreshController.refreshCompleted();
                                      _getController.clearCategoriesProductsModel();
                                      _getController.clearCategoriesAllProductsModel();
                                      _getController.clearProductsModel();
                                      _getController.clearCategoriesModel();
                                      ApiController().getCategories();
                                    }
                                    //_getController.clearCategoriesAllProductsModel();
                                    _debounceTimer(() => search(value));
                                  },
                                ),
                                SizedBox(height: 15.h),
                                if (_getController.categoriesModel.value.result != null)
                                  SizedBox(
                                      width: Get.width,
                                      height: 82.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.only(left: 10.w, right: 30.w),
                                        itemBuilder: (context, index) => InkWell(
                                            onTap: () => Get.to(CategoryPage(open: 0, id: _getController.categoriesModel.value.result![index].id!.toInt())),
                                            child:  Container(
                                                margin: EdgeInsets.only(left: 15.w),
                                                padding: EdgeInsets.only(left: 6.w, right: 6.w),
                                                decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20.r)),
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(width: 40.w, height: 38.w, child: CacheImage(keys: _getController.categoriesModel.value.result![index].id.toString(), url: _getController.categoriesModel.value.result![index].photoUrl.toString())),
                                                      Container(margin: EdgeInsets.only(top: 5.h), width: 71.w, child: Center(child: _getController.categoriesModel.value.result != null ? TextSmall(text: _getController.categoriesModel.value.result![index].name.toString(), color: AppColors.white, maxLines: 1, fontSize: 11.sp, fontWeight: FontWeight.w600) : const SizedBox()))
                                                    ]
                                                )
                                            )
                                        ),
                                        itemCount: _getController.categoriesModel.value.result != null ? _getController.categoriesModel.value.result!.length : 0,
                                      )
                                  )
                                else
                                  const SkeletonCategory(),
                                if (_getController.productsModel.value.result != null && _getController.productsModel.value.result!.isNotEmpty)
                                  Stack(
                                      children: [
                                        SizedBox(
                                            height: 365.h,
                                            width: Get.width,
                                            child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                padding: EdgeInsets.only(left: 25.w, right: 15.w),
                                                child: Row(
                                                    children: [
                                                      if (_getController.productsModel.value.result != null)
                                                        for (int index = 0; index < _getController.productsModel.value.result!.length; index++)
                                                          InkWell(onTap: () => Get.to(DetailPage(id: _getController.productsModel.value.result![index].id)), child: ProductItem(index: index))
                                                    ]
                                                )
                                            )
                                        ),
                                        Positioned(
                                            child: Container(
                                                margin: EdgeInsets.only(left: 25.w, top: 10.h),
                                                child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      TextSmall(text: 'Barcha mahsulotlar'.tr, color: AppColors.black),
                                                      const Spacer(),
                                                      TextButton(onPressed: () => Get.to(const CategoryPage(id: 0, open: 2)), child: TextSmall(text: 'Ko‘proq'.tr, color: AppColors.black70))
                                                    ]
                                                )
                                            )
                                        )
                                      ]
                                  ),
                                if (_getController.categoriesModel.value.result != null && _getController.categoriesAllProductsModel.value.all != null && _getController.categoriesAllProductsModel.value.all!.isNotEmpty && _getController.productsModel.value.result != null && _getController.productsModel.value.result!.isNotEmpty)
                                  Column(
                                      children: [
                                        for (int i = 0; i < _getController.categoriesModel.value.result!.length; i++)
                                          if (_getController.categoriesAllProductsModel.value.all != null && _getController.categoriesAllProductsModel.value.all!.length > i && _getController.categoriesAllProductsModel.value.all![i].result!.isNotEmpty)
                                            Stack(
                                                children: [
                                                  SizedBox(
                                                      height: 355.h,
                                                      width: Get.width,
                                                      child: SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          padding: EdgeInsets.only(left: 25.w, right: 15.w),
                                                          child: Row(
                                                              children: [
                                                                if (_getController.productsModel.value.result != null)
                                                                  for (int index = 0; index < _getController.categoriesAllProductsModel.value.all![i].result!.length; index++)
                                                                    InkWell(onTap: () => Get.to(DetailPage(id: _getController.categoriesAllProductsModel.value.all![i].result![index].id)), child: ProductItems(index: i, i: index, category: false))
                                                              ]
                                                          )
                                                      )
                                                  ),
                                                  Positioned(
                                                      child: Container(
                                                          margin: EdgeInsets.only(left: 25.w),
                                                          child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                TextSmall(text: _getController.categoriesAllProductsModel.value.all![i].result!.first.categoryName.toString(), color: Theme.of(context).colorScheme.onSurface),
                                                                const Spacer(),
                                                                TextButton(onPressed: () => Get.to(CategoryPage(id: _getController.categoriesAllProductsModel.value.all![i].result!.first.categoryId!.toInt(), open: 0)), child: TextSmall(text: 'Ko‘proq'.tr, color: AppColors.black70))
                                                              ]
                                                          )
                                                      )
                                                  )
                                                ]
                                            )
                                      ]
                                  ),
                                if (_getController.productsModel.value.result != null && _getController.productsModel.value.result!.isEmpty && _getController.categoriesAllProductsModel.value.all != null && _getController.categoriesAllProductsModel.value.all!.isNotEmpty)
                                  Container(
                                      height: Get.height * 0.3,
                                      width: Get.width,
                                      alignment: Alignment.center,
                                      child: TextSmall(text: 'Ma’lumotlar yo‘q'.tr, color: Theme.of(context).colorScheme.onSurface)
                                  ),
                                SizedBox(height: Get.height * 0.1)
                              ]
                          )
                              : Column(
                              children: [
                                SizedBox(height: 25.h),
                                SearchTextField(
                                  controller: _getController.searchController,
                                  //color: AppColors.grey.withOpacity(0.2),
                                  color: AppColors.grey.withAlpha(100),
                                  onChanged: (value) {
                                    _getController.clearCategoriesProductsModel();
                                    _getController.clearCategoriesAllProductsModel();
                                    _getController.clearProductsModel();
                                    if (_getController.searchController.text.isEmpty) {
                                      _getController.searchController.clear();
                                      _getController.refreshController.refreshCompleted();
                                      _getController.clearCategoriesProductsModel();
                                      _getController.clearCategoriesAllProductsModel();
                                      _getController.clearProductsModel();
                                      _getController.clearCategoriesModel();
                                      ApiController().getCategories();
                                    }
                                    //_getController.clearCategoriesAllProductsModel();
                                    _debounceTimer(() => search(value));
                                  },
                                ),
                                SizedBox(height: 15.h),
                                if (_getController.categoriesModel.value.result != null)
                                  SizedBox(
                                      width: Get.width,
                                      height: 82.h,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          padding: EdgeInsets.only(left: 10.w, right: 30.w),
                                          itemBuilder: (context, index) => InkWell(
                                              onTap: () => Get.to(CategoryPage(id: _getController.categoriesModel.value.result![index].id!.toInt(), open: 0)),
                                              child:  Container(
                                                  margin: EdgeInsets.only(left: 15.w),
                                                  padding: EdgeInsets.only(left: 6.w, right: 6.w),
                                                  decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(20.r)),
                                                  child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                            width: 40.w,
                                                            height: 38.w,
                                                            child: CacheImage(
                                                                url: _getController.categoriesModel.value.result![index].photoUrl.toString(),
                                                                keys: _getController.categoriesModel.value.result![index].id.toString()
                                                            )
                                                        ),
                                                        Container(margin: EdgeInsets.only(top: 5.h), width: 71.w, child: Center(child: _getController.categoriesModel.value.result != null ? TextSmall(text: _getController.categoriesModel.value.result![index].name.toString(), color: AppColors.white, maxLines: 1, fontSize: 11.sp, fontWeight: FontWeight.w600) : const SizedBox()))
                                                      ]
                                                  )
                                              )
                                          ),
                                          itemCount: _getController.categoriesModel.value.result != null ? _getController.categoriesModel.value.result!.length : 0,
                                          shrinkWrap: true
                                      )
                                  )
                                else
                                  const SkeletonCategory(),
                                for (int i = 0; i < 3; i++)
                                  const SkeletonProducts()
                              ]
                          )
                      )
                    ]))
            )
        )
    );
  }
}



class DebounceTimer {
  final int milliseconds;
  Timer? _timer;
  DebounceTimer({required this.milliseconds});
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
  void dispose() => _timer?.cancel();
}