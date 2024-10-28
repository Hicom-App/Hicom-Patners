import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hicom_patners/pages/bottombar/guarantee_page.dart';
import 'package:hicom_patners/pages/bottombar/report_page.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../companents/instrument/shake_widget.dart';
import '../models/auth/countries_model.dart';
import '../models/sample/categories.dart';
import '../models/sample/profile_info_model.dart';
import '../pages/bottombar/account_page.dart';
import '../pages/bottombar/home_page.dart';
import '../resource/colors.dart';

class GetController extends GetxController {
  var fullName = 'Dilshodjon Haydarov'.obs;
  var id = 1209098100.obs;
  var height = 0.0.obs;
  var width = 0.0.obs;
  RxBool back = true.obs;
  var code = '+998'.obs;
  RxString countryCode = ''.obs;
  RxList<int> dropDownItems = <int>[0, 0, 0, 0].obs;
  RxList<String> dropDownItemsCountries = <String>[].obs;
  RxList<String> dropDownItemsRegions = <String>[].obs;
  RxList<String> dropDownItemsCities = <String>[].obs;
  RxList<String> dropDownItem = <String>['Sotuvchi'.tr, 'O‘rnatuvchi'.tr, 'Buyurtmachi'.tr].obs;
  RxList<bool> errorInput = <bool>[false, false, false, false, false, false, false].obs;
  RxBool whileApi = true.obs;
  RxBool errorField = false.obs;
  RxBool errorFieldOk = false.obs;
  var hasFingerprint = false.obs;
  var hasFaceID = false.obs;
  Timer? _timerTap;
  Timer? _timer;
  var image = File('').obs;
  RxString firstPasscode = ''.obs;
  RxString enteredPasscode = ''.obs;
  RxBool isCreatingPasscode = true.obs;

  final qrKey = GlobalKey(debugLabel: 'QR');
  var result = Rxn<Barcode>();
  QRViewController? controller;
  RxBool isLampOn = false.obs;
  var cameraFacing = CameraFacing.back.obs;

  void setHeightWidth(BuildContext context) {
    height.value = MediaQuery.of(context).size.height;
    width.value = MediaQuery.of(context).size.width;
  }

  void tapTimes(Function onTap, int sec) {
    if (_timerTap != null) stopTimerTap();
    _timerTap = Timer(Duration(seconds: sec), () {
      onTap();
      _timerTap = null;
    });
  }

  //errorInput index change value
  void changeErrorInput(int index, bool value) {
    errorInput[index] = value;
    update();
  }

