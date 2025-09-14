import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movies_event.dart';
import 'package:ditonton/presentation/bloc/popular_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import your project files
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';

import '../../dummy_data/dummy_objects.dart'; 
import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesBloc popularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(
      getPopularMovies: mockGetPopularMovies,
    );
  });

  final tMovieList = <Movie>[testMovie];

  test('initial state should be empty', () {
    expect(popularMoviesBloc.state, const PopularMoviesState());
  });

  group('FetchPopularMovies', () {
    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
      },
      build: () => popularMoviesBloc,
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        const PopularMoviesState(state: RequestState.Loading),
        PopularMoviesState(
          state: RequestState.Loaded,
          movies: tMovieList,
        ),
      ],
      verify: (_) => verify(mockGetPopularMovies.execute()),
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      setUp: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => popularMoviesBloc,
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        const PopularMoviesState(state: RequestState.Loading),
        const PopularMoviesState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockGetPopularMovies.execute()),
    );
  });
}