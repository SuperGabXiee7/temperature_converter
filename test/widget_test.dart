import 'package:flutter_test/flutter_test.dart';
import 'package:temperature_converter/main.dart';

void main() {
  test('Celsius to Fahrenheit', () {
    expect(convertTemp(0, TempUnit.celsius, TempUnit.fahrenheit), 32);
    expect(convertTemp(100, TempUnit.celsius, TempUnit.fahrenheit), 212);
    expect(convertTemp(-40, TempUnit.celsius, TempUnit.fahrenheit), -40);
  });

  test('Fahrenheit to Celsius', () {
    expect(convertTemp(212, TempUnit.fahrenheit, TempUnit.celsius), 100);
  });

  test('Kelvin conversions', () {
    expect(convertTemp(0, TempUnit.celsius, TempUnit.kelvin), 273.15);
    expect(convertTemp(273.15, TempUnit.kelvin, TempUnit.celsius), 0);
  });

  test('parseTemp handles invalid and negative input', () {
    expect(parseTemp('abc'), isNull);
    expect(parseTemp(''), isNull);
    expect(parseTemp(' -5.5 '), -5.5);
  });

  testWidgets('converts 100 C to 212.00 F by default', (tester) async {
    await tester.pumpWidget(const TempApp());
    expect(find.text('Enter a valid number'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '100');
    await tester.pump();
    expect(find.text('212.00 °F'), findsOneWidget);
  });
}