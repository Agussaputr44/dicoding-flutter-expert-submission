import 'package:equatable/equatable.dart';
import '../../common/state_enum.dart';
import '../../domain/entities/movie.dart';

class WatchlistMoviesState extends Equatable {
  final RequestState watchlistState;
  final List<Movie> watchlistMovies;
  final String message;

  const WatchlistMoviesState({
    this.watchlistState = RequestState.Empty,
    this.watchlistMovies = const [],
    this.message = '',
  });

  WatchlistMoviesState copyWith({
    RequestState? watchlistState,
    List<Movie>? watchlistMovies,
    String? message,
  }) {
    return WatchlistMoviesState(
      watchlistState: watchlistState ?? this.watchlistState,
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [watchlistState, watchlistMovies, message];
}