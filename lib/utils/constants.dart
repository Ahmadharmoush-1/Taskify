import 'package:flutter/material.dart';
import '../models/task.dart';

// Priority color mapping
Map<Priority, Color> priorityColors = {
  Priority.low: Colors.green,
  Priority.medium: Colors.amber,
  Priority.high: Colors.red,
};

// Priority label mapping
Map<Priority, String> priorityLabels = {
  Priority.low: 'Low',
  Priority.medium: 'Medium',
  Priority.high: 'High',
};
