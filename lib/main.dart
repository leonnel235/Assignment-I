import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scientific Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String expression = '';
  String result = '';

  final List<String> buttons = [
    '7', '8', '9', '/', 'C',
    '4', '5', '6', '*', 'sin',
    '1', '2', '3', '-', 'cos',
    '0', '.', '=', '+', 'tan',
  ];

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        expression = '';
        result = '';
      } else if (buttonText == '=') {
        try {
          Parser parser = Parser();
          Expression exp = parser.parse(expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          result = eval.toString();
        } catch (e) {
          result = 'Error';
        }
      } else if (buttonText == 'sin' || buttonText == 'cos' || buttonText == 'tan') {
        expression += ' $buttonText(';
      } else {
        expression += buttonText;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
      ),
      body: Center(
        child: Container(
          width: 300, // Set the width of the calculator
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 3), // Add a black border
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // White background for the display
                  border: Border.all(color: Colors.black, width: 2), // Add a black border around the display
                ),
                padding: const EdgeInsets.all(12),
                alignment: Alignment.bottomRight,
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      expression,
                      style: const TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    Text(
                      result,
                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    bool isOperator = ['/', '*', '-', '+', 'C', '=', 'sin', 'cos', 'tan'].contains(buttons[index]);
                    return GestureDetector(
                      onTap: () => buttonPressed(buttons[index]),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isOperator ? Colors.blue : Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            buttons[index],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isOperator ? Colors.white : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
