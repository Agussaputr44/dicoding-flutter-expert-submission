import 'package:dartz/dartz.dart';
import '../../../common/failure.dart';
import '../../entities/tv_entities/tv_detail.dart';
import '../../repositories/tv_repository.dart';

class SaveWatchlistTv {
  final TvRepository _repository;
  SaveWatchlistTv(this._repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return _repository.saveWatchlist(tv);
  }
}
