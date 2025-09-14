import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import your project files
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_movies_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_movies_state.dart';

import '../../dummy_data/dummy_objects.dart'; // Make sure this path is correct
import 'watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMoviesBloc watchlistMoviesBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMoviesBloc = WatchlistMoviesBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
    );
  });

  final tMovieList = <Movie>[testMovie];

  test('initial state should be empty', () {
    expect(watchlistMoviesBloc.state, const WatchlistMoviesState());
  });

  group('Fetch Watchlist Movies', () {
    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
      },
      build: () => watchlistMoviesBloc,
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        const WatchlistMoviesState(watchlistState: RequestState.Loading),
        WatchlistMoviesState(
          watchlistState: RequestState.Loaded,
          watchlistMovies: tMovieList,
        ),
      ],
      verify: (_) => verify(mockGetWatchlistMovies.execute()),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      setUp: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => watchlistMoviesBloc,
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        const WatchlistMoviesState(watchlistState: RequestState.Loading),
        const WatchlistMoviesState(
          watchlistState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockGetWatchlistMovies.execute()),
    );
  });
}