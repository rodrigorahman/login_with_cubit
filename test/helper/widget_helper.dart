import 'package:flutter_test/flutter_test.dart';

Future<void> enterTextByName(WidgetTester widgetTester, Type widgetType, String widgetName, String text) async {
  var field = find.widgetWithText(widgetType, widgetName);
  await widgetTester.enterText(field, text);
}

Future<void> tabButtonByText(WidgetTester widgetTester, Type widgetType, String widgetName) async {
  final button = find.widgetWithText(widgetType, widgetName);
  await widgetTester.tap(button);
}
