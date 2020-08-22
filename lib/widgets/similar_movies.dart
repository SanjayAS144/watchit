import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:watched_it/models/base_model.dart';

import 'movie_info.dart';

class SimilarMovies extends StatefulWidget {
  final String movieId;

  SimilarMovies({this.movieId});

  @override
  _SimilarMoviesState createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends State<SimilarMovies> {
  var movieDetails;
  bool isLoading = true;
  int maxResults = 5;
  List<MakeSimilarCard> moviesList;
  final BaseModel _baseModel = BaseModel();

  getSimilarMovieDetail() async {
    movieDetails = await _baseModel.getSimilarMovieDetails(widget.movieId);
    setState(() {
      getSimilarMoviesList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getSimilarMovieDetail();
  }

  getSimilarMoviesList() {
    moviesList = [];

    if (movieDetails['total_results'] < maxResults)
      maxResults = movieDetails['total_results'];

    for (int i = 0; i < maxResults; i++) {
      moviesList.add(
        MakeSimilarCard(
          movieId: movieDetails['results'][i]['id'].toString(),
          movieName: movieDetails['results'][i]['original_title'].toString(),
          movieImage: movieDetails['results'][i]['poster_path'].toString(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.0,
      child: moviesList == null
          ? Center(child: Text('No Similar Movies'))
          : ListView(
              scrollDirection: Axis.horizontal,
              children: moviesList,
            ),
    );
  }
}

class MakeSimilarCard extends StatelessWidget {
  final String movieId;
  final String movieImage;
  final String movieName;

  MakeSimilarCard({this.movieId, this.movieImage, this.movieName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieInfo(
              movieId: movieId,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            height: 200.0,
            width: 160.0,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: movieImage == null
                  ? AssetImage('assets/images/loader.gif')
                  : Image(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        'https://image.tmdb.org/t/p/w500$movieImage',
                      ),
                    ),
            ),
          ),
          Container(
            height: 200.0,
            width: 160.0,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          Container(
            height: 200.0,
            width: 160.0,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                movieName,
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  letterSpacing: 1.3,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
