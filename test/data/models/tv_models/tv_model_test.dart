import 'package:ditonton/data/models/tv_models/tv_model.dart';
import 'package:ditonton/domain/entities/tv_entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tTvModel = TvModel(
    id: 1,
    originalName: 'Original Test Show',
    name: 'Test Show',
    overview: 'Overview text here',
    popularity: 100.0,
    backdropPath: '/backdrop.jpg',
    posterPath: '/poster.jpg',
    firstAirDate: '2020-01-01',
    genreIds: [18, 35],
    voteAverage: 8.5,
    voteCount: 200,
    adult: false,
    originCountry: ['US'],
    originalLanguage: 'en',
  );

  final tTvEntity = Tv(
    id: 1,
    originalName: 'Original Test Show',
    name: 'Test Show',
    overview: 'Overview text here',
    popularity: 100.0,
    backdropPath: '/backdrop.jpg',
    posterPath: '/poster.jpg',
    firstAirDate: '2020-01-01',
    originCountry: ['US'],
    genreIds: [18, 35],
    voteAverage: 8.5,
    voteCount: 200,
    adult: false,
    originalLanguage: 'en',
  );

  final tTvJson = {
    "id": 1,
    "original_name": "Original Test Show",
    "name": "Test Show",
    "overview": "Overview text here",
    "popularity": 100.0,
    "backdrop_path": "/backdrop.jpg",
    "poster_path": "/poster.jpg",
    "first_air_date": "2020-01-01",
    "genre_ids": [18, 35],
    "vote_average": 8.5,
    "vote_count": 200,
    "adult": false,
    "origin_country": ["US"],
    "original_language": "en",
  };

  test('should parse JSON to TvModel', () {
    final result = TvModel.fromJson(tTvJson);
    expect(result, tTvModel);
  });

  test('should convert TvModel to JSON', () {
    final result = tTvModel.toJson();
    expect(result, tTvJson);
  });

  test('should convert TvModel to Tv entity', () {
    final result = tTvModel.toEntity();
    expect(result, tTvEntity);
  });

  test('props should contain all fields', () {
    final result = tTvModel.props;
    expect(result.contains(tTvModel.name), true);
    expect(result.contains(tTvModel.id), true);
    expect(result.contains(tTvModel.originalName), true);
  });
}
