import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tool_bag/appBar.dart';
import 'package:flutter_tool_bag/theme_change.dart';
import 'package:flutter_tool_bag/theme_notifier.dart';
import 'package:flutter_tool_bag/theme_values.dart';
import 'package:flutter_tool_bag/to_do_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tool_bag/calculator.dart';
import 'package:provider/provider.dart';
import 'gallery.dart';

void main() => runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => ThemeNotifier(greenTheme), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Dynamic Theme",
      theme: themeNotifier.getTheme(),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
        appBar: headerNav(context, 'My Tool Bag'),
        body: Center(
          child: GridView.count(
              crossAxisCount: 1,
              shrinkWrap: true,
              children: List.generate(4, (index) {
                return Container(
                  child: ChoiceCard(
                      choice: tools[index], index: index, callback: refresh),
                );
              })),
        ),
    );
  }
}

class Tool {
  final String title;
  final IconData icon;

  Tool({this.title, this.icon});
}

List<Tool> tools = <Tool>[
  Tool(
    title: "To-do List",
    icon: FontAwesomeIcons.list,
  ),
  Tool(
    title: "Gallery",
    icon: FontAwesomeIcons.images,
  ),
  Tool(
    title: "Calculator",
    icon: FontAwesomeIcons.calculator,
  ),
  Tool(
    title: "Settings",
    icon: Icons.settings,
  ),
];

class ChoiceCard extends StatelessWidget {
  ChoiceCard({Key key, this.choice, this.index, this.callback})
      : super(key: key);
  Tool choice;
  final int index;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (index == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ToDoList()));
        }
        if (index == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Gallery()));
        }
        if (index == 2) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Calculator()));
        }
        if (index == 3) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ThemeChange()));
        }
      },
      child: Center(
        child: Container(
          padding: EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 20),
          child: GridTile(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Theme.of(context).accentColor,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      choice.icon,
                      size: 130.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        choice.title,
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
