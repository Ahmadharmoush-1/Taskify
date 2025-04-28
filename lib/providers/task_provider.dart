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
    _initData(); // Initializes data when the provider is created
  }
//Getters for private variables
  List<Task> get tasks => _tasks;
  List<Category> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get showCompleted => _showCompleted;

//This getter returns a filtered list of tasks based on:
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

//The constructor calls _initData(), which is an asynchronous method.
  Future<void> _initData() async {
    await _loadTasks(); // Fetches the tasks from storage
    await _loadCategories(); // Fetches the categories from storage
    notifyListeners(); // Notifies any listeners (UI components) to rebuild
  }

  Future<void> _loadTasks() async {
    _tasks = await _storageService
        .getTasks(); //method fetches the list of tasks from persistent storage
    // database. If no tasks are found,
    //it may load default tasks or an empty list.
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
    _tasks.add(task); //  Add the new task to the in-memory list of tasks.
    await _storageService.saveTasks(
        _tasks); //Save the updated list of tasks to persistent storage.
    notifyListeners(); // Triggers UI updates to reflect new data
  }

  Future<void> updateTask(String id, Task updatedTask) async {
    final taskIndex = _tasks.indexWhere((task) =>
        task.id == id); //searches for index with the same id to update
    if (taskIndex != -1) {
      _tasks[taskIndex] =
          updatedTask; //Replace the Old Task with the Updated Task
      await _storageService
          .saveTasks(_tasks); //Save the Updated Tasks List to Storage
      notifyListeners(); //Notify Listeners (Update the UI)
    }
  }

  Future<void> toggleTaskCompletion(String id) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];// Get the Task at the Found Index
      _tasks[taskIndex] = task.copyWith(completed: !task.completed);
      await _storageService.saveTasks(_tasks);//Saves the updated list of tasks to persistent storage.
      notifyListeners();//Notify Listeners to Update the UI
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);//Remove the Task with the Given ID from the List
    await _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> addCategory(Category category) async {
    _categories.add(category);// Add the new category to the in-memory list of categories.
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
     //Removes the category from the list
    _categories.removeWhere((cat) => cat.id == id);
    //Removes the tasks from the list
    await _storageService.saveCategories(_categories);
    await _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  void setFilter({String? category, String? searchQuery, bool? showCompleted}) {
    if (category != null) _selectedCategory = category;// Filters tasks by a specific category 
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
    final category = _categories.firstWhere(//searches categorys for the given name
      (cat) => cat.name == categoryName,//if found returns the category color
      orElse: () => Category(name: categoryName, color: Colors.grey),//if not found returns a default color
    );
    return category.color;
  }
}
