import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../data/models/movie_model.dart';
import '../../../../data/repositories/movie_repository.dart';
import '../../../../data/services/movie_api_service.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final dioClient = DioClient();
        final apiService = MovieApiService(dioClient);
        final repository = MovieRepository(apiService);

        return SearchCubit(repository);
      },
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});

    context.read<SearchCubit>().onQueryChanged(value);
  }

  void _clearSearch() {
    _controller.clear();

    context.read<SearchCubit>().clearSearch();

    setState(() {});

    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: _SearchBar(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _onSearchChanged,
                onClear: _clearSearch,
              ),
            ),

            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  // Empty query
                  if (state.query.trim().isEmpty) {
                    return const _TopSearchesView();
                  }

                  // Loading
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  // Error
                  if (state.errorMessage != null) {
                    return _ErrorView(
                      message: state.errorMessage!,
                      onRetry: () {
                        context.read<SearchCubit>().searchMovies(
                          state.query.trim(),
                        );
                      },
                    );
                  }

                  // No results
                  if (state.movies.isEmpty) {
                    return const _NoResultsView();
                  }

                  // Search results
                  return _SearchResults(movies: state.movies);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),

          const Icon(Icons.search, color: Colors.white70, size: 28),

          const SizedBox(width: 12),

          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search for a show, movie, genre, etc.',
                hintStyle: TextStyle(color: Colors.white60, fontSize: 15),
              ),
            ),
          ),

          if (controller.text.isNotEmpty)
            IconButton(
              onPressed: onClear,
              icon: const Icon(Icons.close, color: Colors.white70),
            )
          else
            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.mic_none, color: Colors.white70, size: 27),
            ),
        ],
      ),
    );
  }
}

class _TopSearchesView extends StatelessWidget {
  const _TopSearchesView();

  @override
  Widget build(BuildContext context) {
    final topSearches = _topSearchMovies;

    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          color: const Color(0xFF171717),
          child: const Text(
            'Top Searches',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        ...topSearches.map((movie) {
          return _TopSearchItem(movie: movie);
        }),
      ],
    );
  }
}

class _TopSearchItem extends StatelessWidget {
  final _TopSearchMovie movie;

  const _TopSearchItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      decoration: const BoxDecoration(
        color: Color(0xFF303030),
        border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
      ),
      child: Row(
        children: [
          // Poster
          SizedBox(
            width: 205,
            height: 115,
            child: CachedNetworkImage(
              imageUrl: movie.imageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return Container(
                  color: Colors.grey.shade900,
                  child: const Icon(
                    Icons.movie_outlined,
                    color: Colors.white38,
                    size: 35,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 18),

          // Title
          Expanded(
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Play button
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<MovieModel> movies;

  const _SearchResults({required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return _SearchResultItem(movie: movies[index]);
      },
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final MovieModel movie;

  const _SearchResultItem({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      margin: const EdgeInsets.only(bottom: 1),
      color: const Color(0xFF303030),
      child: Row(
        children: [
          SizedBox(
            width: 205,
            height: 115,
            child: CachedNetworkImage(
              imageUrl: movie.posterUrl ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Container(
                  color: Colors.grey.shade900,
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return Container(
                  color: Colors.grey.shade900,
                  child: const Icon(
                    Icons.movie_outlined,
                    color: Colors.white38,
                    size: 35,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoResultsView extends StatelessWidget {
  const _NoResultsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, color: Colors.white30, size: 65),
          SizedBox(height: 18),
          Text(
            'No results found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try a different movie or show.',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: Colors.white54,
              size: 60,
            ),
            const SizedBox(height: 18),
            const Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopSearchMovie {
  final String title;
  final String imageUrl;

  const _TopSearchMovie({required this.title, required this.imageUrl});
}

const List<_TopSearchMovie> _topSearchMovies = [
  _TopSearchMovie(
    title: 'Citation',
    imageUrl: 'https://image.tmdb.org/t/p/w500/5YQx3fR7gPqYwY8qY4h7J4J4J4J.jpg',
  ),
  _TopSearchMovie(
    title: 'Oloture',
    imageUrl: 'https://image.tmdb.org/t/p/w500/placeholder.jpg',
  ),
  _TopSearchMovie(
    title: 'The Setup',
    imageUrl: 'https://image.tmdb.org/t/p/w500/placeholder.jpg',
  ),
  _TopSearchMovie(
    title: 'Breaking Bad',
    imageUrl: 'https://image.tmdb.org/t/p/w500/placeholder.jpg',
  ),
  _TopSearchMovie(
    title: 'Ozark',
    imageUrl: 'https://image.tmdb.org/t/p/w500/placeholder.jpg',
  ),
  _TopSearchMovie(
    title: 'The Governor',
    imageUrl: 'https://image.tmdb.org/t/p/w500/placeholder.jpg',
  ),
  _TopSearchMovie(
    title: 'Your Excellency',
    imageUrl: 'https://image.tmdb.org/t/p/w500/placeholder.jpg',
  ),
];
