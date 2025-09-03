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
  const TvDetailPage({Key? key, required this.id}) : super(key: key);

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
            return Center(child: CircularProgressIndicator());
          } else if (provider.tvState == RequestState.Loaded) {
            final tv = provider.tv;
            return SafeArea(
              child: DetailContent(
                tv,
                provider.tvRecommendations,
                provider.isAddedToWatchlist,
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
  final bool isAddedWatchlist;

  const DetailContent(this.tv, this.recommendations, this.isAddedWatchlist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath ?? ''}',
          width: screenWidth,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            minChildSize: 0.25,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                          SizedBox(height: 8),
                          FilledButton(
                            onPressed: () async {
                              final notifier = Provider.of<TvDetailNotifier>(
                                  context,
                                  listen: false);
                              if (!isAddedWatchlist) {
                                await notifier.addWatchlist(tv);
                              } else {
                                await notifier.removeFromWatchlist(tv);
                              }

                              final message = notifier.watchlistMessage;

                              if (message ==
                                      TvDetailNotifier
                                          .watchlistAddSuccessMessage ||
                                  message ==
                                      TvDetailNotifier
                                          .watchlistRemoveSuccessMessage) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)));
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
                                isAddedWatchlist
                                    ? Icon(Icons.check)
                                    : Icon(Icons.add),
                                SizedBox(width: 4),
                                Text('Watchlist'),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(_showGenres(tv.genres ?? [])),
                          SizedBox(height: 4),
                          Text(_showDuration(tv.episodeRuntime ?? [])),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: (tv.voteAverage ?? 0) / 2,
                                itemCount: 5,
                                itemBuilder: (context, index) =>
                                    Icon(Icons.star, color: kMikadoYellow),
                                itemSize: 24,
                              ),
                              SizedBox(width: 8),
                              Text('${tv.voteAverage ?? 0}'),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text('Overview', style: kHeading6),
                          SizedBox(height: 4),
                          Text(tv.overview ?? ''),
                          SizedBox(height: 16),
                          Text('Recommendations', style: kHeading6),
                          SizedBox(height: 8),
                          Consumer<TvDetailNotifier>(
                            builder: (context, data, child) {
                              if (data.recommendationState ==
                                  RequestState.Loading) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (data.recommendationState ==
                                  RequestState.Error) {
                                return Text(data.message);
                              } else if (data.recommendationState ==
                                  RequestState.Loaded) {
                                if (recommendations.isEmpty) {
                                  return Text('No recommendations available.');
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
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
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
                      child:
                          Container(color: Colors.white, height: 4, width: 48),
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
              icon: Icon(Icons.arrow_back),
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
