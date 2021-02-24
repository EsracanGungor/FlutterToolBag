import 'package:flutter/material.dart';
import 'package:flutter_tool_bag/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'appBar.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _expression = '';
  List<String> numbers;
  double result = 0.0;

  void numberClick(String text) {
    setState(() => _expression += text);
  }

  void allClear(String text) {
    setState(() {
      _expression = '';
    });
  }

  void delete(String text) {
    setState(() {
      _expression = _expression.substring(0, _expression.length - 1);
      if (_expression == "") {
        _expression = "";
      }
    });
  }

  void calculate(String text) {
    if (_expression.contains('+')) {
      numbers = _expression.split('+');
      result = double.parse(numbers[0]) + double.parse(numbers[1]);
    }
    if (_expression.contains('-')) {
      numbers = _expression.split('-');
      result = double.parse(numbers[0]) - double.parse(numbers[1]);
    }
    if (_expression.contains('x')) {
      numbers = _expression.split('x');
      result = double.parse(numbers[0]) * double.parse(numbers[1]);
    }
    if (_expression.contains('÷')) {
      numbers = _expression.split('÷');
      result = double.parse(numbers[0]) / double.parse(numbers[1]);
    }
    if (_expression.contains('%')) {
      numbers = _expression.split('%');
      result = double.parse(numbers[0]) % double.parse(numbers[1]);
    }

    setState(() {
      _expression = result.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: headerNav(context, 'Calculator'),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Spacer(),
              Container(
                color: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    _expression,
                    style: TextStyle(
                      fontSize: 48,
                      color: Colors.black,
                    ),
                  ),
                ),
                alignment: Alignment(1.0, 1.0),
              ),
              Row(
                children: <Widget>[
                  CalculatorButton(
                    text: 'C',
                    callback: allClear,
                  ),
                  CalculatorButton(
                    text: '÷',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: '%',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: '⌫',
                    callback: delete,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  CalculatorButton(
                    text: '7',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: '8',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: '9',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: 'x',
                    textSize: 24,
                    callback: numberClick,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  CalculatorButton(
                    text: '4',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: '5',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: '6',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: '-',
                    textSize: 40,
                    callback: numberClick,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  CalculatorButton(
                    text: '1',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: '2',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: '3',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: '+',
                    textSize: 30,
                    callback: numberClick,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  CalculatorButton(
                    text: ',',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: '0',
                    callback: numberClick,
                  ),
                  CalculatorButton(
                    text: '00',
                    callback: numberClick,
                    textSize: 26,
                  ),
                  CalculatorButton(
                    text: '=',
                    callback: calculate,
                  ),
                ],
              )
            ],
          ),
        ),
  );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final int textColor;
  final double textSize;
  final Function callback;

  const CalculatorButton({
    Key key,
    this.text,
    this.textColor = 0xFFFFFFFF,
    this.textSize = 22,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Theme.of(context).primaryColor,
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 10,
        decoration: BoxDecoration(
          color:Theme.of(context).primaryColor,
          border: Border.all(
            color:Theme.of(context).accentColor,
            width: 2.0,
          ),
        ),
        child: FlatButton(
          onPressed: () {
            callback(text);
          },
          child: Text(
            text,
            style: TextStyle(
              fontSize: textSize,
            ),
          ),
          textColor: Color(textColor),
        ),
      ),
    );
  }
}
