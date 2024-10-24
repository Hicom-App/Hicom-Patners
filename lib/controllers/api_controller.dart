import 'dart:convert';
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

  final api = 'http://185.196.213.76:8080';
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
    print(_getController.code.value + _getController.phoneController.text);
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        _getController.startTimer();
        Get.to(() => const VerifyPageNumber(), transition: Transition.fadeIn);
      } else {
        _getController.shakeKey[8].currentState?.shake();
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
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
        print('Telefon tasdiqlandi va token olindi: ${data['result']['token']}');
      } else {
        _getController.shakeKey[7].currentState?.shake();
        print('Xatolik: ${data['message']}');
        _getController.changeErrorInput(0, true);
        _getController.errorField.value = true;
        print('Xatolik: xaaa0');
        _getController.tapTimes((){print('Xatolik: xaaa1');_getController.errorField.value = false;_getController.verifyCodeControllers.clear();_getController.changeErrorInput(0, false);}, 1);
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> getCountries({int? offset, int? limit}) async {
    String url = '$baseUrl/place/countries';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        _getController.changeCountriesModel(CountriesModel.fromJson(data));
        print('Davlatlar ro‘yxati: ${data['countries']}');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> getRegions(int countryId) async {
    final response = await http.get(Uri.parse('$baseUrl/place/regions?country_id=$countryId'));
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        _getController.changeRegionsModel(CountriesModel.fromJson(data));
        print('Viloyatlar ro‘yxati: ${data['regions']}');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> getCities(int regionId, {int? offset, int? limit}) async {
    final response = await http.get(Uri.parse('$baseUrl/place/cities?region_id=$regionId'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Shaharlar ro‘yxati: ${data['cities']}');
        _getController.changeCitiesModel(CountriesModel.fromJson(data));
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> login() async {
    Map<String, dynamic> body = {'phone': _getController.phoneNumber.toString()};
    print(body);
    try {
      final response = await http.post(Uri.parse('$baseUrl/auth/login'), headers: headersBearer(), body: jsonEncode(body));
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 0) {
          print('Login muvaffaqiyatli: ${data['message']}');
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
        print('Xatolik: Serverga ulanishda muammo');
      }
    } catch(e) {
      print('bilmasam endi: $e');
      Get.offAll(NotConnection(), transition: Transition.fadeIn);
    }

  }

  Future<void> getProfile() async {
    final response = await http.get(Uri.parse('$baseUrl/users'), headers: headersBearer());
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] == 0) {
        _getController.changeProfileInfoModel(ProfileInfoModel.fromJson(data));
        if (_getController.profileInfoModel.value.result?.first.firstName == null || _getController.profileInfoModel.value.result?.first.lastName == '') {
          getCountries();
          _getController.updateSelectedDate(DateTime.now());
          Get.to(() => const RegisterPage());
        } else {
          Get.offAll(() => SamplePage());
        }
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else if (response.statusCode == 401) {
      _getController.logout();
      login();
    } else if (response.statusCode == 404) {
      _getController.logout();
      login();
    }
    else {
      print('Xatolik1: Serverga ulanishda muammo');
    }
  }

  Future<void> updateProfile() async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/users'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer ${_getController.token}',
        'Content-Type': 'multipart/form-data',
      });

      // Add profile fields as text fields
      request.fields['first_name'] = _getController.nameController.text;
      request.fields['last_name'] = _getController.surNameController.text;
      request.fields['birthday'] = DateFormat('yyyy-MM-dd').format(_getController.selectedDate.value);
      request.fields['user_type'] = _getController.dropDownItems[0].toString();
      request.fields['country_id'] = _getController.dropDownItems[1].toString();
      request.fields['region_id'] = _getController.dropDownItems[2].toString();
      request.fields['city_id'] = _getController.dropDownItems[3].toString();

      // Add the photo file if it exists
      if (_getController.image.value.path != '') {
        var photo = await http.MultipartFile.fromPath('photo', _getController.image.value.path);
        request.files.add(photo);
      }

      // Send the request and get response
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print(responseBody);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(responseBody);
        if (data['status'] == 0) {
          login();
        } else if (data['status'] == 1) {
          Get.offAll(() => SplashScreen(), transition: Transition.fadeIn);
        } else {
          print('Xatolik: ${data['message']}');
        }
      } else {
        print('Xatolik: Serverga ulanishda muammo');
      }
    } catch (e) {
      print('Xatolik: $e');
    }
  }


  Future<void> updateProfiles() async {
    Map<String, dynamic> body = {
      'first_name': _getController.nameController.text,
      'last_name': _getController.surNameController.text,
      'birthday': DateFormat('yyyy-MM-dd').format(_getController.selectedDate.value),
      'user_type': _getController.dropDownItems[0],
      'country_id': _getController.dropDownItems[1],
      'region_id': _getController.dropDownItems[2],
      'city_id': _getController.dropDownItems[3]
    };
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Authorization': 'Bearer ${_getController.token}', 'Content-Type': 'application/json',},
      body: jsonEncode(body),
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        login();
      } else if (data['status'] == 1) {
        Get.offAll(() => SplashScreen(), transition: Transition.fadeIn);
      }
      else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> deleteProfile() async {
    print('Profil o‘chirish');
    final response = await http.delete(Uri.parse('$baseUrl/users'), headers: headersBearer());
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        _getController.logout();
        login();
      } else {
        print('Xatolik: ${data['message']}');
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
      print(data);
      //print(data);
      if (data['status'] == 0) {
        _getController.changeCategoriesModel(CategoriesModel.fromJson(data));
        print(jsonEncode(_getController.categoriesModel.value));
        getProducts(0);
        //getAllCatProducts();
        //print('Kategoriyalar ro‘yxati: ${data['result']}');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Mahsulotlar ro'yxatini olish
  Future<void> getProducts(int categoryId, {int? offset, int? limit}) async {
    final response = await http.get(Uri.parse('$baseUrl/catalog/products${categoryId == 0 ? '' : '?category_id=$categoryId'}'),
      headers: {'Authorization': 'Bearer ${_getController.token}'},);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        _getController.changeProductsModel(CategoriesModel.fromJson(data));
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> getProduct(categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/catalog/products${categoryId == 0 || categoryId == null ? '' : '?category_id=$categoryId'}'), headers: headersBearer());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0 && data['result'] != null) {
        _getController.addCategoriesProductsModel(CategoriesModel.fromJson(data));
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  Future<void> getAllCatProducts() async {
    for (int i = 0; i < _getController.categoriesModel.value.result!.length; i++) {
      await getProduct(_getController.categoriesModel.value.result![i].id);
    }
  }
}
