import 'package:flutter/material.dart';

void main() => runApp(const TempApp());

class TempApp extends StatelessWidget {
  const TempApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temperature Converter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const TempPage(),
    );
  }
}

enum TempUnit {
  celsius('Celsius', '°C'),
  fahrenheit('Fahrenheit', '°F'),
  kelvin('Kelvin', 'K');

  const TempUnit(this.label, this.symbol);
  final String label;
  final String symbol;
}

double? parseTemp(String input) => double.tryParse(input.trim());

double convertTemp(double value, TempUnit from, TempUnit to) {
  if (from == to) return value;

  final celsius = switch (from) {
    TempUnit.celsius => value,
    TempUnit.fahrenheit => (value - 32) * 5 / 9,
    TempUnit.kelvin => value - 273.15,
  };

  return switch (to) {
    TempUnit.celsius => celsius,
    TempUnit.fahrenheit => celsius * 9 / 5 + 32,
    TempUnit.kelvin => celsius + 273.15,
  };
}

class TempPage extends StatefulWidget {
  const TempPage({super.key});

  @override
  State<TempPage> createState() => _TempPageState();
}

class _TempPageState extends State<TempPage> {
  final TextEditingController _controller = TextEditingController();
  TempUnit _from = TempUnit.celsius;
  TempUnit _to = TempUnit.fahrenheit;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _swap() {
    setState(() {
      final temp = _from;
      _from = _to;
      _to = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final value = parseTemp(_controller.text);
    final result = value == null ? null : convertTemp(value, _from, _to);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Temperature Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: InputDecoration(
                labelText: 'Temperature',
                suffixText: _from.symbol,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<TempUnit>(
                    initialValue: _from,
                    key: ValueKey('from-$_from'),
                    decoration: const InputDecoration(
                      labelText: 'From',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final unit in TempUnit.values)
                        DropdownMenuItem(value: unit, child: Text(unit.label)),
                    ],
                    onChanged: (unit) => setState(() => _from = unit!),
                  ),
                ),
                IconButton(
                  onPressed: _swap,
                  icon: const Icon(Icons.swap_horiz),
                  tooltip: 'Swap units',
                ),
                Expanded(
                  child: DropdownButtonFormField<TempUnit>(
                    initialValue: _to,
                    key: ValueKey('to-$_to'),
                    decoration: const InputDecoration(
                      labelText: 'To',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final unit in TempUnit.values)
                        DropdownMenuItem(value: unit, child: Text(unit.label)),
                    ],
                    onChanged: (unit) => setState(() => _to = unit!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (result == null)
              Text(
                'Enter a valid number',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              )
            else
              Text(
                '${result.toStringAsFixed(2)} ${_to.symbol}',
                textAlign: TextAlign.center,
                style: textTheme.displaySmall,
              ),
          ],
        ),
      ),
    );
  }
}
