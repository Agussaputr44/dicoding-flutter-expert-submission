import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_list_event.dart';
import 'package:ditonton/presentation/bloc/movie_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


import '../../dummy_data/dummy_objects.dart'; 
import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc movieListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieListBloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  final tMovieList = <Movie>[testMovie];

  test('initial state should be empty', () {
    expect(movieListBloc.state, const MovieListState());
  });

  group('Now Playing Movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
      },
      build: () => movieListBloc,
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        const MovieListState(nowPlayingState: RequestState.Loading),
        MovieListState(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: tMovieList,
        ),
      ],
      verify: (_) => verify(mockGetNowPlayingMovies.execute()),
    );

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      setUp: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => movieListBloc,
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        const MovieListState(nowPlayingState: RequestState.Loading),
        const MovieListState(
          nowPlayingState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockGetNowPlayingMovies.execute()),
    );
  });

  group('Popular Movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
      },
      build: () => movieListBloc,
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        const MovieListState(popularMoviesState: RequestState.Loading),
        MovieListState(
          popularMoviesState: RequestState.Loaded,
          popularMovies: tMovieList,
        ),
      ],
      verify: (_) => verify(mockGetPopularMovies.execute()),
    );

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      setUp: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => movieListBloc,
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        const MovieListState(popularMoviesState: RequestState.Loading),
        const MovieListState(
          popularMoviesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockGetPopularMovies.execute()),
    );
  });

  group('Top Rated Movies', () {
    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
      },
      build: () => movieListBloc,
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        const MovieListState(topRatedMoviesState: RequestState.Loading),
        MovieListState(
          topRatedMoviesState: RequestState.Loaded,
          topRatedMovies: tMovieList,
        ),
      ],
      verify: (_) => verify(mockGetTopRatedMovies.execute()),
    );

    blocTest<MovieListBloc, MovieListState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      setUp: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => movieListBloc,
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        const MovieListState(topRatedMoviesState: RequestState.Loading),
        const MovieListState(
          topRatedMoviesState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockGetTopRatedMovies.execute()),
    );
  });
}