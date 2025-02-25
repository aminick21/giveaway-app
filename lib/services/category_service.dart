import 'package:give_away/models/category_model.dart';
import 'dart:convert';
import '../utils/app_constants.dart';
import 'package:http/http.dart' as http ;

class CategoryService{

  Future<List<CategoryModel>> getCategories() async{
    List<CategoryModel> categoryList=[];
    try{
      var response = await http.get(Uri.parse(AppConstants.getCategories));
      if(response.statusCode==200){
        categoryList = (json.decode(response.body) as List).map((element) =>CategoryModel.fromMap(element)).toList();
      }
      else{
        print("failed to fetch category" + "${response.statusCode}");
      }

    }catch(err){
      print(err);
    }
    return categoryList;
  }


}