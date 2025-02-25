import 'package:flutter/material.dart';
import 'package:give_away/services/auth_service.dart';
import 'package:give_away/utils/token_manager.dart';

enum AuthState {
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {

  bool _isLoading = false;
  AuthState _authState = AuthState.unauthenticated;
  bool _isRegistered=false;

  AuthState get authState => _authState;
  bool get isLoading=>_isLoading;
  bool get isRegistered=>_isRegistered;


  init() async {
    final token = await TokenManager.getToken();
    if(token!=null){
      _authState=AuthState.authenticated;
      notifyListeners();
    }
    print('authentication - '+ '$_authState');
  }

  //auth

  login(String email, String password, Function snackBar) async {
    _isLoading = true;
    notifyListeners();

    try{
      var res = await AuthService().loginUser(email, password);
      if(res['success']==true){
        _authState=AuthState.authenticated;
        await TokenManager.saveToken(res['token']);
      }
      else{
        snackBar(res['message']);
      }
    }
    catch (error){
      snackBar(error.toString());
    }
    _isLoading=false;
    notifyListeners();
  }

  register(String email, String password, Function snackBar) async {
    _isLoading = true;
    notifyListeners();

    try{
      var res = await AuthService().registerUser(email, password);
      if(res['success']==true){
        _authState=AuthState.authenticated;
        await TokenManager.saveToken(res['token']);
        snackBar("User Registration Successful!");
      }
      else{
        snackBar(res['message']);
      }
    }
    catch (error){
      snackBar(error.toString());
    }
    _isLoading=false;
    notifyListeners();
  }

  profileRegister(String name, String phoneNumber, String imagePath,Function(String) snackBar) async{
    _isLoading=true;
    notifyListeners();

    try{
      final token = await TokenManager.getToken()??'';
      var res = await AuthService().profileRegister(name, phoneNumber, imagePath,token);
      if(res['success']==true){
        _isRegistered=true;
        snackBar("Profile Registration Successful!");
      }
      else{
        snackBar(res['message']);}
    }catch(e){
      snackBar(e.toString());
    }
    _isLoading=false;
    notifyListeners();
  }

  signOut()async{
    try {
      await AuthService().signOut();
    }catch(err){
      print(err);
    }
  }
  // signOut()async{
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     _firebaseAuth.signOut();
  //     TokenManager.deleteToken();
  //     _isLoading = false;
  //     notifyListeners();
  //   }catch(err){
  //     print(err);
  //   }
  // }

//signUp(String email, String password, Function(String) snackBar) async {
//     String response='';
//     _isLoading = true;
//     notifyListeners();
//
//     try{
//       // response = await AuthService().signUpWithEmailAndPassword(email, password);
//     }
//     catch (error){
//       response=error.toString();
//     }
//
//     _isLoading=false;
//     notifyListeners();
//
//     if(response!='success'){
//       snackBar(response);
//     }
//
//     return response;
//   }
  // googleSignIn(Function(String) snackBar) async {
  //   String response ='';
  //   _isLoading = true;
  //   notifyListeners();
  //   try{
  //     await AuthService().signInWithGoogle();
  //   }catch(error){
  //     response = error.toString();
  //   }
  //   _isLoading=false;
  //   notifyListeners();
  //
  // }
  //
  // signOut( Function(String) snackBar)async{
  //   String response ='';
  //   try{
  //     response=await AuthService().signOut();
  //   }catch(error){
  //     response = error.toString();
  //   }
  //   snackBar(response);
  // }


//register profile

}

