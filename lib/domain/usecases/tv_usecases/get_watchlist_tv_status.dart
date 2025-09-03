import '../../repositories/tv_repository.dart';

class GetWatchlistTvStatus {
  final TvRepository _repository;
  GetWatchlistTvStatus(this._repository);
  Future<bool> execute(int id) {
    return _repository.isAddedToWatchlist(id);
  }
}
