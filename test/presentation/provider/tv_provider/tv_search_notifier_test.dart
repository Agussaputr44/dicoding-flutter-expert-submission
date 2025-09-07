import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/search_tvs.dart';
import 'package:ditonton/presentation/provider/tv_provider/tv_search_notifier.dart';

import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTvs])
void main() {
  late TvSearchNotifier notifier;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchTvs = MockSearchTvs();
    notifier = TvSearchNotifier(searchTvs: mockSearchTvs);
  });

  final tTv = Tv(
    adult: false,
    backdropPath: '/path.jpg',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'Breaking Bad',
    popularity: 9.0,
    firstAirDate: '2008-01-20',
    genreIds: const [18],
    voteCount: 100,

    id: 1,
    name: 'Breaking Bad',
    posterPath: '/path.jpg',
    overview: 'Overview',
    voteAverage: 8.5,
  );
  final tTvList = <Tv>[tTv];
  final tQuery = 'Breaking Bad';

  test('should change state to Loading and then Loaded when data is gotten successfully', () async {
    // arrange
    when(mockSearchTvs.execute(tQuery)).thenAnswer((_) async => Right(tTvList));
    // act
    await notifier.fetchMovieSearch(tQuery);
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.searchResult, tTvList);
  });

  test('should return error when search unsuccessful', () async {
    // arrange
    when(mockSearchTvs.execute(tQuery)).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchMovieSearch(tQuery);
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
  });
}
