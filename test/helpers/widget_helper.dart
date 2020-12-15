import 'package:flutter_test/flutter_test.dart';

Future<void> enterTextByName(WidgetTester tester, Type widgetType, String widgetFind, String text) async {
  final field = find.widgetWithText(widgetType, widgetFind);
  await tester.enterText(field, text);
}
