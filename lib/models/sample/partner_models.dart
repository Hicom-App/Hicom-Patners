/*
import 'dart:math' as math;
import 'package:get/get.dart';
import '../../pages/partners/controllers/partners_controller.dart';

class PartnerModels {
  int? status;
  String? message;
  List<Result>? result;
  List<Result>? _fullResultList;  // Private: original ro'yxatni saqlash (filter bekor qilish uchun)

  PartnerModels({this.status, this.message, this.result});

  factory PartnerModels.fromJson(Map<String, dynamic> json) {
    final model = PartnerModels(
      status: json['status'],
      message: json['message'],
    );
    if (json['result'] != null) {
      model._fullResultList = <Result>[];  // Original ro'yxatni saqlash
      model.result = <Result>[];
      json['result'].forEach((v) {
        final res = Result.fromJson(v);
        model._fullResultList!.add(res);
        model.result!.add(res);
      });
      // Ma'lumot yuklanganda faqat bir marta controller dan location olish va hisoblash
      try {
        final partnersController = Get.find<PartnersController>();
        final currentLat = partnersController.currentLocation.value.longitude;
        final currentLng = partnersController.currentLocation.value.latitude;

        // Har bir result uchun distance ni hisoblash va keshlash
        for (var res in model.result!) {
          res._computeDistance(currentLat, currentLng);
        }

        // Default so'rt: distance bo'yicha (eng yaqin birinchi)
        model.applyFilterAndSort('distance', partnersController.currentWeekday, false);  // Filter off
      } catch (e) {
        print('Distance hisoblash xatosi: $e');
      }
    }
    return model;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) data['result'] = result!.map((v) => v.toJson()).toList();
    return data;
  }

// Filter va so'rtni birgalikda qo'llash: filter ochiq bo'lsa filter qiladi, keyin sort (birgalikda ishlaydi, konflikt yo'q)
  void applyFilterAndSort(String sortType, int currentWeekday, bool filterOpen) {
    if (result == null || result!.isEmpty) return;

    List<Result> workingList = List<Result>.from(_fullResultList!);  // Original dan boshlash (filter off bo'lsa barcha, on bo'lsa filterlangan)

    // Filter qo'llash (ochiq bo'lsa, faqat ochiq do'konlar qoladi)
    if (filterOpen) {
      workingList = workingList.where((item) => _getTodayIsOpen(item.workingDays, currentWeekday) == 1).toList();  // Ochiq do'konlar qoladi
    }

    // So'rt qo'llash (filtered list ustida)
    workingList.sort((a, b) {
      switch (sortType) {
        case 'distance':
          return a.distanceKm.compareTo(b.distanceKm);  // Eng yaqin birinchi
        case 'rating':
          return (b.rating ?? 0.0).compareTo(a.rating ?? 0.0);  // Yuqori reyting birinchi (descending)
        case 'open':
          final aOpen = _getTodayIsOpen(a.workingDays, currentWeekday);
          final bOpen = _getTodayIsOpen(b.workingDays, currentWeekday);
          if (aOpen != bOpen) return bOpen.compareTo(aOpen);  // Ochiq (1) birinchi
          return 0;  // Teng bo'lsa, joyida qolish
        default:
          return a.distanceKm.compareTo(b.distanceKm);  // Default: distance
      }
    });

    // Natijani qo'llash (result yangi bo'ladi)
    result = workingList;
  }

// Filter bekor qilish va so'rt qo'llash: original ro'yxatga qaytaradi va sort qo'llaydi
  void resetToFullAndSort(String sortType, int currentWeekday) {
    if (_fullResultList == null || _fullResultList!.isEmpty) return;
    applyFilterAndSort(sortType, currentWeekday, false);  // Filter off, faqat sort (original ro'yxatdan)
  }

  // Ochiq holatni tekshirish uchun yordamchi metod (currentWeekday dan foydalanib)
  static int _getTodayIsOpen(List<WorkingDays>? days, int currentWeekday) {
    if (days == null || days.isEmpty) return 0;
    try {
      final day = days.firstWhere((day) => day.weekday == currentWeekday);
      return day.isOpen ?? 0;
    } catch (e) {
      return 0;  // Kun topilmasa yopiq
    }
  }
}

class Result {
  int? id;
  String? name;
  String? phone;
  double? lat;
  double? lng;
  String? address;
  int? categoryId;
  String? categoryName;
  int? cityId;
  String? photoUrl;
  String? description;
  int? reviews;
  double? rating;
  List<WorkingDays>? workingDays;
  double? _distanceKm;
  Result({this.id, this.name, this.phone, this.lat, this.lng, this.address, this.categoryId, this.categoryName, this.cityId, this.photoUrl, this.description, this.reviews, this.rating, this.workingDays, double? distanceKm}) : _distanceKm = distanceKm;

  factory Result.fromJson(Map<String, dynamic> json) {
    final result = Result(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        lat: json['lat'],
        lng: json['lng'],
        address: json['address'],
        categoryId: json['category_id'],
        categoryName: json['category_name'],
        cityId: json['city_id'],
        photoUrl: json['photo_url'],
        description: json['description'],
        reviews: json['reviews'],
        rating: (json['rating'] as num?)?.toDouble()
    );

    if (json['working_days'] != null) {
      result.workingDays = <WorkingDays>[];
      json['working_days'].forEach((v) => result.workingDays!.add(WorkingDays.fromJson(v)));
    }

    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['lat'] = lat;
    data['lng'] = lng;
    data['address'] = address;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['city_id'] = cityId;
    data['photo_url'] = photoUrl;
    data['description'] = description;
    data['reviews'] = reviews;
    data['rating'] = rating;
    if (workingDays != null) data['working_days'] = workingDays!.map((v) => v.toJson()).toList();
    return data;
  }

  // Distance getter: formatted string (keshdan, controller chaqirilmaydi)
  String get distance {
    if (_distanceKm == null) return '-';
    final dist = _distanceKm!;
    if (dist < 1) {
      return '${(dist * 1000).round()} m';
    } else {
      return '${dist.toStringAsFixed(1)} km';
    }
  }

  // Ichki hisoblash method (faqat yuklash vaqtidan chaqiriladi)
  void _computeDistance(double currentLat, double currentLng) {
    if (lat == null || lng == null) {
      _distanceKm = null;
      return;
    }
    const double R = 6371.0;  // Yer radiusi, km
    final double lat1Rad = lat! * math.pi / 180.0;
    final double lon1Rad = lng! * math.pi / 180.0;
    final double lat2Rad = currentLat * math.pi / 180.0;
    final double lon2Rad = currentLng * math.pi / 180.0;

    final double deltaLat = lat2Rad - lat1Rad;
    final double deltaLon = lon2Rad - lon1Rad;

    final double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) + math.cos(lat1Rad) * math.cos(lat2Rad) * math.sin(deltaLon / 2) * math.sin(deltaLon / 2);

    final double c = 2 * math.asin(math.sqrt(a));
    _distanceKm = R * c;  // km da keshlash
  }

  // Sort uchun getter: km da raqam (eng yaqin birinchi)
  double get distanceKm => _distanceKm ?? double.infinity;
}

class WorkingDays {
  int? weekday;
  String? openTime;
  String? closeTime;
  int? isOpen;

  WorkingDays({this.weekday, this.openTime, this.closeTime, this.isOpen});

  WorkingDays.fromJson(Map<String, dynamic> json) {
    weekday = json['weekday'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    isOpen = json['is_open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weekday'] = weekday;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['is_open'] = isOpen;
    return data;
  }
}
*/








