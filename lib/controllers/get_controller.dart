import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hicom_patners/pages/bottombar/guarantee_page.dart';
import 'package:hicom_patners/pages/bottombar/report_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../companents/instrument/instrument_components.dart';
import '../models/districts_model.dart';
import '../models/login_model.dart';
import '../models/province_model.dart';
import '../models/register_model.dart';
import '../models/sample/Switch_detail_model.dart';
import '../models/sample/get_users_model.dart';
import '../models/sample/project_model.dart';
import '../models/sample/switch_list_model.dart';
import '../models/settings_info.dart';
import '../pages/bottombar/account_page.dart';
import '../pages/bottombar/home_page.dart';
import '../resource/colors.dart';


class GetController extends GetxController {
  var fullName = 'Dilshodjon Haydarov'.obs;
  var id = 1209098100.obs;
  var height = 0.0.obs;
  var width = 0.0.obs;
  var sec = 0.obs;
  RxBool isRequest = true.obs;
  RxBool isSearch = false.obs;
  RxBool isNightMode = false.obs;
  RxBool back = true.obs;
  var code = '+998'.obs;
  RxString countryCode = ''.obs;
  RxList<int> dropDownItems = <int>[0, 0, 0, 0].obs;
  RxList<String> dropDownItemsTitle = <String>['Uzbekistan'].obs;
  RxList<String> dropDownItem = <String>['Sotuvchi'.tr,'O‘rnatuvchi'.tr,'Buyurtmachi'.tr].obs;
  var responseText = ''.obs;
  RxBool whileApi = true.obs;
  RxBool onLoading = false.obs;
  RxBool onLoadingSwitch = false.obs;
  RxBool errorField = false.obs;
  RxBool errorFieldOk = false.obs;

  final qrKey = GlobalKey(debugLabel: 'QR');
  var result = Rxn<Barcode>();
  QRViewController? controller;
  RxBool isLampOn = false.obs;
  var cameraFacing = CameraFacing.back.obs;


  void setHeightWidth(BuildContext context) {
    height.value = MediaQuery.of(context).size.height;
    width.value = MediaQuery.of(context).size.width;
  }

  var timer = Timer.periodic(const Duration(seconds: 2), (timer) {});

