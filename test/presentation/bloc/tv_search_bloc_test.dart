import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/usecases/tv_usecases/search_tvs.dart';
import 'package:ditonton/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_search_event.dart';
import 'package:ditonton/presentation/bloc/tv_search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';



import '../../dummy_data/dummy_objects.dart';
import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvs])
void main() {
  late TvSearchBloc tvSearchBloc;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchTvs = MockSearchTvs();
    tvSearchBloc = TvSearchBloc(
      searchTvs: mockSearchTvs,
    );
  });

  final tTvList = <Tv>[testTv];
  const tQuery = 'game of thrones';
  const tInitialState = TvSearchState(
    searchResult: [],
    state: RequestState.Empty,
    message: '',
  );

  test('initial state should be correct', () {
    expect(tvSearchBloc.state, tInitialState);
  });

  group('Search TV Shows', () {
    blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      setUp: () {
        when(mockSearchTvs.execute(tQuery))
            .thenAnswer((_) async => Right(tTvList));
      },
      build: () => tvSearchBloc,
      act: (bloc) => bloc.add(const FetchTvSearch(tQuery)),
      expect: () => [
        // Each state must be a complete object
        tInitialState.copyWith(state: RequestState.Loading),
        tInitialState.copyWith(
          state: RequestState.Loaded,
          searchResult: tTvList,
        ),
      ],
      verify: (_) => verify(mockSearchTvs.execute(tQuery)),
    );

    blocTest<TvSearchBloc, TvSearchState>(
      'Should emit [Loading, Error] when get search is unsuccessful',
      setUp: () {
        when(mockSearchTvs.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      },
      build: () => tvSearchBloc,
      act: (bloc) => bloc.add(const FetchTvSearch(tQuery)),
      expect: () => [
        tInitialState.copyWith(state: RequestState.Loading),
        tInitialState.copyWith(
          state: RequestState.Error,
          message: 'Server Failure',
        ),
      ],
      verify: (_) => verify(mockSearchTvs.execute(tQuery)),
    );
  });
}