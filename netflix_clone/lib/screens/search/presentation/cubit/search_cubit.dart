import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repositories/movie_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MovieRepository _repository;

  Timer? _debounce;

  SearchCubit(this._repository) : super(const SearchState());

  void onQueryChanged(String query) {
    emit(state.copyWith(query: query, errorMessage: null, movies: const []));

    _debounce?.cancel();

    if (query.trim().isEmpty) {
      emit(state.copyWith(isLoading: false, movies: const []));
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      searchMovies(query.trim());
    });
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) return;

    emit(state.copyWith(isLoading: true, errorMessage: null, movies: const []));

    try {
      debugPrint('SEARCH: $query');

      final movies = await _repository.searchMovies(query);

      debugPrint('SEARCH RESULTS: ${movies.length}');

      emit(
        state.copyWith(isLoading: false, errorMessage: null, movies: movies),
      );
    } catch (e, stackTrace) {
      debugPrint('SEARCH ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Unable to search movies. Please try again.',
          movies: const [],
        ),
      );
    }
  }

  void clearSearch() {
    _debounce?.cancel();

    emit(const SearchState());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
