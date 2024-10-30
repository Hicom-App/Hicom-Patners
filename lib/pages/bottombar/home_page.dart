import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:hicom_patners/pages/home/category_page.dart';
import 'package:hicom_patners/pages/home/detail_page.dart';
import 'package:hicom_patners/pages/home/notification_page.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../companents/filds/search_text_field.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/home/skeleton_category.dart';
import '../../companents/home/skeleton_products.dart';
import '../../companents/product_item.dart';
import '../../companents/product_items.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../home/checks_page.dart';
import '../home/transfer_to_wallet.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    ApiController().getProfile(isWorker: false);
    ApiController().getCategories();
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Container(
            height: Get.height,
            width: Get.width,
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/home_fon.png'), fit: BoxFit.cover)),
            child: RefreshComponent(
                color: AppColors.white,
                scrollController: _getController.scrollController,
                refreshController: _getController.refreshController,
                onLoading: () async {
                  ApiController().getAllCatProducts();
                  _getController.refreshController.refreshCompleted();
                  _getController.refreshController.loadComplete();
                },
                onRefresh: () async {
                  _getController.refreshController.refreshCompleted();
                  _getController.clearCategoriesProductsModel();
                  _getController.clearProductsModel();
                  _getController.clearCategoriesModel();
                  ApiController().getCategories();
                },
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
                                    title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                              children: [
                                                TextLarge(text: _getController.fullName.value.toString().split(' ')[0].toString(), color: AppColors.white, fontWeight: FontWeight.bold, maxLines: 1),
                                                SizedBox(width: 5.w),
                                                TextLarge(text: _getController.fullName.value.toString().split(' ')[1].toString(), color: AppColors.white, fontWeight: FontWeight.w400, maxLines: 1)
                                              ]
                                          ),
                                          TextSmall(text: 'ID: ${_getController.id.value.toString()}', color: AppColors.white, fontWeight: FontWeight.w400, maxLines: 1)
                                        ]
                                    ),
                                    actions: [
                                      IconButton(icon: Icon(EneftyIcons.notification_bold, color: AppColors.white, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.to(() =>  NotificationPage()))
                                    ]
                                ),
                                Column(
                                    children: [
                                      TextSmall(text: 'Jami hisoblangan'.tr, color: AppColors.white, fontWeight: FontWeight.bold),
                                      TextLarge(text: _getController.profileInfoModel.value.result != null ? _getController.profileInfoModel.value.result!.first.cashbackCalculated.toString() : '0 ${'so‘m'.tr}',color: AppColors.white,fontWeight: FontWeight.bold)
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
                                              if(index == 1) {
                                                Get.to(() => TransferToWallet(index: index));
                                              }else if(index == 0) {
                                                Get.to(() => ChecksPage());
                                              }
                                            },
                                            child: Card(
                                                color: Theme.of(context).brightness == Brightness.dark ? AppColors.black : AppColors.white,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.r)),
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
                                                                TextSmall(
                                                                    text: _getController.profileInfoModel.value.result != null
                                                                        ? index == 0 ? _getController.profileInfoModel.value.result!.first.cashbackWaiting!.toString()
                                                                        : index == 1 ? _getController.profileInfoModel.value.result!.first.cashbackWithdrawn.toString()
                                                                        : _getController.profileInfoModel.value.result!.first.cashbackRejected.toString()
                                                                        : '0',
                                                                    color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 17.sp),
                                                                TextSmall(text: ' so‘m', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 17.sp)
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
                          decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? AppColors.black : AppColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)), boxShadow: [BoxShadow(color: Theme.of(context).brightness == Brightness.dark ? AppColors.black.withOpacity(0.3) : AppColors.black.withOpacity(0.3), spreadRadius: 3, blurRadius: 35, offset: const Offset(0, 0))]),
                          child: Column(
                              children: [
                                SizedBox(height: 25.h),
                                if (_getController.categoriesModel.value.result != null)
                                  SearchTextField(color: AppColors.grey.withOpacity(0.2))
                                else
                                  Skeletonizer(child: SearchTextField(color: AppColors.grey.withOpacity(0.2))),
                                SizedBox(height: 15.h),
                                if (_getController.categoriesModel.value.result != null)
                                  SizedBox(
                                    width: Get.width,
                                    height: 82.h,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.only(left: 10.w, right: 30.w),
                                        itemBuilder: (context, index) => InkWell(
                                            onTap: () => Get.to(CategoryPage(
                                              index: index,
                                            )),
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
                                                          child: FadeInImage(
                                                              image: NetworkImage(_getController.categoriesModel.value.result![index].photoUrl.toString(), headers: ApiController().headersBearer()),
                                                              placeholder: const AssetImage('assets/images/logo_back.png'),
                                                              imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/logo_back.png'), fit: BoxFit.cover)));},
                                                              fit: BoxFit.contain
                                                          )
                                                      ),
                                                      Container(
                                                          margin: EdgeInsets.only(top: 5.h),
                                                          width: 71.w,
                                                          child: Center(
                                                              child: _getController.categoriesModel.value.result != null
                                                                  ? TextSmall(text: _getController.categoriesModel.value.result![index].name.toString(),
                                                                  color: AppColors.white, maxLines: 1, fontSize: 11.sp, fontWeight: FontWeight.w600)
                                                                  : const SizedBox()
                                                          )
                                                      )
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
                                if (_getController.productsModel.value.result != null)
                                  Stack(
                                  children: [
                                    Positioned(
                                      child: Container(
                                          margin: EdgeInsets.only(left: 25.w, top: 10.h),
                                          child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                TextSmall(text: 'Tavsiya etiladi'.tr, color: Theme.of(context).colorScheme.onSurface),
                                                const Spacer(),
                                                TextButton(onPressed: () => Get.to(CategoryPage(index: 0)), child: TextSmall(text: 'Ko`proq'.tr, color: AppColors.grey.withOpacity(0.9)))
                                              ]
                                          )
                                      )
                                    ),
                                    SizedBox(
                                        height: 345.h,
                                        width: Get.width,
                                        child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                SizedBox(width: 35.w),
                                                if (_getController.productsModel.value.result != null)
                                                  for (int index = 0; index < _getController.productsModel.value.result!.length; index++)
                                                    InkWell(onTap: () => Get.to(DetailPage(id: _getController.productsModel.value.result![index].id)), child: ProductItem(index: index))
                                              ]
                                            )
                                        )
                                    )
                                  ]
                                )
                                else
                                  const SkeletonProducts(),
                                if (_getController.productsModel.value.result != null)
                                  Stack(
                                    children: [
                                      Positioned(
                                          child: Container(
                                              margin: EdgeInsets.only(left: 25.w, top: 10.h),
                                              child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    TextSmall(text: 'Barcha tovarlar'.tr, color: Theme.of(context).colorScheme.onSurface),
                                                    const Spacer(),
                                                    TextButton(onPressed: () => Get.to(CategoryPage(index: 0)), child: TextSmall(text: 'Ko`proq'.tr, color: AppColors.grey.withOpacity(0.9)))
                                                  ]
                                              )
                                          )
                                      ),
                                      SizedBox(
                                          height: 345.h,
                                          width: Get.width,
                                          child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                  children: [
                                                    SizedBox(width: 35.w),
                                                    if (_getController.productsModel.value.result != null)
                                                      for (int index = 0; index < _getController.productsModel.value.result!.length; index++)
                                                        InkWell(onTap: () => Get.to(DetailPage(id: _getController.productsModel.value.result![index].id)), child: ProductItem(index: index))
                                                  ]
                                              )
                                          )
                                      )
                                    ]
                                )
                                else
                                  const SkeletonProducts(),
                                if (_getController.categoriesProductsModel.value.all != null)
                                  Column(
                                    children: [
                                      for (int i = 0; i < _getController.categoriesModel.value.result!.length; i++)
                                        if (_getController.categoriesProductsModel.value.all != null && _getController.categoriesProductsModel.value.all!.length > i && _getController.categoriesProductsModel.value.all![i].result!.isNotEmpty)
                                          Stack(
                                            children: [
                                              SizedBox(
                                                height: 345.h,
                                                width: Get.width,
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 35.w),
                                                      if (_getController.productsModel.value.result != null)
                                                        for (int index = 0; index < _getController.productsModel.value.result!.length; index++)
                                                          InkWell(onTap: () => Get.to(DetailPage(id: _getController.categoriesProductsModel.value.all![i].result![index].id)), child: ProductItems(index: i , i: index))
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
                                                            TextSmall(text: _getController.getCategoryName(int.parse(_getController.categoriesModel.value.result![i].id.toString())), color: Theme.of(context).colorScheme.onSurface),
                                                            const Spacer(),
                                                            TextButton(onPressed: () => Get.to(CategoryPage(index: i)), child: TextSmall(text: 'Ko`proq'.tr, color: AppColors.grey.withOpacity(0.9)))
                                                          ]
                                                      )
                                                  )
                                              )
                                            ]
                                          )
                                    ]
                                  ),
                                SizedBox(height: Get.height * 0.1)
                              ]
                          )
                      )
                    ])
                )
            )
        )
    );
  }
}