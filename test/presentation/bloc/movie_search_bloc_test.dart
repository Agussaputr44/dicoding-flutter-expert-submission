import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search_event.dart';
import 'package:ditonton/presentation/bloc/movie_search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import your project files
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';

import '../../dummy_data/dummy_objects.dart'; // Make sure this path is correct
import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc movieSearchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    movieSearchBloc = MovieSearchBloc(
      searchMovies: mockSearchMovies,
    );
  });

  final tMovieList = <Movie>[testMovie];
  const tQuery = 'spiderman';

  test('initial state should be empty', () {
    expect(movieSearchBloc.state, const MovieSearchState());
  });

  group('Search Movies', () {
    blocTest<MovieSearchBloc, MovieSearchState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
      },
      build: () => movieSearchBloc,
      act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
      expect: () => [
        const MovieSearchState(state: RequestState.Loading),
        MovieSearchState(
          state: RequestState.Loaded,
          searchResult: tMovieList,
        ),
      ],
      verify: (_) => verify(mockSearchMovies.execute(tQuery)),
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      setUp: () {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => movieSearchBloc,
      act: (bloc) => bloc.add(const FetchMovieSearch(tQuery)),
      expect: () => [
        const MovieSearchState(state: RequestState.Loading),
        const MovieSearchState(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockSearchMovies.execute(tQuery)),
    );
  });
}