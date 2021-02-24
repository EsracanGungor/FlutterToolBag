import 'package:flutter/material.dart';

class Task {
  String taskId;
  String name;
  bool _completed = false;
  String taskDetails;
  DateTime createDate;
  String priority;
  String categoryName;
  MaterialColor color;

  Task({this.taskId, this.categoryName, this.name, this.taskDetails,
    DateTime createDate, this.priority, this.color});

  isCompleted() => this._completed;

  setCompleted(completed) => this._completed = completed;
}