import 'package:get/get.dart';

import '../../../controllers/switch_repository.dart';
import '../../../models/sample/switch_model.dart';

class ProjectDetailController extends GetxController {
  final SwitchRepository _switchRepository = Get.find();

  final _project = Rx<SwitchModel?>(null);
  final _isLoading = false.obs;

  SwitchModel? get project => _project.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    final projectId = int.parse(Get.parameters['id']!);
    loadProject(projectId);
  }

  Future<void> loadProject(int projectId) async {
    try {
      _isLoading.value = true;
      final projects = await _switchRepository.getProjects();
      _project.value = projects.firstWhere((p) => p.id == projectId);
    } catch (e) {
      Get.snackbar('Xato', 'Loyiha ma\'lumotlarini yuklashda xato yuz berdi');
    } finally {
      _isLoading.value = false;
    }
  }
}