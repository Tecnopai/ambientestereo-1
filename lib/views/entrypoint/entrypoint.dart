import 'package:ambientestereo/views/player/player_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_defaults.dart';
import '../explore/explore_page.dart';
import '../home/home_page/home_page.dart';
import '../saved/saved_page.dart';
import '../settings/settings_page.dart';

class EntryPointUI extends StatefulWidget {
  const EntryPointUI({Key? key}) : super(key: key);

  @override
  State<EntryPointUI> createState() => _EntryPointUIState();
}

class _EntryPointUIState extends State<EntryPointUI> {
  late PageController _controller;

  int _selectedIndex = 0;

  onTabTap(int index) {
    _controller.animateToPage(
      index,
      duration: AppDefaults.duration,
      curve: Curves.ease,
    );
    _selectedIndex = index;
    setState(() {});
  }

  final screens = const [
    HomePage(),
    ExplorePage(),
    SavedPage(),
    SettingsPage(),
  ];

  Future<bool> _onPop() async {
    int currentPage = _controller.page?.round() ?? 0;
    if (currentPage != 0) {
      _controller.animateToPage(0,
          duration: AppDefaults.duration, curve: Curves.ease);
      _selectedIndex = 0;
      setState(() {});
      return false;
    } else {
      await SystemNavigator.pop();
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onPop,
      child: Scaffold(
        body: PageView(
          allowImplicitScrolling: false,
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: screens,
        ),
        bottomNavigationBar:
          buildMyNavBar(context),
        //backgroundColor: const Color(0x00ffffff),
        extendBodyBehindAppBar: true,
        extendBody: true,
      
      ),
    );
  }



Container buildMyNavBar(BuildContext context) {

    final navbarItems = [
      GButton(icon: IconlyLight.home, text: 'home'.tr()),
      GButton(icon: IconlyLight.category, text: 'explore'.tr()),
      GButton(icon: IconlyLight.heart, text: 'saved'.tr()),
      GButton(icon: IconlyLight.profile, text: 'settings'.tr()),
    ];

    return 
    Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color.fromARGB(166, 0, 0, 0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(70),
          topRight: Radius.circular(70),
        ),
      ),
      child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 1),
              const MyApp(),
              GNav(
                        rippleColor: AppColors.primary.withOpacity(0.3),
                        hoverColor: Colors.grey.shade700,
                        haptic: true, // haptic feedback
                        tabBorderRadius: AppDefaults.radius,
                        curve: Curves.easeIn, // tab animation curves
                        duration: AppDefaults.duration, // tab animation duration
                        gap: 8,
                        padding: const EdgeInsets.all(AppDefaults.padding),
                        color: Colors.grey.withOpacity(0.8), // unselected icon color
                        activeColor: Colors.white, // selected icon and text color
                        iconSize: 24, // tab button icon size
                        //tabBackgroundColor: AppColors.primary.withOpacity(0.1),
                        //backgroundColor: const Color(0x00ffffff),
                        tabs: navbarItems,
                        onTabChange: onTabTap,
                        selectedIndex: _selectedIndex,
                      ),
            ]
          )
    );

}



}



