import 'package:flutter/material.dart';

class AdminRecipesScreen extends StatelessWidget {
  const AdminRecipesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Admin • Recipes')), body: const Center(child: Text('Recipes CRUD')));
  }
}
