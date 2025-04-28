import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/category.dart';

class StorageService {
  static const String _tasksKey = 'tasks';// List of tasks to be stored when app is turned off
  static const String _categoriesKey = 'categories';// List of categories to be stored when app is turned off
  static const String _themeKey = 'isDarkMode';// Dark mode preference to be stored when app is turned off

  // Tasks
  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];// If no tasks are stored prefs.getStringList it returns an empty list.
    return tasksJson//Each task is decoded from JSON format and converted back into a Task object using Task.fromJson().
        .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
        .toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    //Converts the list of tasks into a JSON format and stores them in SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  // Categories
  Future<List<Category>> getCategories() async {
    //fetches the list of categories stored in SharedPreferences
    // and converts them back into Category objects.
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = prefs.getStringList(_categoriesKey) ?? [];
    return categoriesJson
        .map((catJson) => Category.fromJson(jsonDecode(catJson)))
        .toList();
  }

  Future<void> saveCategories(List<Category> categories) async {
    //Converts each Category to JSON and stores the list in SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson =
        categories.map((cat) => jsonEncode(cat.toJson())).toList();
    await prefs.setStringList(_categoriesKey, categoriesJson);
  }

  // Theme
  Future<bool> isDarkMode() async {

  //This retrieves the theme preference stored in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }
}
