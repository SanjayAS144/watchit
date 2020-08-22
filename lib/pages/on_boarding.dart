import 'package:flutter/material.dart';
import 'package:sk_onboarding_screen/sk_onboarding_model.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';
import 'package:watched_it/pages/home_screen_with_bottom_nav.dart';

class OnBoarding extends StatelessWidget {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: SKOnboardingScreen(
        bgColor: Colors.white,
        themeColor: Theme.of(context).primaryColor,
        pages: pages,
        skipClicked: (value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreenWithBottomNav(),
            ),
          );
        },
        getStartedClicked: (value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreenWithBottomNav(),
            ),
          );
        },
      ),
    );
  }

  final pages = [
    SkOnboardingModel(
        title: 'Wanna watch a Movie ?',
        description:
            'Do want to remember a movie\'s name ? We got you covered now...Just Netflix n Chill',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/cinema.png'),
    SkOnboardingModel(
        title: 'Did you see it ?',
        description:
            'List all the movies you have ever watched, and never forget again',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/watching-tv.png'),
    SkOnboardingModel(
        title: 'Search a Movie',
        description:
            'Search from 100000+ movies worldwide, search all the movies you\'ve watched',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/search.png'),
    SkOnboardingModel(
        title: 'Realtime Database',
        description: 'With our high-end Database your Data is Secure than ever',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/images/server.png'),
  ];
}
