import 'package:flutter/material.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/tv_entities/tv.dart';
import '../../../domain/usecases/tv_usecases/get_on_airing_tvs.dart';
import '../../../domain/usecases/tv_usecases/get_popular_tvs.dart';
import '../../../domain/usecases/tv_usecases/get_top_rated_tvs.dart';

class TvListNotifier extends ChangeNotifier {
  var _onAiringTvs = <Tv>[];
  List<Tv> get onAiringTvs => _onAiringTvs;

  RequestState _onAiringState = RequestState.Empty;
  RequestState get onAiringState => _onAiringState;

  var _popularTvs = <Tv>[];
  List<Tv> get popularTvs => _popularTvs;

  RequestState _popularTvsState = RequestState.Empty;
  RequestState get popularTvsState => _popularTvsState;

  var _topRatedTvs = <Tv>[];
  List<Tv> get topRatedTvs => _topRatedTvs;

  RequestState _topRatedTvsState = RequestState.Empty;
  RequestState get topRatedTvsState => _topRatedTvsState;

  String _message = '';
  String get message => _message;

  TvListNotifier({
    required this.getOnAiringTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  });

  final GetOnAiringTVs getOnAiringTvs;
  final GetPopularTVs getPopularTvs;
  final GetTopRatedTVs getTopRatedTvs;

  Future<void> fetchOnAiringTvs() async {
    _onAiringState = RequestState.Loading;
    notifyListeners();

    final result = await getOnAiringTvs.execute();
    result.fold(
      (failure) {
        _onAiringState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (TvsData) {
        _onAiringState = RequestState.Loaded;
        _onAiringTvs = TvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvs() async {
    _popularTvsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvs.execute();
    result.fold(
      (failure) {
        _popularTvsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (TvsData) {
        _popularTvsState = RequestState.Loaded;
        _popularTvs = TvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvs() async {
    _topRatedTvsState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvs.execute();
    result.fold(
      (failure) {
        _topRatedTvsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (TvsData) {
        _topRatedTvsState = RequestState.Loaded;
        _topRatedTvs = TvsData;
        notifyListeners();
      },
    );
  }
}
