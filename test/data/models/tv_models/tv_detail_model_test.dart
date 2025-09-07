import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_models/tv_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTvDetailModel = TvDetailModel(
    adult: false,
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2020-01-01',
    genres: [GenreModel(id: 1, name: 'Drama')],
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
  );

  final tTvDetailEntity = TvDetail(
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
  );

  final tTvDetailJson = {
    "adult": false,
    "backdrop_path": "/backdrop.jpg",
    "first_air_date": "2020-01-01",
    "genres": [
      {"id": 1, "name": "Drama"}
    ],
    "id": 1,
    "name": "Test Show",
    "origin_country": ["US"],
    "original_language": "en",
    "original_name": "Original Test Show",
    "overview": "Overview text here",
    "popularity": 100.0,
    "poster_path": "/poster.jpg",
    "vote_average": 8.0,
    "vote_count": 120,
    "number_of_episodes": 10,
    "number_of_seasons": 1,
    "status": "Running",
    "tagline": "Best Show",
    "type": "Scripted",
  };

  test('should convert JSON to TvDetailModel', () {
    final result = TvDetailModel.fromJson(tTvDetailJson);
    expect(result, tTvDetailModel);
  });

  test('should convert TvDetailModel to JSON', () {
    final result = tTvDetailModel.toJson();
    expect(result, tTvDetailJson);
  });

  test('should convert TvDetailModel to TvDetail entity', () {
    final result = tTvDetailModel.toEntity();
    expect(result, tTvDetailEntity);
  });

  test('props should contain all fields', () {
    final result = tTvDetailModel.props;
    expect(result.contains(tTvDetailModel.name), true);
    expect(result.contains(tTvDetailModel.id), true);
    expect(result.contains(tTvDetailModel.overview), true);
  });
}
