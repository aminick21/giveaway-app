import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:give_away/providers/auth_provider.dart';
import 'package:give_away/screens/auth_screens/profile_reg_screen.dart';
import 'package:give_away/utils/colors.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  void snackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return authProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      //  heading
                      const Text(
                        "Create Account",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Explore items by creating your account",
                        style: TextStyle(color: secondaryColor, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      const Text(
                        "Email",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        validator: (value) => value != null &&
                                !EmailValidator.validate(emailController.text)
                            ? 'Enter a valid email!!'
                            : null,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.withOpacity(.2),
                          prefixIcon: const Icon(
                            LineIcons.envelope,
                            color: secondaryColor,
                          ),
                          filled: true,
                          hintText: "Enter your email",
                          hintStyle: const TextStyle(color: secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1.5, color: primaryColor), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      //  password
                      const Text(
                        "Password",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) => value != null && value.length < 8
                            ? 'Password must be at least 8 characters long'
                            : null,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.withOpacity(.2),
                          prefixIcon: const Icon(
                            LineIcons.lock,
                            color: secondaryColor,
                          ),
                          filled: true,
                          hintText: "Create your password",
                          hintStyle: const TextStyle(color: secondaryColor),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1.5, color: primaryColor), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),

                      //   login button
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {

                            await authProvider.register(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                snackBar);

                            if (authProvider.authState ==AuthState.authenticated && mounted) {

                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                                        ProfileRegistration()),
                              );
                            }
                          }
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Center(
                              child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 18),
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                          child: Text(
                        "or using other method",
                        style: TextStyle(color: secondaryColor, fontSize: 14),
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      //  social logins

                      GestureDetector(
                        onTap: () async {},
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(.5),
                                  width: 1)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Brand(
                                Brands.google,
                                size: 24,
                              ),
                              const Text(
                                "  Sign In with Google",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: blackColor,
                                    fontSize: 18),
                              ),
                            ],
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // authProvider?.signOut(snackBar);
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(.5),
                                  width: 1)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Brand(
                                Brands.facebook,
                                size: 24,
                              ),
                              const Text(
                                "  Sign In with Facebook",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: blackColor,
                                    fontSize: 18),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    ));
  }
}
