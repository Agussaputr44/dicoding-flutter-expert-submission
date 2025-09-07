import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_pages/watchlist_tv_page.dart';
import 'package:ditonton/presentation/provider/tv_provider/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'watchlist_tv_page_test.mocks.dart';

@GenerateMocks([WatchlistTvNotifier])
void main() {
  late MockWatchlistTvNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockWatchlistTvNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistTvNotifier>.value(
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

  testWidgets('should display CircularProgressIndicator when loading',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Loading);
    when(mockNotifier.watchlistTvs).thenReturn([]);

    await tester.pumpWidget(makeTestableWidget(const WatchlistTvPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when data loaded',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Loaded);
    when(mockNotifier.watchlistTvs).thenReturn([tTv]);

    await tester.pumpWidget(makeTestableWidget(const WatchlistTvPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
  });

  testWidgets('should display error message when state is Error',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error Message');

    await tester.pumpWidget(makeTestableWidget(const WatchlistTvPage()));

    final textFinder = find.byKey(Key('error_message'));
    expect(textFinder, findsOneWidget);
    expect(find.text('Error Message'), findsOneWidget);
  });
}