import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:give_away/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier{
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;



  Future<void> saveUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toMap()));
    _user=user;
    notifyListeners();
  }


  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    if (userData != null) {
      _user = UserModel.fromMap(jsonDecode(userData));
      notifyListeners();
    }
    print(_user);
  }

  getUserById(String id) async{

  }

}