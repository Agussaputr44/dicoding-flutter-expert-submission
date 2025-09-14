import 'package:ditonton/presentation/bloc/on_airing_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail_bloc.dart';

import 'presentation/bloc/movie_list_bloc.dart';
import 'presentation/bloc/movie_search_bloc.dart';
import 'presentation/bloc/popular_movies_bloc.dart';
import 'presentation/bloc/popular_tv_bloc.dart';
import 'presentation/bloc/top_rated_movies_bloc.dart';
import 'presentation/bloc/top_rated_tv_bloc.dart';
import 'presentation/bloc/tv_list_bloc.dart';
import 'presentation/bloc/tv_search_bloc.dart';
import 'presentation/bloc/watchlist_movies_bloc.dart';
import 'presentation/bloc/watchlist_tv_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'common/pinned_http_client.dart';
import 'data/datasources/db/database_helper.dart';
import 'data/datasources/movie_local_data_source.dart';
import 'data/datasources/movie_remote_data_source.dart';
import 'data/datasources/tv_datasources/tv_local_datasource.dart';
import 'data/datasources/tv_datasources/tv_remote_datasource.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'data/repositories/tv_repository_impl.dart';
import 'domain/repositories/movie_repository.dart';
import 'domain/repositories/tv_repository.dart';
import 'domain/usecases/get_movie_detail.dart';
import 'domain/usecases/get_movie_recommendations.dart';
import 'domain/usecases/get_now_playing_movies.dart';
import 'domain/usecases/get_popular_movies.dart';
import 'domain/usecases/get_top_rated_movies.dart';
import 'domain/usecases/get_watchlist_movies.dart';
import 'domain/usecases/get_watchlist_status.dart';
import 'domain/usecases/remove_watchlist.dart';
import 'domain/usecases/save_watchlist.dart';
import 'domain/usecases/search_movies.dart';
import 'domain/usecases/tv_usecases/get_on_airing_tvs.dart';
import 'domain/usecases/tv_usecases/get_popular_tvs.dart';
import 'domain/usecases/tv_usecases/get_top_rated_tvs.dart';
import 'domain/usecases/tv_usecases/get_tv_detail.dart';
import 'domain/usecases/tv_usecases/get_tv_recommendations.dart';
import 'domain/usecases/tv_usecases/get_watchlist_tv_status.dart';
import 'domain/usecases/tv_usecases/get_watchlist_tvs.dart';
import 'domain/usecases/tv_usecases/remove_watchlist_tv.dart';
import 'domain/usecases/tv_usecases/save_watchlist_tv.dart';
import 'domain/usecases/tv_usecases/search_tvs.dart';
import 'presentation/bloc/movie_detail_bloc.dart';
final locator = GetIt.instance;

Future<void> init() async {

  // =========================
  // Movie Bloc
  // =========================
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  locator.registerFactory(
    () => MovieListBloc(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );

  locator.registerFactory(() => MovieSearchBloc(searchMovies: locator()));

  locator.registerFactory(() => PopularMoviesBloc(getPopularMovies: locator()));
  locator.registerFactory(
    () => TopRatedMoviesBloc(getTopRatedMovies: locator()),
  );
  locator.registerFactory(
    () => WatchlistMoviesBloc(getWatchlistMovies: locator()),
  );

  // =========================
  // Tv Bloc
  // =========================
  locator.registerFactory(
    () => TvDetailBloc(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

   locator.registerFactory(
    () => TvListBloc(
      getOnAiringTvs: locator(),
      getPopularTvs: locator(),
      getTopRatedTvs: locator(),
    ),
  );

    locator.registerFactory(
    () => OnAiringTvBloc(getOnAiringTvs: locator()),
  );

   locator.registerFactory(
    () => PopularTvBloc(getPopularTvs: locator()),
  );

 locator.registerFactory(
    () => TvSearchBloc(searchTvs: locator()),
  );
    locator.registerFactory(
    () => TopRatedTvBloc(getTopRatedTvs: locator()),
  );
  locator.registerFactory(
    () => WatchlistTvBloc(getWatchlistTvs: locator()),
  );


  // =========================
  // Movie Use Cases
  // =========================
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // =========================
  // TV Use Cases
  // =========================
  locator.registerLazySingleton(() => GetOnAiringTVs(locator()));
  locator.registerLazySingleton(() => GetPopularTVs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTVs(locator()));
  locator.registerLazySingleton(() => GetTVDetail(locator()));
  locator.registerLazySingleton(() => GetTVRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvs(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvs(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));

  // =========================
  // Repositories
  // =========================
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // =========================
  // Data Sources
  // =========================
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator<http.Client>()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );

  locator.registerLazySingleton<TvRemoteDatasource>(
    () => TvRemoteDatasourceImpl(client: locator<http.Client>()),
  );

  locator.registerLazySingleton<TvLocalDatasource>(
    () => TvLocalDatasourceImpl(databaseHelper: locator()),
  );

  // =========================
  // Helpers & External
  // =========================
  final ioClient = await SslPinning.ioClientStrict(
    assetPemPath: 'assets/certificates.cer',
  );

  locator.registerLazySingleton<IOClient>(() => ioClient);
  locator.registerLazySingleton<http.Client>(() => locator<IOClient>());

  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}
