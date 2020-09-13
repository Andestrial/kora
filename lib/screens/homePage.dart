import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/resources/styles/customNavBar.dart';
import 'package:kora/domain/user.dart';
import 'package:kora/resources/fonts/my_flutter_app_icons.dart';
import 'package:kora/screens/MainScreen.dart';
import 'package:kora/screens/addAndUpdateAdScreen.dart';
import 'package:kora/screens/favoriteScreen.dart';
import 'package:kora/screens/myAdsScreen.dart';
import 'package:kora/screens/profileScreen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
 HomePage({Key key}) : super(key: key);

  @override
   HomePageState createState() =>  HomePageState();
}

class  HomePageState extends State <HomePage>{
  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    List<Widget> _buildScreens = [
      MainScreen(),
      MyAdsScreen(userId: user.id),
      null,
      FavoriteScreen(userId: user.id,),
      ProfileScreen(),
    ];

    List<PersistentBottomNavBarItem> _navBarItems = <PersistentBottomNavBarItem> [
      PersistentBottomNavBarItem(
          icon: Icon(CustomIcons.home,size: 25),
          activeColor: blueColor,
          inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
          icon: Icon(CustomIcons.sneacker, size: 25),
          activeColor: blueColor,
          inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.add),
          activeColor: Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => AddAndUpdateAdScreen()));
          }
      ),
      PersistentBottomNavBarItem(
          icon: Icon(CustomIcons.favorite, size: 25),
          activeColor: blueColor,
          inactiveColor: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
          icon: Icon(CustomIcons.settings, size: 25),
          activeColor: blueColor,
          inactiveColor: CupertinoColors.systemGrey,
      ),
    ];

    return PersistentTabView(
      controller: _controller,
      itemCount: _navBarItems.length,
      items: _navBarItems,
      screens: _buildScreens,
      confineInSafeArea: true,
      handleAndroidBackButtonPress: true,
      onItemSelected: (int) {
        setState(() {});
      },
      customWidget: CustomNavBar(
        selectedIndex: _controller.index,
        popScreensOnTapOfSelectedTab: false,
        iconSize: 35,
        backgroundColor: Color.fromRGBO(80,80,81, 1),
        items: _navBarItems,
        onItemSelected: (index) {
          setState(() {
            _controller.index = index;
          });
        },
      ),
      navBarStyle: NavBarStyle.custom
    );
  } 
}