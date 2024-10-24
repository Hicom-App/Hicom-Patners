import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/auth/login_page.dart';
import 'package:hicom_patners/pages/auth/register_page.dart';
import 'package:hicom_patners/pages/sample/sample_page.dart';
import 'package:hicom_patners/pages/sample/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/auth/countries_model.dart';
import '../models/sample/categories.dart';
import '../models/sample/profile_info_model.dart';
import '../pages/auth/verify_page_number.dart';
import '../pages/not_connection.dart';
import 'get_controller.dart';

class ApiController extends GetxController {
  final GetController _getController = Get.put(GetController());

  final  baseUrl = 'http://185.196.213.76:8080/api';

  //return header function
  Map<String, String> headersBearer() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_getController.token}',
    };
  }

  //Auth
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Registratsiya

  Future<void> sendCode() async {
    String url = '$baseUrl/auth/register';
    Map<String, dynamic> body = {'phone': _getController.code.value + _getController.phoneController.text};
    final response = await http.post(Uri.parse(url), headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    debugPrint(_getController.code.value + _getController.phoneController.text);
    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        _getController.startTimer();
        Get.to(() => const VerifyPageNumber(), transition: Transition.fadeIn);
      } else {
        _getController.shakeKey[8].currentState?.shake();
        debugPrint('Xatolik: ${data['message']}');
      }
    } else {
      debugPrint('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> verifyPhone() async {
    Map<String, dynamic> body = {'phone': _getController.code.value + _getController.phoneController.text, 'code': _getController.verifyCodeControllers.text};
    final response = await http.post(Uri.parse('$baseUrl/auth/verify'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        _getController.saveToken(data['result']['token']);
        _getController.savePhoneNumber(_getController.code.value + _getController.phoneController.text);
        _getController.errorFieldOk.value = true;
        _getController.errorField.value = true;
        _getController.tapTimes((){
          _getController.errorFieldOk.value = false;
          _getController.errorField.value = false;
          _getController.verifyCodeControllers.clear();
          login();
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
    } else {
      debugPrint('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> getCountries({int? offset, int? limit}) async {
    String url = '$baseUrl/place/countries';
    final response = await http.get(Uri.parse(url));
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
  }

  Future<void> getRegions(int countryId) async {
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
  }

  Future<void> getCities(int regionId, {int? offset, int? limit}) async {
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
  }

  Future<void> login() async {
    Map<String, dynamic> body = {'phone': _getController.phoneNumber.toString()};
    debugPrint(body.toString());
    try {
      final response = await http.post(Uri.parse('$baseUrl/auth/login'), headers: headersBearer(), body: jsonEncode(body));
      debugPrint(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 0) {
          debugPrint('Login muvaffaqiyatli: ${data['message']}');
          getProfile();
        } else if (data['status'] == 3 || data['status'] == 4) {
          if (_getController.phoneNumber != '' && _getController.token != null) {
            _getController.updateSelectedDate(DateTime.now());
            Get.to(() => const RegisterPage());
            getCountries();
          } else {
            Get.offAll(const LoginPage(), transition: Transition.fadeIn);
          }
        } else {
          Get.offAll(NotConnection(), transition: Transition.fadeIn);
        }
      } else {
        debugPrint('Xatolik: Serverga ulanishda muammo');
      }
    } catch(e) {
      debugPrint('bilmasam endi: $e');
      Get.offAll(NotConnection(), transition: Transition.fadeIn);
    }

  }

  Future<void> getProfile({bool isWorker = true}) async {
    final response = await http.get(Uri.parse('$baseUrl/users'), headers: headersBearer());
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
          Get.offAll(() => SamplePage());
        }
      } else {
        debugPrint('Xatolik: ${data['message']}');
      }
    } else if (response.statusCode == 401) {
      _getController.logout();
      login();
    } else if (response.statusCode == 404) {
      _getController.logout();
      login();
    }
    else {
      debugPrint('Xatolik1: Serverga ulanishda muammo');
    }
  }

  Future<void> updateProfiles() async {
    print(_getController.dropDownItems[1].toString());
    print(_getController.dropDownItems[2].toString());
    print(_getController.dropDownItems[3].toString());
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/users'),);
      request.headers.addAll({'Authorization': 'Bearer ${_getController.token}', 'Content-Type': 'multipart/form-data',});
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
      'city_id': _getController.citiesModel.value.cities![_getController.dropDownItems[3]].id,
    };
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Authorization': 'Bearer ${_getController.token}', 'Content-Type': 'application/json',},
      body: jsonEncode(body),
    );
    debugPrint(response.body.toString());
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        login();
      } else if (data['status'] == 1) {
        Get.offAll(() => SplashScreen(), transition: Transition.fadeIn);
      }
      else {
        debugPrint('Xatolik: ${data['message']}');
      }
    } else {
      debugPrint('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> deleteProfile() async {
    debugPrint('Profil o‘chirish');
    final response = await http.delete(Uri.parse('$baseUrl/users'), headers: headersBearer());
    debugPrint(response.body.toString());
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        _getController.logout();
        login();
      } else {
        debugPrint('Xatolik: ${data['message']}');
      }
    } else {
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Mahsulot kategoriyalari ro'yxatini olish

  Future<void> getCategories({int? offset, int? limit}) async {
    final response = await http.get(Uri.parse('$baseUrl/catalog/categories'), headers: {'Authorization': 'Bearer ${_getController.token}'});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      debugPrint(data.toString());
      if (data['status'] == 0) {
        _getController.changeCategoriesModel(CategoriesModel.fromJson(data));
        debugPrint(jsonEncode(_getController.categoriesModel.value).toString());
        getProducts(0);
        //getAllCatProducts();
        //debugPrint('Kategoriyalar ro‘yxati: ${data['result']}');
      } else {
        debugPrint('Xatolik: ${data['message']}');
      }
    } else {
      debugPrint('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Mahsulotlar ro'yxatini olish
  Future<void> getProducts(int categoryId, {bool isCategory = true, int? offset, int? limit}) async {
    final response = await http.get(Uri.parse('$baseUrl/catalog/products${categoryId == 0 ? '' : '?category_id=$categoryId'}'),
      headers: {'Authorization': 'Bearer ${_getController.token}'},);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        if (isCategory == true) {
          _getController.changeProductsModel(CategoriesModel.fromJson(data));
        } else {
          _getController.changeCatProductsModel(CategoriesModel.fromJson(data));
        }
      } else {
        debugPrint('Xatolik: ${data['message']}');
      }
    } else {
      debugPrint('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> getProduct(categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/catalog/products${categoryId == 0 || categoryId == null ? '' : '?category_id=$categoryId'}'), headers: headersBearer());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0 && data['result'] != null) {
        _getController.addCategoriesProductsModel(CategoriesModel.fromJson(data));
      } else {
        debugPrint('Xatolik: ${data['message']}');
      }
    } else {
      debugPrint('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> getAllCatProducts() async {
    for (int i = 0; i < _getController.categoriesModel.value.result!.length; i++) {
      await getProduct(_getController.categoriesModel.value.result![i].id);
    }
  }
}
