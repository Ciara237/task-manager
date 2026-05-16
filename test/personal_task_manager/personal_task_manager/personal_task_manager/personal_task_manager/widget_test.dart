import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:personal_task_manager/main.dart';

void main() {
  testWidgets('App loads with task list screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Tasks'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
