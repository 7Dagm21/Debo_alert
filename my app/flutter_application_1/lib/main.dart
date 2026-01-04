import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modern Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String userInput = '';
  String result = '0';

  final List<String> buttons = [
    '(',
    ')',
    '%',
    'AC',
    '7',
    '8',
    '9',
    '÷',
    '4',
    '5',
    '6',
    '×',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    '=',
    '+',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        userInput,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        result,
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              GridView.builder(
                shrinkWrap: true,
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final buttonText = buttons[index];

                  Color bgColor = _getButtonColor(buttonText);
                  Color textColor = buttonText == '='
                      ? Colors.black
                      : Colors.white.withOpacity(0.9);

                  return ElevatedButton(
                    onPressed: () => _onButtonPressed(buttonText),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.all(20),
                      elevation: 0,
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: 24,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(String text) {
    if (text == '=') {
      return const Color(0xFF9DB2FF);
    } else if (['AC', '÷', '×', '-', '+', '%'].contains(text)) {
      return const Color(0xFF2E2E2E);
    } else {
      return const Color(0xFF1E1E1E);
    }
  }

  void _onButtonPressed(String text) {
    setState(() {
      if (text == 'AC') {
        userInput = '';
        result = '0';
      } else if (text == '=') {
        _calculateResult();
      } else {
        userInput += text;
      }
    });
  }

  void _calculateResult() {
    try {
      String input = userInput.replaceAll('×', '*').replaceAll('÷', '/');

      final expression = Expression.parse(input);
      const evaluator = ExpressionEvaluator();
      final evalResult = evaluator.eval(expression, {});

      result = evalResult.toString();
    } catch (e) {
      result = 'Error';
    }
  }
}
