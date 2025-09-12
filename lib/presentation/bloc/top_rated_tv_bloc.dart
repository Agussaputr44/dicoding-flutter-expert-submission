import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/state_enum.dart';
import '../../../domain/usecases/tv_usecases/get_top_rated_tvs.dart';
import 'top_rated_tv_event.dart';
import 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTVs getTopRatedTvs;

  TopRatedTvBloc({required this.getTopRatedTvs})
      : super(const TopRatedTvState(
          tvs: [],
          state: RequestState.Empty,
          message: '',
        )) {
    on<FetchTopRatedTvs>(_onFetchTopRatedTvs);
  }

  Future<void> _onFetchTopRatedTvs(
      FetchTopRatedTvs event, Emitter<TopRatedTvState> emit) async {
    emit(const TopRatedTvState(
      tvs: [],
      state: RequestState.Loading,
      message: '',
    ));

    final result = await getTopRatedTvs.execute();
    result.fold(
      (failure) {
        emit(TopRatedTvState(
          tvs: state.tvs,
          state: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvsData) {
        emit(TopRatedTvState(
          tvs: tvsData,
          state: RequestState.Loaded,
          message: '',
        ));
      },
    );
  }
}