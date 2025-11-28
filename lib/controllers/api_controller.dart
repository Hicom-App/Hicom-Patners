import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import 'package:hicom_patners/pages/auth/login_page.dart';
import 'package:hicom_patners/pages/auth/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/auth/countries_model.dart';
import '../models/auth/send_code_model.dart';
import '../models/sample/cards_model.dart';
import '../models/sample/categories.dart';
import '../models/sample/partner_models.dart';
import '../models/sample/profile_info_model.dart';
import '../models/sample/reviews_model.dart';
import '../models/sample/sorted_pay_transactions.dart';
import '../models/sample/warranty_model.dart';
import '../pages/auth/passcode/create_passcode_page.dart';
import '../pages/auth/passcode/passcode_page.dart';
import '../pages/auth/verify_page_number.dart';
import '../pages/bottombar/guarantee_page.dart';
import '../pages/not_connection.dart';
import '../resource/colors.dart';
import 'get_controller.dart';

class ApiController extends GetxController {
  final GetController _getController = Get.put(GetController());

  //final  baseUrl = 'http://185.196.213.76:8080/api';
  final  baseUrl = 'https://hicom.app:81/api';

  Future<List<dynamic>> getProjects() async {
    return [
      {'id': 1, 'name': 'Loyiha 1'},
      {'id': 2, 'name': 'Loyiha 2'},
      {'id': 3, 'name': 'Loyiha 3'},
    ];
  }

