import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_pages/on_airing_tv_page.dart';
import 'package:ditonton/presentation/provider/tv_provider/on_airing_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'on_airing_tv_page_test.mocks.dart';

@GenerateMocks([OnAiringTvNotifier])
void main() {
  late MockOnAiringTvNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockOnAiringTvNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<OnAiringTvNotifier>.value(
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
    when(mockNotifier.tvs).thenReturn([]);

    await tester.pumpWidget(makeTestableWidget(const OnAiringTvPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should display ListView when data loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvs).thenReturn([tTv]);

    await tester.pumpWidget(makeTestableWidget(const OnAiringTvPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
  });

  testWidgets('should display error message when state is Error',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('Error Message');

    await tester.pumpWidget(makeTestableWidget(const OnAiringTvPage()));

    final textFinder = find.byKey(Key('error_message'));
    expect(textFinder, findsOneWidget);
    expect(find.text('Error Message'), findsOneWidget);
  });
}
