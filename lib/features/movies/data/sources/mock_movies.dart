import '../models/movie.dart';

final List<Movie> mockMovies = [
  const Movie(
    id: 'avatar-3',
    title: 'Avatar: Fire and Ash',
    description:
        'In the wake of the devastating war against the RDA and the loss of their eldest son, Jake Sully and Neytiri face a new threat on Pandora as they encounter the Ash People, a aggressive Na\'vi clan.',
    posterUrl:
        'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600&auto=format&fit=crop',
    backdropUrl:
        'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1200&auto=format&fit=crop',
    rating: 7.3,
    year: 2025,
    duration: '3h 15m',
    certification: 'U/A 13',
    language: 'EN',
    genres: ['Action', 'Adventure', 'Science Fiction'],
    cast: ['Sam Worthington', 'Zoe Saldana', 'Sigourney Weaver', 'Stephen Lang'],
    countries: ['United States of America'],
    isOriginal: true,
    isPopular: true,
    isTrending: true,
  ),
  const Movie(
    id: 'crime-101',
    title: 'Crime 101',
    description:
        'When an elusive thief whose high-stakes heists unfold along the iconic 101 freeway in Los Angeles eyes the score of a lifetime, with hopes of this being his final job, his path collides with a disillusioned insurance broker facing her own crossroads. Determined to crack the case, a relentless detective closes in.',
    posterUrl:
        'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=600&auto=format&fit=crop',
    backdropUrl:
        'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=1200&auto=format&fit=crop',
    rating: 7.3,
    year: 2025,
    duration: '2h 21m',
    certification: 'U/A 13',
    language: 'EN',
    genres: ['Crime', 'Thriller', 'Drama'],
    cast: [
      'Chris Hemsworth',
      'Mark Ruffalo',
      'Halle Berry',
      'Barry Keoghan',
      'Monica Barbaro'
    ],
    countries: ['United Kingdom', 'United States of America'],
    isOriginal: true,
    isPopular: true,
    isTopRated: true,
  ),
  const Movie(
    id: 'gladiator-2',
    title: 'Gladiator II',
    description:
        'Years after witnessing the death of the revered hero Maximus at the hands of his uncle, Lucius must enter the Colosseum after his home is conquered by the tyrannical Emperors who now lead Rome.',
    posterUrl:
        'https://images.unsplash.com/photo-1568890686150-63155c229f64?w=600&auto=format&fit=crop',
    backdropUrl:
        'https://images.unsplash.com/photo-1514533450685-4493e01d1fdc?w=1200&auto=format&fit=crop',
    rating: 7.8,
    year: 2024,
    duration: '2h 28m',
    certification: 'A 18+',
    language: 'EN',
    genres: ['Action', 'Historical', 'Drama'],
    cast: ['Paul Mescal', 'Pedro Pascal', 'Denzel Washington', 'Connie Nielsen'],
    countries: ['United Kingdom', 'United States of America'],
    isOriginal: false,
    isPopular: true,
    isNowPlaying: true,
    isTrending: true,
  ),
  const Movie(
    id: 'dune-2',
    title: 'Dune: Part Two',
    description:
        'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family. Facing a choice between the love of his life and the fate of the universe.',
    posterUrl:
        'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=600&auto=format&fit=crop',
    backdropUrl:
        'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=1200&auto=format&fit=crop',
    rating: 8.6,
    year: 2024,
    duration: '2h 46m',
    certification: 'U/A 13',
    language: 'EN',
    genres: ['Science Fiction', 'Adventure', 'Drama'],
    cast: ['Timothée Chalamet', 'Zendaya', 'Rebecca Ferguson', 'Javier Bardem'],
    countries: ['United States of America'],
    isOriginal: true,
    isTopRated: true,
    isPopular: true,
  ),
  const Movie(
    id: 'oppenheimer',
    title: 'Oppenheimer',
    description:
        'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb during World War II.',
    posterUrl:
        'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=600&auto=format&fit=crop',
    backdropUrl:
        'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=1200&auto=format&fit=crop',
    rating: 8.9,
    year: 2023,
    duration: '3h 00m',
    certification: 'A 18+',
    language: 'EN',
    genres: ['Historical', 'Drama'],
    cast: ['Cillian Murphy', 'Emily Blunt', 'Matt Damon', 'Robert Downey Jr.'],
    countries: ['United States of America', 'United Kingdom'],
    isOriginal: false,
    isTopRated: true,
  ),
  const Movie(
    id: 'interstellar',
    title: 'Interstellar',
    description:
        'When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.',
    posterUrl:
        'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=600&auto=format&fit=crop',
    backdropUrl:
        'https://images.unsplash.com/photo-1506703719100-a0f3a48c0f86?w=1200&auto=format&fit=crop',
    rating: 8.7,
    year: 2014,
    duration: '2h 49m',
    certification: 'U/A 13',
    language: 'EN',
    genres: ['Science Fiction', 'Adventure', 'Drama'],
    cast: ['Matthew McConaughey', 'Anne Hathaway', 'Jessica Chastain'],
    countries: ['United States of America'],
    isOriginal: true,
    isTopRated: true,
    isNowPlaying: true,
  ),
];