import 'dart:math' as math;
import 'package:get/get.dart';
import '../../pages/partners/controllers/partners_controller.dart';

class PartnerModels {
  int? status;
  String? message;
  List<Result>? result;
  List<Result>? _fullResultList;  // Private: original ro'yxatni saqlash (filter bekor qilish uchun)

  PartnerModels({this.status, this.message, this.result});

  factory PartnerModels.fromJson(Map<String, dynamic> json) {
    final model = PartnerModels(status: json['status'], message: json['message']);
    if (json['result'] != null) {
      model._fullResultList = <Result>[];  // Original ro'yxatni saqlash
      model.result = <Result>[];
      json['result'].forEach((v) {
        final res = Result.fromJson(v);
        model._fullResultList!.add(res);
        model.result!.add(res);
      });
      // Ma'lumot yuklanganda faqat bir marta controller dan location olish va hisoblash
      try {
        final partnersController = Get.find<PartnersController>();
        final currentLat = partnersController.currentLocation.value.longitude;
        final currentLng = partnersController.currentLocation.value.latitude;

        // Har bir result uchun distance ni hisoblash va keshlash
        for (var res in model.result!) {
          res._computeDistance(currentLat, currentLng);
        }

        // Default so'rt: distance bo'yicha (eng yaqin birinchi)
        model.applyFilterAndSort('distance', partnersController.currentWeekday, false, cityIdFilter: null);  // Filter off, cityId filter off
      } catch (e) {
        print('Distance hisoblash xatosi: $e');
      }
    }
    return model;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) data['result'] = result!.map((v) => v.toJson()).toList();
    return data;
  }

  // Filter va so'rtni birgalikda qo'llash: filter ochiq bo'lsa filter qiladi, keyin sort (birgalikda ishlaydi, konflikt yo'q)
  void applyFilterAndSort(String sortType, int currentWeekday, bool filterOpen, {String? cityIdFilter}) {
    if (result == null || result!.isEmpty) return;

    List<Result> workingList = List<Result>.from(_fullResultList!);  // Original dan boshlash (filter off bo'lsa barcha, on bo'lsa filterlangan)

    // Filter qo'llash (ochiq bo'lsa, faqat ochiq do'konlar qoladi)
    if (filterOpen) {
      workingList = workingList.where((item) => _getTodayIsOpen(item.workingDays, currentWeekday) == 1).toList();  // Ochiq do'konlar qoladi
    }

    // cityId filter qo'llash (cityIdFilter berilganda, faqat o'sha cityId ga mos keladiganlar qoladi – ochiq kabi toggle style)
    if (cityIdFilter != null && cityIdFilter.isNotEmpty) {
      workingList = workingList.where((item) => item.cityId?.toString() == cityIdFilter).toList();  // cityId bo'yicha filter (ochiq kabi, boshqa filter/sort ga ta'sir qilmaydi)
    }

    // So'rt qo'llash (filtered list ustida – boshqa filter/sort ga ta'sir qilmaydi)
    workingList.sort((a, b) {
      switch (sortType) {
        case 'distance':
          return a.distanceKm.compareTo(b.distanceKm);  // Eng yaqin birinchi
        case 'rating':
          return (b.rating ?? 0.0).compareTo(a.rating ?? 0.0);  // Yuqori reyting birinchi (descending)
        case 'open':
          final aOpen = _getTodayIsOpen(a.workingDays, currentWeekday);
          final bOpen = _getTodayIsOpen(b.workingDays, currentWeekday);
          if (aOpen != bOpen) return bOpen.compareTo(aOpen);  // Ochiq (1) birinchi
          return 0;  // Teng bo'lsa, joyida qolish
        case 'cityId':
          return (a.cityId ?? 0).compareTo(b.cityId ?? 0);  // cityId bo'yicha so'rt (kichikdan katta, boshqa sort/filter ga ta'sir qilmaydi)
        default:
          return a.distanceKm.compareTo(b.distanceKm);  // Default: distance
      }
    });

    // Natijani qo'llash (result yangi bo'ladi)
    result = workingList;
  }

  // Filter bekor qilish va so'rt qo'llash: original ro'yxatga qaytaradi va sort qo'llaydi
  void resetToFullAndSort(String sortType, int currentWeekday) {
    if (_fullResultList == null || _fullResultList!.isEmpty) return;
    applyFilterAndSort(sortType, currentWeekday, false, cityIdFilter: null);  // Filter off, cityId filter off, faqat sort (original ro'yxatdan)
  }

  // Ochiq holatni tekshirish uchun yordamchi metod (currentWeekday dan foydalanib)
  static int _getTodayIsOpen(List<WorkingDays>? days, int currentWeekday) {
    if (days == null || days.isEmpty) return 0;
    try {
      final day = days.firstWhere((day) => day.weekday == currentWeekday);
      return day.isOpen ?? 0;
    } catch (e) {
      return 0;  // Kun topilmasa yopiq
    }
  }
}

