import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie2you/app/models/movie_types.dart';
import 'package:movie2you/app/repositories/safe_service_constants.dart';
import 'package:movie2you/app/repositories/services_constants.dart';

class HomeRepository {
  Uri _getTypeUri(String type) => Uri.parse(
        "${ServicesConstants.baseUrl}movie/$type?page=1&language=pt-BR",
      );

  Future<MovieTypes> fetchMoviesType() async {
    try {
      final upcoming = await _fetch("upcoming");
      final nowPlaying = await _fetch("now_playing");
      final popular = await _fetch("popular");
      final topRated = await _fetch("top_rated");

      return MovieTypes(
        upcoming: upcoming,
        nowPlaying: nowPlaying,
        popular: popular,
        topRated: topRated,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map> _fetch(String type) async {
    try {
      final response = await http.get(
        _getTypeUri(type),
        headers: SafeServiceConstants.requestHeader,
      );

      return jsonDecode(response.body);
    } on Exception catch (e) {
      throw Exception("Problema ao consultar filmes. Tente novamente");
    }
  }
}
