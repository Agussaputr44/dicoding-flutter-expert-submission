import 'package:ditonton/data/datasources/tv_datasources/tv_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/common_models/watchlist_table.dart';

import '../../../helpers/test_helper.mocks.dart';


void main() {
  late TvLocalDatasourceImpl datasource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    datasource = TvLocalDatasourceImpl(databaseHelper: mockDatabaseHelper);
  });

  const tWatchlistTable = WatchlistTable(
    id: 1,
    title: 'Test Show',
    overview: 'Overview',
    posterPath: 'poster.jpg',
    type: 'tv',
  );

  group('insertWatchlist', () {
    test('should return success message when insert succeeds', () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlist(tWatchlistTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await datasource.insertWatchlist(tWatchlistTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert fails', () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlist(tWatchlistTable))
          .thenThrow(Exception('fail'));
      // act
      final call = datasource.insertWatchlist(tWatchlistTable);
      // assert
      expect(call, throwsA(isA<DatabaseException>()));
    });
  });

  group('removeWatchlist', () {
    test('should return success message when remove succeeds', () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlist(tWatchlistTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await datasource.removeWatchlist(tWatchlistTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove fails', () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlist(tWatchlistTable))
          .thenThrow(Exception('fail'));
      // act
      final call = datasource.removeWatchlist(tWatchlistTable);
      // assert
      expect(call, throwsA(isA<DatabaseException>()));
    });
  });

  group('getTvById', () {
    test('should return WatchlistTable when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getEntityById(1, "tv")).thenAnswer((_) async => {
            'id': 1,
            'title': 'Test Show',
            'overview': 'Overview',
            'posterPath': 'poster.jpg',
            'type': 'tv',
          });
      // act
      final result = await datasource.getTvById(1);
      // assert
      expect(result, isA<WatchlistTable>());
      expect(result?.id, 1);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getEntityById(1, "tv")).thenAnswer((_) async => null);
      // act
      final result = await datasource.getTvById(1);
      // assert
      expect(result, null);
    });
  });
group('getWatchlistTvs', () {
  test('should return list of WatchlistTable', () async {
    // arrange
    when(mockDatabaseHelper.getWatchlistsByType('tv')).thenAnswer((_) async => [
          {
            'id': 1,
            'title': 'Test Show',
            'overview': 'Overview',
            'posterPath': 'poster.jpg',
            'type': 'tv',
          }
        ]);
    // act
    final result = await datasource.getWatchlistTvs();
    // assert
    expect(result, isA<List<WatchlistTable>>());
    expect(result.first.title, 'Test Show');
  });
});

}
