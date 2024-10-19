class ProfileInfoModel {
  int? status;
  Profile? profile;

  ProfileInfoModel({this.status, this.profile});

  ProfileInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  int? id;
  String? firstName;
  String? lastName;
  String? birthday;
  int? userType;
  int? countryId;
  int? regionId;
  int? cityId;
  String? address;
  String? phone;
  String? photoUrl;
  Cashback? cashback;

  Profile({this.id, this.firstName, this.lastName, this.birthday, this.userType, this.countryId, this.regionId, this.cityId, this.address, this.phone, this.photoUrl, this.cashback});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    birthday = json['birthday'];
    userType = json['user_type'];
    countryId = json['country_id'];
    regionId = json['region_id'];
    cityId = json['city_id'];
    address = json['address'];
    phone = json['phone'];
    photoUrl = json['photo_url'];
    cashback = json['cashback'] != null
        ? new Cashback.fromJson(json['cashback'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['birthday'] = birthday;
    data['user_type'] = userType;
    data['country_id'] = countryId;
    data['region_id'] = regionId;
    data['city_id'] = cityId;
    data['address'] = address;
    data['phone'] = phone;
    data['photo_url'] = photoUrl;
    if (cashback != null) {
      data['cashback'] = cashback!.toJson();
    }
    return data;
  }
}

class Cashback {
  int? calculated;
  int? withdrawn;
  int? waiting;
  int? rejected;

  Cashback({this.calculated, this.withdrawn, this.waiting, this.rejected});

  Cashback.fromJson(Map<String, dynamic> json) {
    calculated = json['calculated'];
    withdrawn = json['withdrawn'];
    waiting = json['waiting'];
    rejected = json['rejected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['calculated'] = calculated;
    data['withdrawn'] = withdrawn;
    data['waiting'] = waiting;
    data['rejected'] = rejected;
    return data;
  }
}
