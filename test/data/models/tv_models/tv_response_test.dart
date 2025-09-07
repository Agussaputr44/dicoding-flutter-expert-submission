import 'package:ditonton/data/models/tv_models/tv_model.dart';
import 'package:ditonton/data/models/tv_models/tv_response.dart';
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

  const tTvResponse = TvResponse(tvList: [tTvModel]);

  final tTvResponseJson = {
    "results": [
      {
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
      }
    ]
  };

  test('should parse JSON to TvResponse', () {
    final result = TvResponse.fromJson(tTvResponseJson);
    expect(result, tTvResponse);
  });

  test('should convert TvResponse to JSON', () {
    final result = tTvResponse.toJson();
    expect(result, tTvResponseJson);
  });

  test('props should contain tvList', () {
    expect(tTvResponse.props, [tTvResponse.tvList]);
  });
}
