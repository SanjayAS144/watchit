import 'package:watched_it/constants.dart';
import 'package:watched_it/networking/networking.dart';

class GetSearchResults {
  Future<dynamic> getSpecificMovieList(String title) async {
    NetworkHelper networkHelper = NetworkHelper(
        'https://api.themoviedb.org/3/search/movie?api_key=$kApiKey&language=en-US&query=$title&page=1&include_adult=true');

    var specificMovieList = await networkHelper.getData();
    return specificMovieList;
  }
}
