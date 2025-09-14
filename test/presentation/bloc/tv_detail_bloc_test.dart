import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/tv_usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetWatchlistTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTVDetail mockGetTvDetail;
  late MockGetTVRecommendations mockGetTvRecommendations;
  late MockGetWatchlistTvStatus mockGetWatchlistTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvDetail = MockGetTVDetail();
    mockGetTvRecommendations = MockGetTVRecommendations();
    mockGetWatchlistTvStatus = MockGetWatchlistTvStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchlistTvStatus,
      saveWatchlist: mockSaveWatchlistTv,
      removeWatchlist: mockRemoveWatchlistTv,
    );
  });

  const tId = 1;
  final tTvList = <Tv>[testTv];
  const tInitialState = TvDetailState(
    tv: null,
    tvState: RequestState.Empty,
    tvRecommendations: [],
    recommendationState: RequestState.Empty,
    message: '',
    isAddedToWatchlist: false,
    watchlistMessage: '',
  );

  test('initial state should be correct', () {
    expect(tvDetailBloc.state, tInitialState);
  });

  group('Fetch TV Detail', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit correct states when data is gotten successfully',
      setUp: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvList));
      },
      build: () => tvDetailBloc,
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect: () => [
        // Each state must be a complete object with all required properties
        tInitialState.copyWith(tvState: RequestState.Loading),
        tInitialState.copyWith(
          tvState: RequestState.Loading,
          tv: testTvDetail,
          recommendationState: RequestState.Loading,
        ),
        tInitialState.copyWith(
          tvState: RequestState.Loading,
          tv: testTvDetail,
          recommendationState: RequestState.Loaded,
          tvRecommendations: tTvList,
        ),
        tInitialState.copyWith(
          tvState: RequestState.Loaded,
          tv: testTvDetail,
          recommendationState: RequestState.Loaded,
          tvRecommendations: tTvList,
        ),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
      },
    );
  });

  group('Watchlist Operations', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit success message and update status when adding to watchlist',
      setUp: () {
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
      },
      build: () => tvDetailBloc,
      act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),
      expect: () => [
        // Each state must be a complete object
        tInitialState.copyWith(watchlistMessage: 'Added to Watchlist'),
        tInitialState.copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
    );

   blocTest<TvDetailBloc, TvDetailState>(
    'should emit failure message when adding to watchlist fails',
    setUp: () {
      when(mockSaveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('DB Failure')));
      when(mockGetWatchlistTvStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
    },
    build: () => tvDetailBloc,
    act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),

    expect: () => [
      tInitialState.copyWith(
        watchlistMessage: 'DB Failure',
        isAddedToWatchlist: false,
      ),
    ],
);
  });
}