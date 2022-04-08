import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:my_cat_api_clone/pages/category_page.dart';
import 'package:my_cat_api_clone/pages/home_page.dart';
import 'package:my_cat_api_clone/pages/profile_page.dart';
import 'package:my_cat_api_clone/pages/search_page.dart';
import 'package:my_cat_api_clone/utils/glow_widget.dart';
import '../services/log_service.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);
  static const String id = "control_page";

  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final PageController _pageController = PageController();
  int selectedPage = 0;
  DateTime? currentBackPressTime;
  bool isOffline = false;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
    _pageController.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      Log.e(
        "Couldn't check connectivity status",
      );
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
    if (_connectionStatus == ConnectivityResult.none) {
      setState(() {
        isOffline = true;
      });
    } else {
      setState(() {
        isOffline = false;
        selectedPage = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: (isOffline)
          ? Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Lottie.asset('assets/anims/no_internet.json',
                      width: 100)),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              body: Glow(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    HomePage(),
                    SearchPage(),
                    CategoryPage(),
                    ProfilePage()
                  ],
                ),
              ),
              bottomNavigationBar: buildBottomNavigationBar(),
            ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      fixedColor: Colors.black,
      selectedFontSize: 14,
      currentIndex: selectedPage,
      onTap: (index) {
        setState(() {
          _pageController.jumpToPage(index);
          selectedPage = index;
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image(
              color: (selectedPage == 0) ? Colors.black : null,
              width: 25,
              height: 25,
              image: const AssetImage('assets/icons/ic_home.png')),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Image(
              color: (selectedPage == 1) ? Colors.black : null,
              width: 25,
              height: 25,
              image: const AssetImage('assets/icons/ic_search.png')),
          label: "Search",
        ),
        const BottomNavigationBarItem(
          icon: Image(
              // color : (selectedPage ==2) ? Colors.black : null,
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/icons/ic_cat2.png',
              )),
          label: "Categories",
        ),
        BottomNavigationBarItem(
          icon: Image(
              color: (selectedPage == 3) ? Colors.black : Colors.grey.shade700,
              width: 25,
              height: 25,
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/icons/ic_account.png',
              )),
          label: "Account",
        ),
      ],
    );
  }

  /// Will pop
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      setState(() {
        currentBackPressTime = now;
      });

      return Future.value(false);
    }
    return Future.value(true);
  }
}
