import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import your project files
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_watchlist_tvs.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_state.dart';

import '../../dummy_data/dummy_objects.dart'; // Make sure this path is correct
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
void main() {
  late WatchlistTvBloc watchlistTvBloc;
  late MockGetWatchlistTvs mockGetWatchlistTvs;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    watchlistTvBloc = WatchlistTvBloc(
      getWatchlistTvs: mockGetWatchlistTvs,
    );
  });

  final tTvList = <Tv>[testTv];

  test('initial state should be empty', () {
    expect(
      watchlistTvBloc.state,
      const WatchlistTvState(
        watchlistTvs: [],
        state: RequestState.Empty,
        message: '',
      ),
    );
  });

  group('Fetch Watchlist TV Shows', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
      },
      build: () => watchlistTvBloc,
      act: (bloc) => bloc.add(FetchWatchlistTvs()),
      expect: () => [
        const WatchlistTvState(
          watchlistTvs: [],
          state: RequestState.Loading,
          message: '',
        ),
        WatchlistTvState(
          watchlistTvs: tTvList,
          state: RequestState.Loaded,
          message: '',
        ),
      ],
      verify: (_) => verify(mockGetWatchlistTvs.execute()),
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      setUp: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => watchlistTvBloc,
      act: (bloc) => bloc.add(FetchWatchlistTvs()),
      expect: () => [
        const WatchlistTvState(
          watchlistTvs: [],
          state: RequestState.Loading,
          message: '',
        ),
        const WatchlistTvState(
          watchlistTvs: [],
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockGetWatchlistTvs.execute()),
    );
  });
}