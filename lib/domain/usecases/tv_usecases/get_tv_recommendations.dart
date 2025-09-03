import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../../entities/tv_entities/tv.dart';
import '../../repositories/tv_repository.dart';

class GetTVRecommendations {
  final TvRepository _repository;

  GetTVRecommendations(this._repository);

  Future<Either<Failure, List<Tv>>> execute(int id) {
    return _repository.getTVRecommendations(id);
  }
}
