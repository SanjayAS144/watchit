import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watched_it/pages/home_screen_with_bottom_nav.dart';
import 'package:watched_it/widgets/movie_list.dart';
import 'package:watched_it/widgets/progress.dart';

class ToWatchScreen extends StatefulWidget {
  @override
  _ToWatchScreenState createState() => _ToWatchScreenState();
}

class _ToWatchScreenState extends State<ToWatchScreen> {
  List<MovieList> moviesList;

  getTimeline() async {
    QuerySnapshot snapshot = await toWatchRef
        .document(currentUser.id)
        .collection('toWatchMovies')
        .getDocuments();

    List<MovieList> moviesListTemp = [];

    snapshot.documents.forEach((element) {
      moviesListTemp.add(MovieList(
        movieId: element['id'].toString(),
      ));
    });

    setState(() {
      moviesList = moviesListTemp;
    });
  }

  buildTimeline() {
    if (moviesList == null) {
      return circularProgress();
    } else if (moviesList.isEmpty) {
      return Center(
        child: Text(
          'Everything Looks so Empty',
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.black87,
            letterSpacing: 2,
            fontFamily: 'GreatVibes',
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
