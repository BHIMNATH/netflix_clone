import 'package:equatable/equatable.dart';

import '../../../../data/models/movie_model.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  final List<MovieModel> trendingMovies;
  final List<MovieModel> popularMovies;
  final List<MovieModel> nowPlayingMovies;
  final List<MovieModel> topRatedMovies;

  const HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.trendingMovies = const [],
    this.popularMovies = const [],
    this.nowPlayingMovies = const [],
    this.topRatedMovies = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<MovieModel>? trendingMovies,
    List<MovieModel>? popularMovies,
    List<MovieModel>? nowPlayingMovies,
    List<MovieModel>? topRatedMovies,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    trendingMovies,
    popularMovies,
    nowPlayingMovies,
    topRatedMovies,
  ];
}
