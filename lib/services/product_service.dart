import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:give_away/models/product_model.dart';
import 'package:give_away/utils/app_constants.dart';
import 'package:give_away/utils/token_manager.dart';
import 'package:http/http.dart' as http;
class ProductService{

 Future<List<ProductModel>> getAllProducts()async{
  List<ProductModel> products=[];
  try{
   var response = await http.get(Uri.parse(AppConstants.getAllProducts));
   if(response.statusCode==200){
    products = (json.decode(response.body)['Products'] as List)
        .map((dynamic item) => ProductModel.fromMap(item))
        .toList();
   }
   else{
    print('Failed to fetch products. Status code: ${response.statusCode}');
   }
  }catch(err){
   print(err);
  }
  return products;
 }

 Future<Map<String, dynamic>>  addProduct(ProductModel newProduct) async {

  String imageUrl = 'abc'; // Replace with actual Base64 image data

  final cloudinary = CloudinaryPublic('dwupgegy0', 'zwsgvj6t', cache: false);

  try {
   CloudinaryResponse response = await cloudinary.uploadFile(
    CloudinaryFile.fromFile(newProduct.imageUrl, resourceType: CloudinaryResourceType.Image),
   );
   imageUrl= response.secureUrl;
  }catch(e){
   print(e);
  }
  try {
   final idToken = await TokenManager.getToken();
   var response = await http.post(
    Uri.parse(AppConstants.addProduct),
    headers: {
     'Content-Type': 'application/json',
     'Authorization': 'Bearer $idToken',
    },
    body: jsonEncode({
     'title': newProduct.title,
     'category': 'Electronics',
     'productAge': newProduct.productAge,
     'condition': 'New',
     'productDescription':newProduct.productDescription,
     'addressLine': newProduct.location.addressLine,
     'city': newProduct.location.city,
     'state': newProduct.location.state,
     'pinCode': newProduct.location.pinCode,
     'lat': newProduct.location.lat,
     'long': newProduct.location.long,
     'imageUrl': imageUrl,
    }),
   );

   if(response.statusCode==401) {
    final idToken2 = await TokenManager.getToken();
    response = await http.post(
     Uri.parse(AppConstants.addProduct),
     headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken2',
     },
     body: jsonEncode({
      'title': newProduct.title,
      'category': 'Electronics',
      'productAge': newProduct.productAge,
      'condition': 'New',
      'productDescription':newProduct.productDescription,
      'addressLine': newProduct.location.addressLine,
      'city': newProduct.location.city,
      'state': newProduct.location.state,
      'pinCode': newProduct.location.pinCode,
      'lat': newProduct.location.lat,
      'long': newProduct.location.long,
      'imageUrl': imageUrl,
     }),
    );

   }
   print(json.decode(response.body)['message']);
   if (response.statusCode == 200) {
    return {'success': true, 'message': 'Product Added successfully!!'};
   }
   else {
    final Map<String, dynamic> data = json.decode(response.body);
    return {'success': false, 'message': data['message']};
   }
  } catch (error) {
   return {'success': false, 'message': 'Internal server error'};
  }
 }

 Future<List<ProductModel>> getRecentlyAddedProducts()async{
  List<ProductModel> products=[];
  try{
   var response = await http.get(Uri.parse(AppConstants.recentlyAddedProducts));
   if(response.statusCode==200){
    products = (json.decode(response.body)['Products'] as List)
        .map((dynamic item) => ProductModel.fromMap(item))
        .toList();
   }
   else{
    print('Failed to fetch products. Status code: ${response.statusCode}');
   }
  }catch(err){
   print(err);
    }
  return products;
 }

 Future<List<ProductModel>> productList(
    String? category,
    String? search,
    int? minAge,
    int? maxAge,
    String? condition,
    {int page = 1, int limit = 10}
     ) async
 {
  final queryParameters = {
   if (category != null) 'category': category,
   if (search != null) 'search': search,
   if (minAge != null) 'minAge': minAge.toString(),
   if (maxAge != null) 'maxAge': maxAge.toString(),
   if (condition != null) 'condition': condition,
   'page': page.toString(),
   'limit': limit.toString(),
  };

  List<ProductModel> products=[];
  final uri;
  try{
   uri = Uri.https('8db3-103-16-69-208.ngrok-free.app','productList',queryParameters);
   var response = await http.get(uri);

   if(response.statusCode==200){
    products = (json.decode(response.body)['products'] as List)
        .map((dynamic item) => ProductModel.fromMap(item))
        .toList();
   }
   else{
    print('Failed to fetch products. Status code: ${response.statusCode}');
   }
  }catch(err){
   print(err);
  }
  return products;
 }

// Future<List<ProductModel>> getProductById()async{
//  List<ProductModel> products=[];
//  try{
//   // var response = await http.get(Uri.parse("${AppConstants.getAllProductsUri}getProductById/65cff01ec7b8654e3784bfb4"));
//
//   if(response.statusCode==200){
//    products = (json.decode(response.body)['Product'] as List)
//        .map((dynamic item) => ProductModel.fromMap(item))
//        .toList();
//   }
//   else{
//
//    print('Failed to fetch products. Status code: ${response.statusCode}');
//
//   }
//  }catch(err){
//   print(err);
//  }
//  return products;
// }
}