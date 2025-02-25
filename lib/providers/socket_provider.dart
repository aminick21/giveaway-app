import 'package:flutter/cupertino.dart';
import 'package:give_away/utils/db_helper.dart';
import 'package:give_away/utils/token_manager.dart';
import 'package:line_icons/line_icon.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../models/message_model.dart';
import '../services/chat_service.dart';
import '../utils/app_constants.dart';
import 'package:uuid/uuid.dart';
class SocketProvider with ChangeNotifier{
  Socket? socket;

  List<MessageModel> _listOfMessageModels=[];
  List<types.Message> _messages=[];
  bool _loading=false;
  bool isConnected = false;

  get messages =>_messages;
  get isLoading=>_loading;


  connectSocket() async {
      final idToken = await TokenManager.getToken();
      socket = io(AppConstants.endPoint, <String, dynamic>{
        "transports": ["websocket"],
        'auth': {
          'token': idToken,
        },
        "autoConnect": false,
      });

      socket?.connect();

      socket?.onConnect((data) {
        print('socket connected');
        socket?.emit('register');
      });

      socket?.on('newMessage', (data) {
        print(data['timeStamp']);
      // save msg
        MessageModel messageModel=MessageModel(
            id: data['id'],
            senderId: data['from'],
            receiverId: data['to'],
            content: data['content'],
            timestamp: data['timeStamp']);
        DatabaseHelper().insertMessage(messageModel);

        //update msg list
        _messages.insert(0, types.TextMessage(author: types.User(id: data['from']), id: data['id'], text: data['content'], createdAt:data['timeStamp']));
        notifyListeners();
      });

      socket?.onDisconnect((data) => print('socket disconnected'));
    }

  disconnectSocket() {
    if (socket != null){
      socket!.off('connect');
      socket!.off('newMessage');
      socket!.off('newMessage2');
      socket!.off('disconnect');
      socket!.disconnect();
      socket = null;
      print('Socket disconnected.');
    }
  }

  void sendMessage(String from, String to, String content) {
    final id = generateId();
    final timeStamp=DateTime.now().millisecondsSinceEpoch;
    final message = {
      'id':id,
      'from': from,
      'to': to,
      'content': content,
      'timeStamp':timeStamp,
    };

    // send msg
    socket?.emit('sendMessage',message);

    // store msg
    MessageModel messageModel= MessageModel(
        id: id,
        senderId: from,
        receiverId: to,
        content: content,
        timestamp: timeStamp);
    DatabaseHelper().insertMessage(messageModel);

    //update list
    _messages.insert(0, types.TextMessage(author: types.User(id: from), id: id, text: content, createdAt:timeStamp));
    notifyListeners();

  }

  getMessages(String userID) async {
    try{
      _loading=true;
      notifyListeners();

      _listOfMessageModels = await ChatService().getMessages(userID);
      _messages = _listOfMessageModels.map((message) {
        return types.TextMessage(
          author: types.User(id: message.senderId),
          id: message.id,
          text: message.content,
          createdAt: message.timestamp,
        );
      }).toList();
      _loading=false;
      notifyListeners();
    }catch(e){
      print(e);
    }
  }

  loadMoreMessages(String senderUid )async {
    // try{
    //   _listOfMessageModels = await ChatService().getMessages();
    //   List<types.Message> newMessages =_listOfMessageModels.map((message) {
    //     return types.TextMessage(
    //       author: types.User(id: message.senderId),
    //       id: message.id,
    //       text: message.content,
    //     );
    //   }).toList();
    //   _messages.addAll(newMessages);
    //   notifyListeners();
    // }catch(e){
    //   print(e);
    // }
  }


  String generateId(){
    // Create a UUID object
    var uuid = Uuid();
    // Generate a random UUID
    String id = uuid.v1();
    return id;
  }

}



