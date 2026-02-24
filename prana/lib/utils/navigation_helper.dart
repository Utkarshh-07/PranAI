// lib/utils/navigation_helper.dart
import 'package:flutter/material.dart';

class NavigationHelper {
  // Navigate to a named route
  static void navigateTo(BuildContext context, String routeName, {dynamic arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }
  
  // Navigate and replace (no back)
  static void navigateReplace(BuildContext context, String routeName, {dynamic arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }
  
  // Navigate and remove all previous routes
  static void navigateClearStack(BuildContext context, String routeName, {dynamic arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context, 
      routeName, 
      (route) => false,
      arguments: arguments,
    );
  }
  
  // Go back
  static void goBack(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }
  
  // Show exercise completion with parameters
  static void showExerciseComplete(
    BuildContext context, {
    required String exerciseName,
    required int duration,
    required Map<String, String> metrics,
    required String tip,
  }) {
    navigateTo(context, '/exercise-complete', arguments: {
      'exerciseName': exerciseName,
      'duration': duration,
      'metrics': metrics,
      'tip': tip,
    });
  }
  
  // Navigate to AI chat with character
  static void goToVideoChat(BuildContext context, String characterName, String characterImage) {
    navigateTo(context, '/video-chat', arguments: {
      'characterName': characterName,
      'characterImage': characterImage,
    });
  }
  
  // Navigate through prankster levels
  static void goToPranksterLevel(BuildContext context, int level) {
    switch (level) {
      case 1:
        navigateTo(context, '/prankster/level1');
        break;
      case 2:
        navigateTo(context, '/prankster/level2');
        break;
      case 3:
        navigateTo(context, '/prankster/level3');
        break;
      case 4:
        navigateTo(context, '/prankster/level4');
        break;
      default:
        navigateTo(context, '/prankster/level1');
    }
  }
}
