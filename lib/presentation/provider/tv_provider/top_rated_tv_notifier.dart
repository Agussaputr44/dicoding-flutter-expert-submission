import 'package:flutter/foundation.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/tv_entities/tv.dart';
import '../../../domain/usecases/tv_usecases/get_top_rated_tvs.dart';

class TopRatedTvNotifier extends ChangeNotifier {
  final GetTopRatedTVs getTopRatedTvs;

  TopRatedTvNotifier({required this.getTopRatedTvs});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tvs = [];
  List<Tv> get tvs => _tvs;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTvs() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvs.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (TVsData) {
        _tvs = TVsData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
