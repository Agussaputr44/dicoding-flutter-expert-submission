import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_watchlist_tv_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/entities/tv_entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/save_watchlist_tv.dart';

import 'tv_detail_notifier_test.mocks.dart';
import 'package:ditonton/presentation/provider/tv_provider/tv_detail_notifier.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetWatchlistTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvDetailNotifier notifier;
  late MockGetTVDetail mockGetTVDetail;
  late MockGetTVRecommendations mockGetTVRecommendations;
  late MockGetWatchlistTvStatus mockGetWatchListStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTVDetail = MockGetTVDetail();
    mockGetTVRecommendations = MockGetTVRecommendations();
    mockGetWatchListStatus = MockGetWatchlistTvStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();

    notifier = TvDetailNotifier(
      getTvDetail: mockGetTVDetail,
      getTvRecommendations: mockGetTVRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlistTv,
      removeWatchlist: mockRemoveWatchlistTv,
    );
  });

  final tId = 1;
  final tTvDetail = TvDetail(
    adult: false,
    backdropPath: '/path.jpg',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Breaking Bad',
    popularity: 9.0,
    voteAverage: 8.5,
    voteCount: 100,
    firstAirDate: '2008-01-20',
    id: 1,
    status: 'Ended',
    tagline: 'All bad things must come to an end',
    type: 'Scripted',
    name: 'Breaking Bad',
    overview: 'Overview',
    genres: [],
    numberOfEpisodes: 10,
    numberOfSeasons: 2,
    posterPath: '/path.jpg',
  );
  final tTvs = <Tv>[];

  group('Fetch TV Detail', () {
    test('should change state to Loading and then Loaded when data is gotten successfully', () async {
      // arrange
      when(mockGetTVDetail.execute(tId)).thenAnswer((_) async => Right(tTvDetail));
      when(mockGetTVRecommendations.execute(tId)).thenAnswer((_) async => Right(tTvs));
      // act
      await notifier.fetchTvDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.Loaded);
      expect(notifier.tv, tTvDetail);
      expect(notifier.recommendationState, RequestState.Loaded);
      expect(notifier.tvRecommendations, tTvs);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTVDetail.execute(tId)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTVRecommendations.execute(tId)).thenAnswer((_) async => Right(tTvs));
      // act
      await notifier.fetchTvDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
    });
  });

  group('Watchlist', () {
    test('should get watchlist status', () async {
      // arrange
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      // act
      await notifier.loadWatchlistStatus(tId);
      // assert
      expect(notifier.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => Right(TvDetailNotifier.watchlistAddSuccessMessage));
      when(mockGetWatchListStatus.execute(tTvDetail.id)).thenAnswer((_) async => true);
      // act
      await notifier.addWatchlist(tTvDetail);
      // assert
      verify(mockSaveWatchlistTv.execute(tTvDetail));
      expect(notifier.watchlistMessage, TvDetailNotifier.watchlistAddSuccessMessage);
      expect(notifier.isAddedToWatchlist, true);
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => Right(TvDetailNotifier.watchlistRemoveSuccessMessage));
      when(mockGetWatchListStatus.execute(tTvDetail.id)).thenAnswer((_) async => false);
      // act
      await notifier.removeFromWatchlist(tTvDetail);
      // assert
      verify(mockRemoveWatchlistTv.execute(tTvDetail));
      expect(notifier.watchlistMessage, TvDetailNotifier.watchlistRemoveSuccessMessage);
      expect(notifier.isAddedToWatchlist, false);
    });
  });
}
