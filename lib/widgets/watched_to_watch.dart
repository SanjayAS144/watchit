import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watched_it/models/base_model.dart';
import 'package:watched_it/pages/home_screen_with_bottom_nav.dart';

class MovieActions extends StatefulWidget {
  final String movieId;

  MovieActions({this.movieId});

  @override
  _MovieActionsState createState() => _MovieActionsState(movieId: movieId);
}

class _MovieActionsState extends State<MovieActions> {
  int actionType = 0;
  var movieDetails;
  final String movieId;
  final BaseModel _baseModel = BaseModel();
  final format = NumberFormat.compact(locale: 'en_US');

  _MovieActionsState({this.movieId});

  getMovieDetail() async {
    movieDetails = await _baseModel.getSpecificMovieDetails(widget.movieId);
    print('Done');
  }

  Row buildAction() {
    if (actionType == 0) {
      return Row(
        children: [
          ButtonAction(
            title: 'Watch',
            shouldFill: true,
            onTap: () => addToWatch(),
          ),
          ButtonAction(
            title: 'Watched',
            shouldFill: true,
            onTap: () => addWatched(),
          ),
        ],
      );
    } else if (actionType == 1) {
      return Row(
        children: [
          ButtonAction(
            title: 'Watch',
            shouldFill: true,
            onTap: () => addToWatch(),
          ),
          ButtonAction(
            title: 'Delete',
            shouldFill: false,
            onTap: () => deleteWatched(),
          ),
        ],
      );
    } else if (actionType == 2) {
      return Row(
        children: [
          ButtonAction(
            title: 'Watched',
            shouldFill: true,
            onTap: () => addWatched(),
          ),
          ButtonAction(
            title: 'Delete',
            shouldFill: false,
            onTap: () => deleteToWatch(),
          ),
        ],
      );
    }
  }

  initializeActions() {
    Future<DocumentSnapshot> watched = watchedRef
        .document(currentUser.id)
        .collection('watchedMovies')
        .document(movieId)
        .get();

    Future<DocumentSnapshot> toWatch = toWatchRef
        .document(currentUser.id)
        .collection('toWatchMovies')
        .document(movieId)
        .get();

    watched.then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          print('Watched');
          actionType = 1;
        });
      }
    });

    toWatch.then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          print('To Watch');
          actionType = 2;
        });
      }
    });
  }

  addWatched() {
    watchedRef
        .document(currentUser.id)
        .collection('watchedMovies')
        .document(movieId)
        .setData(
      {
        'id': movieDetails['id'],
        'name': movieDetails['original_title'],
        'image': movieDetails['poster_path'],
        'synopsis': movieDetails['overview'],
        'budget': movieDetails['budget'],
        'revenue': movieDetails['revenue'],
        'releaseDate': movieDetails['release_date'],
        'runTime': movieDetails['runtime'],
      },
    );

    toWatchRef
        .document(currentUser.id)
        .collection('toWatchMovies')
        .document(movieId)
        .delete();

    setState(() {
      actionType = 1;
    });
  }

  addToWatch() {
    toWatchRef
        .document(currentUser.id)
        .collection('toWatchMovies')
        .document(movieId)
        .setData(
      {
        'id': movieDetails['id'],
        'name': movieDetails['original_title'],
        'image': movieDetails['poster_path'],
        'synopsis': movieDetails['overview'],
        'budget': movieDetails['budget'],
        'revenue': movieDetails['revenue'],
        'releaseDate': movieDetails['release_date'],
        'runTime': movieDetails['runtime'],
      },
    );

    watchedRef
        .document(currentUser.id)
        .collection('watchedMovies')
        .document(movieId)
        .delete();

    setState(() {
      actionType = 2;
    });
  }

  deleteWatched() {
    watchedRef
        .document(currentUser.id)
        .collection('watchedMovies')
        .document(movieId)
        .delete();

    setState(() {
      actionType = 0;
    });
  }

  deleteToWatch() {
    toWatchRef
        .document(currentUser.id)
        .collection('toWatchMovies')
        .document(movieId)
        .delete();

    setState(() {
      actionType = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeActions();
    getMovieDetail();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Container(
      width: mediaQuery.width,
      child: buildAction(),
    );
  }
}

class ButtonAction extends StatelessWidget {
  final String title;
  final bool shouldFill;
  final Function onTap;

  ButtonAction({this.title, this.shouldFill, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 60.0,
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: shouldFill == true ? Colors.red : Colors.white,
            border: Border.all(
              color: shouldFill == true ? Colors.black : Colors.redAccent,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 30.0,
                color: shouldFill == true ? Colors.white : Colors.black,
                letterSpacing: 2,
                fontFamily: 'MavenPro',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
