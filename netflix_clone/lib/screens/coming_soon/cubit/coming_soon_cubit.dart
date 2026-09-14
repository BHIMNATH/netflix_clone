import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repositories/movie_repository.dart';
import 'coming_soon_state.dart';

class ComingSoonCubit extends Cubit<ComingSoonState> {
  final MovieRepository _repository;

  ComingSoonCubit(this._repository) : super(const ComingSoonState());

  Future<void> loadComingSoon() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      debugPrint('LOADING UPCOMING MOVIES');

      final movies = await _repository.getUpcomingMovies();

      debugPrint('UPCOMING RESULTS: ${movies.length}');

      emit(
        state.copyWith(isLoading: false, errorMessage: null, movies: movies),
      );
    } catch (e, stackTrace) {
      debugPrint('COMING SOON ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Unable to load upcoming movies. Please try again.',
        ),
      );
    }
  }

  Future<void> refresh() async {
    await loadComingSoon();
  }
}
