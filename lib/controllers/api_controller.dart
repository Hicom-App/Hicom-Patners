import 'dart:convert';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/auth/register_page.dart';
import 'package:hicom_patners/pages/sample/sample_page.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/auth/countries_model.dart';
import '../models/sample/profile_info_model.dart';
import '../pages/auth/verify_page_number.dart';
import '../pages/not_connection.dart';
import 'get_controller.dart';

class ApiController extends GetxController {
  final GetController _getController = Get.put(GetController());

  final String baseUrl = 'http://185.196.213.76:8080/api';


  //return header function
  Map<String, String> headersBearer() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_getController.token}',
    };
  }

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
        //{"status":0,"message":"OK"}
        print('Registratsiya muvaffaqiyatli: ${data['message']}');
        if (data['status'] == 0 && data['message'] == 'OK') {
          _getController.startTimer();
          Get.to(() => VerifyPageNumber(),transition: Transition.downToUp);
        }
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Telefon raqamni tasdiqlash
  Future<void> verifyPhone() async {
    String url = '$baseUrl/auth/verify';
    Map<String, dynamic> body = {
      'phone': _getController.code.value + _getController.phoneController.text,
      'code': _getController.verifyCodeControllers.text
    };
    final response = await http.post(Uri.parse(url), headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        _getController.saveToken(data['result']['token']);
        _getController.savePhoneNumber(_getController.code.value + _getController.phoneController.text);
        login();
        _getController.errorFieldOk.value = true;
        print('Telefon tasdiqlandi va token olindi: ${data['result']['token']}');
      } else {
        print('Xatolik: ${data['message']}');
        _getController.changeErrorInput(0, true);
        _getController.errorField.value = true;
        _getController.triggerShake();
        _getController.triggerShake();
        print('Xatolik: xaaa0');
        _getController.tapTimes((){print('Xatolik: xaaa1');_getController.errorField.value = false;_getController.verifyCodeControllers.clear();_getController.changeErrorInput(0, false);}, 1);
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Davlatlar ro'yxatini o'qish
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

  // Viloyatlar ro'yxatini o'qish
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

  // Shaharlar ro'yxatini o'qish
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

  // Kirish (login)
  Future<void> login() async {
    Map<String, dynamic> body = {'phone': _getController.phoneNumber};
    print(body);
    final response = await http.post(Uri.parse('$baseUrl/auth/login'), headers: headersBearer(), body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Login muvaffaqiyatli: ${data['message']}');
        //Get.to(() => SamplePage());
        getProfile();
      } else if (data['status'] == 3 || data['status'] == 4) {
        Get.to(() => const RegisterPage());
      } else {
        Get.offAll(NotConnection());
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Profil ma'lumotlarini olish
  Future<void> getProfile() async {
    final response = await http.get(Uri.parse('$baseUrl/profile/info'), headers: headersBearer());
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Profil ma‘lumotlari: ${data['profile']}');
        _getController.changeProfileInfoModel(ProfileInfoModel.fromJson(data));
        if (_getController.profileInfoModel.value.profile?.first.firstName == null || _getController.profileInfoModel.value.profile?.first.lastName == '') {
          Get.to(() => const RegisterPage());
        } else {
          Get.to(() => SamplePage());
        }
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Profil ma'lumotlarini o'zgartirish
  Future<void> updateProfile() async {
    String url = '$baseUrl/profile/info';
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
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${_getController.token}', 'Content-Type': 'application/json',},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Profil muvaffaqiyatli o‘zgartirildi');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Mahsulot kategoriyalari ro'yxatini olish
  Future<void> getCategories({int? offset, int? limit}) async {
    String url = '$baseUrl/catalog/categories';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${_getController.token.value}'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Kategoriyalar ro‘yxati: ${data['result']}');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Mahsulotlar ro'yxatini olish
  Future<void> getProducts(int categoryId, {int? offset, int? limit}) async {
    String url = '$baseUrl/catalog/products';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer ${_getController.token.value}'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Mahsulotlar ro‘yxati: ${data['result']}');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }
}
