import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutterapp/main.dart';

void main() {
  testWidgets('renders salary prediction screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryPredictionApp());

    expect(find.text('Student Salary Predictor'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.widgetWithText(FilledButton, 'Predict'), findsOneWidget);
  });
}
