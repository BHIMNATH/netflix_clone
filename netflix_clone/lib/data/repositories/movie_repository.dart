import 'package:netflix_clone/data/models/movie_model.dart';
import 'package:netflix_clone/data/services/movie_api_service.dart';

class MovieRepository {
  final MovieApiService _apiService;

  MovieRepository(this._apiService);

  Future<List<MovieModel>> getTrendingMovies() async {
    return await _apiService.getTrendingMovies();
  }

  Future<List<MovieModel>> getPopularMovies() async {
    return await _apiService.getPopularMovies();
  }

  Future<List<MovieModel>> getUpcomingMovies() async {
    return await _apiService.getUpcomingMovies();
  }

  Future<List<MovieModel>> getNowPlayingMovies() async {
    return await _apiService.getNowPlayingMovies();
  }

  Future<List<MovieModel>> getTopRatedMovies() async {
    return await _apiService.getTopratedMovies();
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    return await _apiService.searchMovies(query);
  }

  // Add your methods to fetch movie data here
}
