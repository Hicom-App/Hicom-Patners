import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'get_controller.dart'; // GetController-ni implement qilgan fayl

class ApiController extends GetxController {
  final String baseUrl = 'http://185.196.213.76:8080/api';
  final GetController _getController = Get.put(GetController());

  // Davlatlar ro'yxatini olish
  Future<List<dynamic>> getCountries({int offset = 0, int limit = 10}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/place/countries'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "offset": offset,
        "limit": limit,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        return data['result']; // Davlatlar ro'yxati
      } else {
        throw Exception('Xatolik: ${data['message']}');
      }
    } else {
      throw Exception('Server bilan bog\'lanishda xatolik');
    }
  }

  // Viloyatlar ro'yxatini olish
  Future<List<dynamic>> getRegions(int countryId, {int offset = 0, int limit = 0}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/place/regions'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "country_id": countryId,
        "offset": offset,
        "limit": limit,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        return data['result']; // Viloyatlar ro'yxati
      } else {
        throw Exception('Xatolik: ${data['message']}');
      }
    } else {
      throw Exception('Server bilan bog\'lanishda xatolik');
    }
  }

  // Shahar/Tumanlar ro'yxatini olish
  Future<List<dynamic>> getCities(int regionId, {int offset = 0, int limit = 0}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/place/cities'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "region_id": regionId,
        "offset": offset,
        "limit": limit,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        return data['result']; // Shaharlar ro'yxati
      } else {
        throw Exception('Xatolik: ${data['message']}');
      }
    } else {
      throw Exception('Server bilan bog\'lanishda xatolik');
    }
  }

  // Kirish (Login)
  Future<void> login(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"phone": phone}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        // Muvaffaqiyatli login, kerakli ma'lumotlarni saqlash mumkin
      } else {
        throw Exception('Xatolik: ${data['message']}');
      }
    } else {
      throw Exception('Server bilan bog\'lanishda xatolik');
    }
  }

  // Registratsiya
  Future<void> register(String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"phone": phone}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        // Muvaffaqiyatli registratsiya
      } else {
        throw Exception('Xatolik: ${data['message']}');
      }
    } else {
      throw Exception('Server bilan bog\'lanishda xatolik');
    }
  }

  // Profilni o'qish
  Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile/info'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        return data['profile']; // Profil ma'lumotlari
      } else {
        throw Exception('Xatolik: ${data['message']}');
      }
    } else {
      throw Exception('Server bilan bog\'lanishda xatolik');
    }
  }

  // Profilni yangilash
  Future<void> updateProfile(String token, String firstName, String lastName, String birthday, int countryId, int regionId, int cityId, String userType) async {
    final response = await http.post(
      Uri.parse('$baseUrl/profile/info'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "birthday": birthday,
        "user_type": userType,
        "country_id": countryId,
        "region_id": regionId,
        "city_id": cityId,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] != 0) {
        throw Exception('Xatolik: ${data['message']}');
      }
    } else {
      throw Exception('Server bilan bog\'lanishda xatolik');
    }
  }

  // Mahsulot kategoriyalarini olish
  Future<List<dynamic>> getCategories(String token, {int offset = 0, int limit = 0}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/catalog/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "offset": offset,
        "limit": limit,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        return data['result']; // Kategoriyalar ro'yxati
      } else {
        throw Exception('Xatolik: ${data['message']}');
      }
    } else {
      throw Exception('Server bilan bog\'lanishda xatolik');
    }
  }

  // Mahsulotlar ro'yxatini olish
  Future<List<dynamic>> getProducts(String token, int categoryId, {int offset = 0, int limit = 0}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/catalog/products'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "category_id": categoryId,
        "offset": offset,
        "limit": limit,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 0) {
        return data['result']; // Mahsulotlar ro'yxati
      } else {
        throw Exception('Xatolik: ${data['message']}');
      }
    } else {
      throw Exception('Server bilan bog\'lanishda xatolik');
    }
  }

}
