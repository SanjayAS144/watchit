import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watched_it/models/base_model.dart';
import 'package:watched_it/widgets/progress.dart';
import 'package:watched_it/widgets/similar_movies.dart';
import 'package:watched_it/widgets/stats_grid.dart';
import 'package:watched_it/widgets/watched_to_watch.dart';

class MovieInfo extends StatefulWidget {
  final String movieId;

  MovieInfo({this.movieId});

  @override
  _MovieInfoState createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  bool isLoading = true;
  var movieDetails;
  ScrollController _scrollController;
  final BaseModel _baseModel = BaseModel();
  final format = NumberFormat.compact(locale: 'en_US');

  getMovieDetail() async {
    movieDetails = await _baseModel.getSpecificMovieDetails(widget.movieId);
    setState(() {
      isLoading = false;
    });
  }

  getImage() {
    if (movieDetails['poster_path'] == null) {
      return AssetImage('assets/images/loader.gif');
    }

    return CachedNetworkImageProvider(
        'https://image.tmdb.org/t/p/w500${movieDetails['poster_path'].toString()}');
  }

  getMapData() {
    Map<String, String> movieData = {
      'release': movieDetails['release_date'].toString(),
      'runTime': movieDetails['runtime'].toString(),
      'revenue': format.format(movieDetails['revenue']).toString(),
      'budget': format.format(movieDetails['budget']).toString(),
    };

    return movieData;
  }

  @override
  void initState() {
    super.initState();
    getMovieDetail();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//              builder: (context) => HomeScreenWithBottomNav(),
//            ),
//          );
//        },
//        splashColor: Colors.yellowAccent,
//        elevation: 6.0,
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(5.0),
//        ),
//        child: Icon(
//          Icons.home,
//          color: Colors.white,
//        ),
//      ),
      body: isLoading == true
          ? circularProgress3()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: getImage(),
                          ),
                        ),
                        height: mediaQuery.height * 0.65,
                      ),
                      Container(
                        height: mediaQuery.height * 0.65,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.white54.withOpacity(0.0),
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.4),
                              Colors.white.withOpacity(0.6),
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(1),
                            ],
                            stops: [0.0, 0.5, 0.6, 0.8, 0.9, 1.0],
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 50.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: mediaQuery.height * 0.35,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        FittedBox(
                          child: Text(
                            movieDetails['original_title'].toString(),
                            maxLines: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 45.0,
                              letterSpacing: 1.3,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          movieDetails['release_date'].toString() == ''
                              ? 'Unknown'
                              : movieDetails['release_date']
                                  .toString()
                                  .substring(0, 4),
                          style: TextStyle(
                            fontSize: 16.0,
                            letterSpacing: 1.5,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          child: MovieActions(
                            movieId: widget.movieId,
                          ),
                        ),
//                    CircleAvatar(
//                      radius: 30.0,
//                      backgroundColor: Theme.of(context).primaryColor,
//                      child: Icon(
//                        Icons.play_arrow,
//                        size: 35.0,
//                        color: Colors.white,
//                      ),
//                    ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _scrollController.animateTo(
                                  mediaQuery.height * 0.60,
                                  duration: Duration(milliseconds: 800),
                                  curve: Curves.decelerate);
                            });
                          },
                          child: Column(
                            children: [
                              Text('More',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    letterSpacing: 1.5,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300,
                                  )),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 30.0, bottom: 15.0),
                        child: Text(
                          'Synopsis',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'MavenPro',
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      movieDetails['overview'].toString(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Raleway',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: StatsGrid(getMapData()),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      'Similar Movies',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'MavenPro',
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SimilarMovies(
                    movieId: widget.movieId,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              ),
            ),
    );
  }
}
