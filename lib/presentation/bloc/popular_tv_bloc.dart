import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/state_enum.dart';
import '../../../domain/usecases/tv_usecases/get_popular_tvs.dart';
import 'popular_tv_event.dart';
import 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTVs getPopularTvs;

  PopularTvBloc({required this.getPopularTvs})
      : super(const PopularTvState(
          tvs: [],
          state: RequestState.Empty,
          message: '',
        )) {
    on<FetchPopularTvs>(_onFetchPopularTvs);
  }

  Future<void> _onFetchPopularTvs(
      FetchPopularTvs event, Emitter<PopularTvState> emit) async {
    emit(const PopularTvState(
      tvs: [],
      state: RequestState.Loading,
      message: '',
    ));

    final result = await getPopularTvs.execute();
    result.fold(
      (failure) {
        emit(PopularTvState(
          tvs: state.tvs,
          state: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvsData) {
        emit(PopularTvState(
          tvs: tvsData,
          state: RequestState.Loaded,
          message: '',
        ));
      },
    );
  }
}