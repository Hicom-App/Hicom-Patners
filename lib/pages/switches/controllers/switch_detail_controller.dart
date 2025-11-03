import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hicom_patners/models/sample/switch_model.dart';
import 'package:hicom_patners/resource/colors.dart';
import 'package:hicom_patners/pages/switches/controllers/switches_controller.dart';

class SwitchDetailController extends GetxController {
  final SwitchesController switchesController = Get.find<SwitchesController>();
  final Rx<SwitchModel?> switchItem = Rx<SwitchModel?>(null);

  // Demo data for ports
  final RxList<Map<String, dynamic>> portStatuses = RxList<Map<String, dynamic>>([]);
  final RxList<Map<String, dynamic>> portSettings = RxList<Map<String, dynamic>>([]);

  // VLAN
  final RxBool vlanEnabled = RxBool(false);

  // Port Mirror
  final RxString capturePort = RxString('');
  final RxString capturedPort = RxString('');

  // DHCP Snooping
  final RxBool dhcpSnoopingEnabled = RxBool(false);
  final RxString dhcpInfo = RxString('');

  // Settings
  final RxBool dhcpEnabled = RxBool(true);
  final RxString ipAddress = RxString('');
  final RxString macAddress = RxString('');
  final RxString gateway = RxString('');
  final RxString dns = RxString('');
  final RxBool stormControlEnabled = RxBool(false);
  final RxBool powerSupplyAdaptiveEnabled = RxBool(false);
  final RxBool portWatchdogEnabled = RxBool(false);
  final RxBool autoPortExtensionEnabled = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    final project = switchesController.projects.firstWhereOrNull((p) => p.switches.any((s) => s.id == Get.arguments as int));
    if (project != null) {
      switchItem.value = project.switches.firstWhere((s) => s.id == Get.arguments as int);
      initDemoData(switchItem.value!.portCount);
    }
  }

  void initDemoData(int portCount) {
    portStatuses.clear();
    portSettings.clear();
    portStatuses.add({
      'port': 'L2',
      'tx': '0 KB/s',
      'rx': '0 KB/s',
      'power': 'Off',
      'status': 'Inactive',
    });
    portSettings.add({
      'port': 'L2',
      'poeEnabled': RxBool(false),
      'extendEnabled': RxBool(false),
      'timing': RxInt(0),
    });

    portStatuses.add({
      'port': 'SFP',
      'tx': '0 KB/s',
      'rx': '0 KB/s',
      'power': 'Off',
      'status': 'Inactive',
    });
    portSettings.add({
      'port': 'SFP',
      'poeEnabled': RxBool(false),
      'extendEnabled': RxBool(false),
      'timing': RxInt(0),
    });

    for (int i = 1; i <= portCount; i++) {
      portStatuses.add({
        'port': i,
        'tx': '${(i * 100)} KB/s',
        'rx': '${(i * 50)} KB/s',
        'power': i % 2 == 0 ? 'On' : 'Off',
        'status': i % 3 == 0 ? 'Active' : 'Inactive',
      });

      portSettings.add({
        'port': i,
        'poeEnabled': RxBool(i % 2 == 0),
        'extendEnabled': RxBool(i % 3 == 0),
        'timing': RxInt(0),
      });
    }
  }

  void toggleVlan() {
    vlanEnabled.value = !vlanEnabled.value;
    Fluttertoast.showToast(msg: 'VLAN ${vlanEnabled.value ? 'yoqildi' : 'o\'chirildi'}', backgroundColor: AppColors.blue);
  }

  void savePortMirror() {
    Fluttertoast.showToast(msg: 'Port Mirror saqlandi: Capture: $capturePort, Captured: $capturedPort', backgroundColor: AppColors.blue);
  }

  void deletePortMirror() {
    capturePort.value = '';
    capturedPort.value = '';
    Fluttertoast.showToast(msg: 'Port Mirror o\'chirildi', backgroundColor: AppColors.red);
  }

  void toggleDhcpSnooping() {
    dhcpSnoopingEnabled.value = !dhcpSnoopingEnabled.value;
    Fluttertoast.showToast(msg: 'DHCP Snooping ${dhcpSnoopingEnabled.value ? 'yoqildi' : 'o\'chirildi'}', backgroundColor: AppColors.blue);
  }

  void getDhcpInfo() {
    dhcpInfo.value = 'Demo DHCP ma\'lumotlari: IP: 192.168.1.1, MAC: AA:BB:CC:DD:EE:FF';
    Fluttertoast.showToast(msg: 'DHCP ma\'lumotlari olingan', backgroundColor: AppColors.blue);
  }

  void toggleDhcp() {
    dhcpEnabled.value = !dhcpEnabled.value;
    if (dhcpEnabled.value) {
      ipAddress.value = '192.168.1.100';
      macAddress.value = 'AA:BB:CC:DD:EE:FF';
      gateway.value = '192.168.1.1';
      dns.value = '8.8.8.8';
    }
    Fluttertoast.showToast(msg: 'DHCP ${dhcpEnabled.value ? 'yoqildi' : 'o\'chirildi'}', backgroundColor: AppColors.blue);
  }

  void saveSettings() {
    Fluttertoast.showToast(msg: 'Sozlamalar saqlandi', backgroundColor: AppColors.blue);
  }

  void togglePortSetting(int index, String key) {
    portSettings[index][key].value = !portSettings[index][key].value;
    Fluttertoast.showToast(msg: 'Port ${portSettings[index]['port']} ${key.replaceAll('Enabled', '')} ${portSettings[index][key].value ? 'yoqildi' : 'o\'chirildi'}', backgroundColor: AppColors.blue);
  }

  void rebootPort(int index) {
    Fluttertoast.showToast(msg: 'Port ${portSettings[index]['port']} reboot qilindi', backgroundColor: AppColors.blue);
  }
}