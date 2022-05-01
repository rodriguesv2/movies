import '../repositories/services_constants.dart';

class MovieTypes {
  List<Map> upcoming = [];
  List<Map> nowPlaying = [];
  List<Map> popular = [];
  List<Map> topRated = [];

  MovieTypes({
    required Map upcoming,
    required Map nowPlaying,
    required Map popular,
    required Map topRated,
  }) {
    if(upcoming["results"].isEmpty) return;

    this.upcoming = _movieMap(upcoming["results"] as List<dynamic>);
    this.nowPlaying = _movieMap(nowPlaying["results"] as List<dynamic>);
    this.popular = _movieMap(popular["results"] as List<dynamic>);
    this.topRated = _movieMap(topRated["results"] as List<dynamic>);
  }

  static List<Map> _movieMap(List<dynamic> completeMovieList) {
    return completeMovieList.map((movie) {
      return {
        "id": movie["id"],
        "poster": "${ServicesConstants.imageUrl}${movie["poster_path"]}",
      };
    }).toList();
  }
}
