import 'package:flutter/material.dart';
import 'package:movie2you/app/models/movie_types.dart';
import 'package:movie2you/app/repositories/home_repository.dart';

enum HomeState {
  start,
  loading,
  success,
  error,
}

class HomeController {
  final state = ValueNotifier(HomeState.start);
  final repository = HomeRepository();

  String? _errorMessage;

  String? get errorMessage {
    final message = _errorMessage;
    _errorMessage = null;
    return message;
  }

  var movieTypes = MovieTypes(
    upcoming: {"results": []},
    nowPlaying: {"results": []},
    popular: {"results": []},
    topRated: {"results": []},
  );

  fetch() {
    state.value = HomeState.loading;

    repository.fetchMoviesType().then((value) {
      movieTypes = value;
      state.value = HomeState.success;
    }).catchError((e) {
      _errorMessage = e.toString();
      state.value = HomeState.error;
    });
  }
}
