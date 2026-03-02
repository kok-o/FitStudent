import 'package:flutter/material.dart';

class DemoDietScreen extends StatelessWidget {
  const DemoDietScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SmartDiet • Demo')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.amber.withOpacity(.2),
            child: const Text('Это демо-версия. Зарегистрируйтесь, чтобы сохранить данные!'),
          ),
          const Expanded(
            child: Center(child: Text('Demo profile form placeholder')),
          ),
        ],
      ),
    );
  }
}
