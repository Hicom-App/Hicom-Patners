class SwitchModel {
  final int id;
  final String name;
  final String model;
  final String ipAddress;
  final String location;
  final String uptime;
  final String status;
  final int portCount;
  final bool isOnline;

  SwitchModel({
    required this.id,
    required this.name,
    required this.model,
    required this.ipAddress,
    required this.location,
    required this.uptime,
    required this.status,
    required this.portCount,
    required this.isOnline,
  });

  factory SwitchModel.fromJson(Map<String, dynamic> json) {
    return SwitchModel(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      ipAddress: json['ipAddress'],
      location: json['location'],
      uptime: json['uptime'],
      status: json['status'],
      portCount: json['portCount'],
      isOnline: json['isOnline'],
    );
  }

}
