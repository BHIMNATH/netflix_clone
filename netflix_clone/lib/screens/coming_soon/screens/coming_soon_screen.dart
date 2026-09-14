import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../data/models/movie_model.dart';
import '../../../../data/repositories/movie_repository.dart';
import '../../../../data/services/movie_api_service.dart';
import '../cubit/coming_soon_cubit.dart';
import '../cubit/coming_soon_state.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final dioClient = DioClient();
        final apiService = MovieApiService(dioClient);
        final repository = MovieRepository(apiService);

        return ComingSoonCubit(repository)..loadComingSoon();
      },
      child: const _ComingSoonView(),
    );
  }
}

class _ComingSoonView extends StatelessWidget {
  const _ComingSoonView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Coming Soon',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<ComingSoonCubit, ComingSoonState>(
        builder: (context, state) {
          if (state.isLoading && state.movies.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (state.errorMessage != null && state.movies.isEmpty) {
            return _ErrorView(
              message: state.errorMessage!,
              onRetry: () {
                context.read<ComingSoonCubit>().loadComingSoon();
              },
            );
          }

          if (state.movies.isEmpty) {
            return const _EmptyView();
          }

          return RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.grey.shade900,
            onRefresh: () {
              return context.read<ComingSoonCubit>().refresh();
            },
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.movies.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 22,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) {
                return _UpcomingMovieCard(movie: state.movies[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _UpcomingMovieCard extends StatelessWidget {
  final MovieModel movie;

  const _UpcomingMovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: movie.posterUrl ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(
                    color: Colors.grey.shade900,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey.shade900,
                    child: const Center(
                      child: Icon(
                        Icons.movie_outlined,
                        color: Colors.white38,
                        size: 45,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          movie.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: Colors.white54,
              size: 12,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                _formatDate(movie.releaseDate),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) {
      return 'Release date unavailable';
    }

    final parts = date.split('-');

    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }

    return date;
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_filter_outlined, color: Colors.white30, size: 70),
          SizedBox(height: 16),
          Text(
            'No upcoming movies',
            style: TextStyle(color: Colors.white70, fontSize: 18),
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
