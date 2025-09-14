import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


import '../../dummy_data/dummy_objects.dart'; 
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;
  final tMovies = <Movie>[testMovie];

  test('initial state should be correct', () {
    expect(movieDetailBloc.state, const MovieDetailState());
  });

  group('Fetch Movie Detail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
      },
      build: () => movieDetailBloc,
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.Loading),
        MovieDetailState(
          movieState: RequestState.Loading,
          movie: testMovieDetail,
        ),
        MovieDetailState(
          movieState: RequestState.Loading,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: tMovies,
        ),
        MovieDetailState(
          movieState: RequestState.Loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.Loaded,
          movieRecommendations: tMovies,
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when get movie detail is unsuccessful',
      setUp: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
      },
      build: () => movieDetailBloc,
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        const MovieDetailState(movieState: RequestState.Loading),
        const MovieDetailState(
          movieState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });

  group('Watchlist Operations', () {

blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit success message and update status when removing from watchlist is successful',
    setUp: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
    },
    build: () => movieDetailBloc,
    act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
    
    expect: () => [
      const MovieDetailState(
        watchlistMessage: 'Removed from Watchlist',
        isAddedToWatchlist: false,
      ),
    ],
    
    verify: (_) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
      verify(mockGetWatchListStatus.execute(testMovieDetail.id));
    },
);
    blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit success message and update status when removing from watchlist is successful',
    setUp: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
    },
    build: () => movieDetailBloc,
    act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
    
    expect: () => [
      const MovieDetailState(
        watchlistMessage: 'Removed from Watchlist',
        isAddedToWatchlist: false,
      ),
    ],
    
    verify: (_) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
      verify(mockGetWatchListStatus.execute(testMovieDetail.id));
    },
    );
  });
  group('Load Watchlist Status', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit isAddedToWatchlist status',
      setUp: () {
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      },
      build: () => movieDetailBloc,
      act: (bloc) => bloc.add(const LoadWatchlistStatus(tId)),
      expect: () => [
        const MovieDetailState(isAddedToWatchlist: true),
      ],
      verify: (_) => verify(mockGetWatchListStatus.execute(tId)),
    );
  });
}