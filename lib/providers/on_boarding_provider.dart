import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingProvider with ChangeNotifier {
  bool _showOnBoarding = true;

  bool get showOnBoarding => _showOnBoarding;

  Future<void> loadOnBoardingState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _showOnBoarding = prefs.getBool('showOnBoarding')??true;
    print('showOnboarding - '+'$_showOnBoarding');
  }

  Future<void> hideOnBoarding() async {
    _showOnBoarding = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnBoarding', false);
  }

}