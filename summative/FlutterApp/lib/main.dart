import 'package:flutter/material.dart';

import 'screens/prediction_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SalaryPredictionApp());
}

class SalaryPredictionApp extends StatelessWidget {
  const SalaryPredictionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salary Predictor',
      theme: AppTheme.lightTheme,
      home: const PredictionScreen(),
    );
  }
}
