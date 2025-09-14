import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_event.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

// Import your project files
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart'; 
import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMoviesBloc topRatedMoviesBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = TopRatedMoviesBloc(
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  final tMovieList = <Movie>[testMovie];

  test('initial state should be empty', () {
    expect(topRatedMoviesBloc.state, const TopRatedMoviesState());
  });

  group('FetchTopRatedMovies', () {
    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
      },
      build: () => topRatedMoviesBloc,
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        const TopRatedMoviesState(state: RequestState.Loading),
        TopRatedMoviesState(
          state: RequestState.Loaded,
          movies: tMovieList,
        ),
      ],
      verify: (_) => verify(mockGetTopRatedMovies.execute()),
    );

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      setUp: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => topRatedMoviesBloc,
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        const TopRatedMoviesState(state: RequestState.Loading),
        const TopRatedMoviesState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockGetTopRatedMovies.execute()),
    );
  });
}