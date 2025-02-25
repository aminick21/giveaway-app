import 'package:flutter/cupertino.dart';
import 'package:give_away/models/product_model.dart';
import 'package:give_away/services/product_service.dart';

class AddProductProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isSuccess=false;
  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;

  addProduct(ProductModel newProduct,Function snackBar) async {
    _isLoading = true;
    _isSuccess=false;
    notifyListeners();
    try {
      var res =  await ProductService().addProduct(newProduct);
      if(res['success']==true){
        snackBar(res['message']);
        _isSuccess=true;
      }
      else{
        snackBar(res['message']);
      }
    }
    catch (err) {
      snackBar(err.toString());
    }
    _isLoading = false;
    notifyListeners();
  }

}