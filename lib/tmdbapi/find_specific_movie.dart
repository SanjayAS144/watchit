import 'package:watched_it/constants.dart';
import 'package:watched_it/networking/networking.dart';

class GetSpecificMovieResults {
  Future<dynamic> getSpecificMovieDetails(String movieId) async {
    NetworkHelper networkHelper = NetworkHelper(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$kApiKey&language=en-US');

    var specificMovieList = await networkHelper.getData();
    return specificMovieList;
  }
}
