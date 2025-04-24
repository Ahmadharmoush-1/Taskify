import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/constants.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({Key? key, this.task}) : super(key: key);

  @override
  TaskFormScreenState createState() => TaskFormScreenState();
}

class TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _category = '';
  Priority _priority = Priority.medium;
  DateTime? _dueDate;
  
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _category = widget.task?.category ?? '';
    _priority = widget.task?.priority ?? Priority.medium;
    _dueDate = widget.task?.dueDate;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (_category.isEmpty) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      if (taskProvider.categories.isNotEmpty) {
        _category = taskProvider.categories[0].name;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      
      if (widget.task == null) {
        // Add new task
        final newTask = Task(
          title: _titleController.text,
          description: _descriptionController.text,
          category: _category,
          priority: _priority,
          dueDate: _dueDate,
        );
        taskProvider.addTask(newTask);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added')),
        );
      } else {
        // Update existing task
        final updatedTask = Task(
          id: widget.task!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          category: _category,
          priority: _priority,
          completed: widget.task!.completed,
          dueDate: _dueDate,
          createdAt: widget.task!.createdAt,
        );
        taskProvider.updateTask(widget.task!.id, updatedTask);
        Navigator.pop(context, updatedTask);
        return;
      }
      
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Text('Category', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: taskProvider.categories.map((category) {
                    return DropdownMenuItem(
                      value: category.name,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: category.color,
                            radius: 8,
                          ),
                          const SizedBox(width: 8),
                          Text(category.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _category = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text('Priority', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: Priority.values.map((priority) {
                    return ChoiceChip(
                      label: Text(priorityLabels[priority]!),
                      selected: _priority == priority,
                      selectedColor: priorityColors[priority]!.withOpacity(0.2),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _priority = priority;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text('Due Date ', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _dueDate != null
                          ? DateFormat('EEEE, MMMM d, yyyy').format(_dueDate!)
                          : 'No date selected',
                    ),
                  ),
                ),
                if (_dueDate != null)
                  TextButton.icon(
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear date'),
                    onPressed: () {
                      setState(() {
                        _dueDate = null;
                      });
                    },
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _saveForm,
                    child: Text(widget.task == null ? 'Add Task' : 'Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}