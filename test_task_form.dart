import 'package:flutter/material.dart';
import 'package:motiv_fy/core/widgets/task_form.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Test TaskForm')),
        body: const TaskForm(),
      ),
    ),
  );
}
