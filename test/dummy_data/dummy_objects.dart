import 'package:ditonton/data/models/common_models/watchlist_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:ditonton/domain/entities/tv_entities/tv_detail.dart';

// ================= MOVIE DUMMY (yang sudah ada) =================
final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = WatchlistTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  type: "movie",
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
  'type': "movie",
};

// ================= TV DUMMY =================
final testTv = Tv(
  adult: false,
  backdropPath: '/backdrop.jpg',
  firstAirDate: '2020-01-01',
  genreIds: [18],
  id: 1,
  name: 'Test Show',
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'Original Test Show',
  overview: 'Overview text here',
  popularity: 100.0,
  posterPath: '/poster.jpg',
  voteAverage: 8.0,
  voteCount: 120,
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
  adult: false,
  backdropPath: '/backdrop.jpg',
  firstAirDate: '2020-01-01',
  genres: [Genre(id: 1, name: 'Drama')],
  id: 1,
  name: 'Test Show',
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'Original Test Show',
  overview: 'Overview text here',
  popularity: 100.0,
  posterPath: '/poster.jpg',
  voteAverage: 8.0,
  voteCount: 120,
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  status: 'Running',
  tagline: 'Best Show',
  type: 'Scripted',
  episodeRuntime: [45],
);

final testTvWatchlist = Tv.watchlist(
  id: 1,
  name: 'Test Show',
  posterPath: '/poster.jpg',
  overview: 'Overview text here',
);

final testWatchlistTable = WatchlistTable(
  id: 1,
  title: 'Test Show',
  posterPath: '/poster.jpg',
  overview: 'Overview text here',
  type: "tv",
);

final testTvMap = {
  'id': 1,
  'overview': 'Overview text here',
  'posterPath': '/poster.jpg',
  'title': 'Test Show',
  'type': "tv",
};
