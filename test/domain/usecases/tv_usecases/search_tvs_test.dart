import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/search_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

// Mock class

void main() {
  late SearchTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTvs(mockTvRepository);
  });

  const tQuery = 'Test Show';

  final tTv = Tv(
    adult: false,
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2020-01-01',
    genreIds: [18],
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
  );
  final tTvList = <Tv>[tTv];

  test('should return list of TVs when search is successful', () async {
    // arrange
    when(mockTvRepository.searchTVs(tQuery))
        .thenAnswer((_) async => Right(tTvList));

    // act
    final result = await usecase.execute(tQuery);

    // assert
    expect(result, Right(tTvList));
    verify(mockTvRepository.searchTVs(tQuery)).called(1);
    verifyNoMoreInteractions(mockTvRepository);
  });

  test('should return failure when search fails', () async {
    // arrange
    when(mockTvRepository.searchTVs(tQuery))
        .thenAnswer((_) async => Left(ServerFailure('Server error')));

    // act
    final result = await usecase.execute(tQuery);

    // assert
    expect(result, Left(ServerFailure('Server error')));
    verify(mockTvRepository.searchTVs(tQuery)).called(1);
    verifyNoMoreInteractions(mockTvRepository);
  });
}
