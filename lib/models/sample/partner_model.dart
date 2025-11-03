import 'coordinates_models.dart';

enum PartnerStatus { active, pending, inactive }
enum ViewMode { list, map }

class PartnerModel {
  final int id;
  final String name;
  final String logo;
  final String description;
  final String category;
  final double rating;
  final String location;
  final String address;
  final String phone;
  final String website;
  final PartnerStatus status;
  final int revenue;
  final int orders;
  final String since;
  final Coordinates coordinates;
  final bool isOpen;
  final String openHours;
  final String? country;
  final String? region;
  final String? district;
  double? distance;

  PartnerModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.description,
    required this.category,
    required this.rating,
    required this.location,
    required this.address,
    required this.phone,
    required this.website,
    required this.status,
    required this.revenue,
    required this.orders,
    required this.since,
    required this.coordinates,
    required this.isOpen,
    required this.openHours,
    this.country,
    this.region,
    this.district,
    this.distance,
  });

  PartnerModel copyWith({
    int? id,
    String? name,
    String? logo,
    String? description,
    String? category,
    double? rating,
    String? location,
    String? address,
    String? phone,
    String? website,
    PartnerStatus? status,
    int? revenue,
    int? orders,
    String? since,
    Coordinates? coordinates,
    bool? isOpen,
    String? openHours,
    String? country,
    String? region,
    String? district,
    double? distance,
  }) {
    return PartnerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      description: description ?? this.description,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      status: status ?? this.status,
      revenue: revenue ?? this.revenue,
      orders: orders ?? this.orders,
      since: since ?? this.since,
      coordinates: coordinates ?? this.coordinates,
      isOpen: isOpen ?? this.isOpen,
      openHours: openHours ?? this.openHours,
      country: country ?? this.country,
      region: region ?? this.region,
      district: district ?? this.district,
      distance: distance ?? this.distance,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'description': description,
      'category': category,
      'rating': rating,
      'location': location,
      'address': address,
      'phone': phone,
      'website': website,
      'status': status.name,
      'revenue': revenue,
      'orders': orders,
      'since': since,
      'coordinates': coordinates.toJson(),
      'isOpen': isOpen,
      'openHours': openHours,
      'country': country,
      'region': region,
      'district': district,
      'distance': distance,
    };
  }

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      description: json['description'],
      category: json['category'],
      rating: json['rating']?.toDouble() ?? 0.0,
      location: json['location'],
      address: json['address'],
      phone: json['phone'],
      website: json['website'],
      status: PartnerStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => PartnerStatus.active),
      revenue: json['revenue'],
      orders: json['orders'],
      since: json['since'],
      coordinates: Coordinates.fromJson(json['coordinates']),
      isOpen: json['isOpen'],
      openHours: json['openHours'],
      country: json['country'],
      region: json['region'],
      district: json['district'],
      distance: json['distance']?.toDouble(),
    );
  }

  @override
  String toString() {
    return 'PartnerModel{id: $id, name: $name, category: $category, rating: $rating, location: $location,country: $country, region: $region, district: $district, distance: $distance}';
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PartnerModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}