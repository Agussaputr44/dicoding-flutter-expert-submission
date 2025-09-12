import 'package:equatable/equatable.dart';

abstract class TopRatedTvEvent extends Equatable {
  const TopRatedTvEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTvs extends TopRatedTvEvent {}