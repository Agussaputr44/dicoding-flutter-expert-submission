import '../../../domain/entities/tv_entities/tv.dart';
import 'package:flutter/widgets.dart';

import '../../../common/state_enum.dart';
import '../../../domain/usecases/tv_usecases/get_on_airing_tvs.dart';

class OnAiringTvNotifier extends ChangeNotifier {
  final GetOnAiringTVs getOnAiringTvs;

  OnAiringTvNotifier({required this.getOnAiringTvs});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tvs = [];
  List<Tv> get tvs => _tvs;

  String _message = '';
  String get message => _message;

  Future<void> fetchOnAiringTvs() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getOnAiringTvs.execute();

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
