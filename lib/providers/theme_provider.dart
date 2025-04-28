import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  bool _isDarkMode = false;//tracks if dark mode is enabled or not

  ThemeProvider() {
    _loadThemePreference();//loads the theme preference when the provider is created
  }

  bool get isDarkMode => _isDarkMode;//getter for dark mode
  
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;//returns the current theme mode based on the _isDarkMode variable

  Future<void> _loadThemePreference() async {
    _isDarkMode = await _storageService.isDarkMode();//Loads the saved dark mode preference from storage.
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;// Toggles the dark mode preference
    await _storageService.setDarkMode(_isDarkMode);//Saves the new preference to storage.
    notifyListeners();// Notifies listeners to rebuild the UI with the new theme.
  }
}