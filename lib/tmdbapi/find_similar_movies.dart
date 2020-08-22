import 'package:watched_it/constants.dart';
import 'package:watched_it/networking/networking.dart';

class GetSimilarMovies {
  Future<dynamic> getSimilarMovieDetails(String movieId) async {
    NetworkHelper networkHelper = NetworkHelper(
        'https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$kApiKey&language=en-US&page=1');

    var similarMovieList = await networkHelper.getData();
    return similarMovieList;
  }
}
