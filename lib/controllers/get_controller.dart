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
  RxString version = '1.0.0'.obs;
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
  RxString secondPasscode = ''.obs;
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

  String getDateFormat(String timeStamp) {
    if (timeStamp.isEmpty) return '';
    var date = DateTime.parse(timeStamp);
    if (date.day == DateTime.now().day && date.year == DateTime.now().year) {
      return 'Bugun'.tr;
    } else if (date.day == DateTime.now().day - 1 && date.year == DateTime.now().year) {
      return 'Kecha'.tr;
    } else {
      return '${date.day} ${getMonth(DateFormat('MMM').format(date))} ${date.year}';
    }
  }

  String getMoneyFormat(int? value) => value == null ? '' : value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');

  String getMonth(String month) => month.isEmpty ? '' : month.tr;

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
    getNotification();
    getBiometrics();
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

  void saveFcmToken(String token) => GetStorage().write('fcmToken', token);

  void savePhoneNumber(String phoneNumber) => GetStorage().write('phoneNumber', phoneNumber);

  void saveSelectedCardIndex(int index) => GetStorage().write('selectedCardIndex', index).then((value) => getSelectedCardIndex);

  void logout() {
    GetStorage().erase();
    Get.delete<GetController>();
  }

  get phoneNumber => GetStorage().read('phoneNumber');

  get token => GetStorage().read('token');

  String get fcmToken => GetStorage().read('fcmToken');

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
    //if (_timer != null && _timer!.isActive) _timer!.cancel();
    if (_timer != null && _timer!.isActive) resetTimer();
    if (countdownDuration.value.inSeconds > 0) {
      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(
          oneSec, (timer) {
            print(countdownDuration.value.inSeconds);
            if (countdownDuration.value.inSeconds == 0) {
              timer.cancel();
            } else {
              countdownDuration.value = countdownDuration.value - oneSec;
            }
          },
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
  late TabController controllerConvex;

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

  void saveBiometrics(bool value) {
    GetStorage().write('biometrics', value);
    getBiometrics();
  }

  //save notification message

  void saveNotificationMessage(String title, String body) {
    if (title.isEmpty || body.isEmpty) {
      debugPrint("Notification message is empty");
      return;
    }
    List messages = [];
    String? messagesJson = GetStorage().read('notificationMessages');
    if (messagesJson != null) {
      messages = json.decode(messagesJson);
    }
    messages.add({"title": title, "body": body, "date": DateTime.now().toString()});
    GetStorage().write('notificationMessages', json.encode(messages));
  }

  loadNotificationMessages() {
    String? messagesJson = GetStorage().read('notificationMessages');
    if (messagesJson != null) {
      return messagesJson;
    }
    return '[]';
  }

  var getBiometricsValue = false.obs;
  var getNotificationValue = true.obs;

  bool getBiometrics(){
    getBiometricsValue.value = GetStorage().read('biometrics') ?? false;
    return getBiometricsValue.value;
  }

  bool getNotification(){
    getNotificationValue.value = GetStorage().read('notification') ?? false;
    return getNotificationValue.value;
  }

  void saveNotification(bool value) {
    GetStorage().write('notification', value);
    getNotification();
  }

  String getPassCode() => GetStorage().read('passCode') ?? '';

  bool checkPassCode(String passCode) => GetStorage().read('passCode') == passCode;

  void deletePassCode() => GetStorage().remove('passCode');

  Locale get language => Locale(GetStorage().read('language') ?? 'uz_UZ');

  //get uz, ru, or oz
  String get headerLanguage => language.languageCode == 'uz_UZ' ? 'uz' : language.languageCode == 'oz_OZ' ? 'oz' : language.languageCode == 'ru_RU' ? 'ru' : 'en';

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

  void changeSelectedMonths(int value) {
    clearSortedTransactionsModel();
    ApiController().getTransactions(
        filter: 't.date_created%20%3E%3D%20%222024-11-01%22%20AND%20t.date_created%20%3C%3D%20%222024-11-30%22'
    );
    for (var i = 0; i < listMonth.length; i++) {
      listMonth[i]['selected'] = i == value ? true : false;
    }
    selectMonth.value = value;
    listMonth.refresh();
  }

  void changeSelectedMonth(int value) {
    for (var i = 0; i < listMonth.length; i++) {
      listMonth[i]['selected'] = i == value ? true : false;
    }

    selectMonth.value = value;
    if (value == 0) {
      ApiController().getTransactions();
    } else {
      DateTime today = DateTime.now();
      DateTime firstDayOfMonth = DateTime(today.year, DateTime(today.year, selectMonth.value , 1).month, 1);
      if (firstDayOfMonth.month > 12) {
        firstDayOfMonth = DateTime(today.year + (firstDayOfMonth.month ~/ 12), firstDayOfMonth.month % 12, 1);
      }
      DateTime lastDayOfMonth = DateTime(firstDayOfMonth.year, firstDayOfMonth.month + 1, 0);
      if (firstDayOfMonth.month == 2) {
        if ((firstDayOfMonth.year % 4 == 0 && firstDayOfMonth.year % 100 != 0) || (firstDayOfMonth.year % 400 == 0)) {
          lastDayOfMonth = DateTime(firstDayOfMonth.year, firstDayOfMonth.month, 29); // Leap year
        } else {
          lastDayOfMonth = DateTime(firstDayOfMonth.year, firstDayOfMonth.month, 28); // Non-leap year
        }
      }
      String filter = 't.date_created >= "${DateFormat('yyyy-MM-dd').format(firstDayOfMonth)}" '
          'AND t.date_created <= "${DateFormat('yyyy-MM-dd').format(lastDayOfMonth)}"';
      ApiController().getTransactions(filter: filter);
    }
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

  var listMonth = [{'name':'Hammasi'.tr, 'selected': true}, {'name':'Yanvar'.tr, 'selected': false}, {'name':'Fevral'.tr, 'selected': false}, {'name':'Mart'.tr, 'selected': false}, {'name':'Aprel'.tr, 'selected': false}, {'name':'Mays'.tr, 'selected': false}, {'name':'Iyun'.tr, 'selected': false}, {'name':'Iyul'.tr, 'selected': false}, {'name':'Avgust'.tr, 'selected': false}, {'name':'Sentabr'.tr, 'selected': false}, {'name':'Oktabr'.tr, 'selected': false}, {'name':'Noyabr'.tr, 'selected': false}, {'name':'Dekabr'.tr, 'selected': false}].obs;

  var listTitle = ['Jarayonda'.tr,'Tasdiqlangan'.tr, 'To‘langan'.tr, 'Rad etilgan'.tr].obs;

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

  String getCategoryName(int id) => categoriesModel.value.result != null ? categoriesModel.value.result!.firstWhere((element) => element.id == id).name ?? '' : '';

  String getMaskedName(String name) {
    if (name == '-') return '-';
    if (name.isEmpty || name.length < 3) {
      return '*' * name.length;
    }
    if (name.length <= 6) {
      return name[0] + '*' * (name.length - 2) + name[name.length - 1];
    }
    String visibleStart = name.substring(0, 3); // Boshlanishdagi 3 harf
    String visibleEnd = name.substring(name.length - 3); // Oxiridagi 3 harf
    String maskedMiddle = name.substring(3, name.length - 3).split('').map((char) {
      return char == ' ' ? ' ' : '*'; // Bo'sh joyni saqlab, boshqa belgilarni yulduzcha bilan almashtirish
    }).join('');
    return visibleStart + maskedMiddle + visibleEnd;
  }

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
  var twoList = TwoList().obs;

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


  void changeSortedTransactionsModel(SortedPayTransactions sortedTransactionsModels, TwoList twoLists){
    sortedTransactionsModel.value = sortedTransactionsModels;
    twoList.value = twoLists;
  }

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

  void clearSortedTransactionsModel () => sortedTransactionsModel.value = SortedPayTransactions();

  void clearCategoryProductsModel () => categoryProductsModel.value = CategoriesModel();

}

