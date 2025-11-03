import 'switch_model.dart';

class ProjectModel {
  final int id;
  final String name;
  final String description;
  final int switchCount;
  final String status;
  final List<SwitchModel> switches;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.switchCount,
    required this.status,
    required this.switches,
  });
}