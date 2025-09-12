import 'package:equatable/equatable.dart';

abstract class OnAiringTvEvent extends Equatable {
  const OnAiringTvEvent();

  @override
  List<Object> get props => [];
}

class FetchOnAiringTvs extends OnAiringTvEvent {}