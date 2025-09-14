import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import your project files
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_on_airing_tvs.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/bloc/tv_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_list_event.dart';
import 'package:ditonton/presentation/bloc/tv_list_state.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetOnAiringTVs, GetPopularTVs, GetTopRatedTVs])
void main() {
  late TvListBloc tvListBloc;
  late MockGetOnAiringTVs mockGetOnAiringTvs;
  late MockGetPopularTVs mockGetPopularTvs;
  late MockGetTopRatedTVs mockGetTopRatedTvs;

  setUp(() {
    mockGetOnAiringTvs = MockGetOnAiringTVs();
    mockGetPopularTvs = MockGetPopularTVs();
    mockGetTopRatedTvs = MockGetTopRatedTVs();
    tvListBloc = TvListBloc(
      getOnAiringTvs: mockGetOnAiringTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    );
  });

  final tTvList = <Tv>[testTv];

  const tInitialState = TvListState(
    onAiringTvs: [],
    onAiringState: RequestState.Empty,
    popularTvs: [],
    popularTvsState: RequestState.Empty,
    topRatedTvs: [],
    topRatedTvsState: RequestState.Empty,
    message: '',
  );

  test('initial state should be correct', () {
    expect(tvListBloc.state, tInitialState);
  });

  group('On Airing TVs', () {
    blocTest<TvListBloc, TvListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetOnAiringTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
      },
      build: () => tvListBloc,
      act: (bloc) => bloc.add(FetchOnAiringTvs()),
      expect: () => [
        tInitialState.copyWith(onAiringState: RequestState.Loading),
        tInitialState.copyWith(
          onAiringState: RequestState.Loaded,
          onAiringTvs: tTvList,
        ),
      ],
      verify: (_) => verify(mockGetOnAiringTvs.execute()),
    );
  });

  group('Popular TVs', () {
    blocTest<TvListBloc, TvListState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
      },
      build: () => tvListBloc,
      act: (bloc) => bloc.add(FetchPopularTvs()),
      expect: () => [
        tInitialState.copyWith(popularTvsState: RequestState.Loading),
        tInitialState.copyWith(
          popularTvsState: RequestState.Loaded,
          popularTvs: tTvList,
        ),
      ],
      verify: (_) => verify(mockGetPopularTvs.execute()),
    );

    blocTest<TvListBloc, TvListState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      setUp: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => tvListBloc,
      act: (bloc) => bloc.add(FetchPopularTvs()),
      expect: () => [
        tInitialState.copyWith(popularTvsState: RequestState.Loading),
        tInitialState.copyWith(
          popularTvsState: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockGetPopularTvs.execute()),
    );
  });
  
}