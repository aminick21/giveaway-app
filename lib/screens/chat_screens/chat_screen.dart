import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:give_away/providers/socket_provider.dart';
import 'package:provider/provider.dart';


class ChatScreen extends StatefulWidget {
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  const ChatScreen({super.key, required this.senderId, required this.receiverId, required this.senderName, required this.receiverName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late types.User _user ;
  late SocketProvider _socketProvider;
  late int page;
  List<types.Message> _messages = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user=types.User(firstName: widget.senderName, id: widget.senderId);
    page=1;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _socketProvider = Provider.of<SocketProvider>(context,listen: false);
      if(_socketProvider.socket ==null){
        print('socket conneceted through chat page');
        _socketProvider.connectSocket();
      } else if(_socketProvider.socket!.disconnected){
        print('socket conneceted through chat page');
        _socketProvider.connectSocket();
      }
      // _socketProvider.joinRoom(widget.senderId, widget.receiverId);
      getChats(context);
    });
  }



  getChats(context){
    Provider.of<SocketProvider>(context, listen: false).getMessages(widget.senderId);
  }

  sendMessage(String content){
    _socketProvider.sendMessage(widget.senderId, widget.receiverId, content);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _socketProvider.leaveRoom(widget.senderId, widget.receiverId);
    super.dispose();
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.receiverName),
          ),
          body:
          Consumer<SocketProvider>(
            builder: (BuildContext context, SocketProvider provider, Widget? child) {
              return
                provider.isLoading
                  ?Center(child: Text("isLoading"))
                  : Chat(
                  // onEndReached: ()async{
                  //   provider.loadMoreMessages(widget.senderId, widget.receiverId, ++page);
                  // },
                messages: provider.messages,
                onSendPressed:(value)=>sendMessage(value.text),
                user: _user,
              );
            },
          ),
      );
    }

}
// NotificationListener<ScrollNotification>(
// onNotification: (scrollNotification) {
// if (scrollNotification.metrics.pixels ==
// scrollNotification.metrics.maxScrollExtent &&
// !provider.isLoading) {
// _loadMoreMessages();
// }