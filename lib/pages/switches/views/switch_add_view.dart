import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hicom_patners/pages/switches/controllers/switches_controller.dart';
import 'package:hicom_patners/pages/switches/controllers/scan_switch_controller.dart';
import 'package:hicom_patners/companents/filds/text_small.dart';
import 'package:hicom_patners/models/sample/project_model.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:hicom_patners/pages/switches/views/scan_switch_view.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SwitchAddView extends StatelessWidget {
  const SwitchAddView({super.key});

  @override
  Widget build(BuildContext context) {
    final SwitchesController switchesController = Get.find<SwitchesController>();
    final ScanSwitchController scanController = Get.find<ScanSwitchController>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController serialNumberController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final Rx<ProjectModel?> selectedProject = Rx<ProjectModel?>(switchesController.projects.isNotEmpty ? switchesController.projects.first : null); // Birinchi loyiha avtomatik tanlanadi
    final RxBool showProjectError = RxBool(false); // Loyiha tanlanmagan xato holati

    // Skaner natijasidan seriya raqamini avtomatik to'ldirish yoki demo raqam
    serialNumberController.text = scanController.scanHistory.isNotEmpty ? scanController.scanHistory.last.name : 'GPS208*****923LLOPQSA';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: TextSmall(text: 'Switchni qo‘shish', color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 18.sp),
        backgroundColor: AppColors.white
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        margin: EdgeInsets.only(bottom: 30.h),
        child: SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              showProjectError.value = selectedProject.value == null;
              if (formKey.currentState!.validate() && selectedProject.value != null) {
                Fluttertoast.showToast(msg: '${nameController.text} switchi ${selectedProject.value!.name} loyihasiga qo‘shildi, seriya raqami: ${serialNumberController.text}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: AppColors.blue, textColor: AppColors.white);
                Get.back();
              } else if (selectedProject.value == null) {
                Fluttertoast.showToast(msg: 'Iltimos, loyiha tanlang', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: AppColors.red, textColor: AppColors.white);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.blue,
              padding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: 16.sp),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))
            ),
            child: TextSmall(text: 'Saqlash', color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)
          )
        )
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSmall(text: 'Loyiha tanlang', color: AppColors.black, fontWeight: FontWeight.w600, fontSize: 16.sp),
                SizedBox(height: 8.h),
                Obx(() => DropdownMenu<ProjectModel>(
                  initialSelection: selectedProject.value,
                  onSelected: (ProjectModel? newValue) {
                    selectedProject.value = newValue;
                    showProjectError.value = false; // Tanlanganda xato yo'qoladi
                  },
                  requestFocusOnTap: true,
                  dropdownMenuEntries: switchesController.projects.map((project) {
                    return DropdownMenuEntry<ProjectModel>(
                      value: project,
                      label: project.name,
                      trailingIcon: selectedProject.value == project ? Icon(Icons.circle, color: AppColors.black, size: 10.sp) : Icon(Icons.circle, color: AppColors.grey, size: 10.sp),
                      style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)),
                          backgroundColor: WidgetStateProperty.resolveWith((states) {
                          if (selectedProject.value == project) {
                            return AppColors.greys;
                          }
                          return AppColors.white;
                        }),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))),
                        textStyle: WidgetStateProperty.resolveWith((states) => TextStyle(color: AppColors.black, fontSize: 14.sp, fontWeight: FontWeight.w500))
                      )
                    );
                  }).toList(),
                  width: MediaQuery.of(context).size.width - 32.w, // Boshqa maydonlar bilan bir xil en
                  menuHeight: 300.h,
                  inputDecorationTheme: InputDecorationTheme(
                    hintStyle: TextStyle(color: AppColors.black70, fontSize: 14.sp, fontWeight: FontWeight.w500),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.grey, width: 1.w)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.grey, width: 1.w)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.blue, width: 1.5.w)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.red, width: 1.w)),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.red, width: 1.5.w)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)
                  ),
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.white),
                    elevation: WidgetStateProperty.all(8),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r))),
                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h))
                  ),
                  textStyle: TextStyle(color: AppColors.black, fontSize: 14.sp, fontWeight: FontWeight.w500),
                  errorText: showProjectError.value ? 'Iltimos, loyiha tanlang' : null
                )),
                SizedBox(height: 16.h),
                // Qurilma nomi
                TextSmall(text: 'Qurilma nomi', color: AppColors.black, fontWeight: FontWeight.w600, fontSize: 16.sp),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Qurilma nomini kiriting',
                    hintStyle: TextStyle(color: AppColors.black70, fontSize: 14.sp, fontWeight: FontWeight.w500),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.grey, width: 1.w)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.grey, width: 1.w)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.blue, width: 1.5.w)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.red, width: 1.w)),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.red, width: 1.5.w)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Qurilma nomini kiriting';
                    }
                    return null;
                  }
                ),
                SizedBox(height: 16.h),
                // Qurilma seriya raqami (faqat o'qish uchun, skaner tugmasi ichida)
                TextSmall(text: 'Qurilma seriya raqami', color: AppColors.black, fontWeight: FontWeight.w600, fontSize: 16.sp),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: serialNumberController,
                  enabled: false, // Faqat o'qish uchun
                  decoration: InputDecoration(
                    hintText: 'Seriya raqami',
                    hintStyle: TextStyle(color: AppColors.black70, fontSize: 14.sp, fontWeight: FontWeight.w500),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.grey, width: 1.w)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.grey, width: 1.w)),
                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.grey, width: 1.w)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    suffixIcon: IconButton(onPressed: () => Get.to(() => ScanSwitchView(title: 'Switchni qoshish'.tr,)), icon: Icon(Iconsax.scan_barcode, color: AppColors.blue, size: 24.sp), tooltip: 'Qayta skaner qilish')
                  ),
                  style: TextStyle(color: AppColors.black, fontSize: 14.sp, fontWeight: FontWeight.w500)
                ),
                SizedBox(height: 16.h),
                // Qurilma paroli
                TextSmall(text: 'Qurilma paroli', color: AppColors.black, fontWeight: FontWeight.w600, fontSize: 16.sp),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Parolni kiriting',
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
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Parolni kiriting';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 100.h)
              ]
            )
          )
        )
      )
    );
  }
}