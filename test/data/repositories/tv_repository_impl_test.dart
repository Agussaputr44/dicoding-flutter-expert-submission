import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/common_models/watchlist_table.dart';
import 'package:ditonton/data/models/tv_models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_models/tv_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDatasource mockRemoteDatasource;
  late MockTvLocalDatasource mockLocalDatasource;

  setUp(() {
    mockRemoteDatasource = MockTvRemoteDatasource();
    mockLocalDatasource = MockTvLocalDatasource();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDatasource,
      localDataSource: mockLocalDatasource,
    );
  });

  // ---- Test data
  final tTvModel = TvModel(
    adult: false,
    backdropPath: '/backdrop.jpg',
    genreIds: const [18],
    id: 1,
    name: 'Test Show',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'Original Test Show',
    overview: 'Overview text here',
    popularity: 100.0,
    posterPath: '/poster.jpg',
    firstAirDate: '2020-01-01',
    voteAverage: 8.0,
    voteCount: 120,
  );

  final tTv = tTvModel.toEntity();
  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  const tId = 1;

  final tTvDetailModel = TvDetailModel(
    adult: false,
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2020-01-01',
    genres: const [],
    id: tId,
    name: 'Test Show',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'Original Test Show',
    overview: 'Overview text here',
    popularity: 100.0,
    posterPath: '/poster.jpg',
    voteAverage: 8.0,
    voteCount: 120,
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    status: 'Running',
    tagline: 'Best Show',
    type: 'Scripted',
  );

  final tTvDetail = tTvDetailModel.toEntity();

  group('On Airing TVs', () {
    test('should return TV list when remote data source is successful', () async {
      // arrange
      when(mockRemoteDatasource.getOnAiringTVs())
          .thenAnswer((_) async => tTvModelList);

      // act
      final result = await repository.getOnAiringTVs();

      // assert
      result.fold(
        (l) => fail('Expected Right but got Left: $l'),
        (r) => expect(r, equals(tTvList)), // deep equals on list
      );
      verify(mockRemoteDatasource.getOnAiringTVs()).called(1);
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return server failure when server exception', () async {
      when(mockRemoteDatasource.getOnAiringTVs()).thenThrow(ServerException());

      final result = await repository.getOnAiringTVs();

      expect(result, equals(Left(ServerFailure(''))));
      verify(mockRemoteDatasource.getOnAiringTVs()).called(1);
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return connection failure when SocketException', () async {
      when(mockRemoteDatasource.getOnAiringTVs())
          .thenThrow(const SocketException('No connection'));

      final result = await repository.getOnAiringTVs();

      expect(
        result,
        equals(Left(ConnectionFailure('Failed to connect to the network'))),
      );
      verify(mockRemoteDatasource.getOnAiringTVs()).called(1);
      verifyNoMoreInteractions(mockRemoteDatasource);
    });
  });

  group('TV Detail', () {
    test('should return TV Detail when remote data source is successful', () async {
      when(mockRemoteDatasource.getTVDetail(tId))
          .thenAnswer((_) async => tTvDetailModel);

      final result = await repository.getTVDetail(tId);

      result.fold(
        (l) => fail('Expected Right but got Left: $l'),
        (r) => expect(r, equals(tTvDetail)),
      );
      verify(mockRemoteDatasource.getTVDetail(tId)).called(1);
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return failure when server throws', () async {
      when(mockRemoteDatasource.getTVDetail(tId)).thenThrow(ServerException());

      final result = await repository.getTVDetail(tId);

      expect(result, equals(Left(ServerFailure(''))));
      verify(mockRemoteDatasource.getTVDetail(tId)).called(1);
      verifyNoMoreInteractions(mockRemoteDatasource);
    });
  });

  group('Recommendations', () {
    test('should return TV list when successful', () async {
      when(mockRemoteDatasource.getTVRecommendations(tId))
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getTVRecommendations(tId);

      result.fold(
        (l) => fail('Expected Right but got Left: $l'),
        (r) => expect(r, equals(tTvList)),
      );
      verify(mockRemoteDatasource.getTVRecommendations(tId)).called(1);
      verifyNoMoreInteractions(mockRemoteDatasource);
    });
  });

  group('Popular TVs', () {
    test('should return TV list when successful', () async {
      when(mockRemoteDatasource.getPopularTVs())
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getPopularTVs();

      result.fold(
        (l) => fail('Expected Right but got Left: $l'),
        (r) => expect(r, equals(tTvList)),
      );
      verify(mockRemoteDatasource.getPopularTVs()).called(1);
      verifyNoMoreInteractions(mockRemoteDatasource);
    });
  });

  group('Top Rated TVs', () {
    test('should return TV list when successful', () async {
      when(mockRemoteDatasource.getTopRatedTVs())
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getTopRatedTVs();

      result.fold(
        (l) => fail('Expected Right but got Left: $l'),
        (r) => expect(r, equals(tTvList)),
      );
      verify(mockRemoteDatasource.getTopRatedTVs()).called(1);
      verifyNoMoreInteractions(mockRemoteDatasource);
    });
  });

  group('Search TVs', () {
    test('should return TV list when successful', () async {
      when(mockRemoteDatasource.searchTVs('test'))
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.searchTVs('test');

      result.fold(
        (l) => fail('Expected Right but got Left: $l'),
        (r) => expect(r, equals(tTvList)),
      );
      verify(mockRemoteDatasource.searchTVs('test')).called(1);
      verifyNoMoreInteractions(mockRemoteDatasource);
    });
  });

  group('Watchlist', () {
    test('should return success message when insert successful', () async {
      when(mockLocalDatasource
              .insertWatchlist(WatchlistTable.fromTvEntity(testTvDetail)))
          .thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(testTvDetail);

      expect(result, equals(const Right('Added to Watchlist')));
      verify(mockLocalDatasource
              .insertWatchlist(WatchlistTable.fromTvEntity(testTvDetail)))
          .called(1);
      verifyNoMoreInteractions(mockLocalDatasource);
    });

    test('should return failure when insert throws DatabaseException', () async {
      when(mockLocalDatasource
              .insertWatchlist(WatchlistTable.fromTvEntity(testTvDetail)))
          .thenThrow( DatabaseException('DB Error'));

      final result = await repository.saveWatchlist(testTvDetail);

      expect(result, equals(const Left(DatabaseFailure('DB Error'))));
      verify(mockLocalDatasource
              .insertWatchlist(WatchlistTable.fromTvEntity(testTvDetail)))
          .called(1);
      verifyNoMoreInteractions(mockLocalDatasource);
    });

    test('should return success message when remove successful', () async {
      when(mockLocalDatasource
              .removeWatchlist(WatchlistTable.fromTvEntity(testTvDetail)))
          .thenAnswer((_) async => 'Removed from Watchlist');

      final result = await repository.removeWatchlist(testTvDetail);

      expect(result, equals(const Right('Removed from Watchlist')));
      verify(mockLocalDatasource
              .removeWatchlist(WatchlistTable.fromTvEntity(testTvDetail)))
          .called(1);
      verifyNoMoreInteractions(mockLocalDatasource);
    });

    test('should return watchlist TV list', () async {
      when(mockLocalDatasource.getWatchlistTvs())
          .thenAnswer((_) async => [testWatchlistTable]);

      final result = await repository.getWatchlistTVs();

      result.fold(
        (l) => fail('Expected Right but got Left: $l'),
        (r) => expect(r, equals([testTvWatchlist])),
      );
      verify(mockLocalDatasource.getWatchlistTvs()).called(1);
      verifyNoMoreInteractions(mockLocalDatasource);
    });

    test('should return true when TV is added to watchlist', () async {
      when(mockLocalDatasource.getTvById(tId))
          .thenAnswer((_) async => testWatchlistTable);

      final result = await repository.isAddedToWatchlist(tId);

      expect(result, isTrue);
      verify(mockLocalDatasource.getTvById(tId)).called(1);
      verifyNoMoreInteractions(mockLocalDatasource);
    });

    test('should return false when TV is not added to watchlist', () async {
      when(mockLocalDatasource.getTvById(tId))
          .thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlist(tId);

      expect(result, isFalse);
      verify(mockLocalDatasource.getTvById(tId)).called(1);
      verifyNoMoreInteractions(mockLocalDatasource);
    });
  });
}
