//for android emulator use http://192.168.0.100:3000
//for ios simulator use  http://localhost:3000
//physical device use ngnork



class AppConstants {

  static const String endPoint = 'https://4c1a-103-16-69-209.ngrok-free.app';

//  auth
  static const String loginWithEmail = '$endPoint/auth/loginWithEmail';
  static const String registerWithEmail = '$endPoint/auth/registerWithEmail';
  static const String validateToken = '$endPoint/auth/validateToken';
  static const String profileRegister = '$endPoint/auth/registerProfile';

//  chat
  static const String getMessages = '$endPoint/chat/getMessages';


//  product
  static const String addProduct = '$endPoint/addProduct';
  static const String getAllProducts = '$endPoint/';
  static const String recentlyAddedProducts = '$endPoint/recentlyAddedProducts';
  static const String productList = '$endPoint/productList';

//   category
  static const String getCategories = '$endPoint/category/getCategories';

//   user
  static const String getUserById='$endPoint/user/getUserById';
}



