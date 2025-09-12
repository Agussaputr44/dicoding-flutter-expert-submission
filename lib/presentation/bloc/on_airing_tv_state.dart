import 'package:equatable/equatable.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/tv_entities/tv.dart';

class OnAiringTvState extends Equatable {
  final List<Tv> tvs;
  final RequestState state;
  final String message;

  const OnAiringTvState({
    required this.tvs,
    required this.state,
    required this.message,
  });

  OnAiringTvState copyWith({
    List<Tv>? tvs,
    RequestState? state,
    String? message,
  }) {
    return OnAiringTvState(
      tvs: tvs ?? this.tvs,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [tvs, state, message];
}