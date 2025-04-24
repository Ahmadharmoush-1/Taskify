import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/category.dart';

class StorageService {
  static const String _tasksKey = 'tasks';
  static const String _categoriesKey = 'categories';
  static const String _themeKey = 'isDarkMode';

  // Tasks
  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    return tasksJson
        .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
        .toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  // Categories
  Future<List<Category>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = prefs.getStringList(_categoriesKey) ?? [];
    return categoriesJson
        .map((catJson) => Category.fromJson(jsonDecode(catJson)))
        .toList();
  }

  Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson =
        categories.map((cat) => jsonEncode(cat.toJson())).toList();
    await prefs.setStringList(_categoriesKey, categoriesJson);
  }

  // Theme
  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }
}
