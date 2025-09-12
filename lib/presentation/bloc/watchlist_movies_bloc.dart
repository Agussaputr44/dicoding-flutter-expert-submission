import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/state_enum.dart';
import '../../domain/usecases/get_watchlist_movies.dart';
import 'watchlist_movies_event.dart';
import 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc({required this.getWatchlistMovies})
      : super(const WatchlistMoviesState()) {
    on<FetchWatchlistMovies>(_onFetchWatchlistMovies);
  }

  Future<void> _onFetchWatchlistMovies(
      FetchWatchlistMovies event, Emitter<WatchlistMoviesState> emit) async {
    emit(state.copyWith(watchlistState: RequestState.Loading));
    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          watchlistState: RequestState.Error,
          message: failure.message,
        ));
      },
      (moviesData) {
        emit(state.copyWith(
          watchlistState: RequestState.Loaded,
          watchlistMovies: moviesData,
        ));
      },
    );
  }
}