import 'package:equatable/equatable.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/movie.dart';

class PopularMoviesState extends Equatable {
  final RequestState state;
  final List<Movie> movies;
  final String message;

  const PopularMoviesState({
    this.state = RequestState.Empty,
    this.movies = const [],
    this.message = '',
  });

  PopularMoviesState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return PopularMoviesState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, movies, message];
}