import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/state_enum.dart';
import '../../../domain/usecases/tv_usecases/search_tvs.dart';
import 'tv_search_event.dart';
import 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvs searchTvs;

  TvSearchBloc({required this.searchTvs})
      : super(const TvSearchState(
          searchResult: [],
          state: RequestState.Empty,
          message: '',
        )) {
    on<FetchTvSearch>(_onFetchTvSearch);
  }

  Future<void> _onFetchTvSearch(
      FetchTvSearch event, Emitter<TvSearchState> emit) async {
    emit(const TvSearchState(
      searchResult: [],
      state: RequestState.Loading,
      message: '',
    ));

    final result = await searchTvs.execute(event.query);
    result.fold(
      (failure) {
        emit(TvSearchState(
          searchResult: state.searchResult,
          state: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvsData) {
        emit(TvSearchState(
          searchResult: tvsData,
          state: RequestState.Loaded,
          message: '',
        ));
      },
    );
  }
}