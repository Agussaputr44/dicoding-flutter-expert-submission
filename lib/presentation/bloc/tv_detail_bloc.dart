import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/state_enum.dart';
import '../../../domain/usecases/tv_usecases/get_tv_detail.dart';
import '../../../domain/usecases/tv_usecases/get_tv_recommendations.dart';
import '../../../domain/usecases/tv_usecases/get_watchlist_tv_status.dart';
import '../../../domain/usecases/tv_usecases/remove_watchlist_tv.dart';
import '../../../domain/usecases/tv_usecases/save_watchlist_tv.dart';
import 'tv_detail_event.dart';
import 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVDetail getTvDetail;
  final GetTVRecommendations getTvRecommendations;
  final GetWatchlistTvStatus getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const TvDetailState(
          tv: null,
          tvState: RequestState.Empty,
          tvRecommendations: [],
          recommendationState: RequestState.Empty,
          message: '',
          isAddedToWatchlist: false,
          watchlistMessage: '',
        )) {
    on<FetchTvDetail>(_onFetchTvDetail);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchTvDetail(
      FetchTvDetail event, Emitter<TvDetailState> emit) async {
    emit(state.copyWith(
      tvState: RequestState.Loading,
    ));

    final detailResult = await getTvDetail.execute(event.id);
    final recommendationResult = await getTvRecommendations.execute(event.id);

    await detailResult.fold(
      (failure) async {
        emit(state.copyWith(
          tvState: RequestState.Error,
          message: failure.message,
        ));
      },
      (tv) async {
        emit(state.copyWith(
          recommendationState: RequestState.Loading,
          tv: tv,
        ));

        await recommendationResult.fold(
          (failure) async {
            emit(state.copyWith(
              recommendationState: RequestState.Error,
              message: failure.message,
            ));
          },
          (tvs) async {
            emit(state.copyWith(
              recommendationState: RequestState.Loaded,
              tvRecommendations: tvs,
            ));
          },
        );

        emit(state.copyWith(
          tvState: RequestState.Loaded,
        ));
      },
    );
  }

  Future<void> _onAddToWatchlist(
      AddToWatchlist event, Emitter<TvDetailState> emit) async {
    final result = await saveWatchlist.execute(event.tv);

    await result.fold(
      (failure) async {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) async {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );

    await _onLoadWatchlistStatus(LoadWatchlistStatus(event.tv.id), emit);
  }

  Future<void> _onRemoveFromWatchlist(
      RemoveFromWatchlist event, Emitter<TvDetailState> emit) async {
    final result = await removeWatchlist.execute(event.tv);

    await result.fold(
      (failure) async {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) async {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );

    await _onLoadWatchlistStatus(LoadWatchlistStatus(event.tv.id), emit);
  }

  Future<void> _onLoadWatchlistStatus(
      LoadWatchlistStatus event, Emitter<TvDetailState> emit) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}