class Result {
  int? id;
  String? name;
  String? phone;
  double? lat;
  double? lng;
  String? address;
  int? categoryId;
  String? categoryName;
  int? cityId;
  String? photoUrl;
  String? description;
  int? reviews;
  double? rating;
  List<WorkingDays>? workingDays;
  double? _distanceKm;
  Result({this.id, this.name, this.phone, this.lat, this.lng, this.address, this.categoryId, this.categoryName, this.cityId, this.photoUrl, this.description, this.reviews, this.rating, this.workingDays, double? distanceKm}) : _distanceKm = distanceKm;

  factory Result.fromJson(Map<String, dynamic> json) {
    final result = Result(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        lat: json['lat'],
        lng: json['lng'],
        address: json['address'],
        categoryId: json['category_id'],
        categoryName: json['category_name'],
        cityId: json['city_id'],
        photoUrl: json['photo_url'],
        description: json['description'],
        reviews: json['reviews'],
        rating: (json['rating'] as num?)?.toDouble()
    );

    if (json['working_days'] != null) {
      result.workingDays = <WorkingDays>[];
      json['working_days'].forEach((v) => result.workingDays!.add(WorkingDays.fromJson(v)));
    }

    return result;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['lat'] = lat;
    data['lng'] = lng;
    data['address'] = address;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['city_id'] = cityId;
    data['photo_url'] = photoUrl;
    data['description'] = description;
    data['reviews'] = reviews;
    data['rating'] = rating;
    if (workingDays != null) data['working_days'] = workingDays!.map((v) => v.toJson()).toList();
    return data;
  }

