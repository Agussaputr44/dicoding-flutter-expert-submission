import 'package:equatable/equatable.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/tv_entities/tv.dart';

class WatchlistTvState extends Equatable {
  final List<Tv> watchlistTvs;
  final RequestState state;
  final String message;

  const WatchlistTvState({
    required this.watchlistTvs,
    required this.state,
    required this.message,
  });

  WatchlistTvState copyWith({
    List<Tv>? watchlistTvs,
    RequestState? state,
    String? message,
  }) {
    return WatchlistTvState(
      watchlistTvs: watchlistTvs ?? this.watchlistTvs,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [watchlistTvs, state, message];
}