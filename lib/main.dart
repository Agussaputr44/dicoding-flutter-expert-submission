import 'package:ditonton/presentation/bloc/on_airing_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_list_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_search_bloc.dart';

import 'presentation/bloc/movie_detail_bloc.dart';
import 'presentation/bloc/movie_list_bloc.dart';
import 'presentation/bloc/movie_search_bloc.dart';
import 'presentation/bloc/popular_movies_bloc.dart';
import 'presentation/bloc/top_rated_movies_bloc.dart';
import 'presentation/bloc/top_rated_tv_bloc.dart';
import 'presentation/bloc/watchlist_movies_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/constants.dart';
import 'common/pinned_http_client.dart';
import 'common/utils.dart';
import 'injection.dart' as di;
import 'presentation/bloc/watchlist_tv_bloc.dart';
import 'presentation/pages/about_page.dart';
import 'presentation/pages/home_movie_page.dart';
import 'presentation/pages/movie_detail_page.dart';
import 'presentation/pages/popular_movies_page.dart';
import 'presentation/pages/search_page.dart';
import 'presentation/pages/top_rated_movies_page.dart';
import 'presentation/pages/tv_pages/home_tv_page.dart';
import 'presentation/pages/tv_pages/on_airing_tv_page.dart';
import 'presentation/pages/tv_pages/popular_tv_page.dart';
import 'presentation/pages/tv_pages/search_tv_page.dart';
import 'presentation/pages/tv_pages/top_rated_tv_page.dart';
import 'presentation/pages/tv_pages/tv_detail_page.dart';
import 'presentation/pages/tv_pages/watchlist_tv_page.dart';
import 'presentation/pages/watchlist_movies_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await SslPinning.ioClientStrict();
    await di.init();

    runApp(MyApp());
  } catch (e) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: Scaffold(body: Center(child: Text('Certif ssl not valid :('))),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        // TODO: bloc lainnya
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieListBloc>()),
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TvDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TvListBloc>()),
        BlocProvider(create: (_) => di.locator<OnAiringTvBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvBloc>()),
        BlocProvider(create: (_) => di.locator<TvSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTvBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case SearchTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTvPage());
            case HomeTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => HomeTvPage());
            case OnAiringTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => OnAiringTvPage());
            case TopRatedTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvPage());
            case PopularTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvPage());

            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(child: Text('Page not found :(')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
