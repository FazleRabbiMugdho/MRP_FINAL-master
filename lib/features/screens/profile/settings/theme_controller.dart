import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  final GetStorage _box = GetStorage();

  final Rx<ThemeMode> _themeMode = ThemeMode.light.obs;
  RxBool isDarkMode = false.obs;

  ThemeMode get theme => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void _loadThemeFromStorage() {
    String? storedTheme = _box.read('themeMode');
    if (storedTheme != null) {
      ThemeMode mode = storedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      _themeMode.value = mode;
      isDarkMode.value = (mode == ThemeMode.dark);
    }
  }

  void toggleTheme() {
    ThemeMode newMode = _themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _themeMode.value = newMode;
    isDarkMode.value = (newMode == ThemeMode.dark);
    _box.write('themeMode', newMode == ThemeMode.dark ? 'dark' : 'light');

    Get.changeThemeMode(newMode);
  }
}








