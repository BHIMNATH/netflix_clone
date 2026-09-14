import 'package:equatable/equatable.dart';

import '../../../../data/models/movie_model.dart';

class SearchState extends Equatable {
  final String query;
  final bool isLoading;
  final String? errorMessage;
  final List<MovieModel> movies;

  const SearchState({
    this.query = '',
    this.isLoading = false,
    this.errorMessage,
    this.movies = const [],
  });

  SearchState copyWith({
    String? query,
    bool? isLoading,
    String? errorMessage,
    List<MovieModel>? movies,
  }) {
    return SearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      movies: movies ?? this.movies,
    );
  }

  @override
  List<Object?> get props => [query, isLoading, errorMessage, movies];
}
