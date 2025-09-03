import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../../entities/tv_entities/tv.dart';
import '../../repositories/tv_repository.dart';

class GetTopRatedTVs {
  final TvRepository _repository;

  GetTopRatedTVs(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getTopRatedTVs();
  }
}
