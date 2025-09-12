import 'package:equatable/equatable.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/tv_entities/tv.dart';

class TvListState extends Equatable {
  final List<Tv> onAiringTvs;
  final RequestState onAiringState;
  final List<Tv> popularTvs;
  final RequestState popularTvsState;
  final List<Tv> topRatedTvs;
  final RequestState topRatedTvsState;
  final String message;

  const TvListState({
    required this.onAiringTvs,
    required this.onAiringState,
    required this.popularTvs,
    required this.popularTvsState,
    required this.topRatedTvs,
    required this.topRatedTvsState,
    required this.message,
  });

  TvListState copyWith({
    List<Tv>? onAiringTvs,
    RequestState? onAiringState,
    List<Tv>? popularTvs,
    RequestState? popularTvsState,
    List<Tv>? topRatedTvs,
    RequestState? topRatedTvsState,
    String? message,
  }) {
    return TvListState(
      onAiringTvs: onAiringTvs ?? this.onAiringTvs,
      onAiringState: onAiringState ?? this.onAiringState,
      popularTvs: popularTvs ?? this.popularTvs,
      popularTvsState: popularTvsState ?? this.popularTvsState,
      topRatedTvs: topRatedTvs ?? this.topRatedTvs,
      topRatedTvsState: topRatedTvsState ?? this.topRatedTvsState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        onAiringTvs,
        onAiringState,
        popularTvs,
        popularTvsState,
        topRatedTvs,
        topRatedTvsState,
        message,
      ];
}