import 'dart:io';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watched_it/models/user.dart';
import 'package:watched_it/pages/home_screen.dart';
import 'package:watched_it/pages/on_boarding.dart';
import 'package:watched_it/pages/profile_screen.dart';
import 'package:watched_it/pages/search_screen.dart';

import 'create_account.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final StorageReference storageRef = FirebaseStorage.instance.ref();
final usersRef = Firestore.instance.collection('users');
final watchedRef = Firestore.instance.collection('watched');
final toWatchRef = Firestore.instance.collection('toWatch');
final DateTime timestamp = DateTime.now();
User currentUser;

class HomeScreenWithBottomNav extends StatefulWidget {
  @override
  _HomeScreenWithBottomNavState createState() =>
      _HomeScreenWithBottomNavState();
}

class _HomeScreenWithBottomNavState extends State<HomeScreenWithBottomNav> {
  bool isAuth = false;
  int _selectedIndex = 0;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Detects when user signed In
    googleSignIn.onCurrentUserChanged.listen(
      (GoogleSignInAccount account) {
        handleSignIn(account);
      },
      onError: (err) {
        print('Error Signing In: $err');
      },
    );
    // Reauthorise Users when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then(
      (account) {
        handleSignIn(account);
      },
    ).catchError(
      (err) {
        print('Error Signing In: $err');
      },
    );
  }

  handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      await createUserInFirebase();
      setState(() {
        isAuth = true;
      });
      configurePushNotifications();
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  configurePushNotifications() {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    if (Platform.isIOS) getiOSPermissions();

    _firebaseMessaging.getToken().then((token) {
      usersRef
          .document(user.id)
          .updateData({"androidNotificationToken": token});
    });
  }

  getiOSPermissions() {
    _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(alert: true, badge: true, sound: true),
    );
    _firebaseMessaging.onIosSettingsRegistered.listen((event) {});
  }

  createUserInFirebase() async {
    //1. Check if User already exists in the Database (according to their ID)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    if (!doc.exists) {
      //2. If the User doesn't exist take them to the create account page

      final username = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccount(),
        ),
      );

      //3. Get Username from create account, use it to make new user document in users collection
      usersRef.document(user.id).setData(
        {
          'id': user.id,
          'username': username,
          'photoUrl': user.photoUrl,
          'email': user.email,
          'displayName': user.displayName,
          'bio': "",
          "timestamp": timestamp,
        },
      );
      // If not present make an Document and update it.
      doc = await usersRef.document(user.id).get();
    }

    currentUser = User.fromDocument(doc);
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  checkIfFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool checkValue = prefs.containsKey('isFirstRun');

    if (checkValue) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstRun = prefs.getBool('isFirstRun');
      if (isFirstRun == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnBoarding(),
          ),
        );
      } else {
        return;
      }
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isFirstRun', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OnBoarding(),
        ),
      );
    }
  }

  static List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  Scaffold buildAuthScreen() {
    checkIfFirstRun();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: GNav(
              gap: 12,
              activeColor: Colors.white,
              iconSize: 22,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
//                tabBackgroundGradient: LinearGradient(
//                  begin: Alignment.topLeft,
//                  end: Alignment.bottomRight,
//                  colors: [
//                    Colors.redAccent,
//                    Colors.blueAccent,
//                  ],
//                ),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  iconColor: Colors.grey,
                  textColor: Colors.white,
                  curve: Curves.easeInOutCubic,
                  backgroundColor: Color(0xFF8E22A0).withAlpha(100),
                  textStyle: TextStyle(
                    letterSpacing: 1.2,
                    fontSize: 15.0,
                    color: Color(0xFF8E22A0),
//                      shadows: [
//                        BoxShadow(
//                          color: Colors.black38,
//                          offset: Offset(1, 1),
//                          blurRadius: 6,
//                        ),
//                      ],
                    fontFamily: 'MavenPro',
                    fontWeight: FontWeight.w500,
                  ),
                  iconActiveColor: Color(0xFF8E22A0),
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                  iconColor: Colors.grey,
                  curve: Curves.easeInOutCubic,
                  backgroundColor: Color(0xFFDD1B5D).withAlpha(100),
                  textStyle: TextStyle(
                    letterSpacing: 1.2,
                    fontSize: 15.0,
                    color: Color(0xFFDD1B5D),
//                      shadows: [
//                        BoxShadow(
//                          color: Colors.black38,
//                          offset: Offset(1, 1),
//                          blurRadius: 6,
//                        ),
//                      ],
                    fontFamily: 'MavenPro',
                    fontWeight: FontWeight.w500,
                  ),
                  iconActiveColor: Color(0xFFDD1B5D),
                ),
                GButton(
                  leading: Container(
                    height: 23.0,
                    width: 23.0,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(
                          style: BorderStyle.solid,
                          width: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                        image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(currentUser.photoUrl),
                        )),
                  ),
                  backgroundColor: Color(0xFF009184).withAlpha(100),
                  padding: EdgeInsets.only(
                      top: 5.0, left: 13.0, bottom: 5.0, right: 10.0),
                  text: ' Profile',
                  textColor: Colors.white,
                  curve: Curves.easeInOutCubic,
                  textStyle: TextStyle(
                    letterSpacing: 1.2,
                    fontSize: 15.0,
                    color: Color(0xFF009184),
//                      shadows: [
//                        BoxShadow(
//                          color: Colors.black38,
//                          offset: Offset(1, 1),
//                          blurRadius: 6,
//                        ),
//                      ],
                    fontFamily: 'MavenPro',
                    fontWeight: FontWeight.w500,
                  ),
                  iconActiveColor: Color(0xFF009184),
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              }),
        ),
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.95),
              Theme.of(context).accentColor.withOpacity(0.95),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Animator(
              duration: Duration(
                milliseconds: 1000,
              ),
              tween: Tween(
                begin: 0.05,
                end: 1.0,
              ),
              curve: Curves.elasticOut,
              cycles: 0,
              builder: (context, animatorState, child) => Transform.scale(
                scale: animatorState.value,
                child: FittedBox(
                  child: Text(
                    'Watch It.',
                    style: TextStyle(
                      fontFamily: 'GreatVibes',
                      fontSize: 70.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 250.0,
                height: 70.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
