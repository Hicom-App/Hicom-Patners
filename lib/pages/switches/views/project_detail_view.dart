import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_detail_controller.dart';

class ProjectDetailView extends GetView<ProjectDetailController> {
  const ProjectDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loyiha Tafsilotlari'),
        backgroundColor: Colors.blue[600],
      ),
      body: Obx(() => controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.project != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.project!.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('Model: ${controller.project!.model}'),
            Text('Status: ${controller.project!.status}'),
            Text('Portlar soni: ${controller.project!.portCount}'),
            Text('IP manzil: ${controller.project!.ipAddress}'),
            Text('Joylashuv: ${controller.project!.location}'),
          ],
        ),
      )
          : const Center(child: Text('Loyiha topilmadi'))),
    );
  }
}