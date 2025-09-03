import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../entities/tv_entities/tv.dart';
import '../entities/tv_entities/tv_detail.dart';

abstract class TvRepository {
  Future<Either<Failure, List<Tv>>> getOnAiringTVs();
  Future<Either<Failure, List<Tv>>> getPopularTVs();
  Future<Either<Failure, List<Tv>>> getTopRatedTVs();
  Future<Either<Failure, TvDetail>> getTVDetail(int id);
  Future<Either<Failure, List<Tv>>> getTVRecommendations(int id);
  Future<Either<Failure, List<Tv>>> searchTVs(String query);
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv);
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTVs();
}
