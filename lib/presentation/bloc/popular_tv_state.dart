import 'package:equatable/equatable.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/tv_entities/tv.dart';

class PopularTvState extends Equatable {
  final List<Tv> tvs;
  final RequestState state;
  final String message;

  const PopularTvState({
    required this.tvs,
    required this.state,
    required this.message,
  });

  PopularTvState copyWith({
    List<Tv>? tvs,
    RequestState? state,
    String? message,
  }) {
    return PopularTvState(
      tvs: tvs ?? this.tvs,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [tvs, state, message];
}