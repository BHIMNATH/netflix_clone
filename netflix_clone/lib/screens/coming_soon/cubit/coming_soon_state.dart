import 'package:equatable/equatable.dart';

import '../../../../data/models/movie_model.dart';

class ComingSoonState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<MovieModel> movies;

  const ComingSoonState({
    this.isLoading = false,
    this.errorMessage,
    this.movies = const [],
  });

  ComingSoonState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<MovieModel>? movies,
  }) {
    return ComingSoonState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      movies: movies ?? this.movies,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, movies];
}
