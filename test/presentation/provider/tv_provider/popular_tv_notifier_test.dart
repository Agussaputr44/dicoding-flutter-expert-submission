import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_popular_tvs.dart';
import 'package:ditonton/presentation/provider/tv_provider/popular_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTVs])
void main() {
  late PopularTvNotifier notifier;
  late MockGetPopularTVs mockGetPopularTVs;

  setUp(() {
    mockGetPopularTVs = MockGetPopularTVs();
    notifier = PopularTvNotifier(mockGetPopularTVs);
  });

  final tTv = Tv(
    id: 1,
    name: 'Test Popular Show',
    overview: 'Overview text',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    popularity: 20.0,
    voteAverage: 7.5,
    voteCount: 200,
    firstAirDate: '2020-05-01',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'Original Popular Show',
    genreIds: const [35],
    adult: false,
  );
  final tTvList = <Tv>[tTv];

  group('fetch Popular TVs', () {
    test('should change state to Loading then Loaded when data is fetched successfully', () async {
      // arrange
      when(mockGetPopularTVs.execute())
          .thenAnswer((_) async => Right(tTvList));

      // act
      final future = notifier.fetchPopularTvs();

      // assert Loading state
      expect(notifier.state, RequestState.Loading);

      await future;

      // assert Loaded state
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.tvs, tTvList);
    });

    test('should change state to Error when fetching data fails', () async {
      // arrange
      when(mockGetPopularTVs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Failed to fetch popular TVs')));

      // act
      await notifier.fetchPopularTvs();

      // assert
      expect(notifier.state, RequestState.Error);
      expect(notifier.message, 'Failed to fetch popular TVs');
    });
  });
}
