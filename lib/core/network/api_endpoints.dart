class ApiEndpoints {
  static const String baseUrl = 'https://culture-box-backend.onrender.com';

  static const String register = '/api/v1/auth/register';
  static const String login = '/api/v1/auth/login';
  static const String refresh = '/api/v1/auth/refresh';
  static const String me = '/api/v1/users/me';
  
  static const String homepageLayout = '/api/v1/homepage/layout';
  static const String homepageSection = '/api/v1/homepage/sections';
  
  static const String movies = '/api/v1/movies';
  static String movieDetails(String id) => '/api/v1/movies/$id';
  
  static const String search = '/api/v1/search/';
  static const String genres = '/api/v1/genres/';
}
