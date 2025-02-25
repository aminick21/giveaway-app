import 'package:flutter/material.dart';
import 'package:give_away/providers/socket_provider.dart';
import 'package:give_away/screens/chat_screens/chat_screen.dart';
import 'package:give_away/utils/token_manager.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late SocketProvider _socketProvider;
  late String? token;
  late String? senderId;
  late String? receiverId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _socketProvider = Provider.of<SocketProvider>(context,listen: false);
      if(_socketProvider.socket ==null ){
        print('socket connected through chatList page');
        _socketProvider.connectSocket();
      }
      else if(_socketProvider.socket!.disconnected){
        _socketProvider.connectSocket();
      }
      // getChats(context);
      getToken();
    });
  }

  getToken()async {
    token = await TokenManager.getToken();

    if(token=='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NjRkMTI0NWZjZmE3NjJhNTM0MjIxOTciLCJlbWFpbCI6InRlc3QxQGdtYWlsLmNvbSIsImlhdCI6MTcxODY1NDc4OCwiZXhwIjoxNzE5MjU5NTg4fQ.QFlsKop2NatG7smB4KQtCDiWOohBu9fdarYpYoz46To'){
      senderId='664d1245fcfa762a53422197';
      receiverId='664d12b9a1d04a83bcd11143';
    }else{
      senderId='664d12b9a1d04a83bcd11143';
      receiverId='664d1245fcfa762a53422197';
    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        title: const Text(
          "Messages",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: blackColor),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child:Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 40,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            LineIcons.search,
                            color: secondaryColor,
                          ),
                          filled: true,
                          hintText: "Search",
                          hintStyle: const TextStyle(color: secondaryColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    senderId:  senderId!,
                                    receiverName: 'Reciever',
                                    receiverId: receiverId!,
                                    senderName: 'sender',
                                  ))),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(.5),
                            child: Image.asset("assets/Avatar.png"),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ashutosh ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "Hey!! ",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            "04:00",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
        ),
      ),
    );
  }
}
//
//
