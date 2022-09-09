import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocmem/config/size_config.dart';
import 'package:pocmem/constants/colors/color.dart';
import 'package:pocmem/models/user.dart';
import 'package:pocmem/screens/home/add_memory.dart';
import 'package:pocmem/screens/home/memory_book.dart';
import 'package:pocmem/screens/home/plan_screen/add_plan.dart';
import 'package:pocmem/screens/home/plan_screen/plan_screen.dart';
import 'package:pocmem/screens/home/profile_screen.dart';
import 'package:pocmem/services/auth.dart';
import 'package:pocmem/services/database.dart';
import 'package:provider/provider.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../constants/class/hero_dialog.dart';
import 'home_screen.dart';
import 'media_screen.dart';
import 'plan_screen/add_plan.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();
  int? _selectedIndex = 0;
  Widget _selectedWidget = const HomeScreen();
  Map<String, dynamic> _userInfo = ({});
  Map<String, dynamic> _bookInfo = ({});
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final _user = Provider.of<UserModel?>(context);
    Database().usersRef.doc(_user!.uid).get().then((DocumentSnapshot ds) {
      setState(() {
        _userInfo = ds.data() as Map<String, dynamic>;
      });
    });
    Database()
        .memoryBookRef
        .doc(_user.uid)
        .get()
        .then((DocumentSnapshot ds) => {
              setState(() {
                _bookInfo = ds.data() as Map<String, dynamic>;
              })
            });
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: AppBar(
          title: const Center(
            child: Text("POCMEM"),
          ),
          leading: IconButton(
            onPressed: () {
              _authService.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MemoryBook(userInfo: _userInfo, bookInfo: _bookInfo)),
                );
              },
              icon: const Icon(Icons.book_rounded),
            ),
            /*IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
            )*/
          ],
          backgroundColor: homeAppBarBackgroundColor,
          shadowColor: darkColor,
        ),
        body: _selectedWidget,
        bottomNavigationBar: StylishBottomBar(
          items: [
            AnimatedBarItems(
              icon: const Icon(
                Icons.home,
              ),
              title: const Text("Home"),
              selectedColor: homeBottomBarSelectedColor,
              unSelectedColor: homeBottomBarUnselectedColor,
            ),
            AnimatedBarItems(
              icon: const Icon(
                Icons.photo_library,
              ),
              title: const Text("Media"),
              selectedColor: homeBottomBarSelectedColor,
              unSelectedColor: homeBottomBarUnselectedColor,
            ),
            AnimatedBarItems(
              icon: const Icon(
                Icons.library_add_check,
              ),
              title: const Text("Plans"),
              selectedColor: homeBottomBarSelectedColor,
              unSelectedColor: homeBottomBarUnselectedColor,
            ),
            AnimatedBarItems(
              icon: const Icon(
                Icons.person_rounded,
              ),
              title: const Text("Profile"),
              selectedColor: homeBottomBarSelectedColor,
              unSelectedColor: homeBottomBarUnselectedColor,
            )
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              itemOnPressed(_selectedIndex);
            });
          },
          iconStyle: IconStyle.animated,
          barAnimation: BarAnimation.transform3D,
          hasNotch: true,
          opacity: 0.3,
          backgroundColor: homeBottomBarBackgroundColor,
          iconSize: SizeConfig.defaultSize * 10.5,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _selectedIndex == 2
                ? Navigator.pushNamed(context, "/add_plan")
                : Navigator.pushNamed(context, "/add_memory");
          },
          backgroundColor: homeBottomBarSelectedColor,
          child: _selectedIndex == 2
              ? const Icon(Icons.library_add_outlined)
              : const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  void itemOnPressed(index) {
    setState(
      () {
        if (index == 0) {
          _selectedWidget = const HomeScreen();
        } else if (index == 1) {
          _selectedWidget = const MediaScreen();
        } else if (index == 2) {
          _selectedWidget = const PlanScreen();
        } else if (index == 3) {
          _selectedWidget = ProfileScreen(
            userInfo: _userInfo,
          );
        }
      },
    );
  }
}
