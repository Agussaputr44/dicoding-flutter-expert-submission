import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_event.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import your project files
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_top_rated_tvs.dart';

import '../../dummy_data/dummy_objects.dart'; // Make sure this path is correct and has a testTvList
import 'top_rated_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTVs])
void main() {
  late TopRatedTvBloc topRatedTvBloc;
  late MockGetTopRatedTVs mockGetTopRatedTvs;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTVs();
    topRatedTvBloc = TopRatedTvBloc(
      getTopRatedTvs: mockGetTopRatedTvs,
    );
  });

  // Dummy TV list for testing
  final tTvList = <Tv>[testTv];

  test('initial state should be empty', () {
    expect(
      topRatedTvBloc.state,
      const TopRatedTvState(
        tvs: [],
        state: RequestState.Empty,
        message: '',
      ),
    );
  });

  group('FetchTopRatedTvs', () {
    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
      },
      build: () => topRatedTvBloc,
      act: (bloc) => bloc.add(FetchTopRatedTvs()),
      expect: () => [
        const TopRatedTvState(
          tvs: [],
          state: RequestState.Loading,
          message: '',
        ),
        TopRatedTvState(
          tvs: tTvList,
          state: RequestState.Loaded,
          message: '',
        ),
      ],
      verify: (_) => verify(mockGetTopRatedTvs.execute()),
    );

    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      setUp: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => topRatedTvBloc,
      act: (bloc) => bloc.add(FetchTopRatedTvs()),
      expect: () => [
        const TopRatedTvState(
          tvs: [],
          state: RequestState.Loading,
          message: '',
        ),
        const TopRatedTvState(
          tvs: [],
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockGetTopRatedTvs.execute()),
    );
  });
}