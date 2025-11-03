/*
class CategoriesProductsModel {
  List<CategoriesModel>? all;

  CategoriesProductsModel({this.all});

  CategoriesProductsModel.fromJson(Map<String, dynamic> json) {
    if (json['all'] != null) {
      all = <CategoriesModel>[];
      json['all'].forEach((v) {
        all!.add(CategoriesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (all != null) {
      data['all'] = all!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


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
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? id;
  int? active;
  String? name;
  int? categoryId;
  String? categoryName;
  String? brand;
  int? cashback;
  int? warranty;
  int? price;
  int? discount;
  int? reviews;
  var rating;
  String? photoUrl;
  int? favorite;
  String? dateCreated;
  String? dateEdited;
  int? isNew;
  String? description;

  Result({this.id, this.active, this.name, this.categoryId, this.categoryName, this.brand, this.cashback, this.warranty, this.price, this.discount, this.reviews, this.rating, this.photoUrl, this.favorite, this.dateCreated, this.dateEdited, this.isNew, this.description});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    active = json['active'];
    name = json['name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    brand = json['brand'];
    cashback = json['cashback'];
    warranty = json['warranty'];
    price = json['price'];
    discount = json['discount'];
    reviews = json['reviews'];
    rating = json['rating'];
    photoUrl = json['photo_url'];
    favorite = json['favorite'];
    dateCreated = json['date_created'];
    dateEdited = json['date_edited'];
    isNew = json['is_new'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['active'] = active;
    data['name'] = name;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['brand'] = brand;
    data['cashback'] = cashback;
    data['warranty'] = warranty;
    data['price'] = price;
    data['discount'] = discount;
    data['reviews'] = reviews;
    data['rating'] = rating;
    data['photo_url'] = photoUrl;
    data['favorite'] = favorite;
    data['date_created'] = dateCreated;
    data['date_edited'] = dateEdited;
    data['is_new'] = isNew;
    data['description'] = description;
    return data;
  }
}*/






class CategoriesProductsModel {
  List<CategoriesModel>? all;

  CategoriesProductsModel({this.all});

  CategoriesProductsModel.fromJson(Map<String, dynamic> json) {
    if (json['all'] != null) {
      all = <CategoriesModel>[];
      json['all'].forEach((v) => all!.add(CategoriesModel.fromJson(v)));
    }
    // Avtomatik sort: Barcha ichki CategoriesModel larni isNew bo'yicha sort qilish
    sortAllByIsNewDescending();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (all != null) data['all'] = all!.map((v) => v.toJson()).toList();
    return data;
  }

  // Barcha ichki CategoriesModel dagi result larni is_new bo'yicha sort qilish
  void sortAllByIsNewDescending() {
    if (all != null && all!.isNotEmpty) {
      for (var category in all!) {
        category.sortByIsNewDescending();
      }
    }
  }
}

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
      json['result'].forEach((v) => result!.add(Result.fromJson(v)));
      // Avtomatik sort: is_new bo'yicha kamayuvchi tartibda (isNew=1 birinchi o'rinlarda)
      sortByIsNewDescending();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) data['result'] = result!.map((v) => v.toJson()).toList();
    return data;
  }

  // is_new bo'yicha kamayuvchi tartibda sort qilish (yangi mahsulotlar oldinda)
  void sortByIsNewDescending() {
    if (result != null && result!.isNotEmpty) {
      result!.sort((a, b) {
        // is_new bo'yicha kamayuvchi (katta qiymat oldinda), null=0
        return (b.isNew ?? 0).compareTo(a.isNew ?? 0);
      });
    }
  }
}

class Result {
  int? id;
  int? active;
  String? name;
  int? categoryId;
  String? categoryName;
  String? brand;
  int? cashback;
  int? warranty;
  int? price;
  int? discount;
  int? reviews;
  var rating;
  String? photoUrl;
  int? favorite;
  String? dateCreated;
  String? dateEdited;
  int? isNew;
  String? description;

  Result({this.id, this.active, this.name, this.categoryId, this.categoryName, this.brand, this.cashback, this.warranty, this.price, this.discount, this.reviews, this.rating, this.photoUrl, this.favorite, this.dateCreated, this.dateEdited, this.isNew, this.description});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    active = json['active'];
    name = json['name'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    brand = json['brand'];
    cashback = json['cashback'];
    warranty = json['warranty'];
    price = json['price'];
    discount = json['discount'];
    reviews = json['reviews'];
    rating = json['rating'];
    photoUrl = json['photo_url'];
    favorite = json['favorite'];
    dateCreated = json['date_created'];
    dateEdited = json['date_edited'];
    isNew = json['is_new'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['active'] = active;
    data['name'] = name;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['brand'] = brand;
    data['cashback'] = cashback;
    data['warranty'] = warranty;
    data['price'] = price;
    data['discount'] = discount;
    data['reviews'] = reviews;
    data['rating'] = rating;
    data['photo_url'] = photoUrl;
    data['favorite'] = favorite;
    data['date_created'] = dateCreated;
    data['date_edited'] = dateEdited;
    data['is_new'] = isNew;
    data['description'] = description;
    return data;
  }
}