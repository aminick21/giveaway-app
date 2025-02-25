import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:give_away/providers/auth_provider.dart' as auth;
import 'package:give_away/utils/app_constants.dart';
import 'package:give_away/utils/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icon.dart';

class AuthService {

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.loginWithEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final token = data['token'];
        return {'success': true, 'token': token};
      } else {
        final Map<String, dynamic> data = json.decode(response.body);
        return {'success': false, 'message': data['message']};
      }
    } catch (err) {
      return {'success': false, 'message': 'Internal server error'};
    }
  }

  Future<Map<String, dynamic>> registerUser(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.registerWithEmail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final token = data['token'];
        return {'success': true, 'token': token};
      } else {
        final Map<String, dynamic> data = json.decode(response.body);
        return {'success': false, 'message': data['message']};
      }
    } catch (err) {
      return {'success': false, 'message': 'Internal server error'};
    }
  }

  Future<Map<String, dynamic>> profileRegister(String name, String phoneNumber,
      String imagePath, String idToken) async {
    try {
      final imageUrl = await uploadImage(imagePath)??'';
      var response = await http.post(
        Uri.parse(AppConstants.profileRegister),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(
            {'name': name, 'phoneNumber': phoneNumber, 'imagePath': imageUrl}),
      );

      if(response.statusCode==401){
          // token expired - logout

      }
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Profile Creation successful!!'};
      }
      else {
        final Map<String, dynamic> data = json.decode(response.body);
        return {'success': false, 'message': data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Internal server error'};
    }
  }


  Future<String?> uploadImage(String imagePath) async{
    try{
      final cloudinary = CloudinaryPublic('dwupgegy0', 'zwsgvj6t', cache: false);
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imagePath, resourceType: CloudinaryResourceType.Image),);
      final imageUrl = response.secureUrl;
      return imageUrl;
    }catch(err){
      print(err);
      return null;
    }
  }

  signOut()async{
    try {
      await TokenManager.deleteToken();
    }catch(err){
      print(err);
    }
  }
  // Future<String> signInWithGoogle() async {
  //   String response = 'success';
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );
  //     UserCredential? user = await _auth.signInWithCredential(credential);
  //     print(user);
  //   } on Exception catch (e) {
  //     response = e.toString();
  //   }
  //   return response;
  // }


  // Future<String> signOut() async {
  //
  //   String status = 'success';
  //   try {
  //     await _auth.signOut();
  //     await _googleSignIn.signOut();
  //   } catch (error) {
  //     status=error.toString();
  //   }
  //   return status;
  //
  // }
}
