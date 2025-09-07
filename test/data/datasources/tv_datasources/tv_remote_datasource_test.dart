import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_datasources/tv_remote_datasource.dart';
import 'package:ditonton/data/models/tv_models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_models/tv_response.dart';

import '../../../helpers/test_helper.mocks.dart';
import '../../../json_reader.dart';

void main() {
  late TvRemoteDatasourceImpl datasource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = TvRemoteDatasourceImpl(client: mockHttpClient);
  });

  group('getOnAiringTVs', () {
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/tv_on_the_air.json')))
        .tvList;

    test('should return list of TvModel when response code is 200', () async {
      when(mockHttpClient.get(
              Uri.parse('${TvRemoteDatasourceImpl.BASE_URL}/tv/on_the_air?${TvRemoteDatasourceImpl.API_KEY}')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_on_the_air.json'), 200));

      final result = await datasource.getOnAiringTVs();

      expect(result, equals(tTvList));
    });

    test('should throw ServerException when response code is not 200', () async {
      when(mockHttpClient.get(
              Uri.parse('${TvRemoteDatasourceImpl.BASE_URL}/tv/on_the_air?${TvRemoteDatasourceImpl.API_KEY}')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = datasource.getOnAiringTVs();

      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('getTVDetail', () {
    const tId = 1;
    final tTvDetail = TvDetailModel.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return TvDetailModel when response code is 200', () async {
      when(mockHttpClient.get(
              Uri.parse('${TvRemoteDatasourceImpl.BASE_URL}/tv/$tId?${TvRemoteDatasourceImpl.API_KEY}')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_detail.json'), 200));

      final result = await datasource.getTVDetail(tId);

      expect(result, equals(tTvDetail));
    });

    test('should throw ServerException when response code is not 200', () async {
      when(mockHttpClient.get(
              Uri.parse('${TvRemoteDatasourceImpl.BASE_URL}/tv/$tId?${TvRemoteDatasourceImpl.API_KEY}')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = datasource.getTVDetail(tId);

      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('getPopularTVs', () {
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/tv_popular.json'))).tvList;

    test('should return list of TvModel when response code is 200', () async {
      when(mockHttpClient.get(
              Uri.parse('${TvRemoteDatasourceImpl.BASE_URL}/tv/popular?${TvRemoteDatasourceImpl.API_KEY}')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_popular.json'), 200));

      final result = await datasource.getPopularTVs();

      expect(result, equals(tTvList));
    });

    test('should throw ServerException when response code is not 200', () async {
      when(mockHttpClient.get(
              Uri.parse('${TvRemoteDatasourceImpl.BASE_URL}/tv/popular?${TvRemoteDatasourceImpl.API_KEY}')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = datasource.getPopularTVs();

      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('getTopRatedTVs', () {
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/top_rated_tv.json'))).tvList;

    test('should return list of TvModel when response code is 200', () async {
      when(mockHttpClient.get(
              Uri.parse('${TvRemoteDatasourceImpl.BASE_URL}/tv/top_rated?${TvRemoteDatasourceImpl.API_KEY}')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/top_rated_tv.json'), 200));

      final result = await datasource.getTopRatedTVs();

      expect(result, equals(tTvList));
    });

    test('should throw ServerException when response code is not 200', () async {
      when(mockHttpClient.get(
              Uri.parse('${TvRemoteDatasourceImpl.BASE_URL}/tv/top_rated?${TvRemoteDatasourceImpl.API_KEY}')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = datasource.getTopRatedTVs();

      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('getTVRecommendations', () {
    const tId = 1;
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/tv_recommendations.json'))).tvList;

    test('should return list of TvModel when response code is 200', () async {
      when(mockHttpClient.get(
              Uri.parse('${TvRemoteDatasourceImpl.BASE_URL}/tv/$tId/recommendations?${TvRemoteDatasourceImpl.API_KEY}')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_recommendations.json'), 200));

      final result = await datasource.getTVRecommendations(tId);

      expect(result, equals(tTvList));
    });

    test('should throw ServerException when response code is not 200', () async {
      when(mockHttpClient.get(
              Uri.parse('${TvRemoteDatasourceImpl.BASE_URL}/tv/$tId/recommendations?${TvRemoteDatasourceImpl.API_KEY}')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = datasource.getTVRecommendations(tId);

      expect(call, throwsA(isA<ServerException>()));
    });
  });

  group('searchTVs', () {
    const tQuery = 'Test';
    final tTvList = TvResponse.fromJson(
        json.decode(readJson('dummy_data/tv_search.json'))).tvList;

    test('should return list of TvModel when response code is 200', () async {
      when(mockHttpClient.get(
              Uri.parse('${TvRemoteDatasourceImpl.BASE_URL}/search/tv?${TvRemoteDatasourceImpl.API_KEY}&query=$tQuery')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_search.json'), 200));

      final result = await datasource.searchTVs(tQuery);

      expect(result, equals(tTvList));
    });

    test('should throw ServerException when response code is not 200', () async {
      when(mockHttpClient.get(
              Uri.parse('${TvRemoteDatasourceImpl.BASE_URL}/search/tv?${TvRemoteDatasourceImpl.API_KEY}&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = datasource.searchTVs(tQuery);

      expect(call, throwsA(isA<ServerException>()));
    });
  });
}
