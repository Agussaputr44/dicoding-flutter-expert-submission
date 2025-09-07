import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/entities/tv_entities/tv_detail.dart';
import 'package:ditonton/presentation/pages/tv_pages/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailNotifier])
void main() {
  late MockTvDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  final tTvDetail = TvDetail(
    adult: false,
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2020-01-01',
    originCountry: ["US"],
    originalLanguage: 'en',
    originalName: 'Original Test',
    id: 1,
    popularity: 100,
    voteCount: 100,
    numberOfEpisodes: 12,
    numberOfSeasons: 2,
    status: "Ended",
    type: "Scripted",
    tagline: "Tagline",
    name: 'Test Show',
    overview: 'Overview',
    posterPath: '/test.jpg',
    voteAverage: 8.0,
    genres: [],
    episodeRuntime: [60],
  );

  final tTvList = <Tv>[
    Tv(
      genreIds: [18],
      adult: false,
      backdropPath: '/backdrop.jpg',
      firstAirDate: '2020-01-01',
      originCountry: ["US"],
      originalLanguage: 'en',
      originalName: 'Original Test',
      id: 1,
      popularity: 100,
      voteCount: 100,
      name: 'Test Show',
      overview: 'Overview',
      posterPath: '/test.jpg',
      voteAverage: 8.0,
    )
  ];

  testWidgets('should display CircularProgressIndicator when tvState is Loading',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loading);
    when(mockNotifier.tvRecommendations).thenReturn([]);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loading);
    when(mockNotifier.message).thenReturn('');

    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });




  testWidgets('should display error message when tvState is Error',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error Message');
    when(mockNotifier.recommendationState).thenReturn(RequestState.Error);

    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.text('Error Message'), findsOneWidget);
  });

  testWidgets('should show SnackBar when adding to watchlist succeeds',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(tTvDetail);
    when(mockNotifier.tvRecommendations).thenReturn([]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage)
        .thenReturn(TvDetailNotifier.watchlistAddSuccessMessage);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.message).thenReturn('');

    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

    final button = find.byType(FilledButton);
    await tester.tap(button);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(TvDetailNotifier.watchlistAddSuccessMessage), findsOneWidget);
  });

  testWidgets('should show AlertDialog when adding to watchlist fails',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(tTvDetail);
    when(mockNotifier.tvRecommendations).thenReturn([]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.message).thenReturn('');

    await tester.pumpWidget(makeTestableWidget(TvDetailPage(id: 1)));

    final button = find.byType(FilledButton);
    await tester.tap(button);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
