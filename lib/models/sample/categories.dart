class CategoriesModel {
  int? status;
  String? message;
  List<Result>? result;

  CategoriesModel({this.status, this.message, this.result});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {result!.add(Result.fromJson(v));});
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {data['result'] = result!.map((v) => v.toJson()).toList();}
    return data;
  }
}

class Result {
  int? id;
  String? name;
  String? photoUrl;
  String? description;

  Result({this.id, this.name, this.photoUrl, this.description});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photoUrl = json['photo_url'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo_url'] = photoUrl;
    data['description'] = description;
    return data;
  }
}
