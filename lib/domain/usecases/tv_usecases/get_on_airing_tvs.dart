import 'package:dartz/dartz.dart';
import '../../../common/failure.dart';
import '../../entities/tv_entities/tv.dart';

import '../../repositories/tv_repository.dart';

class GetOnAiringTVs {
  final TvRepository _repository;

  GetOnAiringTVs(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getOnAiringTVs();
  }
}
