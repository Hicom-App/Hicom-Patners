class ProfileInfoModel {
  int? status;
  String? message;
  List<Profile>? profile;

  ProfileInfoModel({this.status, this.message, this.profile});

  ProfileInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['profile'] != null) {
      profile = <Profile>[];
      json['profile'].forEach((v) {
        profile!.add(Profile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (profile != null) {
      data['profile'] = profile!.map((v) => v.toJson()).toList();
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

  Profile({this.id, this.firstName, this.lastName, this.birthday, this.userType, this.countryId, this.regionId, this.cityId, this.address, this.phone, this.photoUrl});

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
    return data;
  }
}
