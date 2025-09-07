import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/state_enum.dart';
import '../../../domain/entities/genre.dart';
import '../../../domain/entities/tv_entities/tv.dart';
import '../../../domain/entities/tv_entities/tv_detail.dart';
import '../../provider/tv_provider/tv_detail_notifier.dart';

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
      final notifier = Provider.of<TvDetailNotifier>(context, listen: false);
      notifier.fetchTvDetail(widget.id);
      notifier.loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvState == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.tvState == RequestState.Loaded) {
            final tv = provider.tv;
            return SafeArea(
              child: DetailContent(
                tv: tv,
                recommendations: provider.tvRecommendations,
              ),
            );
          } else {
            return Center(child: Text(provider.message));
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;

  const DetailContent({
    super.key,
    required this.tv,
    required this.recommendations,
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
                          Consumer<TvDetailNotifier>(
                            builder: (context, notifier, child) {
                              return FilledButton(
                                onPressed: () async {
                                  if (!notifier.isAddedToWatchlist) {
                                    await notifier.addWatchlist(tv);
                                  } else {
                                    await notifier.removeFromWatchlist(tv);
                                  }
                                  // Tidak wajib lagi await notifier.loadWatchlistStatus(tv.id), karena sudah dipanggil di Provider
                                  final message = notifier.watchlistMessage;
                                  if (message ==
                                          TvDetailNotifier
                                              .watchlistAddSuccessMessage ||
                                      message ==
                                          TvDetailNotifier
                                              .watchlistRemoveSuccessMessage) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          AlertDialog(content: Text(message)),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    notifier.isAddedToWatchlist
                                        ? Icon(Icons.check)
                                        : Icon(Icons.add),
                                    SizedBox(width: 4),
                                    Text('Watchlist'),
                                  ],
                                ),
                              );
                            },
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
                          Consumer<TvDetailNotifier>(
                            builder: (context, data, child) {
                              if (data.recommendationState ==
                                  RequestState.Loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (data.recommendationState ==
                                  RequestState.Error) {
                                return Text(data.message);
                              } else if (data.recommendationState ==
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
