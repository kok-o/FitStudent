import 'package:flutter/material.dart';

class DoctorPatientDetailScreen extends StatelessWidget {
  final String id;
  const DoctorPatientDetailScreen({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Patient $id')), body: const Center(child: Text('Profile + Diet + Comments')));
  }
}
