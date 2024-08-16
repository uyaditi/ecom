import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_flutter_fire/app/modules/persona/persona_controller.dart';

class SettingsController extends GetxController {
  final selectedPersona = Rx<Persona?>(null);
  final isDarkMode = false.obs;

  void setPersona(Persona? persona) {
    selectedPersona.value = persona;
    if (persona != null) {
      Get.changeTheme(ThemeData(
        primaryColor: persona.primaryColor,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(persona.primaryColor.value, {
            50: persona.primaryColor.withOpacity(0.1),
            100: persona.primaryColor.withOpacity(0.2),
            200: persona.primaryColor.withOpacity(0.3),
            300: persona.primaryColor.withOpacity(0.4),
            400: persona.primaryColor.withOpacity(0.5),
            500: persona.primaryColor.withOpacity(0.6),
            600: persona.primaryColor.withOpacity(0.7),
            700: persona.primaryColor.withOpacity(0.8),
            800: persona.primaryColor.withOpacity(0.9),
            900: persona.primaryColor.withOpacity(1.0),
          }),
        ).copyWith(
          secondary: persona.secondaryColor,
        ),
        scaffoldBackgroundColor: persona.backgroundColor,
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: persona.textColor,
              displayColor: persona.textColor,
            ),
      ));
    } else {
      Get.changeTheme(isDarkMode.value ? ThemeData.dark() : ThemeData.light());
    }
  }

  void toggleDarkMode() {
    isDarkMode.toggle();
    if (selectedPersona.value != null) {
      setPersona(selectedPersona.value!.copyWith(isDarkMode: isDarkMode.value));
    } else {
      Get.changeTheme(isDarkMode.value ? ThemeData.dark() : ThemeData.light());
    }
  }
}
