import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watched_it/models/user.dart';
import 'package:watched_it/pages/edit_profile.dart';
import 'package:watched_it/pages/home_screen_with_bottom_nav.dart';
import 'package:watched_it/widgets/progress.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int toWatchCount = 0;
  int watchedCount = 0;

  @override
  void initState() {
    super.initState();
    getToWatchNumber();
    getWatchedNumber();
  }

  getToWatchNumber() async {
    QuerySnapshot snapshot = await toWatchRef
        .document(currentUser.id)
        .collection('toWatchMovies')
        .getDocuments();

    setState(() {
      toWatchCount = snapshot.documents.length;
    });
  }

  getWatchedNumber() async {
    QuerySnapshot snapshot = await watchedRef
        .document(currentUser.id)
        .collection('watchedMovies')
        .getDocuments();

    setState(() {
      watchedCount = snapshot.documents.length;
    });
  }

  buildProfileButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfile(),
          ),
        );
      },
      child: Container(
        height: 50.0,
        width: 180.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor,
            ],
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            'Edit Profile',
            style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Mukta',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 19.0,
            fontFamily: 'Mukta',
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        Container(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13.0,
              letterSpacing: 2,
              fontFamily: 'Mukta',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  buildProfileHeader() {
    return FutureBuilder(
      future: usersRef.document(currentUser.id).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: CircleAvatar(
                      radius: 52.0,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              CachedNetworkImageProvider(user.photoUrl),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Text(
                            user.username,
                            style: TextStyle(
                              fontFamily: 'Caveat',
                              fontSize: 25.0,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            user.displayName,
                            style: TextStyle(
                              fontSize: 13.0,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Text(
                            user.bio,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Mukta',
                              wordSpacing: 1,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(19.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Divider(
                      height: 2,
                      color: Colors.black54,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          buildCountColumn('To Watch', toWatchCount),
                          buildCountColumn('Watched', watchedCount),
                        ],
                      ),
                    ),
                    Divider(
                      height: 2,
                      color: Colors.black54,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildProfileButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser.username),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          buildProfileHeader(),
        ],
      ),
    );
  }
}
