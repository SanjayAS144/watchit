import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:watched_it/models/base_model.dart';
import 'package:watched_it/widgets/movie_info.dart';
import 'package:watched_it/widgets/progress.dart';

class MovieList extends StatefulWidget {
  final String movieId;

  MovieList({this.movieId});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  bool isLoading = true;
  var movieDetails;
  final BaseModel _baseModel = BaseModel();

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

  @override
  void initState() {
    super.initState();
    getMovieDetail();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return isLoading == true
        ? circularProgress3()
        : InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieInfo(
                    movieId: movieDetails['id'].toString(),
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10.0),
              height: mediaQuery.height * 0.28,
              width: mediaQuery.width,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    height: mediaQuery.height * 0.22,
                    width: mediaQuery.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: mediaQuery.width * 0.40,
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movieDetails['original_title'].toString(),
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'MavenPro',
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                movieDetails['release_date'].toString() == ''
                                    ? 'Unknown'
                                    : movieDetails['release_date']
                                        .toString()
                                        .substring(0, 4),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'MavenPro',
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                movieDetails['overview'].toString(),
                                maxLines: 3,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 10.0,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 10.0,
                      bottom: 15.0,
                    ),
                    height: mediaQuery.height * 0.25,
                    width: mediaQuery.width * 0.35,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FadeInImage(
                        placeholder: AssetImage('assets/images/loader.gif'),
                        fit: BoxFit.cover,
                        image: getImage(),
                      ),
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
