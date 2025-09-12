import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/state_enum.dart';
import '../../../domain/usecases/tv_usecases/get_on_airing_tvs.dart';
import 'on_airing_tv_event.dart';
import 'on_airing_tv_state.dart';

class OnAiringTvBloc extends Bloc<OnAiringTvEvent, OnAiringTvState> {
  final GetOnAiringTVs getOnAiringTvs;

  OnAiringTvBloc({required this.getOnAiringTvs})
      : super(const OnAiringTvState(
          tvs: [],
          state: RequestState.Empty,
          message: '',
        )) {
    on<FetchOnAiringTvs>(_onFetchOnAiringTvs);
  }

  Future<void> _onFetchOnAiringTvs(
      FetchOnAiringTvs event, Emitter<OnAiringTvState> emit) async {
    emit(const OnAiringTvState(
      tvs: [],
      state: RequestState.Loading,
      message: '',
    ));

    final result = await getOnAiringTvs.execute();
    result.fold(
      (failure) {
        emit(OnAiringTvState(
          tvs: state.tvs,
          state: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvsData) {
        emit(OnAiringTvState(
          tvs: tvsData,
          state: RequestState.Loaded,
          message: '',
        ));
      },
    );
  }
}