import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/companents/instrument/instrument_components.dart';
import 'package:hicom_patners/pages/auth/login_page.dart';
import 'package:hicom_patners/pages/auth/register_page.dart';
import 'package:hicom_patners/pages/sample/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/auth/countries_model.dart';
import '../models/auth/send_code_model.dart';
import '../models/sample/cards_model.dart';
import '../models/sample/categories.dart';
import '../models/sample/profile_info_model.dart';
import '../models/sample/reviews_model.dart';
import '../models/sample/sorted_pay_transactions.dart';
import '../models/sample/warranty_model.dart';
import '../pages/auth/passcode/create_passcode_page.dart';
import '../pages/auth/passcode/passcode_page.dart';
import '../pages/auth/verify_page_number.dart';
import '../pages/not_connection.dart';
import '../resource/colors.dart';
import 'get_controller.dart';

class ApiController extends GetxController {
  final GetController _getController = Get.put(GetController());

  final  baseUrl = 'http://185.196.213.76:8080/api';

  //return header function
  Map<String, String> headersBearer() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_getController.token}',
      'Content-Language': _getController.headerLanguage
    };
  }

  Map<String, String> headerBearer() {
    return {
      'Authorization': 'Bearer ${_getController.token}'
    };
  }

  Map<String, String> header() {
    return {
      'Content': 'application/json'
    };
  }

  Map<String, String> multipartHeaderBearer() {
    return {
      'Authorization': 'Bearer ${_getController.token}',
      'Content-Type': 'multipart/form-data',
      'Content-Language': _getController.headerLanguage
    };
  }

  //Auth
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Registratsiya

  Future<void> sendCodeRegister() async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/users/register'));
    request.fields['phone'] = _getController.code.value + _getController.phoneController.text;
    request.headers.addAll(header());
    var response = await request.send();
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      if (data['status'] == 0) {
        _getController.changeSendCodeModel(SendCodeModel.fromJson(data));
        print(jsonEncode(_getController.sendCodeModel.value.toJson()).toString());
        _getController.startTimer();
        Get.to(() => const VerifyPageNumber(isRegister: true), transition: Transition.fadeIn);
      } else if (data['status'] == 5) {
        _getController.shakeKey[8].currentState?.shake();
        InstrumentComponents().showToast('Ushbu telefon ro‘yhatdan o‘qilgan', color: AppColors.red, textColor: AppColors.white);
      }
      else {
        _getController.shakeKey[8].currentState?.shake();
        debugPrint('Xatolik: ${data['message']}');
      }
    } else {
      debugPrint('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> sendCode() async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/users/login'));
    request.fields['phone'] = _getController.code.value + _getController.phoneController.text;
    request.fields['password'] = '';
    request.fields['restore'] = '0';
    request.headers.addAll(header());
    var response = await request.send();
    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      if (data['status'] == 0) {
        _getController.changeSendCodeModel(SendCodeModel.fromJson(data));
        print(jsonEncode(_getController.sendCodeModel.value.toJson()).toString());
        _getController.startTimer();
        Get.to(() => const VerifyPageNumber(isRegister: false), transition: Transition.fadeIn);
      } else if (data['status'] == 3){
        sendCodeRegister();
      }
      else {
        _getController.shakeKey[8].currentState?.shake();
        debugPrint('Xatolik: ${data['message']}');
      }
    } else {
      debugPrint('Xatolik: Serverga ulanishda muammo');
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
      if (data['status'] == 0) {
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

  Future<void> getCountries() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/place/countries'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 0) {
          _getController.changeCountriesModel(CountriesModel.fromJson(data));
          debugPrint('Davlatlar ro‘yxati: ${data['countries']}');
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> getRegions(int countryId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/place/regions?country_id=$countryId'));
      debugPrint(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 0) {
          _getController.changeRegionsModel(CountriesModel.fromJson(data));
          debugPrint('Viloyatlar ro‘yxati: ${data['regions']}');
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> getCities(int regionId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/place/cities?region_id=$regionId'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 0) {
          debugPrint('Shaharlar ro‘yxati: ${data['cities']}');
          _getController.changeCitiesModel(CountriesModel.fromJson(data));
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> getProfile({bool isWorker = true}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/profile'), headers: headersBearer());
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        debugPrint(data.toString());
        if (data['status'] == 0) {
          _getController.changeProfileInfoModel(ProfileInfoModel.fromJson(data));
          if (isWorker && _getController.profileInfoModel.value.result?.first.firstName == null || _getController.profileInfoModel.value.result?.first.lastName == '') {
            getCountries();
            _getController.updateSelectedDate(DateTime.now());
            Get.to(() => const RegisterPage());
          } else if (isWorker) {
            Get.offAll(() => _getController.getPassCode() != '' ? PasscodePage() : CreatePasscodePage());
          }
        } else if (data['status'] == 4) {
          logout();
          _getController.logout();
          Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
        }
      } else if (response.statusCode == 401) {
        logout();
        _getController.logout();
        Get.offAll(() => const LoginPage(), transition: Transition.fadeIn);
      } else if (response.statusCode == 404) {
        Get.offAll(() => NotConnection(), transition: Transition.fadeIn);
      }
      else {
        debugPrint('Xatolik1: Serverga ulanishda muammo');
      }
    } catch(e) {
      debugPrint('bilmasam endi: $e');
      Get.offAll(NotConnection(), transition: Transition.fadeIn);
    }
  }

  Future<void> updateProfiles() async {
    print(_getController.dropDownItems[1].toString());
    print(_getController.dropDownItems[2].toString());
    print(_getController.dropDownItems[3].toString());
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
          Get.back();
        } else if (data['status'] == 1) {
          Get.offAll(() => SplashScreen(), transition: Transition.fadeIn);

        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> updateProfile() async {
    Map<String, dynamic> body = {
      'first_name': _getController.nameController.text,
      'last_name': _getController.surNameController.text,
      'birthday': DateFormat('yyyy-MM-dd').format(_getController.selectedDate.value),
      'user_type': _getController.dropDownItems[0],
      'country_id': _getController.countriesModel.value.countries![_getController.dropDownItems[1]].id,
      'region_id': _getController.regionsModel.value.regions![_getController.dropDownItems[2]].id,
      'city_id': _getController.citiesModel.value.cities![_getController.dropDownItems[3]].id
    };
    try {
      final response = await http.post(Uri.parse('$baseUrl/users/profile'), headers: multipartHeaderBearer(), body: jsonEncode(body));
      debugPrint(response.body.toString());
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['status'] == 0) {
          getProfile(isWorker: false);
        } else if (data['status'] == 1) {
          Get.offAll(() => SplashScreen(), transition: Transition.fadeIn);
        }
        else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
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
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> logout() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/logout'), headers: headersBearer());
      debugPrint(response.body.toString());
      debugPrint(response.statusCode.toString());
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Mahsulot kategoriyalari ro'yxatini olish

  Future<void> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/catalog/categories'), headers: headersBearer());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint(data.toString());
        if (data['status'] == 0) {
          _getController.changeCategoriesModel(CategoriesModel.fromJson(data));
          debugPrint(jsonEncode(_getController.categoriesModel.value).toString());
          getProducts(0);
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  // Mahsulotlar ro'yxatini olish
  Future<void> getProducts(int categoryId, {bool isCategory = true, bool isFavorite = false, filter}) async {
    try {
      String encodedFilter = filter != null && filter.isNotEmpty ? Uri.encodeComponent(filter) : '';
      final response = await http.get(Uri.parse(isFavorite ? '$baseUrl/catalog/favorites' : '$baseUrl/catalog/products?category_id=$categoryId${filter != '' ? '&filter=$encodedFilter' : ''}'), headers: headersBearer());
      print(isFavorite ? '$baseUrl/catalog/favorites' : '$baseUrl/catalog/products?category_id=$categoryId${filter != '' ? '&filter=$encodedFilter' : ''}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint(data.toString());
        if (data['status'] == 0) {
          if (isCategory == true) {
            _getController.changeProductsModel(CategoriesModel.fromJson(data));
            isFavorite ? _getController.changeCatProductsModel(CategoriesModel.fromJson(data)) : null;
          } else {
            _getController.changeCatProductsModel(CategoriesModel.fromJson(data));
          }
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> getProduct(int categoryId, {bool isCategory = true, filter}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/catalog/products${isCategory != true ? '?id=$categoryId' : '?category_id=$categoryId'}${filter != '' ? '&filter=$filter' : ''}'), headers: headersBearer());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data.toString());
        if (data['status'] == 0 && data['result'] != null) {
          if (isCategory == true) {
            _getController.addCategoriesProductsModel(CategoriesModel.fromJson(data));
          } else {
            _getController.clearProductsModelDetail();
            _getController.changeProductsModelDetail(CategoriesModel.fromJson(data));
            getReviews(categoryId);
          }
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> getAllCatProducts({filter}) async {
    for (int i = 0; i < _getController.categoriesModel.value.result!.length; i++) {
      await getProduct(_getController.categoriesModel.value.result![i].id ?? 0, filter: filter);
    }
  }

  Future<void> addFavorites(int id, {bool isProduct = true, isFavorite = false}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/catalog/favorites?product_id=$id'), body: {'product_id': id.toString(),'favorite': isProduct ? '1' : '0'}, headers: headerBearer());
      debugPrint(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint(data.toString());
        if (data['status'] == 0) {
          //getCategories();
          print(data.toString());
          getProducts(0, isFavorite: isFavorite);
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> addReview(int id) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/catalog/reviews'));
      request.headers.addAll(multipartHeaderBearer());
      request.fields.addAll({'id': '0', 'product_id': id.toString(), 'rating': _getController.rating.value.toString(), 'review': '${_getController.surNameController.text}.', 'user_id': '0'});
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      debugPrint(responseBody.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(responseBody);
        debugPrint(data.toString());
        if (data['status'] == 0) {
          print(data.toString());
          _getController.surNameController.text = '';
          InstrumentComponents().showToast('Sizning fikringiz muvaffaqiyatli saqlandi');
          getProduct(id, isCategory: false);
          Get.back();
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> getReviews(int id) async {
    //_getController.clearReviewsModel();
    try {
      final response = await http.get(Uri.parse('$baseUrl/catalog/reviews?product_id=$id'), headers: headersBearer());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint(data.toString());
        if (data['status'] == 0) {
          _getController.changeReviewsModel(ReviewsModel.fromJson(data));
          _getController.initializeExpandedCommentList(data['result'].length);
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Kafolatli mahsulotlar

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
          InstrumentComponents().showToast('Kafolatli mahsulot muvaffaqiyatli qo‘shildi', color: AppColors.green);
        } else if (data['status'] == 9) {
          InstrumentComponents().addWarrantyDialog(context, 'Ushbu mahsulotning seriya raqami ro‘yxatdan o‘tgan! Agarda xatolik bo‘lsa, bizga murojaat qiling.');
        } else if (data['status'] == 8) {
          InstrumentComponents().addWarrantyDialog(context,'Bunday seriya raqami mavjud emas! Agarda xatolik bo‘lsa, bizga murojaat qiling.');
        } else if (data['status'] == 20) {
          InstrumentComponents().addWarrantyDialog(context,'Ushbu mahsulotning Arxivda mavjud emas!');
        }
        else {
          debugPrint('Xatolik: ${data['message']}');
          InstrumentComponents().showToast('Xatolik: ${data['message']}', color: AppColors.red);
        }
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> getWarrantyProducts({filter = ''}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/warranty/products${filter != '' ? '?filter=$filter' : ''}'), headers: headersBearer());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint(data.toString());
        if (data['status'] == 0) {
          _getController.changeWarrantyModel(WarrantyModel.fromJson(data));
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> deleteWarrantyProduct(int id, {bool isArchived = false}) async {
    try {
      //final response = await http.delete(Uri.parse('$baseUrl/warranty/products?id=$id&archived=1'), headers: headersBearer());
      final response = await http.delete(Uri.parse('$baseUrl/warranty/products?id=$id'), headers: headersBearer());
      print('$baseUrl/warranty/products?id=$id${isArchived ? '&archived=1' : ''}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint(data.toString());
        if (data['status'] == 0) {
          getWarrantyProducts();
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> archiveWarrantyProduct(int id) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/warranty/archive'), headers: headerBearer(),body: {
        'id': id.toString(),
        'is_archived': '1',
      });
      print('$baseUrl/warranty/archive/products?id=$id');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint(data.toString());
        if (data['status'] == 0) {
          //getWarrantyProducts();
          getWarrantyProducts();
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

  Future<void> getWarrantyProduct({filter = ''}) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/warranty/archive${filter != '' ? '?filter=$filter' : ''}'), headers: headersBearer());
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint(data.toString());
        if (data['status'] == 0) {
          _getController.changeWarrantyModel(WarrantyModel.fromJson(data));
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
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
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
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
          InstrumentComponents().showToast('Kardtalar chegaralangan miqdordan ko`p!'.tr, color: AppColors.red);
          return;
        }
        if (jsonDecode(responseBody)['status'] == 18) {
          InstrumentComponents().showToast('Ushbu karta avval qo`shilgan!'.tr, color: AppColors.red);
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
        debugPrint('Failed to add card: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error occurred: $e');
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
        InstrumentComponents().showToast('Serverga ulanishda muammo, keyinroq qayta urunib ko‘ring', color: AppColors.red);
      }
    } catch (e) {
      _getController.changeErrorInput(0, true);
      _getController.changeErrorInput(1, true);
      _getController.tapTimes(() {_getController.changeErrorInput(0, false);_getController.changeErrorInput(1, false);},1);
      _getController.shakeKey[0].currentState?.shake();
      _getController.shakeKey[1].currentState?.shake();
      InstrumentComponents().showToast('Xatolik: $e', color: AppColors.red);
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
        InstrumentComponents().showToast('Serverga ulanishda muammo, keyinroq qayta urunib ko‘ring', color: AppColors.red);
      }
    } catch (e) {
      InstrumentComponents().showToast('Xatolik: $e', color: AppColors.red);
      debugPrint('Error occurred: $e');
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
      debugPrint(responseBody.toString());
      if (response.statusCode == 200) {
        if (jsonDecode(responseBody)['status'] == 0) {
          _getController.paymentController.clear();
          Get.back();
          getProfile(isWorker: false);
          getCards();
          InstrumentComponents().showToast('Sizning so‘rovingiz ko‘rib chiqish uchun yuborildi.', color: AppColors.green);
        } else if (jsonDecode(responseBody)['status'] == 1) {
          _getController.changeErrorInput(2, true);
          _getController.tapTimes(() =>_getController.changeErrorInput(2, false),1);
          InstrumentComponents().showToast('Tasiqlangan keshbekingizda mablag‘ yetarli emas', color: AppColors.red);
        } else {
          _getController.changeErrorInput(2, true);
          _getController.tapTimes(() =>_getController.changeErrorInput(2, false),1);
          InstrumentComponents().showToast('Xatolik ${jsonDecode(responseBody)['message']}', color: AppColors.red);
        }
      } else {
        _getController.changeErrorInput(2, true);
        _getController.tapTimes(() =>_getController.changeErrorInput(2, false),1);
        InstrumentComponents().showToast('Serverga ulanishda muammo, keyinroq qayta urunib ko‘ring', color: AppColors.red);
      }
    } catch (e) {
      _getController.changeErrorInput(2, true);
      _getController.tapTimes(() =>_getController.changeErrorInput(2, false),1);
      InstrumentComponents().showToast('Xatolik: $e', color: AppColors.red);
      debugPrint('Error occurred: $e');
    }
  }

  Future<void> getTransactions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/payment/transactions'), headers: headersBearer());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        debugPrint(data.toString());
        if (data['status'] == 0) {
          //_getController.changeTransactionsModel(TransactionsModel.fromJson(data));
          _getController.changeSortedTransactionsModel(SortedPayTransactions.fromJson(data));
          debugPrint('====================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================');
          debugPrint(jsonEncode(_getController.sortedTransactionsModel.value.toJson()).toString());
        } else {
          debugPrint('Xatolik: ${data['message']}');
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      debugPrint('Xatolik: $e');
    }
  }

}
