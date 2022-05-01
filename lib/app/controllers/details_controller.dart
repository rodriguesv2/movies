import 'package:flutter/material.dart';
import 'package:movie2you/app/repositories/details_repository.dart';

import '../models/details.dart';

enum DetailsState {
  start,
  loading,
  success,
  error,
}

class DetailsController {
  final state = ValueNotifier(DetailsState.start);
  final _repository = DetailsRepository();

  String? _errorMessage;

  String? get errorMessage {
    final message = _errorMessage;
    _errorMessage = null;
    return message;
  }

  Details? details;

  fetch(int movieId) {
    state.value = DetailsState.loading;

    _repository.fetchDetails(movieId).then((value) {
      details = value;
      state.value = DetailsState.success;
    }).catchError((e){
      _errorMessage = e.toString();
      print(e);
      state.value = DetailsState.error;
    });
  }
}