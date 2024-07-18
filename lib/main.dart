import 'package:flutter/material.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter',
      theme: ThemeData(
        primarySwatch: Colors.teal, // Change the primary color
        brightness: Brightness.light,
        primaryColor: Colors.teal,
        hintColor: Colors.amber,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          color: Colors.teal, // Change the AppBar color
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const TemperatureConverter(),
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  const TemperatureConverter({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  final TextEditingController _controller = TextEditingController();
  bool _isFahrenheitToCelsius = true;
  String _result = '';
  final List<String> _history = [];

  void _convert() {
    double? inputValue = double.tryParse(_controller.text);

    if (inputValue == null) {
      setState(() {
        _result = '';
      });
      return;
    }

    double convertedValue;
    String conversion;

    if (_isFahrenheitToCelsius) {
      convertedValue = (inputValue - 32) * 5 / 9;
      conversion = 'F to C';
    } else {
      convertedValue = inputValue * 9 / 5 + 32;
      conversion = 'C to F';
    }

    setState(() {
      _result = convertedValue.toStringAsFixed(2);
      _history.insert(0, '$conversion: $inputValue ➔ $_result');
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Converter'),
        toolbarHeight: isPortrait ? kToolbarHeight : 40,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: isPortrait
              ? buildPortraitLayout()
              : buildLandscapeLayout(keyboardHeight),
        ),
      ),
    );
  }

  Widget buildPortraitLayout() {
    return Column(
      children: <Widget>[
        buildConversionLabel(),
        const SizedBox(height: 10),
        buildConversionSelectors(),
        const SizedBox(height: 20),
        buildTemperatureRow(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildConvertButton(),
            Container(width: 10),
            buildClearButton(),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(height: 300, child: buildHistoryList()),
      ],
    );
  }

  Widget buildLandscapeLayout(double keyboardHeight) {
    return Column(
      children: <Widget>[
        buildConversionLabel(),
        const SizedBox(height: 5),
        buildConversionSelectors(),
        const SizedBox(height: 10),
        buildTemperatureRow(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildConvertButton(),
            Container(width: 5),
            buildClearButton(),
          ],
        ),
        SizedBox(height: 20 + keyboardHeight),
        SizedBox(height: 200, child: buildHistoryList()),
      ],
    );
  }

  Widget buildConversionLabel() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Conversion:',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ],
    );
  }

  Widget buildConversionSelectors() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<bool>(
          value: true,
          groupValue: _isFahrenheitToCelsius,
          onChanged: (bool? value) {
            setState(() {
              _isFahrenheitToCelsius = value!;
              _result = '';
            });
          },
          activeColor: Colors.black,
        ),
        const SizedBox(
          width: 80,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Fahrenheit to Celsius',
              style:
                  TextStyle(fontSize: 30, color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Radio<bool>(
          value: false,
          groupValue: _isFahrenheitToCelsius,
          onChanged: (bool? value) {
            setState(() {
              _isFahrenheitToCelsius = value!;
              _result = '';
            });
          },
          activeColor: Colors.black,
        ),
        const SizedBox(
          width: 80,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Celsius to Fahrenheit',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTemperatureRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 100,
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() {
                  _result = '';
                });
              }
            },
            decoration: InputDecoration(
              labelText: 'Enter temperature',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.teal.shade100,
              labelStyle: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          '=',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        const SizedBox(width: 10),
        Container(
          width: 100,
          padding: const EdgeInsets.all(8.0),
          color: Colors.teal.shade100,
          child: Text(
            _result,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget buildConvertButton() {
    return ElevatedButton(
      onPressed: _convert,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        minimumSize: const Size(100, 40),
      ),
      child: const Text('CONVERT', style: TextStyle(fontSize: 12)),
    );
  }

  Widget buildClearButton() {
    return ElevatedButton(
      onPressed: _clearHistory,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        minimumSize: const Size(100, 40),
      ),
      child: const Text('CLEAR HISTORY', style: TextStyle(fontSize: 12)),
    );
  }

  Widget buildHistoryList() {
    return ListView.builder(
      itemCount: _history.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.amber.shade50,
          child: ListTile(
            title: Text(
              _history[index],
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}
