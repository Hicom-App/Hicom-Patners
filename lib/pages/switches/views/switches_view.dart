import 'dart:ui';

import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../companents/custom_app_bar.dart';
import '../../../companents/filds/search_text_field.dart';
import '../../../controllers/dependency.dart';
import '../../../controllers/get_controller.dart';
import '../../../models/sample/project_model.dart';
import '../../../resource/colors.dart';
import '../../auth/login_page.dart';
import '../controllers/switches_controller.dart';
import '../widgets/switch_card.dart';

// Main Switches Page
class SwitchesView extends GetView<SwitchesController> {
  SwitchesView({super.key});
  final GetController _getController = Get.put(GetController());

  InputDecoration _getTextFieldDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.black70,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.grey, width: 1.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.grey, width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.blue, width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.red, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.red, width: 1.5.w),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }
  
  void _showAddProjectDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(context: context, builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: 26.r, horizontal: 26.r),
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: TextSmall(text: 'Yangi loyiha qo‘shish', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 17.sp),
        content: Form(
            key: formKey,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: Get.width),
                  TextFormField(
                      controller: nameController,
                      decoration: _getTextFieldDecoration('Loyiha nomi'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Loyiha nomini kiriting';
                        }
                        return null;
                      }
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(controller: descriptionController, decoration: _getTextFieldDecoration('Tavsif (ixtiyoriy)'), maxLines: 3)
                ]
            )
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: TextSmall(text: 'Bekor qilish', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12.sp)),
          TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) Get.back();
              },
              style: TextButton.styleFrom(
                  foregroundColor: AppColors.white,
                  backgroundColor: AppColors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))
              ),
              child: TextSmall(text: 'Saqlash', color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)
          )
        ]
    ));
  }

  Widget _buildComingSoonOverlay() {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.white.withAlpha(50), AppColors.greys.withAlpha(50)])),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Center(
          child: Container(
            margin: EdgeInsets.only(bottom: 100.h, left: 50.w, right: 50.w),
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(150),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white, width: 1.w),
              boxShadow: [BoxShadow(color: AppColors.grey.withAlpha(150), blurRadius: 20.r, spreadRadius: 0, offset: Offset(0, 10.h))]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.clock, size: 70.sp, color: AppColors.blue),
                SizedBox(height: 16.h),
                TextSmall(text: 'Ushbu bo‘lim tez kunda ishga tushadi!'.tr, color: AppColors.black, fontWeight: FontWeight.w600, fontSize: 18.sp, textAlign: TextAlign.center, maxLines: 2),
                SizedBox(height: 8.h),
                //TextSmall(text: 'Tez orada yangi funksiyalar bilan!'.tr, color: AppColors.black70, fontWeight: FontWeight.w400, fontSize: 14.sp, textAlign: TextAlign.center)
              ]
            )
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SwitchesController>()) Get.lazyPut(() => SwitchesController());
    return Scaffold(
      appBar: CustomAppBar(title: 'Switch Boshqaruvi'.tr, subtitle: 'Tarmoq kommutatorlarini boshqaring'.tr, isBack: false, isCenter: false, /*icon: Iconsax.folder_add,*/ suffixOnTap: () => _showAddProjectDialog(context), titleSize: 24.sp, subtitleSize: 15.sp),
      backgroundColor: Colors.grey[50],
      body: _getController.token !=null && _getController.token.isNotEmpty
          ? Obx(() => Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchTextField(
                          controller: _getController.searchController,
                          color: AppColors.grey.withOpacity(0.2),
                          onChanged: (value) {},
                          margin: 0
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 24),
                          itemCount: controller.projects.length,
                          itemBuilder: (context, index) {
                            final project = controller.projects[index];
                            final isExpanded = controller.expandedProjects.contains(project.id);
                            return ProjectCard(
                                project: project,
                                isExpanded: isExpanded,
                                onProjectTap: () => controller.navigateToProject(project.id),
                                onExpandTap: () => controller.toggleProject(project.id),
                                onSwitchTap: controller.navigateToSwitch
                            );
                          }
                      ),
                      const SizedBox(height: 100), // Bottom navigation space
                    ],
                  ),
                ),
              ),
              _buildComingSoonOverlay()
            ]
          ))
          : Container(
          width: Get.width,
          height: Get.height * 0.8,
          margin: EdgeInsets.only(bottom: 80.h),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextSmall(text: 'Ushbu bo‘limdan foydalanish uchun tizimga kiring.'.tr, color: AppColors.black, fontWeight: FontWeight.w400, maxLines: 10,fontSize: 16.sp, textAlign: TextAlign.center),
              SizedBox(height: 16.h),
              ElevatedButton(
                  onPressed: (){
                    _getController.logout();
                    Get.offAll(() => const LoginPage(),transition: Transition.fadeIn);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
                  child: TextSmall(text: 'Hisobga kirish'.tr, color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16.sp)
              )
            ]
          ))
    );
  }
}

