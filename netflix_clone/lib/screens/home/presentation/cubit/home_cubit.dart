import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repositories/movie_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MovieRepository _repository;

  HomeCubit(this._repository) : super(const HomeState());

  Future<void> loadHome() async {
    debugPrint('HOME LOAD STARTED');

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final results = await Future.wait([
        _repository.getTrendingMovies(),
        _repository.getPopularMovies(),
        _repository.getNowPlayingMovies(),
        _repository.getTopRatedMovies(),
      ]);

      final trending = results[0];
      final popular = results[1];
      final nowPlaying = results[2];
      final topRated = results[3];

      debugPrint('Trending: ${trending.length}');
      debugPrint('Popular: ${popular.length}');
      debugPrint('Now Playing: ${nowPlaying.length}');
      debugPrint('Top Rated: ${topRated.length}');

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: null,
          trendingMovies: trending,
          popularMovies: popular,
          nowPlayingMovies: nowPlaying,
          topRatedMovies: topRated,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('HOME ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Unable to load movies. Please try again.',
        ),
      );
    }
  }

  Future<void> refresh() async {
    await loadHome();
  }
}
