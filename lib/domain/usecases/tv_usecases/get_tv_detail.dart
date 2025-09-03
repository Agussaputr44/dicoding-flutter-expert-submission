import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../../entities/tv_entities/tv_detail.dart';
import '../../repositories/tv_repository.dart';

class GetTVDetail {
  final TvRepository _repository;

  GetTVDetail(this._repository);

  Future<Either<Failure, TvDetail>> execute(int id) {
    return _repository.getTVDetail(id);
  }
}
