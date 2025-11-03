class Coordinates {
  final double lat;
  final double lng;

  Coordinates({
    required this.lat,
    required this.lng,
  });

  Coordinates copyWith({
    double? lat,
    double? lng,
  }) {
    return Coordinates(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(
      lat: json['lat']?.toDouble() ?? 0.0,
      lng: json['lng']?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'Coordinates{lat: $lat, lng: $lng}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Coordinates &&
              runtimeType == other.runtimeType &&
              lat == other.lat &&
              lng == other.lng;

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;
}