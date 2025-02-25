import 'dart:convert';

import 'package:give_away/models/message_model.dart';
import 'package:give_away/utils/db_helper.dart';
import 'package:http/http.dart' as http;
import 'package:give_away/utils/app_constants.dart';

import '../utils/token_manager.dart';

class ChatService{

  Future<List<MessageModel>> getMessages(String userId) async{
    List<MessageModel> listOfMessageModels=[];
    try{
      listOfMessageModels = await DatabaseHelper().getMessages(userId);
    }
    catch(e){
      print(e);
    }
    return listOfMessageModels;
  }


}

