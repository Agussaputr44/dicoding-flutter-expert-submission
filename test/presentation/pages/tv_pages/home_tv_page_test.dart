import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_pages/home_tv_page.dart';
import 'package:ditonton/presentation/provider/tv_provider/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'home_tv_page_test.mocks.dart';

@GenerateMocks([TvListNotifier])
void main() {
  late MockTvListNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvListNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvListNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  final tTv = Tv(
    id: 1,
    name: 'Test Show',
    overview: 'Overview',
    posterPath: '/test.jpg',
    backdropPath: '/backdrop.jpg',
    popularity: 10,
    voteAverage: 8.0,
    voteCount: 100,
    firstAirDate: '2020-01-01',
    originCountry: const ['US'],
    originalLanguage: 'en',
    originalName: 'Original Test',
    genreIds: const [18],
    adult: false,
  );

  group('HomeTvPage Widget Tests', () {
    testWidgets('should show CircularProgressIndicator when loading',
        (tester) async {
      when(mockNotifier.onAiringState).thenReturn(RequestState.Loading);
      when(mockNotifier.popularTvsState).thenReturn(RequestState.Loading);
      when(mockNotifier.topRatedTvsState).thenReturn(RequestState.Loading);
      when(mockNotifier.onAiringTvs).thenReturn([]);
      when(mockNotifier.popularTvs).thenReturn([]);
      when(mockNotifier.topRatedTvs).thenReturn([]);

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));

      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    });

    testWidgets('should show TvList when data loaded', (tester) async {
      when(mockNotifier.onAiringState).thenReturn(RequestState.Loaded);
      when(mockNotifier.popularTvsState).thenReturn(RequestState.Loaded);
      when(mockNotifier.topRatedTvsState).thenReturn(RequestState.Loaded);
      when(mockNotifier.onAiringTvs).thenReturn([tTv]);
      when(mockNotifier.popularTvs).thenReturn([tTv]);
      when(mockNotifier.topRatedTvs).thenReturn([tTv]);

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));

      expect(find.byType(TvList), findsNWidgets(3));
    });

    testWidgets('should show Failed text when state is Error', (tester) async {
      when(mockNotifier.onAiringState).thenReturn(RequestState.Error);
      when(mockNotifier.popularTvsState).thenReturn(RequestState.Error);
      when(mockNotifier.topRatedTvsState).thenReturn(RequestState.Error);
      when(mockNotifier.onAiringTvs).thenReturn([]);
      when(mockNotifier.popularTvs).thenReturn([]);
      when(mockNotifier.topRatedTvs).thenReturn([]);

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));

      expect(find.text('Failed'), findsNWidgets(3));
    });

    testWidgets('should display AppBar with title', (tester) async {
      when(mockNotifier.onAiringState).thenReturn(RequestState.Loading);
      when(mockNotifier.popularTvsState).thenReturn(RequestState.Loading);
      when(mockNotifier.topRatedTvsState).thenReturn(RequestState.Loading);
      when(mockNotifier.onAiringTvs).thenReturn([]);
      when(mockNotifier.popularTvs).thenReturn([]);
      when(mockNotifier.topRatedTvs).thenReturn([]);

      await tester.pumpWidget(makeTestableWidget(const HomeTvPage()));

      expect(find.text('TV Shows'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}