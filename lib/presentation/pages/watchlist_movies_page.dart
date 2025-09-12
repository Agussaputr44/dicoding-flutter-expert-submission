import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // CHANGE: Import flutter_bloc

import '../../common/state_enum.dart';
import '../../common/utils.dart';
import '../bloc/watchlist_movies_bloc.dart'; // CHANGE: Import watchlist_movies_bloc
import '../bloc/watchlist_movies_event.dart'; // CHANGE: Import watchlist_movies_event
import '../bloc/watchlist_movies_state.dart'; // CHANGE: Import watchlist_movies_state
import '../widgets/movie_card_list.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  const WatchlistMoviesPage({super.key});

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        // CHANGE: Mengganti Provider dengan context.read untuk memicu event
        context.read<WatchlistMoviesBloc>().add(FetchWatchlistMovies());
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    // CHANGE: Mengganti Provider dengan context.read untuk memicu event
    context.read<WatchlistMoviesBloc>().add(FetchWatchlistMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistMoviesBloc, WatchlistMoviesState>( // CHANGE: Ganti Consumer dengan BlocBuilder
          builder: (context, state) {
            if (state.watchlistState == RequestState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.watchlistState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.watchlistMovies[index];
                  return MovieCard(movie);
                },
                itemCount: state.watchlistMovies.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}