import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_top_rated_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';
void main() {
  late GetTopRatedTVs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTopRatedTVs(mockTvRepository);
  });

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

  test('should get list of top rated TVs from the repository when execute is called', () async {
    // arrange
    when(mockTvRepository.getTopRatedTVs())
        .thenAnswer((_) async => Right(tTvList));

    // act
    final result = await usecase.execute();

    // assert
    expect(result, Right(tTvList));
    verify(mockTvRepository.getTopRatedTVs()).called(1);
    verifyNoMoreInteractions(mockTvRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    when(mockTvRepository.getTopRatedTVs())
        .thenAnswer((_) async => Left(ServerFailure('Server error')));

    // act
    final result = await usecase.execute();

    // assert
    expect(result, Left(ServerFailure('Server error')));
    verify(mockTvRepository.getTopRatedTVs()).called(1);
    verifyNoMoreInteractions(mockTvRepository);
  });
}
