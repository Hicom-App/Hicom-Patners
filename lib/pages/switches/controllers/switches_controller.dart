import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/pages/switches/controllers/switch_detail_controller.dart';
import '../../../models/sample/project_model.dart';
import '../../../models/sample/switch_model.dart';
import '../views/switch_detail_view.dart';
import '../views/switch_list_view.dart';

class SwitchesController extends GetxController {
  final _projects = <ProjectModel>[].obs;
  final _expandedProjects = <int>{}.obs;
  final _isLoading = false.obs;

  List<ProjectModel> get projects => _projects;
  Set<int> get expandedProjects => _expandedProjects;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  Future<void> loadProjects() async {
    try {
      _isLoading.value = true;

      // Mock data - replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      _projects.value = [
        ProjectModel(
          id: 1,
          name: "Toshkent Office",
          description: "Asosiy ofis tarmoq infratuzilmasi",
          switchCount: 2,
          status: "Faol",
          switches: [
            SwitchModel(
              id: 1,
              name: "Core Switch 01",
              model: "Cisco Catalyst 9300",
              ipAddress: "192.168.1.10",
              location: "1-qavat, Server Room",
              uptime: "45 kun 12 soat",
              status: "Onlayn",
              portCount: 4,
              isOnline: true,
            ),
            SwitchModel(
              id: 2,
              name: "Access Switch 02",
              model: "Cisco Catalyst 2960",
              ipAddress: "192.168.1.11",
              location: "2-qavat, Network Closet",
              uptime: "23 kun 8 soat",
              status: "Onlayn",
              portCount: 8,
              isOnline: true
            ),
            SwitchModel(
                id: 2,
                name: "Access Switch 02",
                model: "Cisco Catalyst 2960",
                ipAddress: "192.168.1.11",
                location: "2-qavat, Network Closet",
                uptime: "23 kun 8 soat",
                status: "Onlayn",
                portCount: 16,
                isOnline: true
            ),
            SwitchModel(
                id: 2,
                name: "Access Switch 02",
                model: "Cisco Catalyst 2960",
                ipAddress: "192.168.1.11",
                location: "2-qavat, Network Closet",
                uptime: "23 kun 8 soat",
                status: "Onlayn",
                portCount: 16,
                isOnline: true
            )
          ]
        ),
        ProjectModel(
          id: 1,
          name: "Toshkent Office",
          description: "Qo'shimcha ma'lumot yo'q",
          switchCount: 2,
          status: "Faol",
          switches: [
            SwitchModel(
              id: 1,
              name: "Core Switch 01",
              model: "Cisco Catalyst 9300",
              ipAddress: "192.168.1.10",
              location: "1-qavat, Server Room",
              uptime: "45 kun 12 soat",
              status: "Onlayn",
              portCount: 16,
              isOnline: true,
            ),
            SwitchModel(
              id: 2,
              name: "Access Switch 02",
              model: "Cisco Catalyst 2960",
              ipAddress: "192.168.1.11",
              location: "2-qavat, Network Closet",
              uptime: "23 kun 8 soat",
              status: "Offline",
              portCount: 8,
              isOnline: false,
            ),
          ],
        ),
        ProjectModel(
          id: 2,
          name: "Samarqand Filial",
          description: "Samarqand shahridagi filial tarmog'i",
          switchCount: 1,
          status: "Faol",
          switches: [
            SwitchModel(
              id: 3,
              name: "Branch Switch 01",
              model: "Cisco Catalyst 2960X",
              ipAddress: "192.168.2.10",
              location: "1-qavat, IT Room",
              uptime: "12 kun 5 soat",
              status: "Offline",
              portCount: 16,
              isOnline: false,
            ),
          ],
        ),
      ];
    } catch (e) {
      Get.snackbar('Xato', 'Loyihalarni yuklashda xato yuz berdi');
    } finally {
      _isLoading.value = false;
    }
  }

  void toggleProject(int projectId) {
    if (_expandedProjects.contains(projectId)) {
      _expandedProjects.remove(projectId);
    } else {
      _expandedProjects.add(projectId);
    }
  }

  void navigateToProject(int projectId) {
    Get.to(() => SwitchListView(projectId: projectId));
  }

  void navigateToSwitch(int switchId) {
    //Get.put(SwitchDetailController());
    Get.to(() => SwitchDetailView(), arguments: switchId);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'faol':
      case 'onlayn':
        return Colors.green;
      case 'offline':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'faol':
        return 'Faol';
      case 'onlayn':
        return 'Onlayn';
      case 'offline':
        return 'Offline';
      case 'maintenance':
        return 'Texnik xizmat';
      default:
        return status;
    }
  }
}