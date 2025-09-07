import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_on_airing_tvs.dart';
import 'package:ditonton/presentation/provider/tv_provider/on_airing_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'on_airing_tv_notifier_test.mocks.dart';

@GenerateMocks([GetOnAiringTVs])
void main() {
  late OnAiringTvNotifier notifier;
  late MockGetOnAiringTVs mockGetOnAiringTVs;

  setUp(() {
    mockGetOnAiringTVs = MockGetOnAiringTVs();
    notifier = OnAiringTvNotifier(getOnAiringTvs: mockGetOnAiringTVs);
  });

  final tTv = Tv(
    id: 1,
    name: 'Test Show',
    overview: 'Overview text',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    popularity: 10.0,
    voteAverage: 8.5,
    voteCount: 100,
    firstAirDate: '2020-01-01',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'Original Test Show',
    genreIds: const [18],
    adult: false,
  );
  final tTvList = <Tv>[tTv];

  group('fetch On Airing TVs', () {
    test('should change state to Loading then Loaded when data is fetched successfully', () async {
      // arrange
      when(mockGetOnAiringTVs.execute())
          .thenAnswer((_) async => Right(tTvList));

      // act
      final future = notifier.fetchOnAiringTvs();

      // assert Loading state
      expect(notifier.state, RequestState.Loading);

      await future;

      // assert Loaded state
      expect(notifier.state, RequestState.Loaded);
      expect(notifier.tvs, tTvList);
    });

    test('should change state to Error when fetching data fails', () async {
      // arrange
      when(mockGetOnAiringTVs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));

      // act
      await notifier.fetchOnAiringTvs();

      // assert
      expect(notifier.state, RequestState.Error);
      expect(notifier.message, 'Server Error');
    });
  });
}