  void setRequest() {
    isRequest.value = false;
    if (timer.isActive) timer.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      isRequest.value = true;
    });
  }

  void setIsBack() {
    back.value = false;
  }

  void tapTimes(Function onTap, int sec) {
    if (_timer != null) stopTimer();
    _timer = Timer(Duration(seconds: sec), () {
      onTap();
      _timer = null;
    });
  }

  void onLoad() {onLoading.value = true;}

  void onLoaded() {onLoading.value = false;}

  void onLoadSwitch() {onLoadingSwitch.value = true;}

  void onLoadedSwitch() {onLoadingSwitch.value = false;}

  void onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    controller?.scannedDataStream.listen((scanData) {
      result.value = scanData;
      if (scanData.code != null) {
        switchSerialProjectController.text = scanData.code.toString();
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
    if (index >= 0 && index < dropDownItems.length) {
      dropDownItems[index] = newValue;
    }
  }

  void changeDropDownItemsTitle(int index, String newValue) {
    if (index >= 0 && index < dropDownItemsTitle.length) {
      dropDownItemsTitle[index] = newValue;
    }
    update();
  }

  changeFullName(String name) {fullName.value = name;}

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
    super.onClose();
  }

  var districtsModel = DistrictsModel().obs;
  var provinceModel = ProvinceModel().obs;
  var loginModel = LoginModel().obs;
  var registerModel = RegisterModel().obs;
  var projectModel = ProjectModel().obs;
  var searchProjectModel = ProjectModel().obs;
  var getUsersModel = GetUsersModel().obs;
  var switchListModel = SwitchListModel().obs;
  var searchSwitchListModel = SwitchListModel().obs;
  var settingsInfoModel = SettingsInfo().obs;
  var switchDetailModel = SwitchDetailModel().obs;
  void changeSwitchDetailModel(SwitchDetailModel switchDetailModels) {switchDetailModel.value = switchDetailModels;}

  void clearSwitchDetailModel() {switchDetailModel.value = SwitchDetailModel();}

  void changeSettingsInfoModel(SettingsInfo settingsInfo) {settingsInfoModel.value = settingsInfo;}

  void changeSwitchList(SwitchListModel switchLists) {switchListModel.value = switchLists;}

  void clearSwitchList() {switchListModel.value = SwitchListModel();}

  void changeGetUsersModel(GetUsersModel getUsersModels) {getUsersModel.value = getUsersModels;}

  void getProject(ProjectModel projectModels){
    projectModel.value = projectModels;
    searchProjectModel.value = projectModel.value;
    update();
  }

  void getProvince(){
    if (loginModel.value.user != null && loginModel.value.user?.regionId != null) {
      for (var i = 0; i < provinceModel.value.regions!.length; i++) {
        if (provinceModel.value.regions![i].id == loginModel.value.user?.regionId) {
          changeDropDownItems(0, i);
          break;
        }
      }
    }
  }

  void getDistricts(){
    if (loginModel.value.user != null && loginModel.value.user?.regionId != null) {
      for (var i = 0; i < districtsModel.value.districts!.length; i++) {
        if (districtsModel.value.districts![i].id == loginModel.value.user?.districtId) {
          changeDropDownItems(1, i);
          break;
        }
      }
    }
  }

  void changeRegisterModel(RegisterModel registerModels) {registerModel.value = registerModels;}

  void changeDistrictsModel(DistrictsModel districtsModel) {
    this.districtsModel.value = districtsModel;
    addDistrictsModel(Districts(id: 0, regionId: 0, name: 'Tanlang'));
  }

  void changeProvinceModel(ProvinceModel provinceModels) {
    provinceModel.value = provinceModels;
    addRegions(Regions(countryId: 0, id: 0, name: 'Tanlang'));
  }

  void addRegions(Regions regions) => provinceModel.value.regions!.insert(0, regions);

  void addDistrictsModel(Districts districtsModels) => districtsModel.value.districts!.insert(0, districtsModels);

  void clearProvinceModel() => provinceModel.value = ProvinceModel();

  void clearDistrictsModel() => districtsModel.value = DistrictsModel();

  void changeLoginModel(LoginModel loginModel) => this.loginModel.value = loginModel;

  void clearLoginModel()  => loginModel.value = LoginModel();

  int getType() => dropDownItems[2];

  void changeDropDownItemsType() {
    if (loginModel.value.user != null && loginModel.value.user?.type != null) {
      for (var i = 0; i < dropDownItem.length; i++) {
        debugPrint(dropDownItem[i].toString());
        if (i == loginModel.value.user?.type) {
          changeDropDownItems(2, i);
          break;
        }
      }
    }
  }

  final countdownDuration = const Duration(minutes: 1, seconds: 59).obs;
  Timer? _timer;
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
  final TextEditingController nameController = TextEditingController();
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  final TextEditingController nameProjectController = TextEditingController();
  final TextEditingController switchNameProjectController = TextEditingController();
  final TextEditingController switchSerialProjectController = TextEditingController();
  final TextEditingController noteProjectController = TextEditingController();
  final TextEditingController passwordProjectController = TextEditingController();

  final TextEditingController verifyCodeControllers = TextEditingController();


  void clearControllers() {
    nameController.clear();
    phoneController.clear();
    codeController.clear();
    nameProjectController.clear();
    switchNameProjectController.clear();
    switchSerialProjectController.clear();
    noteProjectController.clear();
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

  String getSettings(String name) {
    if (settingsInfoModel.value.settings == null) return "";
    for (var i = 0; i < settingsInfoModel.value.settings!.length; i++) {
      if (settingsInfoModel.value.settings![i].name == name) {
        return settingsInfoModel.value.settings![i].value.toString();
      }
    }
    return "";
  }

  String formatPower(double? power) {
    if (power! <= 0) return "--";
    return "${power.toStringAsFixed(1)}W";
  }

  String getPortTypes(int port){
    if (port == 1) {
      return 'assets/svg_assets/port_top.svg';
    } else {
      return 'assets/svg_assets/port.svg';
    }
  }


  void saveLanguage(Locale locale) {
    GetStorage().write('language', '${locale.languageCode}_${locale.countryCode}');
    Get.updateLocale(locale);
  }

  Locale get language => Locale(GetStorage().read('language') ?? 'uz_UZ');



  final RefreshController refreshLibController = RefreshController(initialRefresh: false);
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerOk = ScrollController();
  final RefreshController refreshGuaranteeController = RefreshController(initialRefresh: false);
  final ScrollController scrollGuaranteeController = ScrollController();
  final RefreshController refreshAccountController = RefreshController(initialRefresh: false);
  final ScrollController scrollAccountController = ScrollController();
  var widgetOptions = <Widget>[];
  var index = 0.obs;


  void changeWidgetOptions() {
    widgetOptions.add(HomePage());
    widgetOptions.add(AccountPage());
    widgetOptions.add(GuaranteePage());
    widgetOptions.add(ReportPage());
  }

  void changeIndex(int value) {index.value = value;}



  var list = ['AI POE', 'NETWORK CABINET', 'HDD', 'PDU', 'CAMERA', 'ACSESSORIES', 'HDMI CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE', 'NETWORK CABLE'].obs;
  var listTitle = ['Jarayonda', 'Tasdiqlangan', 'To`langan','Rad etilgan'].obs;
  var listPrice = ['01.02.2025', '09.01.2025', '10.05.2025', '22.12.2025','11.05.2025', '03.10.2025', '13.11.2025', '19.02.2025','23.01.2025', '12.03.2025', '02.04.2025', '11.01.2025',].obs;
  var listColor = [AppColors.blue, AppColors.green, AppColors.primaryColor3, AppColors.red].obs;
  var listImage = ['https://hicom.uz/wp-content/uploads/2023/12/PS208-scaled-600x600.jpg', 'https://hicom.uz/wp-content/uploads/2024/01/8842-600x600.png', 'https://hicom.uz/wp-content/uploads/2024/01/PDU9.png', 'https://images.uzum.uz/ckf8u13k9fq8lb3a7vbg/original.jpg', 'https://frankfurt.apollo.olxcdn.com/v1/files/t3uftbiso49d-UZ/image;s=3024x3024','https://www.prom.uz/_ipx/f_webp/https://devel.prom.uz/upload/product_gallery/aa/3d/aa3d9c672761627e46c43211aa19d720.jpg'].obs;
  var listImageName = ['PoE Switch', 'Network cabinet', 'PDU', 'PoE Switch', 'PoE Switch', 'PoE Switch', 'Network cabinet', 'PDU', 'HDD', 'camera',].obs;
  var listImagePrice = ['Hi-M82CM', 'HIFS-8842', 'Hi-PDU9', 'Hi-M42E', 'Hi-M82E', 'Hi-M82CM', 'HIFS-8842', 'Hi-PDU9', 'HDD', 'camera'].obs;
  var listStar = ['4.8 * 213 baxo', '4.1 * 344 baxo', '4.0 * 1022 baxo', '3.9 * 100 baxo', '4.8 * 213 baxo', '4.5 * 192 baxo', '2.8 * 100 baxo', '4.0 * 943 baxo', '4.1 * 402 baxo'].obs;
  var listCategoryIcon = ['https://img.icons8.com/?size=100&id=91076&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60947&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60988&format=png&color=475566', 'https://img.icons8.com/?size=100&id=67243&format=png&color=475566','https://img.icons8.com/?size=100&id=100062&format=png&color=475566','https://img.icons8.com/?size=100&id=108835&format=png&color=475566','https://img.icons8.com/?size=100&id=90412&format=png&color=475566','https://img.icons8.com/?size=100&id=60947&format=png&color=475566', 'https://img.icons8.com/?size=100&id=60988&format=png&color=475566', 'https://img.icons8.com/?size=100&id=67243&format=png&color=475566','https://img.icons8.com/?size=100&id=59749&format=png&color=475566','https://img.icons8.com/?size=100&id=110322&format=png&color=475566','https://img.icons8.com/?size=100&id=90412&format=png&color=475566'].obs;
  var listPriceAnd = ['02.02.2022', '01.03.2022', '09.01.2022', '10.04.2022','03.05.2022', '06.03.2022', '11.07.2022', '12.07.2022','12.08.2022', '12.04.2022', '12.02.2022', '12.02.2022',];
  var listImageInfo = [
    'Качественный POE коммутатор c возможностью облачного управления при помощи мобильного приложения. Основные особенности данной модели:Технология AI – расширяет развертывание сети на большие расстояния до 250 м.Потребуется в том случае, если расстояние до камеры превышает 100 м. В режиме AI скорость портов снижается до 10 Мбит/с, а дальность подключения увеличивается до 250 метров.Функция WATCHDOG – является эффективным инструментом автоматического управления питанием PoE устройств.Работа любого IP устройства подразумевает постоянный поток данных через коммутатор. Коммутатор PoE автоматически определяет отсутствие потока данных от подключенного устройства. Он отправляет периодический эхо-запрос на устройство. Если ответа нет, то коммутатор кратковременно отключает электропитания PoE. Тогда удаленное устройство совершает «жесткую» аппаратную перезагрузку и продолжает нормальную работу.Коммутатор имеет грозозащиту до 4 кВ, а защита от короткого замыкания при выходе из строя одного порта другие порты не затрагивает они будут продолжать работать.',
    'Сетевой шкаф 42U предназначен для размещения активного и пассивного телекоммуникационного оборудования, в офисных и закрытых промышленных помещениях.',
    'Блок розеток 1U на 9 гнезд для установки в шкафах и стойках 19',
    'Качественный POE коммутатор c возможностью облачного управления при помощи мобильного приложения. Основные особенности данной модели:Технология AI – расширяет развертывание сети на большие расстояния до 250 м.Потребуется в том случае, если расстояние до камеры превышает 100 м. В режиме AI скорость портов снижается до 10 Мбит/с, а дальность подключения увеличивается до 250 метров.Функция WATCHDOG – является эффективным инструментом автоматического управления питанием PoE устройств.Работа любого IP устройства подразумевает постоянный поток данных через коммутатор. Коммутатор PoE автоматически определяет отсутствие потока данных от подключенного устройства. Он отправляет периодический эхо-запрос на устройство. Если ответа нет, то коммутатор кратковременно отключает электропитания PoE. Тогда удаленное устройство совершает «жесткую» аппаратную перезагрузку и продолжает нормальную работу.Коммутатор имеет грозозащиту до 4 кВ, а защита от короткого замыкания при выходе из строя одного порта другие порты не затрагивает они будут продолжать работать.',
    'Качественный POE коммутатор c возможностью облачного управления при помощи мобильного приложения. Основные особенности данной модели:Технология AI – расширяет развертывание сети на большие расстояния до 250 м.Потребуется в том случае, если расстояние до камеры превышает 100 м. В режиме AI скорость портов снижается до 10 Мбит/с, а дальность подключения увеличивается до 250 метров.Функция WATCHDOG – является эффективным инструментом автоматического управления питанием PoE устройств.Работа любого IP устройства подразумевает постоянный поток данных через коммутатор. Коммутатор PoE автоматически определяет отсутствие потока данных от подключенного устройства. Он отправляет периодический эхо-запрос на устройство. Если ответа нет, то коммутатор кратковременно отключает электропитания PoE. Тогда удаленное устройство совершает «жесткую» аппаратную перезагрузку и продолжает нормальную работу.Коммутатор имеет грозозащиту до 4 кВ, а защита от короткого замыкания при выходе из строя одного порта другие порты не затрагивает они будут продолжать работать.',
    'Качественный POE коммутатор c возможностью облачного управления при помощи мобильного приложения. Основные особенности данной модели:Технология AI – расширяет развертывание сети на большие расстояния до 250 м.Потребуется в том случае, если расстояние до камеры превышает 100 м. В режиме AI скорость портов снижается до 10 Мбит/с, а дальность подключения увеличивается до 250 метров.Функция WATCHDOG – является эффективным инструментом автоматического управления питанием PoE устройств.Работа любого IP устройства подразумевает постоянный поток данных через коммутатор. Коммутатор PoE автоматически определяет отсутствие потока данных от подключенного устройства. Он отправляет периодический эхо-запрос на устройство. Если ответа нет, то коммутатор кратковременно отключает электропитания PoE. Тогда удаленное устройство совершает «жесткую» аппаратную перезагрузку и продолжает нормальную работу.Коммутатор имеет грозозащиту до 4 кВ, а защита от короткого замыкания при выходе из строя одного порта другие порты не затрагивает они будут продолжать работать.',
    'Сетевой шкаф 42U предназначен для размещения активного и пассивного телекоммуникационного оборудования, в офисных и закрытых промышленных помещениях.',
    'Блок розеток 1U на 9 гнезд для установки в шкафах и стойках 19',
    'Качественный POE коммутатор c возможностью облачного управления при помощи мобильного приложения. Основные особенности данной модели:Технология AI – расширяет развертывание сети на большие расстояния до 250 м.Потребуется в том случае, если расстояние до камеры превышает 100 м. В режиме AI скорость портов снижается до 10 Мбит/с, а дальность подключения увеличивается до 250 метров.Функция WATCHDOG – является эффективным инструментом автоматического управления питанием PoE устройств.Работа любого IP устройства подразумевает постоянный поток данных через коммутатор. Коммутатор PoE автоматически определяет отсутствие потока данных от подключенного устройства. Он отправляет периодический эхо-запрос на устройство. Если ответа нет, то коммутатор кратковременно отключает электропитания PoE. Тогда удаленное устройство совершает «жесткую» аппаратную перезагрузку и продолжает нормальную работу.Коммутатор имеет грозозащиту до 4 кВ, а защита от короткого замыкания при выходе из строя одного порта другие порты не затрагивает они будут продолжать работать.',
    'Качественный POE коммутатор c возможностью облачного управления при помощи мобильного приложения. Основные особенности данной модели:Технология AI – расширяет развертывание сети на большие расстояния до 250 м.Потребуется в том случае, если расстояние до камеры превышает 100 м. В режиме AI скорость портов снижается до 10 Мбит/с, а дальность подключения увеличивается до 250 метров.Функция WATCHDOG – является эффективным инструментом автоматического управления питанием PoE устройств.Работа любого IP устройства подразумевает постоянный поток данных через коммутатор. Коммутатор PoE автоматически определяет отсутствие потока данных от подключенного устройства. Он отправляет периодический эхо-запрос на устройство. Если ответа нет, то коммутатор кратковременно отключает электропитания PoE. Тогда удаленное устройство совершает «жесткую» аппаратную перезагрузку и продолжает нормальную работу.Коммутатор имеет грозозащиту до 4 кВ, а защита от короткого замыкания при выходе из строя одного порта другие порты не затрагивает они будут продолжать работать.',
  ].obs;

}
