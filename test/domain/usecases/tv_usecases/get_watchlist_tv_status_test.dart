import 'package:ditonton/domain/usecases/tv_usecases/get_watchlist_tv_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';
void main() {
  late GetWatchlistTvStatus usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistTvStatus(mockTvRepository);
  });

  const tId = 1;

  test('should return true when TV is added to watchlist', () async {
    // arrange
    when(mockTvRepository.isAddedToWatchlist(tId))
        .thenAnswer((_) async => true);

    // act
    final result = await usecase.execute(tId);

    // assert
    expect(result, true);
    verify(mockTvRepository.isAddedToWatchlist(tId)).called(1);
    verifyNoMoreInteractions(mockTvRepository);
  });

  test('should return false when TV is not added to watchlist', () async {
    // arrange
    when(mockTvRepository.isAddedToWatchlist(tId))
        .thenAnswer((_) async => false);

    // act
    final result = await usecase.execute(tId);

    // assert
    expect(result, false);
    verify(mockTvRepository.isAddedToWatchlist(tId)).called(1);
    verifyNoMoreInteractions(mockTvRepository);
  });
}
