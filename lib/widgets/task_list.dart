import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(String) onDeleteTask;
  final Function(String) onToggleTaskCompletion;
  final Function(String, Task) onUpdateTask;
  final Function() onAddTask;
  final bool showCompleted;
  final Function(bool) onToggleShowCompleted;
  final Function(String) getCategoryColor;

  const TaskList({
    Key? key,
    required this.tasks,
    required this.onDeleteTask,
    required this.onToggleTaskCompletion,
    required this.onUpdateTask,
    required this.onAddTask,
    required this.showCompleted,
    required this.onToggleShowCompleted,
    required this.getCategoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final incompleteTasks = tasks.where((task) => !task.completed).toList();
    final completedTasks = tasks.where((task) => task.completed).toList();

    final displayedTasks = [
      ...incompleteTasks,
      if (showCompleted) ...completedTasks,
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                'Tasks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 8),
              Text(
                '(${incompleteTasks.length} remaining)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6),
                    ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text('Show completed'),
                  Switch(
                    value: showCompleted,
                    onChanged: onToggleShowCompleted,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (displayedTasks.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 64,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tasks.isEmpty
                        ? "You're all caught up!"
                        : "No matching tasks found",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.6),
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: onAddTask,
                    icon: const Icon(Icons.add),
                    label: const Text('Add a new task'),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: displayedTasks.length,
              itemBuilder: (context, index) {
                final task = displayedTasks[index];
                return TaskItem(
                  task: task,
                  onDelete: onDeleteTask,
                  onToggleComplete: onToggleTaskCompletion,
                  onUpdate: onUpdateTask,
                  categoryColor: getCategoryColor(task.category),
                );
              },
            ),
          ),
      ],
    );
  }
}
