import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _input = "";   // Kullanıcı girişi
  String _result = "";  // Hesaplanan sonuç

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "=") {
        _calculate();
      } else if (value == "C") {
        _input = "";
        _result = "";
      } else {
        _input += value;
      }
    });
  }

  void _calculate() {
    try {
      final double evaluationResult = _evaluateExpression(_input);
      setState(() {
        _result = evaluationResult.toString();
      });
    } catch (e) {
      setState(() {
        _result = "Hatalı işlem";
      });
    }
  }

  double _evaluateExpression(String expression) {
    RegExp regExp = RegExp(r'(\d+\.?\d*|\+|\-|\*|\/)');
    List<String> tokens = regExp.allMatches(expression).map((m) => m.group(0)!).toList();

    // İlk olarak çarpma ve bölme işlemlerini gerçekleştir
    List<double> values = [];
    List<String> operators = [];

    for (var token in tokens) {
      if (_isNumeric(token)) {
        values.add(double.parse(token));
      } else {
        while (operators.isNotEmpty && _getPrecedence(operators.last) >= _getPrecedence(token)) {
          double b = values.removeLast();
          double a = values.removeLast();
          String operator = operators.removeLast();
          values.add(_applyOperator(a, b, operator));
        }
        operators.add(token);
      }
    }

    while (operators.isNotEmpty) {
      double b = values.removeLast();
      double a = values.removeLast();
      String operator = operators.removeLast();
      values.add(_applyOperator(a, b, operator));
    }

    return values.last;
  }

  bool _isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  int _getPrecedence(String operator) {
    if (operator == "+" || operator == "-") {
      return 1;
    } else if (operator == "x" || operator == "÷") {
      return 2;
    }
    return 0;
  }

  double _applyOperator(double a, double b, String operator) {
    switch (operator) {
      case "+":
        return a + b;
      case "-":
        return a - b;
      case "x":
        return a * b;
      case "÷":
        return a / b;
      default:
        throw Exception("Geçersiz operatör");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Center(
          child: Text('Hesap Makinesi',
              style: TextStyle(fontSize: 30, fontFamily: "Revalia", fontWeight: FontWeight.bold)),
        ),
      ),
      backgroundColor: Colors.lightBlueAccent, // Arka plan rengi
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              _input,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _result,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  _buildButtonRow(["7", "8", "9", "÷"]),
                  _buildButtonRow(["4", "5", "6", "x"]),
                  _buildButtonRow(["1", "2", "3", "-"]),
                  _buildButtonRow(["0", "C", "=", "+"]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> values) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: values.map((value) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0), // Mesafeyi azaltmak için padding küçültüldü
              child: ElevatedButton(
                onPressed: () => _onButtonPressed(value),
                child: Text(
                  value,
                  style: TextStyle(fontSize: 28, color: Colors.black), // Yazı rengi siyah
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white, // Yazı rengi siyah
                  minimumSize: Size(0, 90), // Buton boyutunu büyüttük
                  padding: EdgeInsets.all(16), // Buton içi boşlukları artırdık
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
