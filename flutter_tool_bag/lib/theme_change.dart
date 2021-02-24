import 'package:flutter/material.dart';
import 'package:flutter_tool_bag/theme_values.dart';
import 'appBar.dart';
import 'theme_button.dart';


class ThemeChange extends StatefulWidget {
  @override
  _ThemeChangeState createState() => _ThemeChangeState();
}

class _ThemeChangeState extends State<ThemeChange> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerNav(context, 'Settings'),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Current Theme Colors",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 8),
            _themeColorContainer(
                "Primary Color", Theme.of(context).primaryColor),
            _themeColorContainer("Accent Color", Theme.of(context).accentColor),
            Divider(color: Theme.of(context).accentColor,height: 35,thickness: 5,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Select Pre-defined Themes",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ThemeButton(buttonThemeData: blueTheme),
                  ThemeButton(buttonThemeData: spookyTheme),
                  ThemeButton(buttonThemeData: greenTheme),
                  ThemeButton(buttonThemeData: pinkTheme),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ThemeButton(buttonThemeData: purpleTheme),
                  ThemeButton(buttonThemeData: brownTheme),
                  ThemeButton(buttonThemeData: orangeTheme),
                  ThemeButton(buttonThemeData: tealTheme),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget _themeColorContainer(String colorName, Color color) {
    return Container(
      width: double.infinity,
      height: 50,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 16),
      color: color,
      child: Text(colorName,
          textAlign: TextAlign.center,
          style: Theme.of(context).primaryTextTheme.button),
    );
  }

}