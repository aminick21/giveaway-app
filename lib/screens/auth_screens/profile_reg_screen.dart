import 'dart:io';
import 'package:flutter/material.dart';
import 'package:give_away/providers/auth_provider.dart' as auth;
import 'package:give_away/screens/nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class ProfileRegistration extends StatefulWidget {
  const ProfileRegistration({super.key});

  @override
  State<ProfileRegistration> createState() => _ProfileRegistrationState();
}

class _ProfileRegistrationState extends State<ProfileRegistration> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController phoneController;
  XFile? pickedImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
  }



  pickImage()async {
    final ImagePicker picker = ImagePicker();

    try{
      final image =await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        pickedImage=XFile(image!.path);
      });
    }
    catch(e){
      snackBar('Error getting the Image!!');
    }
  }

  void snackBar(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Consumer<auth.AuthProvider>(
        builder: (BuildContext context, auth.AuthProvider provider, Widget? child) {
          return provider.isLoading?
          const Center(child: CircularProgressIndicator(),)
              : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Text(
                    "My Profile",
                    style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: UnconstrainedBox(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: pickedImage==null ?AssetImage('assets/Avatar.png') : FileImage(File(pickedImage!.path)) as ImageProvider<Object>?,
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap:()=> pickImage(),
                                child: const CircleAvatar(
                                  child: Icon(Icons.add,color: secondaryColor,),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),

                  const Text(
                    "User Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      validator: (value) => value == null || value.isEmpty ? "This field can't be empty" : null,
                      controller: nameController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.withOpacity(.2),
                        prefixIcon: const Icon(
                          LineIcons.user,
                          color: secondaryColor,
                        ),
                        filled: true,
                        hintText: " Enter Your Name",
                        hintStyle: const TextStyle(color: secondaryColor),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text(
                    "Phone Number",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      validator: (value) => value == null || value.length != 10 ? "Enter a valid phone number" : null,
                      textAlignVertical: TextAlignVertical.bottom,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          LineIcons.phone,
                          color: secondaryColor,
                        ),
                        fillColor: Colors.grey.withOpacity(.2),
                        filled: true,
                        hintText: " Enter Your Phone Number",
                        hintStyle: const TextStyle(color: secondaryColor),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // FirebaseAuth.instance.signOut();
                      if( _formKey.currentState!.validate()){
                        var imagePath=pickedImage!=null?pickedImage!.path:'';
                       await provider.profileRegister(nameController.text.trim(),phoneController.text.trim(),imagePath,snackBar);

                        if(provider.isRegistered==true && mounted){
                          Navigator.push(context, MaterialPageRoute(builder:(context)=>NavBar()));
                        }
                    }
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child:const Center(
                          child: Text(
                            "Save Profile",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 18),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        },

      ),
    );
  }
}
