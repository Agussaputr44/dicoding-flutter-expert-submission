import 'package:equatable/equatable.dart';

import '../../../common/state_enum.dart';
import '../../../domain/entities/tv_entities/tv.dart';

class TvSearchState extends Equatable {
  final List<Tv> searchResult;
  final RequestState state;
  final String message;

  const TvSearchState({
    required this.searchResult,
    required this.state,
    required this.message,
  });

  TvSearchState copyWith({
    List<Tv>? searchResult,
    RequestState? state,
    String? message,
  }) {
    return TvSearchState(
      searchResult: searchResult ?? this.searchResult,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [searchResult, state, message];
}