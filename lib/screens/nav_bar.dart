import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_away/screens/chat_screens/chat_screen_wrapper.dart';
import 'package:give_away/screens/main_screens/settings.dart';
import 'package:give_away/screens/product_screens/add_product_screen.dart';
import 'package:give_away/utils/colors.dart';
import 'package:give_away/screens/main_screens/categories.dart';
import 'package:give_away/screens/home_screen/home_screen.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:line_icons/line_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar>  with WidgetsBindingObserver  {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
  }

  switchPage(index){
  _controller.jumpToTab(index);
  }


  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      Categories(),
      AddProduct(func: switchPage),
      MessageScreenWrapper(),
      SettingsScreen(),

    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(HeroIcons.home),
        iconSize: 28,
        title: ("Home"),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: secondaryColor,
      ),

      PersistentBottomNavBarItem(
        icon: Icon(HeroIcons.rectangle_group),
        title: ("Categories"),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: secondaryColor,
      ),

      PersistentBottomNavBarItem(
        icon: Icon(LineIcons.plusSquare,size: 28,),
        title: ("add"),
        activeColorPrimary: secondaryColor,
        inactiveColorPrimary: secondaryColor,
      ),

      PersistentBottomNavBarItem(
        icon: Icon(HeroIcons.chat_bubble_left_right),
        title: ("Chat"),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: secondaryColor,
      ),

      PersistentBottomNavBarItem(
        icon: Icon(HeroIcons.user),
        title: ("Profile"),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: secondaryColor,
      ),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        margin: EdgeInsets.all(0),
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor:Colors.grey.shade50, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style12
        // Choose the nav bar style with this property.
      ),
    );

  }
}
