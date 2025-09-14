import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/presentation/bloc/on_airing_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/on_airing_tv_event.dart';
import 'package:ditonton/presentation/bloc/on_airing_tv_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import your project files
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_on_airing_tvs.dart';

import '../../dummy_data/dummy_objects.dart'; 
import 'on_airing_tv_bloc_test.mocks.dart';

@GenerateMocks([GetOnAiringTVs])
void main() {
  late OnAiringTvBloc onAiringTvBloc;
  late MockGetOnAiringTVs mockGetOnAiringTvs;

  setUp(() {
    mockGetOnAiringTvs = MockGetOnAiringTVs();
    onAiringTvBloc = OnAiringTvBloc(
      getOnAiringTvs: mockGetOnAiringTvs,
    );
  });

  // Dummy TV list for testing
  final tTvList = <Tv>[testTv];

  test('initial state should be empty', () {
    expect(
      onAiringTvBloc.state,
      const OnAiringTvState(
        tvs: [],
        state: RequestState.Empty,
        message: '',
      ),
    );
  });

  group('FetchOnAiringTvs', () {
    blocTest<OnAiringTvBloc, OnAiringTvState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetOnAiringTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
      },
      build: () => onAiringTvBloc,
      act: (bloc) => bloc.add(FetchOnAiringTvs()),
      expect: () => [
        const OnAiringTvState(
          tvs: [],
          state: RequestState.Loading,
          message: '',
        ),
        OnAiringTvState(
          tvs: tTvList,
          state: RequestState.Loaded,
          message: '',
        ),
      ],
      verify: (_) => verify(mockGetOnAiringTvs.execute()),
    );

    blocTest<OnAiringTvBloc, OnAiringTvState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      setUp: () {
        when(mockGetOnAiringTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => onAiringTvBloc,
      act: (bloc) => bloc.add(FetchOnAiringTvs()),
      expect: () => [
        const OnAiringTvState(
          tvs: [],
          state: RequestState.Loading,
          message: '',
        ),
        const OnAiringTvState(
          tvs: [],
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockGetOnAiringTvs.execute()),
    );
  });
}