  // Distance getter: formatted string (keshdan, controller chaqirilmaydi)
  String get distance {
    if (_distanceKm == null) return '-';
    final dist = _distanceKm!;
    if (dist < 1) {
      return '${(dist * 1000).round()} ${'m'.tr}';
    } else {
      return '${dist.toStringAsFixed(1)} ${'km'.tr}';
    }
  }

  // Ichki hisoblash method (faqat yuklash vaqtidan chaqiriladi)
  void _computeDistance(double currentLat, double currentLng) {
    if (lat == null || lng == null) {
      _distanceKm = null;
      return;
    }
    const double R = 6371.0;  // Yer radiusi, km
    final double lat1Rad = lat! * math.pi / 180.0;
    final double lon1Rad = lng! * math.pi / 180.0;
    final double lat2Rad = currentLat * math.pi / 180.0;
    final double lon2Rad = currentLng * math.pi / 180.0;

    final double deltaLat = lat2Rad - lat1Rad;
    final double deltaLon = lon2Rad - lon1Rad;

    final double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) + math.cos(lat1Rad) * math.cos(lat2Rad) * math.sin(deltaLon / 2) * math.sin(deltaLon / 2);

    final double c = 2 * math.asin(math.sqrt(a));
    _distanceKm = R * c;  // km da keshlash
  }

  // Sort uchun getter: km da raqam (eng yaqin birinchi)
  double get distanceKm => _distanceKm ?? double.infinity;
}

class WorkingDays {
  int? weekday;
  String? openTime;
  String? closeTime;
  int? isOpen;

  WorkingDays({this.weekday, this.openTime, this.closeTime, this.isOpen});

  WorkingDays.fromJson(Map<String, dynamic> json) {
    weekday = json['weekday'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    isOpen = json['is_open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weekday'] = weekday;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['is_open'] = isOpen;
    return data;
  }
}