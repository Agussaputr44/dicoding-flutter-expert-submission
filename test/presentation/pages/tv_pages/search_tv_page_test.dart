import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_pages/search_tv_page.dart';
import 'package:ditonton/presentation/provider/tv_provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'search_tv_page_test.mocks.dart';

@GenerateMocks([TvSearchNotifier])
void main() {
  late MockTvSearchNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvSearchNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSearchNotifier>.value(
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
    when(mockNotifier.state).thenReturn(RequestState.Loading);
    when(mockNotifier.searchResult).thenReturn([]);

    await tester.pumpWidget(makeTestableWidget(const SearchTvPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when data loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.searchResult).thenReturn([tTv]);

    await tester.pumpWidget(makeTestableWidget(const SearchTvPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
  });

  testWidgets('should call fetchMovieSearch when query submitted',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Empty);
    when(mockNotifier.searchResult).thenReturn([]);

    await tester.pumpWidget(makeTestableWidget(const SearchTvPage()));

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'Breaking Bad');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    verify(mockNotifier.fetchMovieSearch('Breaking Bad'));
  });
}