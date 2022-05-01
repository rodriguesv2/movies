import 'package:movie2you/app/repositories/services_constants.dart';

class Details {
  final String backdropPath;
  final String genres;
  final String overview;
  final String posterPath;
  final String runtime;
  final String title;
  final double voteAverage;
  final List<dynamic> _reviews;
  final Map _similar;

  Details(
    this.backdropPath,
    this.genres,
    this.overview,
    this.posterPath,
    this.runtime,
    this.title,
    this.voteAverage,
    this._reviews,
    this._similar,
  );

  List<Map<String, dynamic>> get reviews {
    return _reviews.take(3).map((review) {
      return {
        "author": review["author"],
        "content": review["content"],
      };
    }).toList();
  }

  List<Map> get similar {
    return (_similar["results"] as List<dynamic>).map((movie) {
      return {
        "id": movie["id"],
        "poster": "${ServicesConstants.imageUrl}${movie["poster_path"]}",
        };
    }).toList();
  }
}
