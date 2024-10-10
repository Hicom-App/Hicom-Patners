import 'dart:convert'; // For JSON encoding and decoding
import 'package:get/get.dart'; // GetX package
import 'package:http/http.dart' as http; // For HTTP requests
import 'get_controller.dart'; // GetController for managing UI state

class ApiController extends GetxController {
  final GetController _getController = Get.put(GetController());
  static const String _baseUrl = 'http://185.196.213.76:8080/api/';

  // Davlatlar ro'yxatini olish
  Future<void> getCountries() async {
    var response = await http.get(Uri.parse('${_baseUrl}place/countries'));
    print(response.body);

    if (response.statusCode == 200) {
      // So'rov muvaffaqiyatli bo'lsa
      var data = jsonDecode(response.body);
      // Davlatlar ro'yxatini GetController'ga joylash
      _getController.countries.value = data['result'];
    } else {
      // So'rov xato bo'lsa
      print('Error: ${response.statusCode}');
    }
  }

  // Viloyatlar ro'yxatini olish
  Future<void> getRegions(int countryId) async {
    var response = await http.post(
      Uri.parse('${_baseUrl}place/regions'),
      body: {'country_id': countryId.toString()},
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Viloyatlar ro'yxatini GetController'ga joylash
      _getController.regions.value = data['result'];
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  // Shahar/Tumanlar ro'yxatini olish
  Future<void> getCities(int regionId) async {
    var response = await http.post(
      Uri.parse('${_baseUrl}place/cities'),
      body: {'region_id': regionId.toString()},
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Shaharlar ro'yxatini GetController'ga joylash
      _getController.cities.value = data['result'];
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  // Telefon raqamni registratsiya qilish
  Future<void> registerPhone(String phone) async {
    var response = await http.post(
      Uri.parse('${_baseUrl}auth/register'),
      body: {'phone': phone},
    );
    print(response.body);

    if (response.statusCode == 200) {
      // Registratsiya muvaffaqiyatli bo'lsa
      var data = jsonDecode(response.body);
      print(data['message']);
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  // Telefon raqamni tasdiqlash
  Future<void> verifyPhone(String phone, String code) async {
    var response = await http.post(
      Uri.parse('${_baseUrl}auth/verify'),
      body: {'phone': phone, 'code': code},
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Tasdiqlangan tokenni olish
      _getController.token.value = data['token'];
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  // Mahsulot kategoriyalari ro'yxatini olish
  Future<void> getCategories(String token) async {
    var response = await http.get(
      Uri.parse('${_baseUrl}catalog/categories'),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Kategoriyalar ro'yxatini GetController'ga joylash
      _getController.categories.value = data['result'];
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  // Mahsulotlar ro'yxatini olish
  Future<void> getProducts(int categoryId, String token) async {
    var response = await http.post(
      Uri.parse('${_baseUrl}catalog/products'),
      headers: {'Authorization': 'Bearer $token'},
      body: {'category_id': categoryId.toString()},
    );
    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Mahsulotlar ro'yxatini GetController'ga joylash
      _getController.products.value = data['result'];
    } else {
      print('Error: ${response.statusCode}');
    }
  }
}
