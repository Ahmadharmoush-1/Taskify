import 'package:uuid/uuid.dart';

enum Priority { low, medium, high }

class Task {
  final String id;
  String title;
  String? description;
  bool completed;
  String category;
  Priority priority;
  DateTime? dueDate;
  final DateTime createdAt;

  Task({
    String? id,
    required this.title,
    this.description,
    this.completed = false,
    required this.category,
    required this.priority,
    this.dueDate,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
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
    return Task(
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

  Task copyWith({
    String? title,
    String? description,
    bool? completed,
    String? category,
    Priority? priority,
    DateTime? dueDate,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
    );
  }
}