  void onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    controller?.scannedDataStream.listen((scanData) {
      result.value = scanData;
      if (scanData.code != null) {
        codeController.text = scanData.code.toString();
        controller?.pauseCamera();
        Get.back();
      }
    });
  }

  void reassembleCamera() {
    if (GetPlatform.isAndroid) {
      controller?.pauseCamera();
    } else if (GetPlatform.isIOS) {
      controller?.resumeCamera();
    }
  }

  void toggleLamp() {
    isLampOn.value = !isLampOn.value;
    controller?.toggleFlash();
  }

  void toggleCamera() {
    if (cameraFacing.value == CameraFacing.back) {
      cameraFacing.value = CameraFacing.front;
    } else {
      cameraFacing.value = CameraFacing.back;
    }
    controller?.flipCamera();
  }

  void changeDropDownItems(int index, int newValue) {
    if (index >= 0 && index < dropDownItems.length) dropDownItems[index] = newValue;
  }

  void changeDropDownItemsCountries(int index, String newValue) {
    if (index >= 0 && index < dropDownItemsCountries.length) dropDownItemsCountries[index] = newValue;
    update();
  }

  void changeDropDownItemsRegions(int index, String newValue) {
    if (index >= 0 && index < dropDownItemsRegions.length) dropDownItemsRegions[index] = newValue;
    update();
  }

  void changeDropDownItemsDistricts(int index, String newValue) {
    if (index >= 0 && index < dropDownItemsCities.length) dropDownItemsCities[index] = newValue;
    update();
  }

  String getLanguage() {
    if (GetStorage().read('language') != null) {
      debugPrint(GetStorage().read('language').toString());
      return GetStorage().read('language').toString();
    } else {
      debugPrint('uz_UZ');
      return 'uz_UZ';
    }
  }

  @override
  void onClose() {
    controller?.dispose();
    nameController.dispose();

    super.onClose();
  }

  void saveToken(String token) => GetStorage().write('token', token);

  void savePhoneNumber(String phoneNumber) => GetStorage().write('phoneNumber', phoneNumber);

  void logout() {
    GetStorage().erase();
    Get.delete<GetController>();
  }

  get phoneNumber => GetStorage().read('phoneNumber');

  get token => GetStorage().read('token');

  String maskPhoneNumber(String phoneNumber) {
    const int minimumLength = 12;
    const String maskedPart = '*****';
    if (phoneNumber.length < minimumLength) return phoneNumber;
    String prefix = phoneNumber.substring(0, 7);
    String suffix = phoneNumber.length > 7 ? phoneNumber.substring(phoneNumber.length - 1) : '';
    return '$prefix$maskedPart$suffix';
  }


  int getType() => dropDownItems[2];

  final countdownDuration = const Duration(minutes: 0, seconds: 7).obs;

  void startTimer() {
    if (_timer != null && _timer!.isActive) _timer!.cancel();
    if (countdownDuration.value.inSeconds > 0) {
      print(countdownDuration.value.inSeconds);
      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(
          oneSec, (timer) {
        if (countdownDuration.value.inSeconds == 0) {
          timer.cancel();
        } else {
          countdownDuration.value = countdownDuration.value - oneSec;
          print(countdownDuration.value.inSeconds);
        }
      }
      );
    }
  }

  void stopTimer() => _timer!.cancel();

  void stopTimerTap() => _timerTap!.cancel();

  void resetTimer() {
    if (_timer != null && _timer!.isActive) {
      stopTimer();
    }
    countdownDuration.value = const Duration(minutes: 1, seconds: 59);
    startTimer();
  }

  void deleteTimer() {
    if (_timer != null && _timer!.isActive) {
      stopTimer();
    }
    countdownDuration.value = const Duration(minutes: 0, seconds: 05);
    startTimer();
  }


  final TextEditingController searchController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surNameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordProjectController = TextEditingController();

  final TextEditingController verifyCodeControllers = TextEditingController();

  void clearControllers() {
    nameController.clear();
    phoneController.clear();
    codeController.clear();
    passwordProjectController.clear();
  }

  late TabController tabController;

  String maskString(String input) {
    if (input.length < 20) return input;
    String prefix = input.substring(0, 6);
    String suffix = input.substring(19);
    String replacement = '*' * (20 - 6);
    return '$prefix$replacement$suffix';
  }

  String formatPower(double? power) {
    if (power! <= 0) return "--";
    return "${power.toStringAsFixed(1)}W";
  }

  String getPortTypes(int port) {
    if (port == 1) {
      return 'assets/svg_assets/port_top.svg';
    } else {
      return 'assets/svg_assets/port.svg';
    }
  }

  void saveLanguage(Locale locale) {
    print(locale.languageCode);
    GetStorage().write('language', '${locale.languageCode}_${locale.countryCode}');
    Get.updateLocale(locale);
  }

  void savePassCode(String passCode) => GetStorage().write('passCode', passCode);

  void saveBiometrics(bool value) => GetStorage().write('biometrics', value);

  bool getBiometrics() => GetStorage().read('biometrics') ?? false;

  String getPassCode() => GetStorage().read('passCode') ?? '';

  bool checkPassCode(String passCode) => GetStorage().read('passCode') == passCode;

  void deletePassCode() => GetStorage().remove('passCode');

  Locale get language => Locale(GetStorage().read('language') ?? 'uz_UZ');

  int get languageIndex => language.languageCode == 'uz_UZ' ? 0 : language.languageCode == 'oz_OZ' ? 1 : language.languageCode == 'ru_RU' ? 2 : 3;

  String languageName(language) {
    if (language == 'uz_UZ') {
      return 'O‘zbekcha';
    } else if (language == 'ru_RU') {
      return 'Русский';
    } else if (language == 'en_US') {
      return 'English';
    }
    return 'Ўзбекча';
  }

  final RefreshController refreshLibController = RefreshController(initialRefresh: false);
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerOk = ScrollController();

  final RefreshController refreshGuaranteeController = RefreshController(initialRefresh: false);
  final ScrollController scrollGuaranteeController = ScrollController();

  final RefreshController refreshTransferWalletController = RefreshController(initialRefresh: false);
  final ScrollController scrollTransferWalletController = ScrollController();

  final RefreshController refreshNotificationController = RefreshController(initialRefresh: false);
  final ScrollController scrollNotificationController = ScrollController();

  final RefreshController refreshChecksController = RefreshController(initialRefresh: false);
  final ScrollController scrollChecksController = ScrollController();

  final RefreshController refreshCategoryController = RefreshController(initialRefresh: false);
  final ScrollController scrollCategoryController = ScrollController();

  final RefreshController refreshReportController = RefreshController(initialRefresh: false);
  final ScrollController scrollReportController = ScrollController();

  final RefreshController refreshArchiveController = RefreshController(initialRefresh: false);
  final ScrollController scrollArchiveController = ScrollController();

  var widgetOptions = <Widget>[];
  var index = 0.obs;
  var cardBackIndex = 0.obs;
  RxString cardNameText = ''.obs;
  RxString cardNumberText = ''.obs;
  var selectedMonth = 0.obs;

  void changeCardBackIndex(int value) => cardBackIndex.value = value;

  void changeSelectedMonth(int value) => selectedMonth.value = value;

  void changeWidgetOptions() {
    widgetOptions.add(HomePage());
    widgetOptions.add(AccountPage());
    widgetOptions.add(GuaranteePage());
    widgetOptions.add(ReportPage());
  }

  void changeIndex(int value) => index.value = value;


  final List locale = [{'name':'O‘zbekcha','locale': const Locale('uz','UZ')},{'name':'Ўзбекча','locale': const Locale('oz','OZ')}, {'name':'Русский','locale': const Locale('ru','RU')}, {'name':'English','locale': const Locale('en','US')}].obs;

  var listMonth = [
    'Yanvar',
    'Fevral',
    'Mart',
    'Aprel',
    'May',
    'Iyun',
    'Iyul',
    'Avgust',
    'Sentyabr',
    'Oktyabr',
    'Noyabr',
    'Dekabr'
  ].obs;
  var listNames = [
    'Jasurbek Shodiyev',
    'APIGATE MERCHANT',
    'Haydarov Dilshodjon',
    'UPAY Humo',
    'Davr Upay',
    'beeli PEREV OPLATA',
    'Yandex Go Taxi',
    'Nasriddinov Jamshid',
    'OZBEKTELEKOM AK',
    'alifmobiuz u2h',
    'ATTO TRANSPORT TOLOV',
    'Haydarov Dilshodjon',
    'ATTO TRANSPORT TOLOV',
    'Nasriddinov Jamshid',
    'beeli PEREV OPLATA',
    'ATTO TRANSPORT TOLOV',
    'Jasurbek Shodiyev',
    'ATTO TRANSPORT TOLOV',
    'Haydarov Dilshodjon',
    'ATTO TRANSPORT TOLOV',
  ].obs;
  var listNamesPay = [
    '10 000',
    '-12 301',
    '11 039',
    '10 312',
    '300 000',
    '13 000',
    '220 000',
    '134 000',
    '12 021',
    '100 210',
    '231 000',
    '5 000',
    '100 001',
    '300 212',
    '231 000',
    '10 200',
    '30 021',
    '12 000',
    '201 000',
    '212 000',
    '323 000'
  ].obs;
  var listNamesDay = [
    '12:01',
    '11:11',
    '22:01',
    '09:31',
    '09:01',
    '12:30',
    '05:21',
    '02:10',
    '10:15',
    '13:41',
    '18:09',
    '20:20',
    '12:03',
    '19:30',
    '18:20',
    '19:20',
    '18:20',
    '02:10',
    '18:09',
    '12:30',
    '22:01',
    '12:01',
  ].obs;
  var listTitle = ['Jarayonda', 'To‘langan', 'Rad etilgan',].obs;
  var listPrice = [
    '01.02.2025',
    '09.01.2025',
    '10.05.2025',
    '22.12.2025',
    '11.05.2025',
    '03.10.2025',
    '13.11.2025',
    '19.02.2025',
    '23.01.2025',
    '12.03.2025',
    '02.04.2025',
    '11.01.2025',
  ].obs;
  var listProductPrice = [
    '200 123',
    '828',
    '224 614',
    '223 786',
    '100 000',
    '300',
    '13.11.2025',
    '19.02.2025',
    '23.01.2025',
    '12.03.2025',
    '02.04.2025',
    '11.01.2025',
  ].obs;
  var listImage = [
    'https://hicom.uz/wp-content/uploads/2024/01/24Pro-600x600.png',
    'https://hicom.uz/wp-content/uploads/2024/01/8842-600x600.png',
    'https://hicom.uz/wp-content/uploads/2024/01/PDU9.png',
    'https://images.uzum.uz/ckf8u13k9fq8lb3a7vbg/original.jpg',
    'https://hicom.uz/wp-content/uploads/2024/01/PDU9.png',
    'https://www.prom.uz/_ipx/f_webp/https://devel.prom.uz/upload/product_gallery/aa/3d/aa3d9c672761627e46c43211aa19d720.jpg'
  ].obs;
  var listImageName = [
    'PoE Switch',
    'Network cabinet',
    'PDU',
    'PoE Switch',
    'PoE Switch',
    'PoE Switch',
    'Network cabinet',
    'PDU',
    'HDD',
    'camera',
  ].obs;
  var listImagePrice = [
    'Hi-M82CM',
    'HIFS-8842',
    'Hi-PDU9',
    'Hi-M42E',
    'Hi-M82E',
    'Hi-M82CM',
    'HIFS-8842',
    'Hi-PDU9',
    'HDD',
    'camera'
  ].obs;

  var listCardBackImage = [
    'https://i.pinimg.com/564x/9c/68/86/9c6886dd642a4869f3fa4578f9fe34ef.jpg',
    'https://i.pinimg.com/474x/f2/32/41/f2324123ed322610368ebc8c8c871b6e.jpg',
    'https://i.pinimg.com/474x/1e/b0/f9/1eb0f9367962763daf1ce6e2ea247415.jpg',
    'https://i.pinimg.com/474x/6e/c6/7b/6ec67b86b6929236abbde2f62ee2d290.jpg',
    'https://i.pinimg.com/474x/3a/24/5d/3a245d83eef7a69961c7f19540e972c1.jpg',
    'https://i.pinimg.com/474x/36/c8/a2/36c8a2535c5345a9916b9975c6e75eb5.jpg',
    'https://i.pinimg.com/564x/dc/59/68/dc5968de1b8ab34f7ef3932e7b200f9e.jpg',
    'https://i.pinimg.com/564x/08/af/15/08af153b75aa01f66e73895ef1fbd662.jpg',
    'https://i.pinimg.com/474x/4f/de/c6/4fdec686fea38584ca336dc61e9b4bd1.jpg',
    'https://i.pinimg.com/474x/61/70/4f/61704f7cae76c05c98d3fa2939c4832e.jpg',
    'https://i.pinimg.com/474x/25/fb/a5/25fba5e5fee645836650cc4eca58ef73.jpg',
    'https://i.pinimg.com/474x/5c/e8/92/5ce8924c34c23647180900a931d1c10a.jpg',
    'https://i.pinimg.com/474x/8b/4d/f5/8b4df5f8e623d935e73a9c8a2ae287c2.jpg',
    'https://i.pinimg.com/474x/4b/6d/69/4b6d69245009abb4d0682291610f46f5.jpg',
    'https://i.pinimg.com/474x/d8/a0/df/d8a0dfc5b6356039df4a6d00cbdf56f1.jpg'
  ].obs;
  var listPriceAnd = [
    '02.02.2022',
    '01.03.2022',
    '09.01.2022',
    '10.04.2022',
    '03.05.2022',
    '06.03.2022',
    '11.07.2022',
    '12.07.2022',
    '12.08.2022',
    '12.04.2022',
    '12.02.2022',
    '12.02.2022',
  ];

  int getCrossAxisCount() {
    double screenWidth = Get.width;
    if (screenWidth > 1023 && screenWidth <= 1366) {
      return 6;
    } else if (screenWidth >= 819 && screenWidth <= 1024) {
      return 4;
    } else if (screenWidth < 399) {
      return 2;
    } else {
      return 2;
    }
  }

  var countries = [].obs;
  var regions = [].obs;
  var cities = [].obs;
  var categories = [].obs;
  var products = [].obs;

  var isKeyboardVisible = false.obs;
  var animateTextFields = false.obs;

  var selectedDate = DateTime.now().obs;
  var formattedDate = ''.obs;
  RxBool fullText = false.obs;

  // Method to trigger animation
  void startDelayedAnimation() {
    animateTextFields.value = true;
    Future.delayed(const Duration(milliseconds: 100), () {
      animateTextFields.value = false;
    });
  }

  // Method to update keyboard visibility
  void updateKeyboardVisibility(bool isVisible) {
    isKeyboardVisible.value = isVisible;
  }

  // Update selected date
  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
    formattedDate.value = DateFormat('dd.MM.yyyy').format(selectedDate.value);
    update();
  }

  // Show Cupertino Date Picker
  void showCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: CupertinoDatePicker(
            initialDateTime: selectedDate.value,
            minimumDate: DateTime(1900),
            maximumDate: DateTime.now().add(const Duration(days: 365)),
            onDateTimeChanged: (DateTime newDate) {
              updateSelectedDate(newDate);
            },
            mode: CupertinoDatePickerMode.date,
          ),
        );
      },
    );
  }


  List shakeKey = [
    GlobalKey<ShakeWidgetState>(), //0
    GlobalKey<ShakeWidgetState>(), //1
    GlobalKey<ShakeWidgetState>(), //2
    GlobalKey<ShakeWidgetState>(), //3
    GlobalKey<ShakeWidgetState>(), //4
    GlobalKey<ShakeWidgetState>(), //5
    GlobalKey<ShakeWidgetState>(), //6
    GlobalKey<ShakeWidgetState>(), //7
    GlobalKey<ShakeWidgetState>(), //8
    GlobalKey<ShakeWidgetState>()  //9
  ];


  int textCount = 0;
  final int limitTextLength = 20;

  String getCategoryName(int id) => categoriesModel.value.result!.firstWhere((element) => element.id == id).name!;

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  var countriesModel = CountriesModel().obs;
  var regionsModel = CountriesModel().obs;
  var citiesModel = CountriesModel().obs;
  var profileInfoModel = ProfileInfoModel().obs;
  var categoriesModel = CategoriesModel().obs;
  var productsModel = CategoriesModel().obs;
  var productsModelDetail = CategoriesModel().obs;
  var categoryProductsModel = CategoriesModel().obs;
  var categoriesProductsModel = CategoriesProductsModel().obs;


  //change models

  void changeCountriesModel(CountriesModel countriesModel) {
    this.countriesModel.value = countriesModel;
    dropDownItemsCountries.value = countriesModel.countries!.map((e) => e.name!).toList();

    int matchingIndex = countriesModel.countries!.indexWhere((country) => country.id == profileInfoModel.value.result!.first.countryId);
    if (matchingIndex != -1) {
      dropDownItems[1] = matchingIndex;
    }
  }

  void changeRegionsModel(CountriesModel regionsModel) {
    this.regionsModel.value = regionsModel;
    dropDownItemsRegions.value = regionsModel.regions!.map((e) => e.name!).toList();

    int? profileRegionId = profileInfoModel.value.result!.first.regionId;
    int matchingIndex = regionsModel.regions!.indexWhere((region) => region.id == profileRegionId);
    if (matchingIndex != -1) {
      dropDownItems[2] = matchingIndex;
    }
  }

  void changeCitiesModel(CountriesModel citiesModel) {
    this.citiesModel.value = citiesModel;
    dropDownItemsCities.value = citiesModel.cities!.map((e) => e.name!).toList();

    int? profileCityId = profileInfoModel.value.result!.first.cityId;
    int matchingIndex = citiesModel.cities!.indexWhere((city) => city.id == profileCityId);
    if (matchingIndex != -1) {
      dropDownItems[3] = matchingIndex;
    }
  }

  void changeProfileInfoModel(ProfileInfoModel profileInfo) => profileInfoModel.value = profileInfo;

  void changeCategoriesModel(CategoriesModel categories) => categoriesModel.value = categories;

  void changeProductsModel(CategoriesModel categoriesModel) => productsModel.value = categoriesModel;
  void changeProductsModelDetail(CategoriesModel categoriesModel) => productsModelDetail.value = categoriesModel;

  void changeCatProductsModel(CategoriesModel categoriesModel) => categoryProductsModel.value = categoriesModel;

  void addCategoriesProductsModels(CategoriesModel categories) {
    if (categoriesProductsModel.value.all == null) {
      categoriesProductsModel.value.all = <CategoriesModel>[];
    } else {
      categoriesProductsModel.value.all!.add(categories);
    }
  }

  void addCategoriesProductsModel(CategoriesModel categories) {
    categoriesProductsModel.value.all ??= <CategoriesModel>[];
    categoriesProductsModel.value.all!.add(categories);
    categoriesProductsModel.refresh();
  }

  //clear models

  void clearCountriesModel() {
    countriesModel.value = CountriesModel();
    dropDownItemsCountries.value = [];
    dropDownItemsRegions.value = [];
    dropDownItemsCities.value = [];
    dropDownItems[1] = 0;
    dropDownItems[2] = 0;
    dropDownItems[3] = 0;
  }

  void clearRegionsModel() {
    regionsModel.value = CountriesModel();
    dropDownItemsRegions.value = [];
    dropDownItemsCities.value = [];
    dropDownItems[2] = 0;
    dropDownItems[3] = 0;
  }

  void clearCitiesModel() {
    citiesModel.value = CountriesModel();
    dropDownItemsCities.value = [];
    dropDownItems[3] = 0;
  }

  void clearProfileInfoModel() => profileInfoModel.value = ProfileInfoModel();

  void clearCategoriesProductsModel() => categoriesProductsModel.value = CategoriesProductsModel();

  void clearProductsModelDetail() => productsModelDetail.value = CategoriesModel();

  //productsModel

  void clearProductsModel () => productsModel.value = CategoriesModel();

  void clearCategoriesModel () => categoriesModel.value = CategoriesModel();

}


/*class GetController extends GetxController {
  RxString enteredPasscode = ''.obs;
  RxBool errorField = false.obs;
  RxBool errorFieldOk = false.obs;
  var hasFingerprint = false.obs;
  var hasFaceID = false.obs;
  void savePassCode(String passCode) => GetStorage().write('passCode', passCode);

  String getPassCode() => GetStorage().read('passCode');

  bool checkPassCode(String passCode) => GetStorage().read('passCode') == passCode;
}*/


