import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../shared/constants.dart';

/// AppStore — equivalent to React Native useAppStore.ts
/// Manages theme mode (light/dark/system)
class AppStore extends ChangeNotifier {
  String _themeMode = 'system'; // 'light' | 'dark' | 'system'

  String get themeMode => _themeMode;

  bool isDark(BuildContext context) {
    if (_themeMode == 'system') {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return _themeMode == 'dark';
  }

  void toggleTheme() {
    final next = _themeMode == 'dark' ? 'light' : 'dark';
    _themeMode = next;
    StorageService.setString(StorageKeys.themeMode, next);
    notifyListeners();
  }

  void setThemeMode(String mode) {
    _themeMode = mode;
    StorageService.setString(StorageKeys.themeMode, mode);
    notifyListeners();
  }

  void loadTheme() {
    final saved = StorageService.getString(StorageKeys.themeMode);
    if (saved != null && ['light', 'dark', 'system'].contains(saved)) {
      _themeMode = saved;
      notifyListeners();
    }
  }
}
