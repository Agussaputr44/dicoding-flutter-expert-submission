import '../../../common/exception.dart';
import '../../models/common_models/watchlist_table.dart';
import '../db/database_helper.dart';

abstract class TvLocalDatasource {
  Future<String> insertWatchlist(WatchlistTable tv);
  Future<String> removeWatchlist(WatchlistTable tv);
  Future<WatchlistTable?> getTvById(int id);
  Future<List<WatchlistTable>> getWatchlistTvs();
}

class TvLocalDatasourceImpl implements TvLocalDatasource {
  final DatabaseHelper databaseHelper;

  TvLocalDatasourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(WatchlistTable tv) async {
    try {
      await databaseHelper.insertWatchlist(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(WatchlistTable tv) async {
    try {
      await databaseHelper.removeWatchlist(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<WatchlistTable?> getTvById(int id) async {
    final result = await databaseHelper.getEntityById(id);
    if (result != null) {
      return WatchlistTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<WatchlistTable>> getWatchlistTvs() async {
    final result = await databaseHelper.getWatchlists();
    return result.map((data) => WatchlistTable.fromMap(data)).toList();
  }
}
