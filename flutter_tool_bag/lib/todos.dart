import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tool_bag/main.dart';
import 'package:flutter_tool_bag/sign_in.dart';
import 'package:flutter_tool_bag/task.dart';
import 'package:flutter_tool_bag/theme_notifier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'appBar.dart';

class Todos extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: headerNav(context, 'Todos'),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return TodosState();
  }
}

class TodosState extends State<Todos> {
  final List<Task> tasks = [];
  User user;

  void onTaskToggled(Task task) {
    setState(() {
      task.setCompleted(!task.isCompleted());
    });
  }

  void onLogin(User user) {
    setState(() {
      this.user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todos',
      theme: themeNotifier.getTheme(),
      initialRoute: TodosList.routeName,
      onGenerateRoute: (RouteSettings settings) {
        var routes = <String, WidgetBuilder>{
          TodosList.routeName: (context) => TodosList(),
          TodosCreateEdit.routeName: (context) =>
              TodosCreateEdit(settings.arguments)
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
    );
  }
}

class TodosList extends StatefulWidget {
  static final String routeName = '/';

  @override
  _TodosListState createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  final collection = FirebaseFirestore.instance.collection('tasks');
  final df = new DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(60))),
          centerTitle: true,
          backgroundColor:Theme.of(context).primaryColor,
          title: Text("Todos"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  signOutGoogle().then((_) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return MyHomePage();
                        },
                      ),
                    );
                  });
                }),
          ]),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            final list = snapshot.data.docs;
            return ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  color: Color(list[index]['color']),
                  child: ExpansionTile(
                    leading: Text(
                      list[index]['priority'],
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    title: Text(
                      list[index]['categoryName'],
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    backgroundColor: Color(list[index]['color']),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    list[index]['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                Checkbox(
                                    value: list[index]['completed'],
                                    onChanged: (newValue) => collection
                                        .doc(list[index].id)
                                        .update({'completed': newValue})),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    df
                                        .format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                list[index]['taskDate']))
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    list[index]['taskDetails'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    collection.doc(list[index].id).delete();
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text("Todo is deleted.")));
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Task taskObject = Task(
                                      taskId: list[index].id,
                                      categoryName:
                                          list[index].data()['categoryName'],
                                      name: list[index].data()['name'],
                                      taskDetails:
                                          list[index].data()['taskDetails'],
                                      priority: list[index].data()['priority'],
                                    );
                                    Navigator.pushNamed(
                                        context, TodosCreateEdit.routeName,
                                        arguments: taskObject);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: list.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor:Theme.of(context).accentColor,
          onPressed: () =>
              Navigator.pushNamed(context, TodosCreateEdit.routeName),
          child: Icon(Icons.add)),
    );
  }
}

class TodosCreateEdit extends StatefulWidget {
  static final String routeName = 'createEdit';
  Task task;

  TodosCreateEdit(this.task);

  @override
  _TodosCreateEditState createState() => _TodosCreateEditState();
}

class _TodosCreateEditState extends State<TodosCreateEdit> {
  final collection = FirebaseFirestore.instance.collection('tasks');
  String categoryName, name, details, date, priority;
  var key = GlobalKey<FormState>();

  get createDate => createDate;
  var selectedColor = MaterialColor(0xFFFf9800, {});
  var selectedCheckBox = "";
  int _radioValue = 0;
  Task task;
  String todoCategory = '';
  String todoName = '';
  String todoDetail = '';
  String todoPriority;

  @override
  void initState() {
    super.initState();

    task = widget.task;
    if (task != null) {
      todoCategory = task.categoryName;
      todoName = task.name;
      todoDetail = task.taskDetails;
      todoPriority = task.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomPadding: false,
      appBar: headerNav(context, task != null ? 'Edit To do' : 'Create To do'),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: task != null ? task.categoryName : "",
                    autofocus: true,
                    onSaved: (text) {
                      categoryName = text;
                    },
                    decoration: InputDecoration(
                        labelText: 'Category Name',
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      initialValue: task != null ? task.name : "",
                      autofocus: true,
                      onSaved: (text) {
                        name = text;
                      },
                      decoration: InputDecoration(
                          labelText: 'Task Name',
                          border: OutlineInputBorder())),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      initialValue: task != null ? task.taskDetails : "",
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      onSaved: (text) {
                        details = text;
                      },
                      decoration: InputDecoration(
                          labelText: 'Task Details',
                          border: OutlineInputBorder())),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: task != null ? task.priority : "",
                    autofocus: true,
                    onSaved: (text) {
                      priority = text;
                    },
                    decoration: InputDecoration(
                        labelText: 'Task Priority',
                        border: OutlineInputBorder()),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 50,
                      child: new RadioListTile<int>(
                        activeColor:Theme.of(context).accentColor,
                        value: 0,
                        title: new Text('amber'),
                        groupValue: _radioValue,
                        onChanged: (val) {
                          setState(() {
                            selectedColor = Colors.amber;
                            _radioValue = val;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 50,
                      child: new RadioListTile<int>(
                        activeColor: Theme.of(context).accentColor,
                        value: 1,
                        title: new Text('lime'),
                        groupValue: _radioValue,
                        onChanged: (val) {
                          setState(() {
                            selectedColor = Colors.lime;
                            _radioValue = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 50,
                      child: new RadioListTile<int>(
                        activeColor:Theme.of(context).accentColor,
                        value: 2,
                        title: new Text('grey'),
                        groupValue: _radioValue,
                        onChanged: (val) {
                          setState(() {
                            selectedColor = Colors.grey;
                            _radioValue = val;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 50,
                      child: new RadioListTile<int>(
                        activeColor: Theme.of(context).accentColor,
                        value: 3,
                        title: new Text('purple'),
                        groupValue: _radioValue,
                        onChanged: (val) {
                          setState(() {
                            selectedColor = Colors.purple;
                            _radioValue = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () async {
          if (task == null) {
            if (key.currentState.validate()) {
              key.currentState.save();
            }
            await collection.add({
              'categoryName': categoryName,
              'name': name,
              'taskDetails': details,
              'taskDate': DateTime.now().millisecondsSinceEpoch,
              'priority': priority,
              'color': selectedColor.value,
              'completed': false
            });
            Navigator.pop(context);
          } else {
            if (key.currentState.validate()) {
              key.currentState.save();
            }
            collection.doc(task.taskId).update({
              'categoryName': categoryName,
              'name': name,
              'taskDetails': details,
              'priority': priority,
              'color': selectedColor.value
            });
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
