import 'package:flutter/material.dart';
import 'package:give_away/providers/auth_provider.dart';
import 'package:give_away/screens/auth_screens/login.dart';
import 'package:give_away/screens/chat_screens/messages.dart';
import 'package:provider/provider.dart';

import '../auth_screens/register.dart';

class MessageScreenWrapper extends StatefulWidget {
  const MessageScreenWrapper({super.key});

  @override
  State<MessageScreenWrapper> createState() => _MessageScreenWrapperState();
}

class _MessageScreenWrapperState extends State<MessageScreenWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (context, provider, child){
          return provider.authState==AuthState.authenticated
              ? MessagesScreen()
              :  Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                      },
                      child: Text("Register ")),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                      },
                      child: Text(" Login")),
                ],
              ),);
        }
    );
  }
}
