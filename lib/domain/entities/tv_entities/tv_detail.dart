import 'package:equatable/equatable.dart';

import '../genre.dart';

class TvDetail extends Equatable {
  TvDetail({
    required this.adult,
    required this.backdropPath,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.name,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.status,
    required this.tagline,
    required this.type,
    this.episodeRuntime,
  });

  bool? adult;
  String? backdropPath;
  String? firstAirDate;
  List<Genre>? genres; // changed to List<Genre>
  int id;
  String? name;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  double? voteAverage;
  int? voteCount;
  int? numberOfEpisodes;
  int? numberOfSeasons;
  String? status;
  String? tagline;
  String? type;
  List<int>? episodeRuntime; // added for duration display

  @override
  List<Object?> get props => [
    adult,
    backdropPath,
    firstAirDate,
    genres,
    id,
    name,
    originCountry,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    voteAverage,
    voteCount,
    numberOfEpisodes,
    numberOfSeasons,
    status,
    tagline,
    type,
    episodeRuntime,
  ];
}
