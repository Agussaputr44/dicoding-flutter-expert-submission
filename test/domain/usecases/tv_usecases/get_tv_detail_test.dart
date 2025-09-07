import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';
void main() {
  late GetTVDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTVDetail(mockTvRepository);
  });

  const tId = 1;

  final tTvDetail = TvDetail(
    adult: false,
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2020-01-01',
    genres: [],
    id: tId,
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

  test('should get TV detail from the repository when execute is called', () async {
    // arrange
    when(mockTvRepository.getTVDetail(tId))
        .thenAnswer((_) async => Right(tTvDetail));

    // act
    final result = await usecase.execute(tId);

    // assert
    expect(result, Right(tTvDetail));
    verify(mockTvRepository.getTVDetail(tId)).called(1);
    verifyNoMoreInteractions(mockTvRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    when(mockTvRepository.getTVDetail(tId))
        .thenAnswer((_) async => Left(ServerFailure('Server error')));

    // act
    final result = await usecase.execute(tId);

    // assert
    expect(result, Left(ServerFailure('Server error')));
    verify(mockTvRepository.getTVDetail(tId)).called(1);
    verifyNoMoreInteractions(mockTvRepository);
  });
}