  //return header function
  Map<String, String> headersBearer() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_getController.token}',
      'Lang': _getController.headerLanguage
    };
  }

  Map<String, String> headersNoBearer() {
    return {
      //'Content-Type': 'application/json',
      'Lang': _getController.headerLanguage
    };
  }

  Map<String, String> headerBearer() => {'Authorization': 'Bearer ${_getController.token}'};

  Map<String, String> header() => {'Content': 'application/json'};

  Map<String, String> multipartHeaderBearer() {
    return {
      'Authorization': 'Bearer ${_getController.token}',
      'Content-Type': 'multipart/form-data',
      'Lang': _getController.headerLanguage
    };
  }

  //Auth
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Registratsiya

  Future<void> sendCodeRegister() async {
    _getController.sendParam(false);
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/users/register'));
    request.fields['phone'] = _getController.code.value + _getController.phoneController.text;
    request.headers.addAll(header());
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        _getController.sendParam(true);
        var data = jsonDecode(await response.stream.bytesToString());
        if (data['status'] == 0) {
          _getController.changeSendCodeModel(SendCodeModel.fromJson(data));
          _getController.startTimer();
          Get.to(() => const VerifyPageNumber(isRegister: true), transition: Transition.fadeIn);
        }
        else if (data['status'] == 5) {
          _getController.shakeKey[8].currentState?.shake();
          InstrumentComponents().showToast('Ushbu telefon raqam ro‘yxatdan o‘tgan', color: AppColors.red, textColor: AppColors.white);
        }
        else {
          _getController.shakeKey[8].currentState?.shake();
          debugPrint('Xatolik sendCodeRegister: ${data['message']}');
        }
      } else {
        _getController.sendParam(true);
        debugPrint('Xatolik sendCodeRegister: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      _getController.sendParam(true);
      debugPrint('Xatolik sendCodeRegister: Serverga ulanishda muammo00');
      debugPrint(stacktrace.toString());
    }

  }

  Future<void> sendCode() async {
    _getController.sendParam(false);
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/users/login'));
    request.fields['phone'] = _getController.code.value + _getController.phoneController.text;
    request.fields['password'] = '';
    request.fields['restore'] = '0';
    request.headers.addAll(header());
    try {
      var response = await request.send();
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        _getController.sendParam(true);
        var data = jsonDecode(await response.stream.bytesToString());
        if (data['status'] == 0) {
          _getController.changeSendCodeModel(SendCodeModel.fromJson(data));
          _getController.startTimer();
          Get.to(() => const VerifyPageNumber(isRegister: false), transition: Transition.fadeIn);
        } else if (data['status'] == 3){
          sendCodeRegister();
        }
        else {
          _getController.shakeKey[8].currentState?.shake();
          InstrumentComponents().showToast('Ehhh nimadir xato ketdi'.tr, color: AppColors.red, textColor: AppColors.white);
          debugPrint('Xatolik sendCode: ${data['message']}');
        }
      } else {
        _getController.sendParam(true);
        debugPrint('Xatolik sendCode: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      _getController.sendParam(true);
      debugPrint('Xatolik sendCode: Serverga ulanishda muammo00');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> verifyPhone(bool isRegister) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/users/code/confirm'));
    request.headers.addAll(header());
    request.fields['confirmation_id'] = _getController.sendCodeModel.value.result?.confirmationId.toString() ?? '';
    request.fields['code'] = _getController.verifyCodeControllers.text;
    var response = await request.send();
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      print(data);
      if (data['status'] == 0) {
        _getController.stopTimer();
        _getController.deletePassCode();
        _getController.saveBiometrics(false);
        _getController.saveToken(data['result']['token']);
        _getController.savePhoneNumber(_getController.code.value + _getController.phoneController.text);
        _getController.errorFieldOk.value = true;
        _getController.errorField.value = true;
        _getController.tapTimes((){
          _getController.errorFieldOk.value = false;
          _getController.errorField.value = false;
          _getController.verifyCodeControllers.clear();
          if (isRegister) {
            getCountries();
            _getController.updateSelectedDate(DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day));
            Get.to(() => const RegisterPage());
          } else {
            getProfile();
          }
        }, 1);
        debugPrint('Telefon tasdiqlandi va token olindi: ${data['result']['token']}');
      } else {
        _getController.shakeKey[7].currentState?.shake();
        debugPrint('Xatolik: ${data['message']}');
        _getController.changeErrorInput(0, true);
        _getController.errorField.value = true;
        debugPrint('Xatolik: xaaa0');
        _getController.tapTimes((){debugPrint('Xatolik: xaaa1');_getController.errorField.value = false;_getController.verifyCodeControllers.clear();_getController.changeErrorInput(0, false);}, 1);
      }
    }
  }

  Future<void> getCountries({bool me = false}) async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/place/countries'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 0) {
          _getController.changeCountriesModel(CountriesModel.fromJson(data));
          if (me == false) {
            getRegions(_getController.countriesModel.value.countries!.first.id != null ? _getController.countriesModel.value.countries!.first.id! : data['result'].first['id']);
          } else {
            getRegions(_getController.profileInfoModel.value.result!.first.countryId!, me: true);
          }
        } else {
          debugPrint('Xatolik countries 1: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik countries 2: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      _getController.clearCountriesModel();
      debugPrint('Xatolik getCountries: $e');
      debugPrint(stacktrace.toString());
    }

  }

  Future<void> getRegions(int countryId, {bool? me = false}) async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/place/regions?country_id=$countryId'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 0) {
          _getController.changeRegionsModel(CountriesModel.fromJson(data));
          if (me == false) {
            getCities(_getController.regionsModel.value.regions![_getController.dropDownItems[2]].id != null ? _getController.regionsModel.value.regions![_getController.dropDownItems[2]].id! : data['result'].first['id']);
          } else {
            getCities(_getController.profileInfoModel.value.result!.first.regionId!);
          }
        } else {
          _getController.clearRegionsModel();
          debugPrint('Xatolik region 1: ${data['message']}');
        }
      } else {
        _getController.clearRegionsModel();
        debugPrint('Xatolik region 2: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      _getController.clearRegionsModel();
      debugPrint('Xatolik getRegions: $e');
      debugPrint(stacktrace.toString());
    }

  }

  Future<void> getCities(int regionId) async {
    final response = await http.get(Uri.parse('$baseUrl/place/cities?region_id=$regionId'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        _getController.dropDownItemsCities.clear();
        _getController.changeCitiesModel(CountriesModel.fromJson(data));
      } else {
        _getController.clearCitiesModel();
        debugPrint('Xatolik getCities: ${data['message']}');
      }
    } else {
      _getController.clearCitiesModel();
      debugPrint('Xatolik getCities: Serverga ulanishda muammo');
    }
  }

  Future<void> postFcmToken() async {
    try {
      debugPrint('========================================================================================================================================================================');
      debugPrint(_getController.fcmToken);
      await http.post(Uri.parse('$baseUrl/users/firebase-token'), headers: headerBearer(), body: {'fcm_token': _getController.fcmToken});
    } catch (e, stacktrace) {
      debugPrint('Xatolik postFcmToken: $e');
      debugPrint(stacktrace.toString());
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Mahsulot kategoriyalari ro'yxatini olish

  Future<void> getCategories({bool category = false}) async {
    if(_getController.token != null && _getController.token != ''){
      print('Bearer ${_getController.token}');
    } else {
      print('Bearer null');
    }
    try {
      //final response = await http.get(Uri.parse('$baseUrl/catalog/categories'), headers: headersBearer());
      final response = await http.get(Uri.parse('$baseUrl/catalog/categories'), headers: _getController.token != null && _getController.token != '' ? headersBearer() : headersNoBearer());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        //debugPrint(data.toString());
        if (data['status'] == 0) {
          _getController.changeCategoriesModel(CategoriesModel.fromJson(data));
          getProducts(0, category: category);
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint(response.statusCode.toString());
        debugPrint('Xatolik getCategories: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik getCategories: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> getProducts(int categoryId, {bool isCategory = true, bool isFavorite = false, filter, bool category = false, String sort = 'category_id.asc'}) async {
    filter = filter ?? '';
    try {
      String encodedFilter = filter != null && filter.isNotEmpty ? Uri.encodeComponent(filter) : '';

      // Add sort parameter to the URL
      String url = isFavorite
          ? '$baseUrl/catalog/favorites?${filter.isNotEmpty ? 'filter=$encodedFilter&' : ''}sort=$sort'
          : '$baseUrl/catalog/products?category_id=$categoryId${filter.isNotEmpty ? '&filter=$encodedFilter' : ''}&sort=$sort';

      print(url);
      //final response = await http.get(Uri.parse(url), headers: headersBearer());
      final response = await http.get(Uri.parse(url), headers: _getController.token != null && _getController.token != '' ? headersBearer() : headersNoBearer());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 0) {
          if (isCategory) {
            _getController.changeProductsModel(CategoriesModel.fromJson(data));
            if (isFavorite) _getController.changeCatProductsModel(CategoriesModel.fromJson(data));
          } else {
            _getController.changeCatProductsModel(CategoriesModel.fromJson(data));
          }
        } else {
          debugPrint('Xatolik getProducts: ${data['message']}');
        }
        if (categoryId == 0 && !isFavorite) {
          if (filter.isNotEmpty) {
            _getController.clearCategoriesProductsModel();
          }
          getAllCatProducts(filter: encodedFilter.isNotEmpty ? encodedFilter : null, category: category);
        }
      } else {
        debugPrint('Xatolik getProducts: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik getProducts: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> getAllCatProducts({filter, bool category = false}) async {
    await Future.forEach(_getController.categoriesModel.value.result!, (category) async {
      //debugPrint(category.id.toString());
      await getProduct(category.id ?? 0, filter: filter, category: false);
    });
  }

  Future<void> getProduct(int categoryId, {bool isCategory = true, filter, bool category = false}) async {
    try {
      //final response = await http.get(Uri.parse('$baseUrl/catalog/products${isCategory != true ? '?id=$categoryId' : '?category_id=$categoryId'}${filter != null && filter != '' ? '&filter=$filter' : ''}'), headers: headersBearer());
      final response = await http.get(Uri.parse('$baseUrl/catalog/products${isCategory != true ? '?id=$categoryId' : '?category_id=$categoryId'}${filter != null && filter != '' ? '&filter=$filter' : ''}'), headers: _getController.token != null && _getController.token != '' ? headersBearer() : headersNoBearer());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //debugPrint(data.toString());
        if (data['status'] == 0 && data['result'] != null) {
          if (isCategory == true) {
            _getController.addCategoriesProductsModel(CategoriesModel.fromJson(data));
            _getController.addCategoriesAllProductsModel(CategoriesModel.fromJson(data));
          } else {
            _getController.clearProductsModelDetail();
            _getController.changeProductsModelDetail(CategoriesModel.fromJson(data));
            getReviews(categoryId);
          }
        } else {
          debugPrint('Xatolik getProduct: ${data['message']}');
        }
      } else {

        debugPrint('Xatolik getProduct: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik getProduct: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> addFavorites(int id, {bool isProduct = true, isFavorite = false}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/catalog/favorites?product_id=$id'), body: {'product_id': id.toString(),'favorite': isProduct ? '1' : '0'}, headers: headerBearer());
      debugPrint('shuuu $baseUrl/catalog/favorites?product_id=$id');
      debugPrint('body: ${'product_id:'+ id.toString() + 'favorite:' + isProduct.toString()}');
      debugPrint('$isProduct');
      debugPrint(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //debugPrint(data.toString());
        if (data['status'] == 0) {
          getProducts(0, isFavorite: isFavorite);
        } else {
          debugPrint('Xatolik addFavorites: ${data['message']}');
        }
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik addFavorites: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> addReview(int id) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/catalog/reviews'));
      request.headers.addAll(multipartHeaderBearer());
      request.fields.addAll({'id': '0', 'product_id': id.toString(), 'rating': _getController.rating.value.toString(), 'review': _getController.surNameController.text, 'user_id': '0'});
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      //debugPrint(responseBody.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(responseBody);
        //debugPrint(data.toString());
        if (data['status'] == 0) {
          _getController.surNameController.text = '';
          InstrumentComponents().showToast('Sizning fikringiz muvaffaqiyatli saqlandi');
          getProduct(id, isCategory: false);
          Get.back();
        } else {
          debugPrint('Xatolik addReview: ${data['message']}');
        }
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik addReview: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> addReviewPartner(int id) async {
    print(id.toString());
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/catalog/shopreviews'));
      request.headers.addAll(multipartHeaderBearer());
      request.fields.addAll({'id': '0', 'shop_id': id.toString(), 'rating': _getController.rating.value.toString(), 'review': _getController.surNameController.text, 'user_id': '0'});
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      //debugPrint(responseBody.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(responseBody);
        //debugPrint(data.toString());
        if (data['status'] == 0) {
          _getController.surNameController.text = '';
          InstrumentComponents().showToast('Sizning fikringiz muvaffaqiyatli saqlandi');
          getProduct(id, isCategory: false);
          Get.back();
        } else {
          debugPrint('Xatolik addReviewPartner: ${data['message']}');
        }
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik addReviewPartner: $e');
      debugPrint(stacktrace.toString());
    }
  }


  Future<void> getReviews(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/catalog/reviews?product_id=$id'), headers: headersBearer());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //debugPrint(data.toString());
        if (data['status'] == 0) {
          _getController.changeReviewsModel(ReviewsModel.fromJson(data));
          _getController.initializeExpandedCommentList(data['result'].length);
        } else {
          debugPrint('Xatolik getReviews: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik getReviews: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik getReviews: $e');
      debugPrint(stacktrace.toString());
    }
  }


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Kafolatli mahsulotlar

  final Map<int, String> uzbekMonths = {
    1: 'yanvar',
    2: 'fevral',
    3: 'mart',
    4: 'aprel',
    5: 'may',
    6: 'iyun',
    7: 'iyul',
    8: 'avgust',
    9: 'sentabr',
    10: 'oktabr',
    11: 'noyabr',
    12: 'dekabr',
  };

// O'zbek tilidagi kun nomlari (agar kerak bo'lsa, masalan qisqa)
  final Map<int, String> uzbekWeekdays = {
    DateTime.sunday: 'Yakshanba',
    DateTime.monday: 'Dushanba',
    DateTime.tuesday: 'Seshanba',
    DateTime.wednesday: 'Chorshanba',
    DateTime.thursday: 'Payshanba',
    DateTime.friday: 'Juma',
    DateTime.saturday: 'Shanba',
  };

  String formatUzbekDate(DateTime date, {String pattern = "d MMMM y, HH:mm"}) {
    final day = date.day.toString().padLeft(2, '0');  // Kun (01, 02...)
    final monthName = uzbekMonths[date.month] ?? 'Noma\'lum oy';  // Oy nomi
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    // Pattern bo'yicha almashtirish
    String formatted = pattern
        .replaceAll('d', day)  // Kun raqami
        .replaceAll('MMMM', monthName)  // To'liq oy nomi
        .replaceAll('y', year)  // Yil
        .replaceAll('HH', hour)  // Soat (24-soat format)
        .replaceAll('mm', minute);  // Daqiqa

    return formatted;
  }

  String formatLocalizedDate(DateTime date, {String lang = 'uz'}) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    if (lang == 'ru') {
      // 12.10.2025 в 18:00
      return '$day.$month.$year в $hour:$minute';
    } else if (lang == 'en') {
      // on 12.10.2025 at 18:00
      return 'on $day.$month.$year at $hour:$minute';
    } else if (lang == 'oz') {
      // on 12.10.2025 at 18:00
      return '$day.$month.$year соат $hour:$minute да';
    } else {
      // O'zbekcha: 12.10.2025 soat 18:00 da
      return '$day.$month.$year soat $hour:$minute da';
    }
  }

  DateTime? parseLocalizedDateTime(String dateStr) {
    return DateTime.tryParse(dateStr);
  }

  Future<void> addWarrantyProduct(String code, context) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/warranty/products'));
      request.headers.addAll(multipartHeaderBearer());
      request.fields.addAll({'qrcode': _getController.codeController.text});
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      debugPrint(responseBody.toString());
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        _getController.searchController.clear();
        var data = jsonDecode(responseBody);
        Get.back();
        if (data['status'] == 0) {
          getWarrantyProducts(filter: 'c.active=1');
          _getController.clearSortedTransactionsModel();
          _getController.changeSelectedMonth(0);
          InstrumentComponents().showToast('Kafolatli mahsulot muvaffaqiyatli qo‘shildi', color: AppColors.green);
          getProfile(isWorker: false);
        }
        else if (data['status'] == 9) {
          final info = data['additional'];
          final int? ids = info['code_id'].toInt();
          final userPhone = info['user_phone'] ?? '';
          final maskedPhone = userPhone.replaceRange(6, 9, '***');
          final codeAdded = info['code_added'] ?? '';
          DateTime parsedDate;
          try {
            parsedDate = parseLocalizedDateTime(codeAdded) ?? DateTime.now(); // Yangi parse funksiyasi
          } catch (e) {
            parsedDate = DateTime.now();
          }

          _getController.headerLanguage;
          final currentLang = _getController.headerLanguage;
          final formattedDate = formatLocalizedDate(parsedDate, lang: currentLang);

          // Xabarlar
          String message;
          if (currentLang == 'ru') {
            message = 'Этот QR-код ранее был зарегистрирован пользователем с номером $maskedPhone $formattedDate.';
          } else if (currentLang == 'en') {
            message = 'This QR-code was previously registered by the user with the number $maskedPhone $formattedDate.';
          } else if (currentLang == 'oz') {
            message = 'Ушбу QR-код аввал $maskedPhone рақамли фойдаланувчи томонидан $formattedDate рўйхатдан ўтказилган.';
          } else if (currentLang == 'uz') {
            message = 'Ushbu QR-kod avval $maskedPhone raqamli foydalanuvchi tomonidan $formattedDate ro‘yxatdan o‘tkazilgan.';
          } else {
            message = 'Этот QR-код ранее был зарегистрирован пользователем с номером $maskedPhone $formattedDate.';
          }
          // Dialog ko'rsatish
          if (_getController.profileInfoModel.value.result?.first.phone == userPhone) {
            _getController.clearWarrantyModel();
            _getController.clearSortedWarrantyModel();
            _getController.warrantyId.value = ids;
            ApiController().getWarrantyProducts(filter: 'c.active=1').then((value) {
              Get.to(() => const GuaranteePage(isCode: true), transition: Transition.fadeIn);
            });
            //Get.to(() => const GuaranteePage(isCode: true), transition: Transition.fadeIn);
          } else {
            InstrumentComponents().addWarrantyDialog(context, message);
          }
          //InstrumentComponents().addWarrantyDialog(context, 'Ushbu mahsulotning seriya raqami ro‘yxatdan o‘tgan! Agarda xatolik bo‘lsa, bizga murojaat qiling.');
        }
        else if (data['status'] == 8) {
          InstrumentComponents().addWarrantyDialog(context,'Bunday seriya raqami mavjud emas! Agarda xatolik bo‘lsa, bizga murojaat qiling');
        }
        else if (data['status'] == 20) {
          InstrumentComponents().addWarrantyDialog(context,'Ushbu mahsulotning Arxivda mavjud!');
        }
        else {
          //debugPrint('Xatolik: ${data['message']}');
          InstrumentComponents().showToast('Xatolik: ${data['message']}', color: AppColors.red);
        }
      }
    } catch (e, stacktrace) {
      debugPrint('addWarrantyProduct funksiyasida xatolik: $e');
      debugPrint('Stacktrace addWarrantyProduct: $stacktrace');
      Get.back();
      InstrumentComponents().addWarrantyDialog(context,'Bunday seriya raqami mavjud emas! Agarda xatolik bo‘lsa, bizga murojaat qiling');
      //InstrumentComponents().showToast('Tarmoq muammosi: Iltimos, qayta urinib ko‘ring', color: AppColors.red);
    }
  }

  Future<void> getWarrantyProducts({filter = ''}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/warranty/products${filter != '' ? '?filter=$filter&sort=warranty_start.desc' : '?sort=warranty_start.desc'}'), headers: headersBearer());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint('$baseUrl/warranty/products${filter != '' ? '?filter=$filter&sort=warranty_start.desc' : '?sort=warranty_start.desc'}');
        //debugPrint(data.toString());
        if (data['status'] == 0) {
          _getController.changeWarrantyModel(WarrantyModel.fromJson(data));
        }
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik getWarrantyProducts: $e');
      debugPrint('Xatolik getWarrantyProducts: $stacktrace');
    }
  }

  Future<void> deleteWarrantyProduct(int id, {bool isArchived = false}) async {
    try {
      //final response = await http.delete(Uri.parse('$baseUrl/warranty/products?id=$id&archived=1'), headers: headersBearer());
      final response = await http.delete(Uri.parse('$baseUrl/warranty/products?id=$id'), headers: headersBearer());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //debugPrint(data.toString());
        if (data['status'] == 0) {
          getWarrantyProducts(filter: 'c.active=1');
        } else {
          debugPrint('Xatolik deleteWarrantyProduct: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik deleteWarrantyProduct: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik deleteWarrantyProduct: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> archiveWarrantyProduct(int id, {bool isArchived = true}) async {
    try {
      if (isArchived) {
        final response = await http.post(Uri.parse('$baseUrl/warranty/archive'), headers: headerBearer(),body: {
          'id': id.toString(),
          'is_archived': '1'
        });
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          //debugPrint(data.toString());
          if (data['status'] == 0) {
            getWarrantyProducts(filter: 'c.active=1');
          } else {
            debugPrint('Xatolik: ${data['message']}');
          }
        }
        else {
          debugPrint('Xatolik archiveWarrantyProduct: Serverga ulanishda muammo');
        }
      }
      else {
        final response = await http.delete(Uri.parse('$baseUrl/warranty/archive?id=$id'), headers: headerBearer());
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          //debugPrint(data.toString());
          if (data['status'] == 0) {
            getWarrantyProduct(filter: 'c.active=1');
          } else {
            debugPrint('Xatolik archiveWarrantyProduct: ${data['message']}');
          }
        }
        else {
          debugPrint('Xatolik archiveWarrantyProduct: Serverga ulanishda muammo');
        }
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik archiveWarrantyProduct: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> getWarrantyProduct({filter = ''}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/warranty/archive${filter != '' ? '?filter=$filter&sort=warranty_start.desc' : '?sort=warranty_start.desc'}'), headers: headersBearer());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        //debugPrint(data.toString());
        if (data['status'] == 0) {
          _getController.changeWarrantyModel(WarrantyModel.fromJson(data));
        } else {
          debugPrint('Xatolik archiveWarrantyProduct: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik archiveWarrantyProduct: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik archiveWarrantyProduct: $e');
      debugPrint(stacktrace.toString());
    }
  }


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//To'lovlar

  Future<void> getCards() async {
    try {
      _getController.clearCardsModel();
      final response = await http.get(Uri.parse('$baseUrl/payment/cards'), headers: headersBearer());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint(data.toString());
        if (data['status'] == 0) {
          _getController.changeCardsModel(CardsModel.fromJson(data));
          if (_getController.cardsModel.value.result!.length == 1) {
            _getController.saveSelectedCardIndex(0);
          }
        } else {
          debugPrint('Xatolik archiveWarrantyProduct: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik archiveWarrantyProduct: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik archiveWarrantyProduct: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> addCard() async {
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/payment/cards'));
    request.headers.addAll(multipartHeaderBearer());
    request.fields.addAll({'card_no': _getController.cardNumberController.text, 'card_holder': _getController.nameController.text, 'expiration_date': DateFormat('MM/yyyy').format(DateTime(DateTime.now().year, DateTime.now().month + 3, 1))});
    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      debugPrint(responseBody.toString());
      if (response.statusCode == 200) {
        if (jsonDecode(responseBody)['status'] == 17) {
          InstrumentComponents().showToast('Kartalar chegaralangan miqdordan ko‘p!'.tr, color: AppColors.red);
          return;
        }
        if (jsonDecode(responseBody)['status'] == 18) {
          InstrumentComponents().showToast('Ushbu karta avval qo‘shilgan!'.tr, color: AppColors.red);
        }
        if (jsonDecode(responseBody)['status'] == 0) {
          _getController.cardNumberController.clear();
          _getController.nameController.clear();
          Get.back();
          _getController.changeErrorInput(0, true);
          _getController.changeErrorInput(1, true);
          _getController.tapTimes(() {_getController.changeErrorInput(0, false);_getController.changeErrorInput(1, false);},1);
          _getController.shakeKey[0].currentState?.shake();
          _getController.shakeKey[1].currentState?.shake();
          getCards();
          return;
        }
        Get.back();
      } else {
        debugPrint('Failed to add card archiveWarrantyProduct: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      debugPrint('Error occurred archiveWarrantyProduct: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> editCard(int id) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/payment/cards'));
    request.headers.addAll(multipartHeaderBearer());
    request.fields.addAll({'id': id.toString(), 'card_no': _getController.cardNumberController.text, 'card_holder': _getController.nameController.text, 'expiration_date': DateFormat('MM/yyyy').format(DateTime(DateTime.now().year, DateTime.now().month + 3, 1))});
    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      debugPrint(responseBody.toString());
      if (response.statusCode == 200) {
        _getController.cardNumberController.clear();
        _getController.nameController.clear();
        Get.back();
        getCards();
      } else {
        _getController.changeErrorInput(0, true);
        _getController.changeErrorInput(1, true);
        _getController.tapTimes(() {_getController.changeErrorInput(0, false);_getController.changeErrorInput(1, false);},1);
        _getController.shakeKey[0].currentState?.shake();
        _getController.shakeKey[1].currentState?.shake();
        InstrumentComponents().showToast('Serverga ulanishda muammo, keyinroq qayta urinib ko‘ring', color: AppColors.red);
      }
    } catch (e, stacktrace) {
      _getController.changeErrorInput(0, true);
      debugPrint(stacktrace.toString());
      _getController.changeErrorInput(1, true);
      _getController.tapTimes(() {_getController.changeErrorInput(0, false);_getController.changeErrorInput(1, false);},1);
      _getController.shakeKey[0].currentState?.shake();
      _getController.shakeKey[1].currentState?.shake();
      InstrumentComponents().showToast('Xatolik : $e', color: AppColors.red);
    }
  }

  Future<void> deleteCard(int id) async {
    var request = http.Request('DELETE', Uri.parse('$baseUrl/payment/cards?id=$id'));
    request.headers.addAll(headerBearer());
    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      debugPrint(responseBody.toString());
      if (response.statusCode == 200) {
        Get.back();
        getCards();
      } else {
        InstrumentComponents().showToast('Serverga ulanishda muammo, keyinroq qayta urinib ko‘ring', color: AppColors.red);
      }
    } catch (e, stacktrace) {
      InstrumentComponents().showToast('Serverga ulanishda muammo, keyinroq qayta urinib ko‘ring', color: AppColors.red);
      debugPrint(stacktrace.toString());
      debugPrint('Error occurred deleteCard: $e');
    }
  }

  Future<void> paymentWithdraw() async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/payment/withdraw'));
    request.headers.addAll(multipartHeaderBearer());
    request.fields.addAll({'amount': _getController.paymentController.text});
    request.fields.addAll({'card_id': _getController.cardsModel.value.result![_getController.selectedCard.value].id.toString()});
    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      //debugPrint(responseBody.toString());
      if (response.statusCode == 200) {
        if (jsonDecode(responseBody)['status'] == 0) {
          _getController.paymentController.clear();
          Get.back();
          getProfile(isWorker: false);
          _getController.clearSortedTransactionsModel();
          _getController.changeSelectedMonth(0);
          getCards();
          InstrumentComponents().showToast('Sizning so‘rovingiz ko‘rib chiqish uchun yuborildi', color: AppColors.green);
        } else if (jsonDecode(responseBody)['status'] == 1) {
          _getController.changeErrorInput(2, true);
          _getController.tapTimes(() =>_getController.changeErrorInput(2, false),1);
          InstrumentComponents().showToast('Tasdiqlangan keshbekingizda mablag‘ yetarli emas', color: AppColors.red);
        } else {
          _getController.changeErrorInput(2, true);
          _getController.tapTimes(() =>_getController.changeErrorInput(2, false),1);
          InstrumentComponents().showToast('Xatolik ${jsonDecode(responseBody)['message']}', color: AppColors.red);
        }
      } else {
        _getController.changeErrorInput(2, true);
        _getController.tapTimes(() =>_getController.changeErrorInput(2, false),1);
        InstrumentComponents().showToast('Serverga ulanishda muammo, keyinroq qayta urinib ko‘ring', color: AppColors.red);
      }
    } catch (e, stacktrace) {
      _getController.changeErrorInput(2, true);
      debugPrint(stacktrace.toString());
      _getController.tapTimes(() =>_getController.changeErrorInput(2, false),1);
      InstrumentComponents().showToast('Xatolik: $e', color: AppColors.red);
      debugPrint('Error occurred paymentWithdraw: $e');
    }
  }

  Future<void> getTransactions({String? filter}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/payment/transactions${filter != '' ? '?filter=$filter' : ''}'), headers: headersBearer());
      //debugPrint('$baseUrl/payment/transactions${filter != '' ? '?filter=$filter' : ''}');
      //debugPrint(response.body.toString());
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['status'] == 0) {
          _getController.changeSortedTransactionsModel(
            SortedPayTransactions.fromJson({"status": jsonDecode(response.body)['status'], "message": jsonDecode(response.body)['message'], "result": List.from(jsonDecode(response.body)['result'][0])}),
            TwoList.fromJson({"status": jsonDecode(response.body)['status'], "message": jsonDecode(response.body)['message'], "result": List.from(jsonDecode(response.body)['result'][1])}),
          );
        } else if (jsonDecode(response.body)['status'] == 4){
          debugPrint('token: ${jsonDecode(response.body)['message']}');
        } else {
          debugPrint('Xatolik getTransactions: ${jsonDecode(response.body)['message']}');
        }
      } else {
        debugPrint('Xatolik getTransactions: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik getTransactions: $e');
      debugPrint(stacktrace.toString());
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Profile
  Future<void> getProfile({bool isWorker = true}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/profile'), headers: headersBearer());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['status'] == 0) {
          print('$baseUrl/users/profile');
          debugPrint(data['result'].toString());
          _getController.changeProfileInfoModel(ProfileInfoModel.fromJson(data));
          if (isWorker && _getController.profileInfoModel.value.result?.first.firstName == null || _getController.profileInfoModel.value.result?.first.lastName == '') {
            getCountries();
            _getController.updateSelectedDate(DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day));
            Get.to(() => const RegisterPage());
          } else if (isWorker) {
            getCountries(me: true);
            Get.offAll(() => _getController.getPassCode() != '' ? PasscodePage() : CreatePasscodePage());
            //Get.offAll(() => NotConnection());\
          }
        }
        else if (data['status'] == 4) {
          if (_getController.token != null && _getController.token.isNotEmpty){
            debugPrint('4');
            logout();
            _getController.logout();
            Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
          }
        }
        else if (data['status'] == 22) {
          debugPrint('22');
          if (_getController.token != null && _getController.token.isNotEmpty){
            logout();
            _getController.logout();
            Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
          }
        }
      }
      else if (response.statusCode == 401) {
        debugPrint('exx 401');
        logout();
        _getController.logout();
        Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
        return;
      }
      else if (response.statusCode == 404) {
        if (_getController.token != null && _getController.token.isNotEmpty){
          debugPrint('exx 404');
          Get.offAll(() => const NotConnection(), transition: Transition.fadeIn, arguments: true);
          sendErrorMessage('404 Server Ishlamayotgan bo‘lishi mumkin!');
          return;
        }
      }
      else {
        if (_getController.token != null && _getController.token.isNotEmpty){
          debugPrint('exx else');
          sendErrorMessage('Xatolik: Server Ishlamayotgan bo‘lishi mumkin!');
          Get.offAll(const NotConnection(), transition: Transition.fadeIn, arguments: true);
        }

      }
    } catch(e, stacktrace) {
      if (_getController.token != null && _getController.token.isNotEmpty){
        debugPrint('xaotlik getProfile: $e');
        sendErrorMessage('Server Ishlamayotgan bo‘lishi mumkin!: $e\n$stacktrace');
        debugPrint(stacktrace.toString());
        Get.offAll(const NotConnection(), transition: Transition.fadeIn, arguments: true);
      }
    }
  }

  Future<void> updateProfiles() async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/users/profile'),);
      request.headers.addAll(multipartHeaderBearer());
      request.fields['first_name'] = _getController.nameController.text;
      request.fields['last_name'] = _getController.surNameController.text;
      request.fields['birthday'] = DateFormat('yyyy-MM-dd').format(_getController.selectedDate.value);
      request.fields['user_type'] = _getController.dropDownItems[0].toString();
      request.fields['country_id'] = _getController.countriesModel.value.countries![_getController.dropDownItems[1]].id.toString();
      request.fields['region_id'] = _getController.regionsModel.value.regions![_getController.dropDownItems[2]].id.toString();
      request.fields['city_id'] = _getController.citiesModel.value.cities![_getController.dropDownItems[3]].id.toString();
      request.fields['address'] = _getController.streetController.text;
      if (_getController.image.value.path != '') {
        var photo = await http.MultipartFile.fromPath('photo', _getController.image.value.path);
        request.files.add(photo);
      }
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      debugPrint(responseBody.toString());
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(responseBody);
        if (data['status'] == 0) {
          _getController.clearSendCodeModel();
          getProfile(isWorker: false);
          getCountries(me: true);
        } else if (data['status'] == 1) {
          InstrumentComponents().showToast('Ehhh nimadir xato ketdi'.tr, color: AppColors.red);
        } else {
          debugPrint('Xatolik updateProfiles: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik updateProfiles: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik updateProfiles: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> updateProfile() async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/users/profile'));
      request.headers.addAll(multipartHeaderBearer());
      request.fields['first_name'] = _getController.nameController.text;
      request.fields['last_name'] = _getController.surNameController.text;
      request.fields['birthday'] = DateFormat('yyyy-MM-dd').format(_getController.selectedDate.value);
      request.fields['user_type'] = _getController.dropDownItems[0].toString();
      request.fields['country_id'] = _getController.countriesModel.value.countries![_getController.dropDownItems[1]].id.toString();
      request.fields['region_id'] = _getController.regionsModel.value.regions![_getController.dropDownItems[2]].id.toString();
      request.fields['city_id'] = _getController.citiesModel.value.cities![_getController.dropDownItems[3]].id.toString();

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      debugPrint(responseBody.toString());
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(responseBody);
        if (data['status'] == 0) {
          getCountries(me: true);
          getProfile(isWorker: true);
          Get.back();
        } else if (data['status'] == 1) {
          InstrumentComponents().showToast('Ehhh nimadir xato ketdi'.tr, color: AppColors.red);
        } else {
          debugPrint('Xatolik updateProfile: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik updateProfile: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik updateProfile: $e');
      debugPrint(stacktrace.toString());
      return;
    }
  }

  Future<void> deleteProfile() async {
    try {
      debugPrint('Profil o‘chirish');
      final response = await http.delete(Uri.parse('$baseUrl/users/profile'), headers: headersBearer());
      debugPrint(response.body.toString());
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['status'] == 0) {
          _getController.logout();
          Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik deleteProfile: Serverga ulanishda muammo');
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik deleteProfile: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> logout() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/logout'), headers: headersBearer());
      debugPrint(response.body.toString());
      debugPrint(response.statusCode.toString());
    } catch (e, stacktrace) {
      debugPrint('Xatolik: $e');
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> deleteImage() async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/images/profiles?id=${_getController.profileInfoModel.value.result?.first.id}'), headers: headersBearer());
      debugPrint(response.body.toString());
      debugPrint(response.statusCode.toString());
    } catch (e, stacktrace) {
      debugPrint('Xatolik: $e');
      debugPrint(stacktrace.toString());
    }
  }


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Patner magazine

  Future<void> getPartnerMagazine({bool? rating, String? search}) async {
    String ratingSort = rating == true ? '?sort=rating.desc' : '';
    String searchFilter = search != null ? rating == true ? '&filter=name CONTAINS $search' : '?filter=name CONTAINS ${'"$search"'}' : '';
    try {
      final response = await http.get(Uri.parse('$baseUrl/catalog/shops$ratingSort$searchFilter'));
      debugPrint('$baseUrl/catalog/shops$ratingSort$searchFilter');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        _getController.changePartnerModels(PartnerModels.fromJson(data));
      }
    } catch (e, stacktrace) {
      debugPrint('Xatolik getPartnerMagazine: $e');
      debugPrint(stacktrace.toString());
    }
  }


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//message error

  String formatLoginErrorMessage({required String id, required String name, required String phone, required String error}) {
    return """
🆔 ID: $id
👤 Ismi: $name
📞 Telefon raqami: $phone
⚠️ Muammo: $error
""";
  }

  Future<void> sendErrorMessage(String errorMessage) async {
    try {
      final url = Uri.parse('https://hicom.uz/link-sniper/error_message.php');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'error_message': formatLoginErrorMessage(
            id: _getController.getProfileId != null ? _getController.getProfileId.toString() : 'Noma’lum',
            name: '${_getController.getProfileFirstName ?? ''} ${_getController.getProfileLastName ?? ''}',
            phone: _getController.phoneNumber ?? 'Noma’lum',
            error: errorMessage,
          )
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Error message sent successfully: ${response.body}');
      } else {
        debugPrint('Failed to send error message. Status code: ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      debugPrint('Exception while sending error message: $e');
      debugPrint(stacktrace.toString());
    }
  }



}
