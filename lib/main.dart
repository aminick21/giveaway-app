import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:give_away/providers/add_product_provider.dart';
import 'package:give_away/providers/auth_provider.dart';
import 'package:give_away/providers/category_provider.dart';
import 'package:give_away/providers/chat_provider.dart';
import 'package:give_away/providers/location_provider.dart';
import 'package:give_away/providers/on_boarding_provider.dart';
import 'package:give_away/providers/product_provider.dart';
import 'package:give_away/providers/socket_provider.dart';
import 'package:give_away/providers/user_provider.dart';
import 'package:give_away/screens/auth_screens/login.dart';
import 'package:give_away/screens/nav_bar.dart';
import 'package:give_away/screens/on_boarding/on_boarding.dart';
import 'package:give_away/screens/on_boarding/splash.dart';
import 'package:give_away/utils/db_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await DatabaseHelper().initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>OnBoardingProvider(),),
        ChangeNotifierProvider(create: (_) =>AuthProvider(),),
        ChangeNotifierProvider(create: (_) =>UserProvider(),),
        ChangeNotifierProvider(create: (_) =>CategoryProvider(),),
        ChangeNotifierProvider(create: (_)=>ProductProvider()),
        ChangeNotifierProvider(create: (_)=>LocationProvider()),
        ChangeNotifierProvider(create: (_)=>SocketProvider()),
        ChangeNotifierProvider(create: (_)=>ChatProvider()),
        ChangeNotifierProvider(create: (_)=>AddProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Give Away',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home:LoginScreen(),
      ),
    );
  }
}
