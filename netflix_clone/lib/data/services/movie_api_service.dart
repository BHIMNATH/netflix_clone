import 'package:dio/dio.dart';
import 'package:netflix_clone/core/network/dio_client.dart';
import 'package:netflix_clone/data/models/movie_model.dart';

class MovieApiService {
  final Dio _dio;
  MovieApiService(DioClient dioClient) : _dio = dioClient.dio;
  Future<List<MovieModel>> getTrendingMovies() async {
    try {
      final response = await _dio.get('/trending/movie/week?');
      return _parseMovies(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response = await _dio.get('/movie/popular?');
      return _parseMovies(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getUpcomingMovies() async {
    try {
      final response = await _dio.get('/movie/upcoming?');
      return _parseMovies(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getNowPlayingMovies() async {
    try {
      final response = await _dio.get('/movie/now_playing?');
      return _parseMovies(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getTopratedMovies() async {
    try {
      final response = await _dio.get('/movie/top_rated?');
      return _parseMovies(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {'query': query},
      );
      return _parseMovies(response.data);
    } catch (e) {
      rethrow;
    }
  }

  List<MovieModel> _parseMovies(dynamic data) {
    final results = data['results'] as List<dynamic>;
    return results
        .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
