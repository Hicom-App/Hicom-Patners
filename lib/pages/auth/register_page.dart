import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../companents/dropdown_item.dart';
import '../../companents/filds/text_large.dart';
import '../../companents/filds/text_small.dart';
import '../../companents/instrument/instrument_components.dart';
import '../../companents/text_fild.dart';
import '../../controllers/get_controller.dart';
import '../../resource/colors.dart';

class RegisterPage extends StatelessWidget{

  RegisterPage({super.key});

  final GetController _getController = Get.put(GetController());


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,surfaceTintColor: Colors.transparent,
          title: TextLarge(text: 'Ma’lumotlarni kiriting', color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500),
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back, size: Theme.of(context).iconTheme.fill), onPressed: () => Get.back()),
          actions: [
            IconButton(icon: Icon(Icons.language, size: Theme.of(context).iconTheme.fill), onPressed: () {
              InstrumentComponents().languageDialog(context);
            })
          ]
      ),
      body: Obx(() => SingleChildScrollView(
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.05),
                  TextFields(title: '${'Ism-familiyangizni kiriting'.tr}:',hintText: 'Kiriting'.tr, controller: _getController.nameController, maxLengthCharacters: 40),
                  SizedBox(height: Get.height * 0.02),
                  Padding(padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03), child:TextSmall(text: '${'Mamlakat'.tr}:', color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),fontWeight: FontWeight.w500)),
                  Container(
                    margin: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03, bottom: Get.height * 0.02, top: Get.height * 0.01),
                    child: DropdownItem(
                        title: _getController.dropDownItemsTitle.first,
                        onTap: () => {
                          showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              useSafeArea: true,
                              showWorldWide: false,
                              useRootNavigator: true,
                              favorite: ['UZ','RU','KZ','TJ','KG','AF'],
                              countryListTheme: CountryListThemeData(
                                  bottomSheetHeight: Get.height * 0.7,
                                  borderRadius: BorderRadius.circular(10),
                                  bottomSheetWidth: Get.width,
                                  flagSize: Get.width * 0.06,
                                  inputDecoration: InputDecoration(
                                      fillColor: AppColors.grey.withOpacity(0.1),
                                      filled: true,
                                      disabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      focusColor: AppColors.grey.withOpacity(0.1),
                                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
                                      contentPadding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                                      border: InputBorder.none,
                                      labelText: 'Mamlakatlarni qidirish'.tr,
                                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize),
                                      enabledBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.circular(10))
                                  )
                              ),
                              onSelect: (Country country) {
                                _getController.changeDropDownItemsTitle(0,country.name.toString());
                                if (_getController.dropDownItemsTitle[0] == 'Uzbekistan' || _getController.dropDownItemsTitle[0] == 'Uzbekistan') {
                                  //ApiController().getRegions(Tea.encryptTea('{"country_id": 1}', '50UvFayZ2w5u3O9B'),'regions');
                                } else {
                                  _getController.dropDownItems[0] = 0;
                                  _getController.dropDownItems[1] = 0;
                                  _getController.dropDownItems[2] = 0;
                                  _getController.dropDownItems[3] = 0;
                                  _getController.clearDistrictsModel();
                                  _getController.clearProvinceModel();
                                }
                                _getController.changeDropDownItemsTitle(0,country.name.toString());
                              }
                          ),
                          _getController.dropDownItems[0] = 0,
                          _getController.dropDownItems[1] = 0,
                          _getController.dropDownItems[2] = 0,
                          _getController.dropDownItems[3] = 0,
                          if (_getController.dropDownItemsTitle[0] == 'Uzbekistan' || _getController.dropDownItemsTitle[0] == 'Uzbekistan') {
                            //ApiController().getRegions(Tea.encryptTea('{"country_id": 1}', '50UvFayZ2w5u3O9B'),'regions')
                          },
                          Get.focusScope?.unfocus()
                        })
                  ),
                  if (_getController.dropDownItemsTitle[0] == 'Uzbekistan' && _getController.provinceModel.value.regions != null && _getController.provinceModel.value.regions!.isNotEmpty)
                    Padding(padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03), child:TextSmall(text: 'Viloyat'.tr, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),fontWeight: FontWeight.w500)),
                  if (_getController.dropDownItemsTitle[0] == 'Uzbekistan' && _getController.provinceModel.value.regions != null && _getController.provinceModel.value.regions!.isNotEmpty)
                    SizedBox(height: Get.height * 0.01),
                  if (_getController.dropDownItemsTitle[0] == 'Uzbekistan' && _getController.provinceModel.value.regions != null && _getController.provinceModel.value.regions!.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03,bottom: Get.height * 0.02),
                      child: DropdownItem(
                          title: _getController.provinceModel.value.regions![_getController.dropDownItems[0]].name.toString(),
                          onTap: () => {
                            InstrumentComponents().bottomBuildLanguageDialog(context,'Viloyat'.tr,0),
                            _getController.dropDownItems[1] = 0,
                            Get.focusScope?.unfocus()
                          })
                    ),
                  if (_getController.dropDownItemsTitle[0] == 'Uzbekistan' && _getController.districtsModel.value.districts != null && _getController.provinceModel.value.regions!.isNotEmpty)
                    Padding(padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03), child:TextSmall(text: 'Shaxar/Tuman'.tr, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),fontWeight: FontWeight.w500)),
                  if (_getController.dropDownItemsTitle[0] == 'Uzbekistan' && _getController.districtsModel.value.districts != null && _getController.provinceModel.value.regions!.isNotEmpty)
                    SizedBox(height: Get.height * 0.01),
                  if (_getController.dropDownItemsTitle[0] == 'Uzbekistan' && _getController.districtsModel.value.districts != null && _getController.provinceModel.value.regions!.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03,bottom: Get.height * 0.02),
                      child: DropdownItem(
                          title: _getController.districtsModel.value.districts![_getController.dropDownItems[1]].name.toString(),
                          onTap: () => {
                            InstrumentComponents().bottomBuildLanguageDialog(context,'Shaxar/Tuman'.tr,1),
                            Get.focusScope?.unfocus()
                          })
                    ),
                  Padding(padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03), child:TextSmall(text: '${'Foydalanuvchi turi'.tr}:', color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),fontWeight: FontWeight.w500)),
                  Container(
                    margin: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03,bottom: Get.height * 0.02,top: Get.height * 0.02),
                    child: DropdownItem(
                        title: _getController.dropDownItem[_getController.dropDownItems[2]].toString(),
                        onTap: () => {
                          InstrumentComponents().bottomBuildLanguageDialog(context,'Foydalanuvchi turi'.tr,2),
                          Get.focusScope?.unfocus(),
                        })
                  ),
                  SizedBox(height: Get.height * 0.05),
                  Container(
                      width: Get.width,
                      padding: EdgeInsets.only(left: Get.width * 0.03, right: Get.width * 0.03),
                      child: ElevatedButton(
                          onPressed: () => {
                            if (_getController.nameController.text.isEmpty) {
                              InstrumentComponents().showToast(context,'Xatolik'.tr, 'Ism-familiyangizni kiriting'.tr, true, 3)
                            } else if (_getController.dropDownItems[0] == 0 && _getController.dropDownItemsTitle[0] == 'Uzbekistan') {
                              InstrumentComponents().showToast(context,'Xatolik'.tr,'Viloyatni tanlang'.tr, true, 3)
                            } else if (_getController.dropDownItems[1] == 0 && _getController.dropDownItemsTitle[0] == 'Uzbekistan') {
                              InstrumentComponents().showToast(context,'Xatolik'.tr,'Shaxarni yoki Tumanni tanlang'.tr, true, 3)
                            } else{
                              //ApiController().signUp()
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: const TextSmall(text: 'Saqlash', color: AppColors.white, fontWeight: FontWeight.w500)
                      )
                  ),
                  SizedBox(height: Get.height * 0.01)
                ]
          )))
    );
  }
}