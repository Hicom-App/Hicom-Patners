import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:intl/intl.dart';
import '../../companents/refresh_component.dart';
import '../../companents/skletons/report_page_skleton.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import 'checks_detail.dart';

class ChecksPage extends StatelessWidget {
  ChecksPage({super.key});

  final GetController _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => _getController.sortedTransactionsModel.value.result != null
            ? Column(
            children: [
              Container(width: Get.width, height: Get.height * 0.431,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.r), bottomRight: Radius.circular(25.r)), image: const DecorationImage(image: AssetImage('assets/images/bar.png'), fit: BoxFit.cover), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 25.r, spreadRadius: 30.r, offset: const Offset(0, 0))]),
                  child: Column(
                      children: [
                        AppBar(backgroundColor: Colors.transparent, elevation: 0, title: TextSmall(text: 'Hisobotlar'.tr, color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 20.sp)),

                        //var listMonth = [
                        //     {'name':'Yanvar', 'selected': true},
                        //     {'name':'Fevral', 'selected': false},
                        //     {'name':'Mart', 'selected': false},
                        //     {'name':'Aprel', 'selected': false},
                        //     {'name':'May', 'selected': false},
                        //     {'name':'Iyun', 'selected': false},
                        //     {'name':'Iyul', 'selected': false},
                        //     {'name':'Avgust', 'selected': false},
                        //     {'name':'Sentabr', 'selected': false},
                        //     {'name':'Oktabr', 'selected': false},
                        //     {'name':'Noyabr', 'selected': false},
                        //     {'name':'Dekabr', 'selected': false}].obs;
                        SizedBox(
                            width: Get.width,
                            height: Get.height * 0.025,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _getController.listMonth.length,
                                padding: EdgeInsets.only(left: 20.w),
                                itemBuilder:(context, index) => InkWell(
                                    onTap: () => _getController.changeSelectedMonth(index),
                                    child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 14.w),
                                        padding: EdgeInsets.only(left: 19.w, right: 19.w),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), border: Border.all(width: 1.5.w, color: AppColors.white), color: _getController.listMonth[index]['selected'] == true ? AppColors.white : Theme.of(context).brightness == Brightness.light ? AppColors.blackTransparent : AppColors.grey.withOpacity(0.2)),
                                        child: TextSmall(
                                            text: _getController.listMonth[index]['name'].toString(),
                                            color: _getController.listMonth[index]['selected'] == true ? AppColors.red : AppColors.white, fontWeight: FontWeight.w500, maxLines: 1,fontSize: 12.sp)
                                    )
                                )
                            )
                        ),
                        Container(
                            width: Get.width,
                            height: Get.height * 0.1,
                            margin: EdgeInsets.only(top: Get.height * 0.03, left: 15.w, right: 15.w),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width: Get.width * 0.43,
                                      height: Get.height * 0.1,
                                      decoration: BoxDecoration(color:AppColors.blue, borderRadius: BorderRadius.all(Radius.circular(15.r))),
                                      child: Container(
                                          height: Get.height * 0.1,
                                          margin: EdgeInsets.only(right: 10.w),
                                          padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r),bottomLeft: Radius.circular(15.r),topRight: Radius.circular(5.r), bottomRight: Radius.circular(5.r))),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextSmall(text: 'Hisoblangan'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp),
                                                SizedBox(height: 4.h),
                                                Row(
                                                    children: [
                                                      TextSmall(text: _getController.profileInfoModel.value.result!.first.cashbackRemain.toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                      TextSmall(text: '.00 so‘m'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 11.sp),
                                                    ]
                                                ),
                                                SizedBox(height: 4.h),
                                                Row(
                                                    children: [
                                                      TextSmall(text: _getController.sortedTransactionsModel.value.result!.length.toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                      SizedBox(width: 5.w),
                                                      TextSmall(text: 'ta'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                    ]
                                                )
                                              ]
                                          )
                                      )
                                  ),
                                  Container(
                                      width: Get.width * 0.43,
                                      height: Get.height * 0.1,
                                      decoration: BoxDecoration(color:AppColors.red, borderRadius: BorderRadius.all(Radius.circular(20.r))),
                                      child: Container(
                                          height: Get.height * 0.1,
                                          margin: EdgeInsets.only(left: 10.w),
                                          padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(5.r),bottomLeft: Radius.circular(5.r),topRight: Radius.circular(15.r), bottomRight: Radius.circular(15.r))),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                TextSmall(text: 'Rad etilgan'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp),
                                                SizedBox(height: 4.h),
                                                Row(
                                                    children: [
                                                      TextSmall(text: _getController.profileInfoModel.value.result!.first.cashbackRejected.toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                      TextSmall(text: '.00 so‘m'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 11.sp),
                                                    ]
                                                ),
                                                SizedBox(height: 4.h),
                                                Row(
                                                    children: [
                                                      TextSmall(text: '0'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                      SizedBox(width: 5.w),
                                                      TextSmall(text: 'ta'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                    ]
                                                )
                                              ]
                                          )
                                      )
                                  )
                                ]
                            )
                        ),
                        Container(
                          width: Get.width,
                          margin: EdgeInsets.only(top: 20.h, left: 15.w, right: 15.w),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: Get.width * 0.43,
                                    height: Get.height * 0.1,
                                    decoration: BoxDecoration(color:AppColors.primaryColor, borderRadius: BorderRadius.all(Radius.circular(15.r))),
                                    child: Container(
                                        height: Get.height * 0.1,
                                        margin: EdgeInsets.only(right: 10.w),
                                        padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r),bottomLeft: Radius.circular(15.r),topRight: Radius.circular(5.r), bottomRight: Radius.circular(5.r))),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TextSmall(text: 'Jarayonda'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp),
                                              SizedBox(height: 4.h),
                                              Row(
                                                  children: [
                                                    TextSmall(text: _getController.profileInfoModel.value.result!.first.cashbackWaiting.toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                    TextSmall(text: '.00 so‘m'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 11.sp),
                                                  ]
                                              ),
                                              SizedBox(height: 4.h),
                                              Row(
                                                  children: [
                                                    TextSmall(text: _getController.sortedTransactionsModel.value.result!.length.toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                    SizedBox(width: 5.w),
                                                    TextSmall(text: 'ta'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                  ]
                                              )
                                            ]
                                        )
                                    )
                                ),
                                Container(
                                    width: Get.width * 0.43,
                                    height: Get.height * 0.1,
                                    decoration: BoxDecoration(color:AppColors.green, borderRadius: BorderRadius.all(Radius.circular(15.r))),
                                    child: Container(
                                        height: Get.height * 0.1,
                                        margin: EdgeInsets.only(left: 10.w),
                                        padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(5.r),bottomLeft: Radius.circular(5.r), topRight: Radius.circular(15.r), bottomRight: Radius.circular(15.r))),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TextSmall(text: 'To`langan'.tr, color: AppColors.black, fontWeight: FontWeight.w500, fontSize: 11.sp),
                                              SizedBox(height: 4.h),
                                              Row(
                                                  children: [
                                                    TextSmall(text: _getController.profileInfoModel.value.result!.first.cashbackWithdrawn.toString(), color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                    TextSmall(text: '.00 so‘m'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 11.sp),
                                                  ]
                                              ),
                                              SizedBox(height: 4.h),
                                              Row(
                                                  children: [
                                                    TextSmall(text: '0'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                    SizedBox(width: 5.w),
                                                    TextSmall(text: 'ta'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                  ]
                                              )
                                            ]
                                        )
                                    )
                                )
                              ]
                          ),
                        )
                      ]
                  )
              ),
              SizedBox(
                  width: Get.width,
                  height: Get.height * 0.54,
                  child: RefreshComponent(
                      scrollController: _getController.scrollReportController,
                      refreshController: _getController.refreshReportController,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                          shrinkWrap: true,
                          itemCount: _getController.sortedTransactionsModel.value.result?.length ?? 0,
                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 13.h, bottom: 100.h),
                          itemBuilder: (context, index) {
                            var transactionGroup = _getController.sortedTransactionsModel.value.result![index];
                            var resultsList = transactionGroup.results;
                            return Column(
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h),
                                      child: TextSmall(
                                          text: transactionGroup.date != null ? (DateTime.parse(transactionGroup.date!).day == DateTime.now().day ? 'Bugun'.tr : DateTime.parse(transactionGroup.date!).day == DateTime.now().subtract(const Duration(days: 1)).day ? 'Kecha'.tr : DateFormat.yMMMd().format(DateTime.parse(transactionGroup.date!))) : '',
                                          color: AppColors.black.withOpacity(0.4),
                                          fontWeight: FontWeight.w400
                                      )
                                  ),
                                  for (var transaction in resultsList ?? [])
                                    GestureDetector(
                                        onTap: () => Get.to(() => ChecksDetail(
                                          id: transaction.id,
                                          cardId: transaction.cardId,
                                          operation: int.parse(transaction.operation.toString()),
                                          dateCreated: transaction.dateCreated,
                                          name: transaction.lastName,
                                          firstName: transaction.firstName,
                                          amount: transaction.amount,
                                          description: transaction.description,
                                        ), arguments: transaction),
                                        child: Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h),
                                            padding: EdgeInsets.only(right: 5.w, top: 5.h, bottom: 6.h, left: 5.w),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: AppColors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 15.r, spreadRadius: 10.r, offset: const Offset(0, 0))]),
                                            child: Column(
                                                children: [
                                                  Container(
                                                      width: Get.width,
                                                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                                      child: TextSmall(text: transaction.operation == 0  ? 'Keshbek'.tr : transaction.operation == 1 ? 'Bank kartalari'.tr : 'Hisobga olish'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 13.sp)
                                                  ),
                                                  Container(
                                                      width: Get.width,
                                                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                                      child: Row(
                                                          children: [
                                                            TextSmall(
                                                                text: '${transaction.operation == 0 || transaction.operation == 0 ? 'Balansni to‘ldirish'.tr : transaction.firstName + ' ' + transaction.lastName}',
                                                                color: transaction.amount != null && transaction.amount! < 0 ? AppColors.red : Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                            const Spacer(),
                                                            TextSmall(text: transaction.amount?.toString() ?? '0', color: transaction.amount != null && transaction.amount! < 0 ? AppColors.red : Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                            TextSmall(text: '.00'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
                                                            SizedBox(width: 5.w),
                                                            TextSmall(text: 'so‘m'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 12.sp)
                                                          ]
                                                      )
                                                  ),
                                                  Container(
                                                      width: Get.width,
                                                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                                      child: Row(
                                                          children: [
                                                            TextSmall(text : transaction.dateCreated != null ? DateFormat.Hm().format(DateTime.parse(transaction.dateCreated!)) : '', color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 10.sp),
                                                            const Spacer(),
                                                            Container(
                                                                margin: EdgeInsets.only(top: 3.h, right: 5.w),
                                                                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.r), color:transaction.operation == 0 ? AppColors.blue : transaction.operation == 1 ? AppColors.primaryColor : transaction.operation == 2 ? AppColors.green : AppColors.red),
                                                                child: TextSmall(text:transaction.operation == 0 ? 'Qabul qilindi': transaction.operation == 1 ? 'Jarayonda'.tr : transaction.operation == 2 ? 'To‘landi'.tr : 'Rad etildi'.tr, color: AppColors.white, fontWeight: FontWeight.w400, fontSize: 10.sp)
                                                            )
                                                          ]
                                                      )
                                                  )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            );
                          }
                      )
                  )
              )
              /*SizedBox(
                      width: Get.width,
                      height: Get.height * 0.54,
                      child: RefreshComponent(
                      scrollController: _getController.scrollReportController,
                      refreshController: _getController.refreshReportController,
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(), // Scrollni o'chiradi
                          shrinkWrap: true,
                          itemCount: _getController.listImagePrice.length,
                          padding: EdgeInsets.only(left: 10.w, right: 10.w,top: 13.h, bottom: 100.h),
                          itemBuilder:(context, index) => GestureDetector(
                              onTap: () => Get.to(() => const ChecksDetail(), arguments: _getController.listImagePrice[index]),
                              child: Column(
                                  children: [
                                    index == 0 || index == 2 || index == 3 || index == 6 || index == 13
                                        ? Container(padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h), child: TextSmall(text: index == 0 ? 'Bugun' : index == 2 ? 'Kecha' : index == 3 ? '15 Sentabr' : index == 6 ? '10 Sentabr' : '5 Sentabr', color: Theme.of(context).brightness == Brightness.light ? AppColors.black.withOpacity(0.4) : AppColors.white.withOpacity(0.6), fontWeight: FontWeight.w400),)
                                        : Container(),
                                    Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 12.h),
                                        padding: EdgeInsets.only(right: 5.w, top: 5.h, bottom: 6.h, left: 5.w),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.r),
                                            color: AppColors.white,
                                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 15.r, spreadRadius: 10.r, offset: const Offset(0, 0))]
                                        ),
                                        child: Column(
                                            children: [
                                              Container(
                                                width: Get.width,
                                                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                                child: index == 0 ? TextSmall(text: 'Bank kartalari', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,fontWeight: FontWeight.w400, fontSize: 13.sp)
                                                    : index == 1 ? TextSmall(text: 'Keshbek', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 13.sp)
                                                    : index == 2 ? TextSmall(text: 'Bank Kartalari', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 13.sp)
                                                    : TextSmall(text: 'Keshbek', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 10.sp),
                                              ),
                                              Container(
                                                  width: Get.width,
                                                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                                  child: Row(
                                                      children: [
                                                        index == 0 ? TextSmall(text: _getController.listNames[index], color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold)
                                                            : index == 2 ? TextSmall(text: _getController.listNames[index], color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold)
                                                            : TextSmall(text: 'Balansni to`ldirish', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold),
                                                        const Spacer(),
                                                        Row(
                                                            children: [
                                                              TextSmall(text: _getController.listNamesPay[index], color: _getController.listNamesPay[index].contains('-') ? AppColors.red : Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                              TextSmall(text: '.00'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
                                                              SizedBox(width: 5.w),
                                                              TextSmall(text: 'so‘m'.tr, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, fontSize: 12.sp)
                                                            ]
                                                        )
                                                      ]
                                                  )
                                              ),
                                              Container(
                                                  width: Get.width,
                                                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                                  child:Row(
                                                      children: [
                                                        TextSmall(text: _getController.listNamesDay[index], color: AppColors.black, fontWeight: FontWeight.w400, fontSize: 10.sp),
                                                        const Spacer(),
                                                        Container(
                                                            margin: EdgeInsets.only(top: 3.h,right: 5.w),
                                                            padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.r), color: index == 0 ? AppColors.green : index == 1 ? AppColors.red : index == 2 ? AppColors.primaryColor : AppColors.blue),
                                                            child: TextSmall(text: index == 0 ? 'To`landi'.tr : index == 1 ? 'Rad etildi'.tr : index == 2 ? 'Jarayonda'.tr : 'Qabul qilindi'.tr, color: AppColors.white, fontWeight: FontWeight.w400, fontSize: 10.sp)
                                                        )
                                                      ]
                                                  )
                                              )
                                            ]
                                        )
                                    )
                                  ]
                              )
                          )
                      )
                  )
                  )*/
            ]
        )
            : const ReportPageSkleton()
        )
    );
  }
}