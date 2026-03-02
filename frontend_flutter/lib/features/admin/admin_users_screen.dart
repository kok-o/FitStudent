import 'package:flutter/material.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin • Users')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DataTable(columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Role')),
          DataColumn(label: Text('Actions')),
        ], rows: const [
          DataRow(cells: [
            DataCell(Text('John Doe')),
            DataCell(Text('john@example.com')),
            DataCell(Text('user')),
            DataCell(Text('—')),
          ]),
        ]),
      ),
    );
  }
}
