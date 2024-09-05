import 'package:flutter/material.dart';
import 'package:personal_tracker/presentation/widgets/register_widget.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: RegisterWidget(),
    );
  }
}
