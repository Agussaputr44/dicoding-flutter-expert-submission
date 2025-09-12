import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/state_enum.dart';
import '../../../domain/usecases/tv_usecases/get_watchlist_tvs.dart';
import 'watchlist_tv_event.dart';
import 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTvs getWatchlistTvs;

  WatchlistTvBloc({required this.getWatchlistTvs})
      : super(const WatchlistTvState(
          watchlistTvs: [],
          state: RequestState.Empty,
          message: '',
        )) {
    on<FetchWatchlistTvs>(_onFetchWatchlistTvs);
  }

  Future<void> _onFetchWatchlistTvs(
      FetchWatchlistTvs event, Emitter<WatchlistTvState> emit) async {
    emit(const WatchlistTvState(
      watchlistTvs: [],
      state: RequestState.Loading,
      message: '',
    ));

    final result = await getWatchlistTvs.execute();
    result.fold(
      (failure) {
        emit(WatchlistTvState(
          watchlistTvs: state.watchlistTvs,
          state: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvsData) {
        emit(WatchlistTvState(
          watchlistTvs: tvsData,
          state: RequestState.Loaded,
          message: '',
        ));
      },
    );
  }
}