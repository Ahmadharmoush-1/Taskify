import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../services/storage_service.dart';

class TaskProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Task> _tasks = [];
  List<Category> _categories = [];
  String? _selectedCategory;
  String _searchQuery = '';
  bool _showCompleted = true;

  TaskProvider() {
    _initData();
  }

  List<Task> get tasks => _tasks;
  List<Category> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get showCompleted => _showCompleted;

  List<Task> get filteredTasks {
    return _tasks.where((task) {
      // Filter by category
      final matchesCategory =
          _selectedCategory == null || task.category == _selectedCategory;

      // Filter by search query
      final matchesSearch =
          task.title.toLowerCase().contains(_searchQuery.toLowerCase());

      // Filter by completion status
      final matchesCompleted = _showCompleted || !task.completed;

      return matchesCategory && matchesSearch && matchesCompleted;
    }).toList();
  }

  Future<void> _initData() async {
    await _loadTasks();
    await _loadCategories();
    notifyListeners();
  }

  Future<void> _loadTasks() async {
    _tasks = await _storageService.getTasks();
  }

  Future<void> _loadCategories() async {
    _categories = await _storageService.getCategories();
    // Initialize with default categories if none exist
    if (_categories.isEmpty) {
      _categories = [
        Category(name: 'Personal', color: Colors.blue),
        Category(name: 'Work', color: Colors.green),
        Category(name: 'Shopping', color: Colors.amber),
        Category(name: 'Education', color: Colors.purple),
      ];
      await _storageService.saveCategories(_categories);
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> updateTask(String id, Task updatedTask) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = updatedTask;
      await _storageService.saveTasks(_tasks);
      notifyListeners();
    }
  }

  Future<void> toggleTaskCompletion(String id) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      _tasks[taskIndex] = task.copyWith(completed: !task.completed);
      await _storageService.saveTasks(_tasks);
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    _categories.add(category);
    await _storageService.saveCategories(_categories);
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    final categoryToDelete = _categories.firstWhere((cat) => cat.id == id);

    // Update tasks in the deleted category to "Uncategorized"
    for (var i = 0; i < _tasks.length; i++) {
      if (_tasks[i].category == categoryToDelete.name) {
        _tasks[i] = _tasks[i].copyWith(category: "Uncategorized");
      }
    }

    _categories.removeWhere((cat) => cat.id == id);

    await _storageService.saveCategories(_categories);
    await _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  void setFilter({String? category, String? searchQuery, bool? showCompleted}) {
    if (category != null) _selectedCategory = category;
    if (searchQuery != null) _searchQuery = searchQuery;
    if (showCompleted != null) _showCompleted = showCompleted;
    notifyListeners();
  }

  void clearFilter() {
    _selectedCategory = null;
    _searchQuery = '';
    notifyListeners();
  }

  Color getCategoryColor(String categoryName) {
    final category = _categories.firstWhere(
      (cat) => cat.name == categoryName,
      orElse: () => Category(name: categoryName, color: Colors.grey),
    );
    return category.color;
  }
}
