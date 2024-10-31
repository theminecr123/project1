import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:project1/config/globals.dart';
import 'package:project1/ui/cart_page.dart';
import 'package:project1/ui/home_page.dart';
import 'package:project1/intro_pages/intro_page2.dart';
import 'package:project1/ui/profile_page.dart';


class MainLayout extends StatelessWidget {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => HomePage(),
          );
        },
      ),
      Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => IntroPage2(),
          );
        },
      ),
      Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => CartPage(),

          );
        },
      ),
      Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => ProfilePage(),
          );
        },
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: "Search",
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_bag_outlined),
        title: "Cart",
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_outline),
        title: "Profile",
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: globalTabController,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarStyle: NavBarStyle.style12, // Choose the style you need
      ),
    );
  }
}
