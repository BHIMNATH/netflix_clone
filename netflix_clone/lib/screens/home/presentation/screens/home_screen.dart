import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../data/models/movie_model.dart';
import '../../../../data/repositories/movie_repository.dart';
import '../../../../data/services/movie_api_service.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final dioClient = DioClient();
        final apiService = MovieApiService(dioClient);
        final repository = MovieRepository(apiService);

        return HomeCubit(repository)..loadHome();
      },
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isLoading && state.trendingMovies.isEmpty) {
            return const _LoadingView();
          }

          if (state.errorMessage != null && state.trendingMovies.isEmpty) {
            return _ErrorView(
              message: state.errorMessage!,
              onRetry: () {
                context.read<HomeCubit>().loadHome();
              },
            );
          }

          return RefreshIndicator(
            color: Colors.white,
            backgroundColor: Colors.grey.shade900,
            onRefresh: () {
              return context.read<HomeCubit>().refresh();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // HERO
                SliverToBoxAdapter(
                  child: _HeroSection(
                    movie: state.trendingMovies.isNotEmpty
                        ? state.trendingMovies.first
                        : null,
                  ),
                ),

                // PREVIEWS
                if (state.trendingMovies.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _PreviewSection(movies: state.trendingMovies),
                  ),

                // TRENDING
                if (state.trendingMovies.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _MovieSection(
                      title: 'Trending Now',
                      movies: state.trendingMovies,
                    ),
                  ),

                // POPULAR
                if (state.popularMovies.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _MovieSection(
                      title: 'Popular on Netflix',
                      movies: state.popularMovies,
                    ),
                  ),

                // NOW PLAYING
                if (state.nowPlayingMovies.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _MovieSection(
                      title: 'Now Playing',
                      movies: state.nowPlayingMovies,
                    ),
                  ),

                // TOP RATED
                if (state.topRatedMovies.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _MovieSection(
                      title: 'Top Rated',
                      movies: state.topRatedMovies,
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final MovieModel? movie;

  const _HeroSection({required this.movie});

  @override
  Widget build(BuildContext context) {
    if (movie == null) {
      return const SizedBox(
        height: 580,
        child: Center(
          child: Text(
            'No featured movie available',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return SizedBox(
      height: 590,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: movie!.backdropUrl ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return Container(color: Colors.grey.shade900);
            },
            errorWidget: (context, url, error) {
              return Container(
                color: Colors.grey.shade900,
                child: const Icon(
                  Icons.movie_outlined,
                  color: Colors.white30,
                  size: 60,
                ),
              );
            },
          ),

          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black12,
                  Colors.transparent,
                  Colors.black87,
                  Colors.black,
                ],
                stops: [0.0, 0.35, 0.72, 1.0],
              ),
            ),
          ),

          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black54, Colors.transparent],
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                child: Row(
                  children: [
                    // Netflix logo
                    Image.asset(
                      'assets/logo.png',
                      width: 42,
                      height: 48,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text(
                          'N',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                          ),
                        );
                      },
                    ),

                    const Spacer(),

                    _TopNavigationItem(title: 'TV Shows', onTap: () {}),

                    const SizedBox(width: 22),

                    _TopNavigationItem(title: 'Movies', onTap: () {}),

                    const SizedBox(width: 22),

                    _TopNavigationItem(title: 'My List', onTap: () {}),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 22,
            right: 22,
            bottom: 25,
            child: Column(
              children: [
                Text(
                  '#2 in Nigeria Today',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // MY LIST
                    _HeroAction(
                      icon: Icons.add,
                      label: 'My List',
                      onTap: () {},
                    ),

                    const SizedBox(width: 18),

                    // PLAY
                    SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.play_arrow,
                          color: Colors.black,
                          size: 28,
                        ),
                        label: const Text(
                          'Play',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 18),

                    // INFO
                    _HeroAction(
                      icon: Icons.info_outline,
                      label: 'Info',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopNavigationItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _TopNavigationItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HeroAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 62,
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewSection extends StatelessWidget {
  final List<MovieModel> movies;

  const _PreviewSection({required this.movies});

  @override
  Widget build(BuildContext context) {
    final previewMovies = movies.take(8).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Previews',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 92,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              scrollDirection: Axis.horizontal,
              itemCount: previewMovies.length,
              separatorBuilder: (_, __) {
                return const SizedBox(width: 16);
              },
              itemBuilder: (context, index) {
                return _PreviewAvatar(movie: previewMovies[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewAvatar extends StatelessWidget {
  final MovieModel movie;

  const _PreviewAvatar({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: movie.posterUrl ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return Container(color: Colors.grey.shade900);
          },
          errorWidget: (context, url, error) {
            return Container(
              color: Colors.grey.shade900,
              child: const Icon(Icons.movie, color: Colors.white38),
            );
          },
        ),
      ),
    );
  }
}

class _MovieSection extends StatelessWidget {
  final String title;
  final List<MovieModel> movies;

  const _MovieSection({required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 13),

          SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: movies.length,
              separatorBuilder: (_, __) {
                return const SizedBox(width: 10);
              },
              itemBuilder: (context, index) {
                return _MovieCard(movie: movies[index], rank: index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final MovieModel movie;
  final int rank;

  const _MovieCard({required this.movie, required this.rank});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: CachedNetworkImage(
                imageUrl: movie.posterUrl ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(
                    color: Colors.grey.shade900,
                    child: const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
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
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),

          // RANK
          Positioned(
            left: 7,
            bottom: 7,
            child: Container(
              width: 25,
              height: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
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
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: Colors.white54,
              size: 60,
            ),

            const SizedBox(height: 20),

            const Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),

            const SizedBox(height: 22),

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
