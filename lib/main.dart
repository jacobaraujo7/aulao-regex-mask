import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(List<String> args) {
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (!RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$').hasMatch(text ?? '')) {
                  return 'Digite um CPF válido!';
                }
              },
              inputFormatters: [
                CurrencyMask(symbol: r'$', decimal: ',', cents: '.'),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'DOLAR',
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (!RegExp(r'[a-zA-Z0-9.-_]+@[a-zA-Z0-9-_]+\..+').hasMatch(text ?? '')) {
                  return 'Digite um email válido!';
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaskInput extends TextInputFormatter {
  final String mask;

  MaskInput(this.mask);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var value = newValue.text.replaceAll(RegExp(r'\D'), '');
    var formatted = mask;
    for (var i = 0; i < value.length; i++) {
      formatted = formatted.replaceFirst('#', value[i]);
    }

    final lastHash = formatted.indexOf('#');

    if (lastHash != -1) {
      formatted = formatted.characters.getRange(0, lastHash).join();
      if (RegExp(r'\D$').hasMatch(formatted)) {
        formatted = formatted.split('').getRange(0, formatted.length - 1).join();
      }
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formatted.length),
      ),
    );
  }
}

class CurrencyMask extends TextInputFormatter {
  final String symbol;
  final String decimal;
  final String cents;

  CurrencyMask({this.symbol = r'R$', this.decimal = '.', this.cents = ','});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var value = newValue.text.replaceAll(RegExp(r'\D'), '');

    value = (int.tryParse(value) ?? 0).toString();

    if (value.length < 3) {
      value = value.padLeft(3, '0');
    }

    value = value.split('').reversed.join();

    final listCharacters = [];
    var decimalCount = 0;

    for (var i = 0; i < value.length; i++) {
      if (i == 2) {
        listCharacters.insert(0, cents);
      }

      if (i > 2) {
        decimalCount++;
      }

      if (decimalCount == 3) {
        listCharacters.insert(0, decimal);
        decimalCount = 0;
      }

      listCharacters.insert(0, value[i]);
    }

    listCharacters.insert(0, symbol);
    var formatted = listCharacters.join();

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formatted.length),
      ),
    );
  }
}
