import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/product_item.dart';
import '../../companents/refresh_component.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

class DetailPage extends StatelessWidget {
  final int index;
  DetailPage({super.key, required this.index});

  final GetController _getController = Get.put(GetController());


  final List list = ['AI POE', 'NETWORK CABINET', 'HDD', 'PDU', 'CAMERA', 'ACSESSORIES', 'HDMI CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE'];
  final List listTitle = ['Jarayonda', 'Tasdiqlangan', 'To`langan','Rad etilgan'];
  final List listPrice = ['2 285 404', '224 614', '223 786', '1 272 102'];
  final List listColor = [AppColors.blue, AppColors.green, AppColors.primaryColor3, AppColors.red];
  final List listImage = ['https://hicom.uz/wp-content/uploads/2023/12/PS208-scaled-600x600.jpg', 'https://hicom.uz/wp-content/uploads/2024/01/8842-600x600.png', 'https://hicom.uz/wp-content/uploads/2024/01/PDU9.png', 'https://images.uzum.uz/ckf8u13k9fq8lb3a7vbg/original.jpg', 'https://hicom.uz/wp-content/uploads/2024/01/PDU9.png','https://www.prom.uz/_ipx/f_webp/https://devel.prom.uz/upload/product_gallery/aa/3d/aa3d9c672761627e46c43211aa19d720.jpg'];
  final List listImageName = ['PoE Switch', 'Network cabinet', 'PDU', 'PoE Switch', 'PoE Switch', 'PoE Switch', 'Network cabinet', 'PDU', 'HDD', 'camera',];
  final List listImagePrice = ['Hi-M82CM', 'HIFS-8842', 'Hi-PDU9', 'Hi-M42E', 'Hi-M82E', 'Hi-M82CM', 'HIFS-8842', 'Hi-PDU9', 'HDD', 'camera'];
  final List listStar = ['4.8 * 213 baxo', '4.1 * 344 baxo', '4.0 * 1022 baxo', '3.9 * 100 baxo', '4.8 * 213 baxo', '4.5 * 192 baxo', '2.8 * 100 baxo', '4.0 * 943 baxo', '4.1 * 402 baxo'];
  final List listCategoryIcon = ['https://img.icons8.com/?size=100&id=91076&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60947&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60988&format=png&color=475566', 'https://img.icons8.com/?size=100&id=67243&format=png&color=475566','https://img.icons8.com/?size=100&id=100062&format=png&color=475566','https://img.icons8.com/?size=100&id=108835&format=png&color=475566','https://img.icons8.com/?size=100&id=90412&format=png&color=475566','https://img.icons8.com/?size=100&id=60947&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60988&format=png&color=475566', 'https://img.icons8.com/?size=100&id=67243&format=png&color=475566','https://img.icons8.com/?size=100&id=59749&format=png&color=475566','https://img.icons8.com/?size=100&id=110322&format=png&color=475566','https://img.icons8.com/?size=100&id=90412&format=png&color=475566'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
        body: RefreshComponent(
            refreshController: _getController.refreshGuaranteeController,
            scrollController: _getController.scrollGuaranteeController,
            child: Column(
                children: [
                  SizedBox(
                      height: Get.height * 0.42,
                      width: Get.width,
                      child: Stack(
                          children: [
                            Positioned.fill(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), topLeft: Radius.circular(10.r)),
                                    child: FadeInImage(
                                        image: NetworkImage(listImage[index]),
                                        placeholder: NetworkImage(listImage[index]),
                                        imageErrorBuilder: (context, error, stackTrace) {return Container(decoration: BoxDecoration(image: const DecorationImage(image: NetworkImage('https://hicom.uz/wp-content/uploads/2024/01/24Pro-600x600.png'), fit: BoxFit.cover), borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))));},
                                        fit: BoxFit.cover
                                    )
                                )
                            ),
                            Positioned.fill(
                                child: Column(
                                    children: [
                                      AppBar(
                                          surfaceTintColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          foregroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
                                          backgroundColor: Colors.transparent,
                                          centerTitle: true,
                                          elevation: 0,
                                          title: TextLarge(text: listImageName[index], color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w500),
                                          actions: [
                                            IconButton(icon: Icon(Icons.share, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
                                            IconButton(icon: Icon(Icons.more_vert, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back())
                                          ]
                                      )
                                    ]
                                )
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: Get.width,
                                padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, -10), blurRadius: 10)]
                                )
                              )
                            )
                          ]
                      )
                  ),
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 10.h),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp,size: Theme.of(context).iconTheme.fill),
                              SizedBox(width: Get.width * 0.01),
                              TextSmall(text: listStar[index], color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w400, maxLines: 1, fontSize: 14),
                              const Spacer(),
                              Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.onSurface, size: Theme.of(context).iconTheme.fill)
                            ]
                          ),
                          SizedBox(height: Get.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextSmall(text: listImagePrice[index], color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.bold, maxLines: 2),
                              Container(
                                padding: EdgeInsets.only(left: Get.width * 0.04, right: Get.width * 0.04, top: 4.sp, bottom: 4.sp),
                                decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(10.r)),
                                child: Row(
                                  children: [
                                    Icon(Icons.gpp_good_sharp, color: AppColors.white, size: Theme.of(context).iconTheme.fill),
                                    SizedBox(width: Get.width * 0.01),
                                    TextSmall(text: '1 yil', color: AppColors.white, fontWeight: FontWeight.w500,fontSize: 14.sp)
                                  ]
                                )
                              )
                            ]
                          ),
                          SizedBox(height: Get.height * 0.02),
                          const TextSmall(text: 'Tavsif', color: AppColors.blue, fontWeight: FontWeight.bold),
                          Container(
                            width: Get.width,
                            height: 135.h,
                            padding: EdgeInsets.only(top: Get.height * 0.01, bottom: Get.height * 0.01),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 83.h,
                                  child: FadingEdgeScrollView.fromScrollView(
                                    gradientFractionOnEnd: 0.5,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: const NeverScrollableScrollPhysics(),
                                      controller: _getController.scrollControllerOk,
                                      itemBuilder: (context, index) => TextSmall(text: _getController.listImageInfo[index], color: RiveAppTheme.shadow, fontWeight: FontWeight.w400, maxLines: 1000, fontSize: 12),
                                      itemCount: _getController.listImageInfo.length
                                    )
                                  )
                                ),
                                InkWell(
                                  child: Row(
                                    children: [
                                      TextSmall(text: 'Batafsil', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, maxLines: 1),
                                      Icon(Icons.keyboard_arrow_down, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, size: Theme.of(context).iconTheme.fill)
                                    ]
                                  )
                                )
                              ]
                            )
                          ),
                          const Divider(color: Colors.grey, thickness: 1),
                          SizedBox(height: Get.height * 0.02),
                          const TextSmall(text: 'Xususiyatlari', color: AppColors.blue, fontWeight: FontWeight.bold),
                          Container(
                              width: Get.width,
                              height: 135.h,
                              padding: EdgeInsets.only(top: Get.height * 0.01, bottom: Get.height * 0.01),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 83.h,
                                    child: FadingEdgeScrollView.fromScrollView(
                                      gradientFractionOnEnd: 0.5,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        controller: _getController.scrollControllerOk,
                                        //itemBuilder: (context, index) => TextSmall(text: _getController.listImageInfo[index], color: RiveAppTheme.shadow, fontWeight: FontWeight.w400, maxLines: 1000, fontSize: 12),
                                        itemBuilder: (context, index) => Html(
                                          style: {
                                            'p': Style(
                                                textDecorationColor: Theme.of(context).colorScheme.error,
                                                padding: HtmlPaddings.symmetric(vertical: 0, horizontal: 0),
                                                fontSize: FontSize(12.sp), fontWeight: FontWeight.w400,
                                                color: Theme.of(context).colorScheme.onSurface
                                            )
                                          },
                                          data: '<h2>AI PoE коммутатор - Hi-F163B</h2><p><strong>Основные особенности данной модели:</strong></p><ul><li>AI Extend</li><li>Функция WATCHDOG</li><li>Защита от короткого замыкания</li><li>Грозозащита до 4 кВ</li><li>Поддерживает стандартный протокол 802.3af/at</li></ul><p><strong>Технические характеристики:</strong></p><ul><li>POE порты: 16 × 1000 Мбит/с</li><li>UPlink порты: 2 × 1000 Мбит/с</li><li>SFP порт: 1 × 1,25 Гбит/с</li><li>Пропускная способность: 38 Гбит/с</li><li>Максимальное расстояние: 250 метров</li><li>Источник питания: Встроенный DC52V, 240 Вт</li><li>Рабочая температура: от 0 до 40 °C</li><li>Габариты: 270мм × 180мм × 45мм</li></ul>'),
                                        itemCount: _getController.listImageInfo.length,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      child: Row(
                                        children: [
                                          TextSmall(text: 'Batafsil', color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, fontWeight: FontWeight.w400, maxLines: 1),
                                          Icon(Icons.keyboard_arrow_down, color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white, size: Theme.of(context).iconTheme.fill)
                                        ]
                                      )
                                  )
                                ]
                              )
                          ),
                          const Divider(color: Colors.grey, thickness: 1),
                          SizedBox(height: Get.height * 0.01),
                          const TextSmall(text: 'Baxolash', color: AppColors.blue, fontWeight: FontWeight.bold),
                          SizedBox(height: Get.height * 0.01),
                          RatingBar.builder(
                              initialRating: 3,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20.sp,
                              itemPadding: EdgeInsets.symmetric(horizontal: 5.sp),
                              unratedColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                              itemBuilder: (context, _) =>
                              const Icon(EneftyIcons.star_bold, color: AppColors.backgroundApp),
                              onRatingUpdate: (rating) {}
                          ),
                          Container(
                              margin: EdgeInsets.only(top: Get.height * 0.02),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextSmall(text: 'Tavsiya etiladi'.tr, color: Theme.of(context).colorScheme.onSurface),
                                    const Spacer(),
                                    TextButton(onPressed: () {}, child: TextSmall(text: 'Ko`proq'.tr, color: AppColors.blue),)
                                  ]
                              )
                          ),
                          SizedBox(
                              height: 200.h,
                              width: Get.width,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) => InkWell(
                                      onTap: () => Get.to(DetailPage(index: index)),
                                      child: ProductItem(index: index)
                                  ),
                                  itemCount: _getController.listImage.length
                              )
                          ),
                          SizedBox(height: Get.height * 0.1)
                        ]
                    ),
                  )
                ]
            )
        )
    );
  }
}