class Watcher {String name;String phone;Watcher({required this.name, required this.phone});}


class OptionalPlusPrefixFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    text = text.replaceAll(RegExp(r'[^0-9+]'), '');
    if (text.isEmpty) return const TextEditingValue(text: '');
    if (text.startsWith('+')) {
      final digits = text.substring(1).replaceAll(RegExp(r'[^0-9]'), '');
      text = '+$digits';
    } else {
      text = '+${text.replaceAll(RegExp(r'[^0-9]'), '')}';
    }
    return TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}

class ProjectCard extends GetView<SwitchesController> {
  final ProjectModel project;
  final bool isExpanded;
  final VoidCallback onProjectTap;
  final VoidCallback onExpandTap;
  final Function(int) onSwitchTap;
  const ProjectCard({super.key, required this.project, required this.isExpanded, required this.onProjectTap, required this.onExpandTap, required this.onSwitchTap});

  InputDecoration _getTextFieldDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: AppColors.black70,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.grey, width: 1.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.grey, width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.blue, width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.red, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.red, width: 1.5.w),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }

  void _showEditProjectDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: project.name);
    final TextEditingController descriptionController = TextEditingController(text: project.description);
    final formKey = GlobalKey<FormState>();

    showDialog(context: context, builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: 26.r, horizontal: 26.r),
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: TextSmall(text: 'Loyihani tahrirlash', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 17.sp),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: Get.width),
              TextFormField(
                controller: nameController,
                decoration: _getTextFieldDecoration('Loyiha nomi'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Loyiha nomini kiriting';
                  }
                  return null;
                }
              ),
              SizedBox(height: 16.h),
              TextFormField(controller: descriptionController, decoration: _getTextFieldDecoration('Tavsif (ixtiyoriy)'), maxLines: 3)
            ]
          )
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: TextSmall(text: 'Bekor qilish', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12.sp)),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Get.back();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.blue,
              padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))
            ),
            child: TextSmall(text: 'Saqlash', color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)
          )
        ]
      ));
  }

  void _showWatchersDialog(BuildContext context) {
    final List<Watcher> initialWatchers = List.generate(10, (i) => Watcher(name: 'User ${i + 1}', phone: '+998 90 000 00 ${i.toString().padLeft(2, '0')}'));

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          insetPadding: EdgeInsets.symmetric(vertical: 26.r, horizontal: 26.r),
          alignment: Alignment.center,
          titlePadding: EdgeInsets.zero,   // 👈 bo‘shliqni olib tashlaydi
          contentPadding: EdgeInsets.zero, // 👈 bo‘shliqni olib tashlaydi
          title: Container(
              padding: EdgeInsets.only(top: 16.r,left: 16.r, right: 16.r),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16.r)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(text: 'Kuzatuvchilar', fontSize: 20.sp, fontWeight: FontWeight.w700),
                      IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close, color: Colors.grey[600]))
                    ]
                  ),
                  SizedBox(height: 12.r),
                  Divider(color: Colors.grey[300], thickness: 1)
                ]
              )
          ),
          backgroundColor: AppColors.white,
          content: StatefulBuilder(
            builder: (context, setState) {
              final List<Watcher> watchers = List<Watcher>.from(initialWatchers);
              Future<void> editWatcher(int index) async {
                final nameController = TextEditingController(text: watchers[index].name);
                final phoneController = TextEditingController(text: watchers[index].phone);
                await showDialog(
                  context: context,
                  useSafeArea: true,
                  builder: (context) => AlertDialog(
                    insetPadding: EdgeInsets.symmetric(vertical: 36.r, horizontal: 36.r),
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                    title: TextSmall(text: 'Tahrirlash', fontSize: 18.sp, fontWeight: FontWeight.w700),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: _getTextFieldDecoration('Ism'),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: phoneController,
                          decoration: _getTextFieldDecoration('Telefon'),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [OptionalPlusPrefixFormatter()],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(),
                          child: TextSmall(text: 'Bekor qilish', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12.sp)
                      ),
                      TextButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                              foregroundColor: AppColors.blue,
                              backgroundColor: AppColors.blue,
                              padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                          ),
                          child: TextSmall(text: 'Saqlash', color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)
                      )
                    ],
                  ),
                );
              }
              Future<void> confirmDelete(int index) async {
                final confirmed = await showDialog<bool>(context: context, builder: (context) =>
                    AlertDialog(
                      backgroundColor: AppColors.white,
                      insetPadding: EdgeInsets.symmetric(vertical: 36.r, horizontal: 36.r),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      title: TextSmall(text: 'O‘chirishni tasdiqlash', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 17.sp),
                      content: TextSmall(text: '${watchers[index].name} nomli kuzatuvchini o‘chirishni tasdiqlaysizmi?', color: AppColors.black70, fontWeight: FontWeight.bold, fontSize: 12.sp, maxLines: 3),
                      actions: [
                        TextButton(
                            onPressed: () => Get.back(),
                            child: TextSmall(text: 'Bekor qilish', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12.sp)
                        ),
                        TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                                foregroundColor: AppColors.red,
                                backgroundColor: AppColors.red,
                                padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                            ),
                            child: TextSmall(text: 'O‘chirish', color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)
                        )
                      ]
                  )) ?? false;
                if (confirmed) {
                  setState(() => watchers.removeAt(index));
                }
              }
              return Container(
                width: Get.width,
                height: Get.height * 0.5,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
                child: watchers.isEmpty
                    ? Center(child: TextSmall(text: 'Kuzatuvchilar topilmadi', fontSize: 14.sp))
                    : ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  itemCount: watchers.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.r),
                  padding: EdgeInsets.symmetric(vertical: 16.r),
                  itemBuilder: (context, index) {
                    final w = watchers[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.r),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [BoxShadow(color: AppColors.greys, blurRadius: 15.r, spreadRadius: 5.r, offset: const Offset(0, 0))]
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
                        leading: Icon(EneftyIcons.profile_2user_bold, color: AppColors.black70, size: 24.sp),
                        title: TextSmall(text: w.name, color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16.sp),
                        subtitle: TextSmall(text: w.phone, color: AppColors.black70, fontWeight: FontWeight.bold, fontSize: 14.sp),
                        onTap: () {},
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Tahrirlash',
                              onPressed: () => editWatcher(index),
                              icon: Icon(Iconsax.edit, size: 20.sp, color: Colors.blue),
                            ),
                            IconButton(
                              tooltip: 'O‘chirish',
                              onPressed: () => confirmDelete(index),
                              icon: Icon(Icons.delete, size: 20.sp, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showContextMenu(BuildContext context, Offset position) async {
    final RenderBox cardRenderBox = context.findRenderObject() as RenderBox;
    final cardPosition = cardRenderBox.localToGlobal(Offset.zero);
    final cardSize = cardRenderBox.size;

    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    // Menyuni kartaning o'ng tomonida ko'rsatish
    final menuWidth = 270.w; // Menyu kengligi
    final menuPosition = RelativeRect.fromLTRB(cardPosition.dx + cardSize.width - menuWidth, cardPosition.dy + 20.h, cardPosition.dx + cardSize.width, 0);

    final result = await showMenu(
      context: context,
      position: menuPosition,
      shadowColor: AppColors.black,
      elevation: 12,
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 20.sp),
            child: Row(
              children: [
                Icon(EneftyIcons.edit_2_bold, size: 20.sp, color: AppColors.blue),
                SizedBox(width: 16.w),
                Text('Tahrirlash', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.black))
              ]
            )
          )
        ),
        PopupMenuItem(
          value: 'share',
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 20.sp),
            child: Row(
              children: [
                Icon(Iconsax.share, size: 20.sp, color: AppColors.blue),
                SizedBox(width: 16.w),
                Text('Ulashish', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.black))
              ]
            )
          )
        ),
        PopupMenuItem(
          value: 'watchers',
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 20.sp),
            child: Row(
              children: [
                Icon(Iconsax.profile_2user, size: 20.sp, color: AppColors.blue),
                SizedBox(width: 16.w),
                Text('Kuzatuvhchilar', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.black))
              ]
            )
          )
        ),
        PopupMenuItem(
          value: 'delete',
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 20.sp),
            child: Row(
              children: [
                Icon(Iconsax.trash, size: 20.sp, color: AppColors.red),
                SizedBox(width: 16.w),
                Text('O‘chirish', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.red))
              ]
            )
          )
        )
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: AppColors.white.withOpacity(0.98),
      constraints: BoxConstraints(minWidth: menuWidth, maxWidth: menuWidth)
    );

    // O'chirishni tasdiqlash dialogi
    void showDeleteConfirmation(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              title: TextSmall(text: 'O‘chirishni tasdiqlash', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 17.sp),
              content: TextSmall(text: '${project.name} loyihasini o‘chirishni xohlaysizmi?', color: AppColors.black70, fontWeight: FontWeight.bold, fontSize: 12.sp, maxLines: 3),
              actions: [
                TextButton(
                    onPressed: () => Get.back(),
                    child: TextSmall(text: 'Bekor qilish', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12.sp)
                ),
                TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.red,
                        backgroundColor: AppColors.red,
                        padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                    ),
                    child: TextSmall(text: 'O‘chirish', color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)
                )
              ]
          )
      );
    }

    // Ulashish funksiyasi
    void shareProject(BuildContext context) {
      final TextEditingController phoneController = TextEditingController();
      final TextEditingController nameController = TextEditingController();
      final formKey = GlobalKey<FormState>();
      showDialog(context: context, builder: (context) => AlertDialog(
          insetPadding: EdgeInsets.symmetric(vertical: 26.r, horizontal: 26.r),
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: TextSmall(text: 'Loyihani ulashish', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 17.sp),
          content: Form(
              key: formKey,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: Get.width),
                    TextFormField(
                      controller: phoneController,
                      decoration: _getTextFieldDecoration('Telefon raqami'),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        OptionalPlusPrefixFormatter(),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty || value == '+') {
                          return 'Telefon raqamini kiriting';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16.h),
                    TextFormField(
                        controller: nameController,
                        decoration: _getTextFieldDecoration('Ism'),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.name,
                        inputFormatters: [PhoneInputFormatter(allowEndlessPhone: true)],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Telefon raqamini kiriting';
                          }
                          return null;
                        })
                  ]
              )
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: TextSmall(text: 'Bekor qilish', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 12.sp)),
            TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Get.back();
                    Fluttertoast.showToast(msg: '${phoneController.text} raqami bilan loyiha ulanadi', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: AppColors.blue, textColor: AppColors.white);
                  }
                },
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.white,
                    backgroundColor: AppColors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))
                ),
                child: TextSmall(text: 'Yuborish', color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)
            )
          ]
      ));
    }


    // Tanlangan menyu opsiyasiga qarab harakat
    switch (result) {
      case 'edit':
        _showEditProjectDialog(context);
        break;
      case 'delete':
        showDeleteConfirmation(context);
        break;
      case 'watchers':
        _showWatchersDialog(context);
        break;
      case 'share':
        shareProject(context);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) => _showContextMenu(context, details.globalPosition),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: AppColors.greys, blurRadius: 15.r, spreadRadius: 5.r, offset: const Offset(0, 0))]
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onProjectTap,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(width: 64, height: 64, padding: const EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.greys.withAlpha(100)), child: Icon(Iconsax.folder, color: AppColors.grey, size: 32.sp)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(project.name, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 16.sp)),
                                  const SizedBox(height: 2),
                                  Text(project.description, style: TextStyle(fontSize: 14.sp, color: AppColors.black70))
                                ]
                              )
                            )
                          ]
                        )
                      )
                    )
                  ),
                  TextButton.icon(
                    onPressed: onExpandTap,
                    style: TextButton.styleFrom(iconColor: AppColors.blue, overlayColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.r)))),
                    icon: AnimatedRotation(turns: isExpanded ? 0.5 : 0, duration: const Duration(milliseconds: 200), child: Icon(Icons.keyboard_arrow_down, color: AppColors.black70, size: 20)),
                    iconAlignment: IconAlignment.end,
                    label: Text('${project.switchCount} Qurilma', style: TextStyle(fontSize: 14.sp, color: AppColors.blue)),
                  )
                ]
              )
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isExpanded ? Container(
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[100]!))),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  itemCount: project.switches.length,
                  itemBuilder: (context, index) {
                    final switchItem = project.switches[index];
                    return InkWell(onTap: () => controller.navigateToSwitch(switchItem.id), child: SwitchCard(switchModel: switchItem, onTap: () => controller.navigateToSwitch(switchItem.id), isSwitchExpanded: false));
                  })
              ) : const SizedBox.shrink()
            )
          ]
        )
      )
    );
  }
}