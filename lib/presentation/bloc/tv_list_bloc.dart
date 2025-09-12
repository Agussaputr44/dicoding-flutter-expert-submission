import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/state_enum.dart';
import '../../../domain/usecases/tv_usecases/get_on_airing_tvs.dart';
import '../../../domain/usecases/tv_usecases/get_popular_tvs.dart';
import '../../../domain/usecases/tv_usecases/get_top_rated_tvs.dart';
import 'tv_list_event.dart';
import 'tv_list_state.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetOnAiringTVs getOnAiringTvs;
  final GetPopularTVs getPopularTvs;
  final GetTopRatedTVs getTopRatedTvs;

  TvListBloc({
    required this.getOnAiringTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  }) : super(const TvListState(
          onAiringTvs: [],
          onAiringState: RequestState.Empty,
          popularTvs: [],
          popularTvsState: RequestState.Empty,
          topRatedTvs: [],
          topRatedTvsState: RequestState.Empty,
          message: '',
        )) {
    on<FetchOnAiringTvs>(_onFetchOnAiringTvs);
    on<FetchPopularTvs>(_onFetchPopularTvs);
    on<FetchTopRatedTvs>(_onFetchTopRatedTvs);
  }

  Future<void> _onFetchOnAiringTvs(
      FetchOnAiringTvs event, Emitter<TvListState> emit) async {
    emit(state.copyWith(onAiringState: RequestState.Loading));

    final result = await getOnAiringTvs.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          onAiringState: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvsData) {
        emit(state.copyWith(
          onAiringState: RequestState.Loaded,
          onAiringTvs: tvsData,
        ));
      },
    );
  }

  Future<void> _onFetchPopularTvs(
      FetchPopularTvs event, Emitter<TvListState> emit) async {
    emit(state.copyWith(popularTvsState: RequestState.Loading));

    final result = await getPopularTvs.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          popularTvsState: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvsData) {
        emit(state.copyWith(
          popularTvsState: RequestState.Loaded,
          popularTvs: tvsData,
        ));
      },
    );
  }

  Future<void> _onFetchTopRatedTvs(
      FetchTopRatedTvs event, Emitter<TvListState> emit) async {
    emit(state.copyWith(topRatedTvsState: RequestState.Loading));

    final result = await getTopRatedTvs.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          topRatedTvsState: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvsData) {
        emit(state.copyWith(
          topRatedTvsState: RequestState.Loaded,
          topRatedTvs: tvsData,
        ));
      },
    );
  }
}