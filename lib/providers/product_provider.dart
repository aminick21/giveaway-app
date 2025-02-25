import 'dart:ffi';

import 'package:flutter/widgets.dart';
import 'package:give_away/services/product_service.dart';

import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier{

  List<ProductModel> _allProducts = [];
  List<ProductModel> _recentlyAdded= [];
  List<ProductModel> _nearByProduct= [];
  List<ProductModel> _productList= [];


  get allProducts=>_allProducts;
  get recentlyAdded=>_recentlyAdded;
  get nearByProducts=>_nearByProduct;
  get productList=>_productList;


  bool _allProductLoading=false;
  bool _recentlyAddedLoading=false;
  bool _nearByLoading=false;
  bool _productListLoading=false;

  get isAllProductLoading=>_allProductLoading;
  get isNearByLoading=>_nearByLoading;
  get isRecentlyAddedLoading=>_recentlyAddedLoading;
  get isProductListLoading=>_productListLoading;


  fetchAllProducts()async {
    _allProductLoading=true;
    notifyListeners();
    try{
      _allProducts = await ProductService().getAllProducts();
    }catch(err){
      print(err);
    }
    _allProductLoading=false;
    notifyListeners();
  }

  fetchRecentlyAdded() async{
    _recentlyAddedLoading=true;
    notifyListeners();
    try{
      _recentlyAdded = await ProductService().getRecentlyAddedProducts();
    }catch(err){
      print(err);
    }
    _recentlyAddedLoading=false;
    notifyListeners();
  }

  fetchNearByProduct() async{
    _nearByLoading=true;
    notifyListeners();
    try{
      _nearByProduct = await ProductService().getAllProducts();
    }catch(err){
      print(err);
    }
    _nearByLoading=false;
    notifyListeners();
  }

  fetchProductList(String category, String? search, int? minAge, int? maxAge,String? condition )async{
    _productListLoading=true;
    notifyListeners();
    try{
      _productList = await ProductService().productList(category, search, minAge, maxAge, condition);
    }catch(err){
      print(err);
    }
    _productListLoading=false;
    notifyListeners();
  }
}