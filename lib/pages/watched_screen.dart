import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watched_it/widgets/movie_list.dart';
import 'package:watched_it/widgets/progress.dart';

import 'home_screen_with_bottom_nav.dart';

class WatchedScreen extends StatefulWidget {
  @override
  _WatchedScreenState createState() => _WatchedScreenState();
}

class _WatchedScreenState extends State<WatchedScreen> {
  List<MovieList> moviesList;

  getTimeline() async {
    QuerySnapshot snapshot = await watchedRef
        .document(currentUser.id)
        .collection('watchedMovies')
        .getDocuments();

    List<MovieList> moviesListTemp = [];

    snapshot.documents.forEach((element) {
      moviesListTemp.add(MovieList(
        movieId: element['id'].toString(),
      ));
    });

    setState(() {
      print(moviesListTemp);
      moviesList = moviesListTemp;
    });
  }

  buildTimeline() {
    if (moviesList == null) {
      return circularProgress();
    } else if (moviesList.isEmpty) {
      return Center(
        child: FittedBox(
          child: Text(
            'Everything Looks so Empty',
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.black87,
              letterSpacing: 2,
              fontFamily: 'GreatVibes',
            ),
          ),
        ),
      );
    } else {
      return ListView(
        children: moviesList,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getTimeline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => getTimeline(),
        child: buildTimeline(),
        color: Theme.of(context).primaryColor,
        strokeWidth: 3,
        backgroundColor: Colors.white,
      ),
    );
  }
}
