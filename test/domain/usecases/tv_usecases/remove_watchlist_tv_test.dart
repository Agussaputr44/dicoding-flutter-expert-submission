import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv_usecases/remove_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

// Mock class

void main() {
  late RemoveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = RemoveWatchlistTv(mockTvRepository);
  });

  final tTvDetail = TvDetail(
    adult: false,
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2020-01-01',
    genres: [],
    id: 1,
    name: 'Test Show',
    originCountry: ['US'],
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
    episodeRuntime: [45],
  );

  test('should remove TV from watchlist in repository when execute is called', () async {
    // arrange
    when(mockTvRepository.removeWatchlist(tTvDetail))
        .thenAnswer((_) async => const Right('Removed from watchlist'));

    // act
    final result = await usecase.execute(tTvDetail);

    // assert
    expect(result, const Right('Removed from watchlist'));
    verify(mockTvRepository.removeWatchlist(tTvDetail)).called(1);
    verifyNoMoreInteractions(mockTvRepository);
  });

  test('should return failure when remove watchlist fails', () async {
    // arrange
    when(mockTvRepository.removeWatchlist(tTvDetail))
        .thenAnswer((_) async => Left(DatabaseFailure('Failed to remove')));

    // act
    final result = await usecase.execute(tTvDetail);

    // assert
    expect(result, Left(DatabaseFailure('Failed to remove')));
    verify(mockTvRepository.removeWatchlist(tTvDetail)).called(1);
    verifyNoMoreInteractions(mockTvRepository);
  });
}
