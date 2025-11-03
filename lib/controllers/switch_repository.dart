import 'package:get/get.dart';
import 'package:hicom_patners/controllers/api_controller.dart';

import '../models/sample/switch_model.dart';

class SwitchRepository {
  final ApiController _apiService = Get.find();

  Future<List<SwitchModel>> getProjects() async {
    final data = await _apiService.getProjects();
    return data.map((json) => SwitchModel.fromJson(json)).toList();
  }
}