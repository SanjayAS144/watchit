import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watched_it/models/base_model.dart';
import 'package:watched_it/widgets/movie_list.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = true;
  var movieData;
  int maxResults = 10;
  List<MovieList> moviesList = [];
  final BaseModel _baseModel = BaseModel();
  TextEditingController searchController = TextEditingController();

  clearSearch() {
    searchController.clear();
    moviesList = [];
    FocusScope.of(context).unfocus();
  }

  getMovieList() {
    moviesList = [];
    if (movieData['total_results'] < maxResults)
      maxResults = movieData['total_results'];

    for (int i = 0; i < maxResults; i++) {
      moviesList.add(
        MovieList(
          movieId: movieData['results'][i]['id'].toString(),
        ),
      );
    }
  }

  void fetchTempData() async {
    await fetchMovieData();
  }

  getString() {
    String search = searchController.text.replaceAll(' ', '%20');
    return search;
  }

  Future<void> fetchMovieData() async {
    setState(() {
      isLoading = true;
    });
    movieData = await _baseModel.getSearchedMovieList(getString());
    getMovieList();
    setState(() {
      isLoading = false;
    });
    //print(movieData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 30.0,
                  bottom: 20.0,
                ),
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  autofocus: false,
                  controller: searchController,
                  keyboardAppearance: Brightness.dark,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 23.0,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search for a Movie...',
                    hintStyle: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 23.0,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black54,
                      size: 30.0,
                    ),
                    suffixIcon: IconButton(
                      onPressed: clearSearch,
                      icon: Icon(
                        Icons.clear,
                        color: Colors.black54,
                        size: 30.0,
                      ),
                    ),
                  ),
                  onFieldSubmitted: (val) => fetchTempData(),
                ),
              ),
              IconButton(
                onPressed: () => fetchMovieData(),
                icon: Icon(
                  Icons.search,
                  color: Colors.red,
                ),
              ),
              isLoading == true
                  ? Container()
                  : Column(
                      children: moviesList,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
