class Movie {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String backdropUrl;
  final double rating;
  final int year;
  final String duration;
  final String certification;
  final String language;
  final List<String> genres;
  final List<String> cast;
  final List<String> countries;
  final bool isOriginal;
  final bool isPopular;
  final bool isTopRated;
  final bool isNowPlaying;
  final bool isTrending;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.backdropUrl,
    required this.rating,
    required this.year,
    required this.duration,
    required this.certification,
    required this.language,
    required this.genres,
    required this.cast,
    required this.countries,
    this.isOriginal = false,
    this.isPopular = false,
    this.isTopRated = false,
    this.isNowPlaying = false,
    this.isTrending = false,
  });
}
