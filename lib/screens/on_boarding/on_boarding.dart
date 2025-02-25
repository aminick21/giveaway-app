import 'dart:async';

import 'package:flutter/material.dart';
import 'package:give_away/screens/auth_screens/login.dart';
import 'package:give_away/screens/auth_screens/register.dart';
import 'package:give_away/utils/colors.dart';
import 'package:give_away/models/onboarding_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _controller;
  int currIndex = 0;
  @override
  void initState() {
    super.initState();
    _controller = PageController();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  void startTimer() {
    // Create a repeating timer that fires every 5 seconds
    Timer.periodic(Duration(seconds: 2), (timer) {
      // Update the value of currIndex
      setState(() {
        currIndex =
            (currIndex + 1) % 3; // Assuming you want to cycle from 0 to 9
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 10),
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _controller,
                    itemCount: onBoardingList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: primaryColor));
                    },
                    onPageChanged: (index) {
                      setState(() {
                        currIndex = index;
                      });
                    },
                  ),
                )),
            Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //heading
                    Text(
                      onBoardingList[currIndex].heading,
                      textAlign: TextAlign.center,
                      style:TextStyle(fontWeight: FontWeight.bold,fontSize: 22)
                    ),

                    //subheading
                    Text(
                      onBoardingList[currIndex].subHeading,
                      textAlign: TextAlign.center,
                       style:TextStyle(fontSize: 16,color: secondaryColor)
                    ),

                    //loading indicator
                    Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: currIndex,
                        count: onBoardingList.length,
                        effect: WormEffect(
                            dotHeight: 7,
                            dotWidth: 14,
                            radius: 7,
                            spacing: 5,
                            activeDotColor: primaryColor,
                            dotColor: Colors.grey.withOpacity(.3)),
                      ),
                    ),

                    //buttons
                    GestureDetector(
                      onTap: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Text(
                          "Create Account",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 18),
                        )),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                      },
                      child: Text(
                        "Already have an account?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 16),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
