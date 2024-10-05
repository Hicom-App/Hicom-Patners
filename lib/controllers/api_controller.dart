import 'package:get/get.dart';
import 'get_controller.dart';
import 'package:http/http.dart';

class ApiController extends GetxController {
  final GetController _getController = Get.put(GetController());
  static const String _baseUrl = 'http://185.196.213.76:8080/api/';

  //http://185.196.213.76:8080/api/auth/register?phone=+998995340313
  Future<void> sendCode() async {
    var response = await post(Uri.parse('${_baseUrl}auth/register?phone=${_getController.phoneController.text}'));
    print(response.body);
    if (response.statusCode == 200) {
      _getController.codeController.text = response.body;
    }
  }

  //http://185.196.213.76:8080/api/auth/verify
  Future<void> verifyCode() async {
    var response = await post(Uri.parse('${_baseUrl}auth/verify'),
        body: {'phone': _getController.phoneController.text, 'code': _getController.codeController.text});
    print(response.body);
    if (response.statusCode == 200) {
      _getController.codeController.text = response.body;
    }
  }

}