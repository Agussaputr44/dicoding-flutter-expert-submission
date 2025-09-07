import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/provider/tv_provider/top_rated_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedTVs])
void main() {
  late TopRatedTvNotifier notifier;
  late MockGetTopRatedTVs mockGetTopRatedTVs;

  setUp(() {
    mockGetTopRatedTVs = MockGetTopRatedTVs();
    notifier = TopRatedTvNotifier(getTopRatedTvs: mockGetTopRatedTVs);
  });

  final tTv = Tv(
    id: 1,
    name: 'Top Rated Show',
    overview: 'Overview of top rated',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    popularity: 30.0,
    voteAverage: 8.5,
    voteCount: 1500,
    firstAirDate: '2019-01-01',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'Original Top Rated Show',
    genreIds: const [18, 80],
    adult: false,
  );
  final tTvList = <Tv>[tTv];

  group('fetch Top Rated TVs', () {
    test('should change state to Loading then Loaded when data fetched successfully', () async {
      // arrange
      when(mockGetTopRatedTVs.execute())
          .thenAnswer((_) async => Right(tTvList));

      // act
      final future = notifier.fetchTopRatedTvs();

      // assert while loading
      expect(notifier.state, RequestState.Loading);

      await future;

      // assert when loaded
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.tvs, tTvList);
    });

    test('should change state to Error when fetching data fails', () async {
      // arrange
      when(mockGetTopRatedTVs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Failed to fetch top rated')));

      // act
      await notifier.fetchTopRatedTvs();

      // assert
      expect(notifier.state, RequestState.Error);
      expect(notifier.message, 'Failed to fetch top rated');
    });
  });
}
