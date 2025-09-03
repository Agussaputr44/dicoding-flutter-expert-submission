import 'package:dartz/dartz.dart';

import '../../../common/failure.dart';
import '../../entities/tv_entities/tv.dart';
import '../../repositories/tv_repository.dart';

class SearchTvs {
  final TvRepository _repository;
  SearchTvs(this._repository);

  Future<Either<Failure, List<Tv>>> execute(String query) {
    return _repository.searchTVs(query);
  }
}
