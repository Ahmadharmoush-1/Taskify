import 'package:uuid/uuid.dart';

enum Priority { low, medium, high } //enum value has three values low, medium and high
// this enum is used to set the priority of the task

class Task { //parameters of the task
  final String id;
  String title;
  String? description;
  bool completed;
  String category;
  Priority priority;
  DateTime? dueDate;
  final DateTime createdAt;

  Task({ //constructor with required parameters
    String? id,
    required this.title,
    this.description,
    this.completed = false,
    required this.category,
    required this.priority,
    this.dueDate,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),//If no id is provided, a unique ID is generated using Uuid().v4().
        this.createdAt = createdAt ?? DateTime.now();//The createdAt field is set to the current time (DateTime.now()) if not passed.

  Map<String, dynamic> toJson() {
    return {//The toJson() method is responsible for converting a Task object into a JSON format.
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'category': category,
      'priority': priority.index,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task( //The fromJson() method is a factory constructor that creates a Task object from a JSON map.
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      category: json['category'],
      priority: Priority.values[json['priority']],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Task copyWith({ //The copyWith() method is a convenient way to create a modified copy of
                  // an existing object while keeping most of its original values.
    String? title,
    String? description,
    bool? completed,
    String? category,
    Priority? priority,
    DateTime? dueDate,
  }) {
    return Task(
      id: id, //id will stay the same as it is not passed in the copyWith method because it is unique
      title: title ?? this.title, //everything down can be changed except createdAt
      description: description ?? this.description,
      completed: completed ?? this.completed,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
    );
  }
}
