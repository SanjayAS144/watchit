import 'package:watched_it/tmdbapi/fetch_search_results.dart';
import 'package:watched_it/tmdbapi/find_similar_movies.dart';
import 'package:watched_it/tmdbapi/find_specific_movie.dart';

class BaseModel {
  Future<dynamic> getSearchedMovieList(String title) async {
    GetSearchResults getSearchResults = GetSearchResults();
    return await getSearchResults.getSpecificMovieList(title);
  }

  Future<dynamic> getSpecificMovieDetails(String movieId) async {
    GetSpecificMovieResults getSearchResults = GetSpecificMovieResults();
    return await getSearchResults.getSpecificMovieDetails(movieId);
  }

  Future<dynamic> getSimilarMovieDetails(String movieId) async {
    GetSimilarMovies getSearchResults = GetSimilarMovies();
    return await getSearchResults.getSimilarMovieDetails(movieId);
  }
}
