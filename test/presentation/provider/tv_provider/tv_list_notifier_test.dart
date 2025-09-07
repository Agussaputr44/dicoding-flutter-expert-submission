import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_on_airing_tvs.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/provider/tv_provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetOnAiringTVs,
  GetPopularTVs,
  GetTopRatedTVs,
])
void main() {
  late TvListNotifier notifier;
  late MockGetOnAiringTVs mockGetOnAiringTVs;
  late MockGetPopularTVs mockGetPopularTVs;
  late MockGetTopRatedTVs mockGetTopRatedTVs;

  setUp(() {
    mockGetOnAiringTVs = MockGetOnAiringTVs();
    mockGetPopularTVs = MockGetPopularTVs();
    mockGetTopRatedTVs = MockGetTopRatedTVs();
    notifier = TvListNotifier(
      getOnAiringTvs: mockGetOnAiringTVs,
      getPopularTvs: mockGetPopularTVs,
      getTopRatedTvs: mockGetTopRatedTVs,
    );
  });

  final tTv = Tv(
    id: 1,
    name: 'Test Show',
    overview: 'Overview',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    popularity: 10.0,
    voteAverage: 8.0,
    voteCount: 100,
    firstAirDate: '2020-01-01',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'Original Test',
    genreIds: const [18],
    adult: false,
  );

  final tTvList = <Tv>[tTv];

  group('On Airing TVs', () {
    test('should change state to Loading then Loaded when data fetched successfully', () async {
      when(mockGetOnAiringTVs.execute())
          .thenAnswer((_) async => Right(tTvList));

      final future = notifier.fetchOnAiringTvs();
      expect(notifier.onAiringState, RequestState.Loading);

      await future;

      expect(notifier.onAiringState, RequestState.Loaded);
      expect(notifier.onAiringTvs, tTvList);
    });

    test('should return error message when fetch failed', () async {
      when(mockGetOnAiringTVs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));

      await notifier.fetchOnAiringTvs();

      expect(notifier.onAiringState, RequestState.Error);
      expect(notifier.message, 'Server Error');
    });
  });

  group('Popular TVs', () {
    test('should change state to Loading then Loaded when data fetched successfully', () async {
      when(mockGetPopularTVs.execute())
          .thenAnswer((_) async => Right(tTvList));

      final future = notifier.fetchPopularTvs();
      expect(notifier.popularTvsState, RequestState.Loading);

      await future;

      expect(notifier.popularTvsState, RequestState.Loaded);
      expect(notifier.popularTvs, tTvList);
    });

    test('should return error message when fetch failed', () async {
      when(mockGetPopularTVs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));

      await notifier.fetchPopularTvs();

      expect(notifier.popularTvsState, RequestState.Error);
      expect(notifier.message, 'Server Error');
    });
  });

  group('Top Rated TVs', () {
    test('should change state to Loading then Loaded when data fetched successfully', () async {
      when(mockGetTopRatedTVs.execute())
          .thenAnswer((_) async => Right(tTvList));

      final future = notifier.fetchTopRatedTvs();
      expect(notifier.topRatedTvsState, RequestState.Loading);

      await future;

      expect(notifier.topRatedTvsState, RequestState.Loaded);
      expect(notifier.topRatedTvs, tTvList);
    });

    test('should return error message when fetch failed', () async {
      when(mockGetTopRatedTVs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));

      await notifier.fetchTopRatedTvs();

      expect(notifier.topRatedTvsState, RequestState.Error);
      expect(notifier.message, 'Server Error');
    });
  });
}
