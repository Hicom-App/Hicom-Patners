import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:hicom_patners/pages/bottombar/guarantee_page.dart';
import 'package:hicom_patners/pages/bottombar/report_page.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../companents/instrument/shake_widget.dart';
import '../models/auth/countries_model.dart';
import '../models/auth/send_code_model.dart';
import '../models/sample/cards_model.dart';
import '../models/sample/categories.dart';
import '../models/sample/profile_info_model.dart';
import '../models/sample/reviews_model.dart';
import '../models/sample/sorted_pay_transactions.dart';
import '../models/sample/warranty_model.dart';
import '../pages/bottombar/account_page.dart';
import '../pages/bottombar/home_page.dart';
import '../pages/not_connection.dart';

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
  RxBool allComments = false.obs;

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

  void onQRViewCreated(QRViewController qrController, context) {
    controller = qrController;
    controller?.scannedDataStream.listen((scanData) {
      result.value = scanData;
      if (scanData.code != null) {
        codeController.text = scanData.code.toString();
        ApiController().addWarrantyProduct(scanData.code.toString(), context);
        controller?.pauseCamera();
        controller?.dispose();

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


  var connectionStatus = 'Unknown'.obs;
  late Connectivity _connectivity;
  late Stream<List<ConnectivityResult>> connectivityStream;


  @override
  void onInit() {

    print('onInit');
    _connectivity = Connectivity();
    connectivityStream = _connectivity.onConnectivityChanged;

    connectivityStream.listen((List<ConnectivityResult> result) {
      connectionStatus.value = _getStatusMessage(result[0]);
      for (int i = 0; i < result.length; i++) {
        print('============================================================================================================');
        print(result[i].toString());
      }
      if (result[0] == ConnectivityResult.none) {
        Get.to(const NotConnection());
      }
    });
    super.onInit();
  }

  String _getStatusMessage(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return "Mobil ma'lumot orqali ulangan";
      case ConnectivityResult.wifi:
        return "Wi-Fi orqali ulangan";
      case ConnectivityResult.none:
        return "Aloqa yo'q";
      default:
        return "Aloqa holati noma'lum";
    }
  }

  var mackFormater = MaskTextInputFormatter(mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  void saveToken(String token) => GetStorage().write('token', token);

  void savePhoneNumber(String phoneNumber) => GetStorage().write('phoneNumber', phoneNumber);

  void saveSelectedCardIndex(int index) => GetStorage().write('selectedCardIndex', index).then((value) => getSelectedCardIndex);

  void logout() {
    GetStorage().erase();
    Get.delete<GetController>();
  }

  get phoneNumber => GetStorage().read('phoneNumber');

  get token => GetStorage().read('token');

  get getSelectedCardIndex => selectedCard.value = GetStorage().read('selectedCardIndex') ?? 0;

  var selectedCard = 0.obs;

  String maskPhoneNumber(String phoneNumber) {
    const int minimumLength = 12;
    const String maskedPart = '*****';
    if (phoneNumber.length < minimumLength) return phoneNumber;
    String prefix = phoneNumber.substring(0, 7);
    String suffix = phoneNumber.length > 7 ? phoneNumber.substring(phoneNumber.length - 1) : '';
    return '$prefix$maskedPart$suffix';
  }

  int getType() => dropDownItems[2];

  final countdownDuration = const Duration(minutes: 1, seconds: 59).obs;

  void startTimer() {
    if (_timer != null && _timer!.isActive) _timer!.cancel();
    if (countdownDuration.value.inSeconds > 0) {
      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(
          oneSec, (timer) {
        if (countdownDuration.value.inSeconds == 0) {
          timer.cancel();
        } else {
          countdownDuration.value = countdownDuration.value - oneSec;
        }
      }
      );
    }
  }

  void stopTimer() => _timer!.cancel();

  void stopTimerTap() => _timerTap!.cancel();

  void resetTimer() {
    if (_timer != null && _timer!.isActive) stopTimer();
    countdownDuration.value = const Duration(minutes: 1, seconds: 59);
    startTimer();
  }

  void deleteTimer() {
    if (_timer != null && _timer!.isActive) {
      stopTimer();
    }
    countdownDuration.value = const Duration(minutes: 1, seconds: 59);
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
  final TextEditingController paymentController = TextEditingController();

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

  String formatNumber(String number) {
    if (number.length != 16) {return number;}
    return '${number.substring(0, 4)}   ${number.substring(4, 6)}**   ****   ${number.substring(12)}';
  }

  String getPortTypes(int port) {
    if (port == 1) {
      return 'assets/svg_assets/port_top.svg';
    } else {
      return 'assets/svg_assets/port.svg';
    }
  }

  void saveLanguage(Locale locale) {
    debugPrint(locale.languageCode.toString());
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
  RxInt selectMonth = 0.obs;

  void changeCardBackIndex(int value) => cardBackIndex.value = value;

  void changeSelectedMonth(int value) {
    for (var i = 0; i < listMonth.length; i++) {
      listMonth[i]['selected'] = i == value ? true : false;
    }
    selectMonth.value = value;
    listMonth.refresh();
  }

  void changeWidgetOptions() {
    widgetOptions.add(HomePage());
    widgetOptions.add(AccountPage());
    widgetOptions.add(GuaranteePage());
    widgetOptions.add(ReportPage());
  }

  void changeIndex(int value) => index.value = value;


  final List locale = [{'name':'O‘zbekcha','locale': const Locale('uz','UZ')},{'name':'Ўзбекча','locale': const Locale('oz','OZ')}, {'name':'Русский','locale': const Locale('ru','RU')}, {'name':'English','locale': const Locale('en','US')}].obs;

  var listMonth = [{'name':'Hammasi', 'selected': true}, {'name':'Yanvar', 'selected': false}, {'name':'Fevral', 'selected': false}, {'name':'Mart', 'selected': false}, {'name':'Aprel', 'selected': false}, {'name':'May', 'selected': false}, {'name':'Iyun', 'selected': false}, {'name':'Iyul', 'selected': false}, {'name':'Avgust', 'selected': false}, {'name':'Sentabr', 'selected': false}, {'name':'Oktabr', 'selected': false}, {'name':'Noyabr', 'selected': false}, {'name':'Dekabr', 'selected': false}].obs;

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
  RxBool fullText = true.obs;

  RxList<bool> isExpandedList = RxList<bool>();

  void toggleExpandedComment(int index) {
    isExpandedList[index] = !isExpandedList[index];
    isExpandedList.refresh();
  }

  void initializeExpandedCommentList(int length) {
    if (isExpandedList.length != length) {
      isExpandedList = List<bool>.filled(length, true).obs;
    }
  }
  // Method to trigger animation
  void startDelayedAnimation() {
    animateTextFields.value = true;
    Future.delayed(const Duration(milliseconds: 100), () => animateTextFields.value = false);
  }

  // Method to update keyboard visibility
  void updateKeyboardVisibility(bool isVisible) => isKeyboardVisible.value = isVisible;

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
            onDateTimeChanged: (DateTime newDate) => updateSelectedDate(newDate),
            mode: CupertinoDatePickerMode.date
          )
        );
      }
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
  var sendCodeModel = SendCodeModel().obs;
  var warrantyModel = WarrantyModel().obs;
  var sortedWarrantyModel = SortedWarrantyModel().obs;
  var reviewsModel = ReviewsModel().obs;
  var cardsModel = CardsModel().obs;
  var sortedTransactionsModel = SortedPayTransactions().obs;

  var rating = 0.0.obs;
  set ratings(double ratings) => rating.value = ratings;


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

  void changeSendCodeModel(SendCodeModel sendCodeModels) => sendCodeModel.value = sendCodeModels;

  void changeWarrantyModel(WarrantyModel warrantyModels) {
    warrantyModel.value = warrantyModels;
    warrantyModel.value = WarrantyModel.fromJson(json.decode(jsonEncode(warrantyModels)));
    sortedWarrantyModel.value = convertToSortedWarrantyModel(warrantyModel.value);
    print(sortedWarrantyModel.value.toJson());
  }

  void changeReviewsModel(ReviewsModel reviewsModels) => reviewsModel.value = reviewsModels;

  void changeCardsModel(CardsModel cardsModels) => cardsModel.value = cardsModels;


  void changeSortedTransactionsModel(SortedPayTransactions sortedTransactionsModels) => sortedTransactionsModel.value = sortedTransactionsModels;

  void updateCategoriesProductsModel(int item, int index, int value) {
    if (categoriesProductsModel.value.all != null && categoriesProductsModel.value.all!.isNotEmpty) {
      categoriesProductsModel.value.all![item].result![index].favorite = value;
      categoriesProductsModel.refresh();
    }
  }

  void updateProductsModel(int index, int value) {
    if (productsModel.value.result != null) {
      productsModel.value.result![index].favorite = value;
      productsModel.refresh();
    }
  }

  void updateCatProductsModel(int index, int value) {
    if (categoryProductsModel.value.result != null) {
      categoryProductsModel.value.result![index].favorite = value;
      categoryProductsModel.refresh();
    }
  }


  //funktions

  // String getSortedTransactionsResultIndex(value){
  //   //value == 0 get all transactions else all result in get result item count
  //   var list = [];
  //   if (value == 0) {
  //     list = sortedTransactionsModel.value.result!;
  //   } else {
  //     list = sortedTransactionsModel.value.result!;
  //   }
  //
  //   return list.length.toString();
  // }

  String getSortedTransactionsResultIndex(int? value) {
    var result = sortedTransactionsModel.value.result;
    List<int> indices = [];

    for (var i = 0; i < result!.length; i++) {
      for (var j = 0; j < result[i].results!.length; j++) {
        final operation = result[i].results![j].operation;

        // If value is null, count all items. Otherwise, filter by operation.
        if (value == null || operation == value) {
          indices.add(j);
        }
      }
    }

    // Return total count of indices or '0' if no matching items found.
    return indices.isEmpty ? '0' : indices.length.toString();
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

  void clearProductsModel () => productsModel.value = CategoriesModel();

  void clearCategoriesModel () => categoriesModel.value = CategoriesModel();

  void clearSendCodeModel () => sendCodeModel.value = SendCodeModel();

  void clearWarrantyModel () => warrantyModel.value = WarrantyModel();

  void clearSortedWarrantyModel () => sortedWarrantyModel.value = SortedWarrantyModel();

  void clearReviewsModel () => reviewsModel.value = ReviewsModel();

  void clearCardsModel () => cardsModel.value = CardsModel();

}

