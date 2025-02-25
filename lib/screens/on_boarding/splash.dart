import 'package:flutter/material.dart';
import 'package:give_away/providers/auth_provider.dart';
import 'package:give_away/providers/on_boarding_provider.dart';
import 'package:give_away/providers/user_provider.dart';
import 'package:give_away/screens/home_screen/home_screen.dart';
import 'package:give_away/screens/nav_bar.dart';
import 'package:give_away/screens/on_boarding/on_boarding.dart';
import 'package:give_away/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      loadData();
    });
  }

  void loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final onBoardingProvider = Provider.of<OnBoardingProvider>(context, listen: false);
    await authProvider.init();
    await onBoardingProvider.loadOnBoardingState();
    await userProvider.loadUser();

    bool showOnboarding= onBoardingProvider.showOnBoarding;
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if(showOnboarding){
        onBoardingProvider.hideOnBoarding();
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OnBoardingScreen()));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NavBar()));
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return const Scaffold(
        backgroundColor: primaryColor,
        body:Center(child: CircularProgressIndicator(
          color: secondaryColor,
        ),
        ),
    );

  }
}
