
import 'dart:convert';

import 'package:intl/intl.dart';

class WarrantyModel {
  int? status;
  String? message;
  List<Result>? result;

  WarrantyModel({this.status, this.message, this.result});

  WarrantyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? id;
  int? productId;
  String? serialCode;
  int? cashback;
  String? warrantyStart;
  String? warrantyExpire;
  String? dateCreated;
  String? name;
  int? categoryId;
  String? brand;
  String? photoUrl;
  String? description;

  Result({this.id, this.productId, this.serialCode, this.cashback, this.warrantyStart, this.warrantyExpire, this.dateCreated, this.name, this.categoryId, this.brand, this.photoUrl, this.description});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    serialCode = json['serial_code'];
    cashback = json['cashback'];
    warrantyStart = json['warranty_start'];
    warrantyExpire = json['warranty_expire'];
    dateCreated = json['date_created'];
    name = json['name'];
    categoryId = json['category_id'];
    brand = json['brand'];
    photoUrl = json['photo_url'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['serial_code'] = serialCode;
    data['cashback'] = cashback;
    data['warranty_start'] = warrantyStart;
    data['warranty_expire'] = warrantyExpire;
    data['date_created'] = dateCreated;
    data['name'] = name;
    data['category_id'] = categoryId;
    data['brand'] = brand;
    data['photo_url'] = photoUrl;
    data['description'] = description;
    return data;
  }
}

class SortedWarrantyModel {
  int? status;
  String? message;
  List<SortedResult>? result;

  SortedWarrantyModel({this.status, this.message, this.result});

  SortedWarrantyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['result'] != null) {
      result = <SortedResult>[];
      json['result'].forEach((v) {result!.add(SortedResult.fromJson(v));});
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

class SortedResult {
  String? date;
  List<Result>? result;

  SortedResult({this.date, this.result});

  SortedResult.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {result!.add(Result.fromJson(v));});
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    if (result != null) {data['result'] = result!.map((v) => v.toJson()).toList();}
    return data;
  }
}

// Function to convert the original data to sorted structure
SortedWarrantyModel convertToSortedWarrantyModel(WarrantyModel warrantyModel) {
  SortedWarrantyModel sortedModel = SortedWarrantyModel(status: warrantyModel.status, message: warrantyModel.message, result: []);

  Map<String, List<Result>> groupedResults = {};

  String getMonth(String date) {
    switch (date) {
      case "01":
        return "yan";
      case "02":
        return "fev";
      case "03":
        return "mar";
      case "04":
        return "ap";
      case "05":
        return "may";
      case "06":
        return "iyn";
      case "07":
        return "iyl";
      case "08":
        return "avq";
      case "09":
        return "sen";
      case "10":
        return "okt";
      case "11":
        return "noy";
      case "12":
        return "dek";
      default:
        return "";
    }
  }

  for (var res in warrantyModel.result!) {
    String dateKey = "";
    if (res.warrantyStart!.contains(DateFormat('yyyy-MM-dd').format(DateTime.now()))) {
      dateKey = "bugun";
    } else if (res.warrantyStart!.contains(DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1))))) {
      dateKey = "kecha";
    } else {
      dateKey = "${DateFormat('dd').format(DateTime.parse(res.warrantyStart!))} ${getMonth(DateFormat('MM').format(DateTime.parse(res.warrantyStart!)))}";
    }

    if (!groupedResults.containsKey(dateKey)) {
      groupedResults[dateKey] = [];
    }
    groupedResults[dateKey]!.add(res);
  }

  groupedResults.forEach((key, value) {
    sortedModel.result!.add(SortedResult(date: key, result: value));
  });

  return sortedModel;
}

//
// void main() {
//   String jsonString = '''{
//     "status": 0,
//     "message": "OK",
//     "result": [
//       {
//         "id": 3001,
//         "product_id": 17,
//         "serial_code": "3001>wnuGikAPCvrIwJi56SXhMQ==",
//         "cashback": null,
//         "warranty_start": "2024-10-28T12:13:05.000Z",
//         "warranty_expire": "2025-10-28T12:13:05.000Z",
//         "date_created": "2024-10-22T05:28:12.000Z",
//         "name": "Test uchun Mahsulot",
//         "category_id": 1,
//         "brand": "",
//         "photo_url": "http://185.196.213.76:8080/api/images/products?id=17",
//         "description": "Qanaqadir switch"
//       },
//       {
//         "id": 3002,
//         "product_id": 17,
//         "serial_code": "3002>a0+q/nMmVq3B0R5I3nkrnQ==",
//         "cashback": null,
//         "warranty_start": "2024-10-29T06:03:25.000Z",
//         "warranty_expire": "2025-10-29T06:03:25.000Z",
//         "date_created": "2024-10-22T05:28:12.000Z",
//         "name": "Test uchun Mahsulot",
//         "category_id": 1,
//         "brand": "",
//         "photo_url": "http://185.196.213.76:8080/api/images/products?id=17",
//         "description": "Qanaqadir switch"
//       }
//     ]
//   }''';
//
//   // Parse JSON
//   WarrantyModel warrantyModel = WarrantyModel.fromJson(json.decode(jsonString));
//
//   // Convert to SortedWarrantyModel
//   SortedWarrantyModel sortedWarrantyModel = convertToSortedWarrantyModel(warrantyModel);
//
//   // Print result
//   print(json.encode(sortedWarrantyModel.toJson()));
//
//   //print all date
//   for (var res in sortedWarrantyModel.result!) {
//     print(res.date);
//   }
// }
