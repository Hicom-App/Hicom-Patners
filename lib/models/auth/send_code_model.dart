class SendCodeModel {
  int? status;
  String? message;
  Result? result;

  SendCodeModel({this.status, this.message, this.result});

  SendCodeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  bool? newUser;

  Result({this.newUser});

  Result.fromJson(Map<String, dynamic> json) {
    newUser = json['new_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['new_user'] = newUser;
    return data;
  }
}
