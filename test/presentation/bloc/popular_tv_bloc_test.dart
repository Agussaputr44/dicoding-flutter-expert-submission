import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_tv_event.dart';
import 'package:ditonton/presentation/bloc/popular_tv_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Import your project files
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv_usecases/get_popular_tvs.dart';

import '../../dummy_data/dummy_objects.dart'; 
import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTVs])
void main() {
  late PopularTvBloc popularTvBloc;
  late MockGetPopularTVs mockGetPopularTvs;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTVs();
    popularTvBloc = PopularTvBloc(
      getPopularTvs: mockGetPopularTvs,
    );
  });

  // Dummy TV list for testing
  final tTvList = <Tv>[testTv];

  test('initial state should be empty', () {
    expect(
      popularTvBloc.state,
      const PopularTvState(
        tvs: [],
        state: RequestState.Empty,
        message: '',
      ),
    );
  });

  group('FetchPopularTvs', () {
    blocTest<PopularTvBloc, PopularTvState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
      },
      build: () => popularTvBloc,
      act: (bloc) => bloc.add(FetchPopularTvs()),
      expect: () => [
        const PopularTvState(
          tvs: [],
          state: RequestState.Loading,
          message: '',
        ),
        PopularTvState(
          tvs: tTvList,
          state: RequestState.Loaded,
          message: '',
        ),
      ],
      verify: (_) => verify(mockGetPopularTvs.execute()),
    );

    blocTest<PopularTvBloc, PopularTvState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      setUp: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => popularTvBloc,
      act: (bloc) => bloc.add(FetchPopularTvs()),
      expect: () => [
        const PopularTvState(
          tvs: [],
          state: RequestState.Loading,
          message: '',
        ),
        const PopularTvState(
          tvs: [],
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockGetPopularTvs.execute()),
    );
  });
}