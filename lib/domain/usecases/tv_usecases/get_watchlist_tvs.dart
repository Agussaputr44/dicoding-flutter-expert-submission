import 'package:dartz/dartz.dart';
import '../../entities/tv_entities/tv.dart';
import '../../repositories/tv_repository.dart';

import '../../../common/failure.dart';

class GetWatchlistTvs {
  final TvRepository _repository;

  GetWatchlistTvs(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getWatchlistTVs();
  }
}
