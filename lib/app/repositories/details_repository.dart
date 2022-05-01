import 'dart:convert';

import 'package:movie2you/app/models/details.dart';
import 'package:movie2you/app/repositories/safe_service_constants.dart';
import 'package:movie2you/app/repositories/services_constants.dart';
import 'package:http/http.dart' as http;

class DetailsRepository {
  Uri _getFormattedUri(int movieId, {String type = ""}) => Uri.parse(
      "${ServicesConstants.baseUrl}movie/$movieId$type?${type != "/reviews" ? "language=pt-BR" : ""}");

  Future<Details> fetchDetails(int movieId) async {
    try {
      final detailsResponse = await http.get(
        _getFormattedUri(movieId),
        headers: SafeServiceConstants.requestHeader,
      );
      final similarResponse = await http.get(
        _getFormattedUri(movieId, type: "/similar"),
        headers: SafeServiceConstants.requestHeader,
      );
      final reviewsResponse = await http.get(
        _getFormattedUri(movieId, type: "/reviews"),
        headers: SafeServiceConstants.requestHeader,
      );

      final details = jsonDecode(detailsResponse.body);
      final similar = jsonDecode(similarResponse.body);
      final reviews = jsonDecode(reviewsResponse.body);

      print(reviews);

      final List<String> genres =
          (details["genres"] as List<dynamic>).map((genre) {
        return genre["name"].toString();
      }).toList();

      return Details(
        "${ServicesConstants.imageUrl}${details["backdrop_path"]}",
        genres.stringfyGenreList(),
        details["overview"],
        "${ServicesConstants.imageUrl}${details["poster_path"]}",
        _convertMinutesToNamedTime(details["runtime"]),
        details["title"],
        details["vote_average"],
        reviews["results"],
        similar,
      );
    } catch (e) {
      throw Exception("Houve um erro ao busca os detalhes do filme");
    }
  }

  String _convertMinutesToNamedTime(int minutes) {
    final int hours = minutes ~/ 60;
    final int newMinutes = minutes % 60;

    return "$hours hora(s) $newMinutes minutos(s)";
  }
}

extension Genres on List<String> {
  String stringfyGenreList() {
    const dot = " • ";
    String result = "";

    forEach((genre) {
      if (result.isNotEmpty) result += dot;
      result += genre;
    });

    return result;
  }
}
