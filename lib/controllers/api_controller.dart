import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/auth/countries_model.dart';
import 'get_controller.dart';

class ApiController extends GetxController {
  final GetController _getController = Get.put(GetController());

  final String baseUrl = 'http://185.196.213.76:8080/api';

  // Tokenni saqlash
  final String bearerToken = 'YOUR_TOKEN_HERE'; // Bu yerda haqiqiy tokeningizni joylashtiring

  // Davlatlar ro'yxatini o'qish
  Future<void> getCountries({int? offset, int? limit}) async {
    String url = '$baseUrl/place/countries';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        _getController.changeCountriesModel(CountriesModel.fromJson(data));
        print('Davlatlar ro\'yxati: ${data['countries']}');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Viloyatlar ro'yxatini o'qish
  Future<void> getRegions(int countryId) async {
    String url = '$baseUrl/place/regions?country_id=$countryId';
    final response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        _getController.changeRegionsModel(CountriesModel.fromJson(data));
        print('Viloyatlar ro\'yxati: ${data['regions']}');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Shaharlar ro'yxatini o'qish
  Future<void> getCities(int regionId, {int? offset, int? limit}) async {
    String url = '$baseUrl/place/cities?region_id=$regionId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Shaharlar ro\'yxati: ${data['cities']}');
        _getController.changeCitiesModel(CountriesModel.fromJson(data));
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Kirish (login)
  Future<void> login(String phone) async {
    String url = '$baseUrl/auth/login';
    Map<String, dynamic> body = {'phone': phone};

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Login muvaffaqiyatli: ${data['message']}');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Registratsiya
  Future<void> register(String phone) async {
    String url = '$baseUrl/auth/register';
    Map<String, dynamic> body = {'phone': phone};

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Registratsiya muvaffaqiyatli: ${data['message']}');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Telefon raqamni tasdiqlash
  Future<void> verifyPhone(String phone, String code) async {
    String url = '$baseUrl/auth/verify';
    Map<String, dynamic> body = {'phone': phone, 'code': code};

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Telefon tasdiqlandi va token olindi: ${data['token']}');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Profil ma'lumotlarini olish
  Future<void> getProfile() async {
    String url = '$baseUrl/profile/info';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Profil ma\'lumotlari: ${data['profile']}');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }

  // Profil ma'lumotlarini o'zgartirish
  Future<void> updateProfile(String firstName, String lastName, String birthday,
      String userType, int countryId, int regionId, int cityId) async {
    String url = '$baseUrl/profile/info';
    Map<String, dynamic> body = {
      'first_name': firstName,
      'last_name': lastName,
      'birthday': birthday,
      'user_type': userType,
      'country_id': countryId,
      'region_id': regionId,
      'city_id': cityId,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Profil muvaffaqiyatli o\'zgartirildi');
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
      headers: {'Authorization': 'Bearer $bearerToken'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Kategoriyalar ro\'yxati: ${data['result']}');
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
      headers: {'Authorization': 'Bearer $bearerToken'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        print('Mahsulotlar ro\'yxati: ${data['result']}');
      } else {
        print('Xatolik: ${data['message']}');
      }
    } else {
      print('Xatolik: Serverga ulanishda muammo');
    }
  }
}
