
import 'package:flutter/material.dart';
import 'package:give_away/models/category_model.dart';
import 'package:give_away/services/category_service.dart';

class CategoryProvider extends ChangeNotifier{
  bool _isLoading=false;
  List<CategoryModel> _categoryList=[];

  bool get isLoading=>_isLoading;
  List<CategoryModel> get categoryList =>_categoryList;

  getCategories() async{
    _isLoading=true;
    notifyListeners();
    try{
      _categoryList = await CategoryService().getCategories();
    }catch(err){
      print(err);
    }
    _isLoading=false;
    notifyListeners();
  }





}