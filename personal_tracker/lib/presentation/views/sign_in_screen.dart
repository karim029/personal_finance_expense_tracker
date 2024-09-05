import 'package:flutter/material.dart';
import 'package:personal_tracker/presentation/widgets/sign_in_widget.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: LogInWidget(),
    );
  }
}
