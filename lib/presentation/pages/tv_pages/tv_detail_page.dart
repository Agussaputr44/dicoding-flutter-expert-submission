import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../common/constants.dart';
import '../../../common/state_enum.dart';
import '../../../domain/entities/genre.dart';
import '../../../domain/entities/tv_entities/tv.dart';
import '../../../domain/entities/tv_entities/tv_detail.dart';
import '../../bloc/tv_detail_bloc.dart';
import '../../bloc/tv_detail_event.dart';
import '../../bloc/tv_detail_state.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-detail';
  final int id;

  const TvDetailPage({super.key, required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvDetailBloc>()
        ..add(FetchTvDetail(widget.id))
        ..add(LoadWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TvDetailBloc, TvDetailState>(
        listener: (context, state) {
          final message = state.watchlistMessage;
          if (message == TvDetailBloc.watchlistAddSuccessMessage ||
              message == TvDetailBloc.watchlistRemoveSuccessMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          } else if (message.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(content: Text(message)),
            );
          }
        },
        child: BlocBuilder<TvDetailBloc, TvDetailState>(
          builder: (context, state) {
            if (state.tvState == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.tvState == RequestState.Loaded && state.tv != null) {
              return SafeArea(
                child: DetailContent(
                  tv: state.tv!,
                  recommendations: state.tvRecommendations,
                  isAddedToWatchlist: state.isAddedToWatchlist,
                  onWatchlistPressed: (tv) {
                    if (state.isAddedToWatchlist) {
                      context.read<TvDetailBloc>().add(RemoveFromWatchlist(tv));
                    } else {
                      context.read<TvDetailBloc>().add(AddToWatchlist(tv));
                    }
                  },
                ),
              );
            } else {
              return Center(child: Text(state.message));
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedToWatchlist;
  final void Function(TvDetail) onWatchlistPressed;

  const DetailContent({
    super.key,
    required this.tv,
    required this.recommendations,
    required this.isAddedToWatchlist,
    required this.onWatchlistPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath ?? ''}',
          width: screenWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 56),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tv.name ?? '', style: kHeading5),
                          const SizedBox(height: 8),
                          FilledButton(
                            onPressed: () => onWatchlistPressed(tv),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                isAddedToWatchlist
                                    ? const Icon(Icons.check)
                                    : const Icon(Icons.add),
                                const SizedBox(width: 4),
                                const Text('Watchlist'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(_showGenres(tv.genres ?? [])),
                          const SizedBox(height: 4),
                          Text(_showDuration(tv.episodeRuntime ?? [])),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: (tv.voteAverage ?? 0) / 2,
                                itemCount: 5,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: kMikadoYellow,
                                ),
                                itemSize: 24,
                              ),
                              const SizedBox(width: 8),
                              Text('${tv.voteAverage ?? 0}'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text('Overview', style: kHeading6),
                          const SizedBox(height: 4),
                          Text(tv.overview ?? ''),
                          const SizedBox(height: 16),
                          Text('Recommendations', style: kHeading6),
                          const SizedBox(height: 8),
                          BlocBuilder<TvDetailBloc, TvDetailState>(
                            builder: (context, state) {
                              if (state.recommendationState ==
                                  RequestState.Loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state.recommendationState ==
                                  RequestState.Error) {
                                return Text(state.message);
                              } else if (state.recommendationState ==
                                  RequestState.Loaded) {
                                if (recommendations.isEmpty) {
                                  return const Text(
                                    'No recommendations available.',
                                  );
                                }
                                return SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: recommendations.length,
                                    itemBuilder: (context, index) {
                                      final tvItem = recommendations[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              TvDetailPage.ROUTE_NAME,
                                              arguments: tvItem.id,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w500${tvItem.posterPath ?? ''}',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    if (genres.isEmpty) return '-';
    return genres.map((g) => g.name).join(', ');
  }

  String _showDuration(List<int> runtimes) {
    if (runtimes.isEmpty) return '-';
    final runtime = runtimes[0];
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }
}