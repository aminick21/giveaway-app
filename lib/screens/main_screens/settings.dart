import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        elevation: .5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        title: Text("Settings",
          style:TextStyle(fontSize:28,fontWeight: FontWeight.bold,color: blackColor),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [

          //avatar
          Row(
            children: [
              Spacer(),
              SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.withOpacity(.5),
                    child: Image.asset("assets/Avatar.png"),),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(LineIcons.plusCircle,))
                ],
                ),
              ),
              Spacer(),
            ],
          ),


        SizedBox(height: 20,),
        Text("General",
        style:TextStyle(fontSize:20,fontWeight: FontWeight.bold,color: blackColor),),

          //rectangle
          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey.shade50,
                boxShadow: [BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 100.0,
                  spreadRadius:5.0,
                ),]
            ),
            child: Row(
              children: [
                Icon(LineIcons.user,size: 25,),
                SizedBox(width:5,),
                Text("Edit Profile",
                    style:TextStyle(
                        fontSize:18,
                        color: blackColor)),
                Spacer(),
                Icon(Icons.chevron_right,size: 30,color: Colors.grey,),

              ],
            ),
          ),

          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade50,
                boxShadow: [BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 100.0,
                  spreadRadius:5.0,
                ),]
            ),
            child: Row(
              children: [
                Icon(LineIcons.bell,size: 25,),
                SizedBox(width:5,),
                Text("Notifications",
                    style:TextStyle(
                        fontSize:18,
                        color: blackColor)),
                Spacer(),
                Icon(Icons.chevron_right,size: 30,color: Colors.grey,),

              ],
            ),
          ),

          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade50,
                boxShadow: [BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 100.0,
                  spreadRadius:5.0,
                ),]
            ),
            child: Row(
              children: [
                Icon(LineIcons.userShield,size: 25,),
                SizedBox(width:5,),
                Text("Security",
                    style:TextStyle(
                        fontSize:18,
                        color: blackColor)),
                Spacer(),
                Icon(Icons.chevron_right,size: 30,color: Colors.grey,),

              ],
            ),
          ),

          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade50,
                boxShadow: [BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 100.0,
                  spreadRadius:5.0,
                ),]
            ),
            child: Row(
              children: [
                Icon(LineIcons.globe,size: 25,),
                SizedBox(width:5,),
                Text("Language",
                    style:TextStyle(
                        fontSize:18,
                        color: blackColor)),
                Spacer(),
                Icon(Icons.chevron_right,size: 30,color: Colors.grey,),

              ],
            ),
          ),

          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade50,
                boxShadow: [BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 100.0,
                  spreadRadius:5.0,
                ),]
            ),
            child: Row(
              children: [
                Icon(LineIcons.fileContract,size: 25,),
                SizedBox(width:5,),
                Text("Privacy Policies",
                    style:TextStyle(
                        fontSize:18,
                        color: blackColor)),
                Spacer(),
                Icon(Icons.chevron_right,size: 30,color: Colors.grey,),

              ],
            ),
          ),

          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade50,
                boxShadow: [BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 100.0,
                  spreadRadius:5.0,
                ),]
            ),
            child: Row(
              children: [
                Icon(LineIcons.questionCircle,size: 25,),
                SizedBox(width:5,),
                Text("Help Center",
                    style:TextStyle(
                        fontSize:18,
                        color: blackColor)),
                Spacer(),
                Icon(Icons.chevron_right,size: 30,color: Colors.grey,),

              ],
            ),
          ),

          SizedBox(height: 15,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade50,
                boxShadow: [BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 100.0,
                  spreadRadius:5.0,
                ),]
            ),
            child: Row(
              children: [
                Icon(LineIcons.alternateSignOut,size: 24,color: Colors.red,),
                SizedBox(width:5,),
                Text("Logout",
                    style:TextStyle(
                        fontSize:18,
                        color: Colors.red)),


              ],
            ),
          ),


        ],
      ),
    );
  }
}
