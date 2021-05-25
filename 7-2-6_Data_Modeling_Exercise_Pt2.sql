-- ========================
-- Schema One: Outer Space:
-- ========================
- for easier DB access and formatting, the moons should have their own table, listing each moon, and pointing to the planet

-- from the terminal run:
-- psql < outer_space.sql

DROP DATABASE IF EXISTS outer_space;

CREATE DATABASE outer_space;

-- \c outer_space
USE outer_space;

CREATE TABLE planets
(
  planet_id SERIAL PRIMARY KEY,
  planet_name TEXT NOT NULL,
  orbital_period_in_years FLOAT NOT NULL,
  orbits_around TEXT NOT NULL,
  galaxy TEXT NOT NULL
);

CREATE TABLE moons
(
  moon_id SERIAL PRIMARY KEY,
  moon_name TEXT NOT NULL,
  planet_name TEXT
);

INSERT INTO planets
  (planet_name, orbital_period_in_years, orbits_around, galaxy)
VALUES
  ('Earth', 1.00, 'The Sun', 'Milky Way'),
  ('Mars', 1.88, 'The Sun', 'Milky Way'),
  ('Venus', 0.62, 'The Sun', 'Milky Way'),
  ('Neptune', 164.8, 'The Sun', 'Milky Way'),
  ('Proxima Centauri b', 0.03, 'Proxima Centauri', 'Milky Way'),
  ('Gliese 876 b', 0.23, 'Gliese 876', 'Milky Way');

INSERT INTO moons
  (moon_name, planet_name)
VALUES
  ('The Moon',   'Earth'),
  ('Phobos',     'Mars'),
  ('Deimos',     'Mars'),
  ('Naiad',      'Neptune'),
  ('Thalassa',   'Neptune'),
  ('Despina',    'Neptune'),
  ('Galatea',    'Neptune'),
  ('Larissa',    'Neptune'),
  ('S/2004 N 1', 'Neptune'),
  ('Proteus',    'Neptune'),
  ('Triton',     'Neptune'),
  ('Nereid',     'Neptune'),
  ('Halimede',   'Neptune'),
  ('Sao',        'Neptune'),
  ('Laomedeia',  'Neptune'),
  ('Psamathe',   'Neptune'),
  ('Neso',       'Neptune');


-- ========================
-- Schema Two: Air Traffic:
-- ========================
-- this table needs to be normalized into passenger, cities, and flights

-- from the terminal run:
-- psql < air_traffic.sql

DROP DATABASE IF EXISTS air_traffic;

CREATE DATABASE air_traffic;

-- \c air_traffic
USE air_traffic;

CREATE TABLE passengers
(
  passenger_id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL
);

CREATE TABLE cities
(
  city_id SERIAL PRIMARY KEY,
  city_name TEXT NOT NULL,
  country_name TEXT NOT NULL
);

CREATE TABLE flights
(
  flight_id SERIAL PRIMARY KEY,
  passenger_id INTEGER,
  seat TEXT NOT NULL,
  departure TIMESTAMP NOT NULL,
  arrival TIMESTAMP NOT NULL,
  airline TEXT NOT NULL,
  from_city_id INTEGER,
  to_city_id INTEGER
);

INSERT INTO passengers
  (first_name, last_name)
VALUES
  ('Jennifer', 'Finch'),
  ('Thadeus',  'Gathercoal'),
  ('Sonja',    'Pauley'),
  ('Waneta',   'Skeleton'),
  ('Berkie',   'Wycliff'),
  ('Alvin',    'Leathes'),
  ('Cory',     'Squibbes');

INSERT INTO cities
  (city_name, country_name)
VALUES
  ('Washington DC', 'United States'),  -- 1
  ('Seattle',       'United States'),  -- 2
  ('Tokyo',         'Japan'),          -- 3
  ('London',        'United Kingdom'), -- 4
  ('Los Angeles',   'United States'),  -- 5
  ('Las Vegas',     'United States'),  -- 6
  ('Mexico City',   'Mexico'),         -- 7
  ('Paris',         'France'),         -- 8
  ('Casablanca',    'Morocco'),        -- 9
  ('Dubai',         'UAE'),            -- 10
  ('Beijing',       'China'),          -- 11
  ('New York',      'United States'),  -- 12
  ('Charlotte',     'United States'),  -- 13
  ('Cedar Rapids',  'United States'),  -- 14
  ('Chicago',       'United States'),  -- 15
  ('New Orleans',   'United States'),  -- 16
  ('Sao Paolo',     'Brazil'),         -- 17
  ('Santiago',      'Chile');          -- 18

INSERT INTO flights
  (passenger_id, seat, departure, arrival, airline, from_city_id, to_city_id)
VALUES
  (1, '33B', '2018-04-08 09:00:00', '2018-04-08 12:00:00', 'United', 1, 2),
  (2, '8A', '2018-12-19 12:45:00', '2018-12-19 16:15:00', 'British Airways', 3, 4),
  (3, '12F', '2018-01-02 07:00:00', '2018-01-02 08:03:00', 'Delta', 5, 6),
  (1, '20A', '2018-04-15 16:50:00', '2018-04-15 21:00:00', 'Delta', 2, 7),
  (4, '23D', '2018-08-01 18:30:00', '2018-08-01 21:50:00', 'TUI Fly Belgium', 8, 9),
  (2, '18C', '2018-10-31 01:15:00', '2018-10-31 12:55:00', 'Air China', 10, 11),
  (5, '9E', '2019-02-06 06:00:00', '2019-02-06 07:47:00', 'United', 12, 13),
  (6, '1A', '2018-12-22 14:42:00', '2018-12-22 15:56:00', 'American Airlines', 14, 15),
  (5, '32B', '2019-02-06 16:28:00', '2019-02-06 19:18:00', 'American Airlines', 13, 16),
  (7, '10D', '2019-01-20 19:30:00', '2019-01-20 22:45:00', 'Avianca Brasil', 17, 18);


-- ====================
-- Schema Three: Music:
-- ====================
-- due to many-to-many relationships, mapping tables are needed for artists and producers
-- NOTE: the same song on different albums are tracked separately due to subtle differences in the song ...

-- from the terminal run:
-- psql < music.sql

DROP DATABASE IF EXISTS music;

CREATE DATABASE music;

-- \c music
USE music;


CREATE TABLE albums
(
  album_id SERIAL PRIMARY KEY,
  album_name TEXT NOT NULL,
  release_date DATE NOT NULL
);

CREATE TABLE producers
(
  producer_id SERIAL PRIMARY KEY,
  producer_name TEXT NOT NULL
);

CREATE TABLE albums_producers
(
  album_producer_id SERIAL PRIMARY KEY,
  album_id INTEGER,
  producer_id INTEGER
);

CREATE TABLE songs
(
  song_id SERIAL PRIMARY KEY,
  song_title TEXT NOT NULL,
  duration_in_seconds INTEGER NOT NULL,
  album_id INTEGER
);

CREATE TABLE artists
(
  aertist_id SERIAL PRIMARY KEY,
  artist_name TEXT NOT NULL
);

CREATE TABLE songs_artists
(
  song_artist_id SERIAL PRIMARY KEY,
  song_id INTEGER,
  artist_id INTEGER
);


INSERT INTO albums
  (album_name, release_date)
VALUES
  ('Middle of Nowhere',          '1997-04-15'), -- 1
  ('A Night at the Opera',       '1975-10-31'), -- 2
  ('Daydream',                   '1995-11-14'), -- 3
  ('A Star Is Born',             '2018-09-27'), -- 4
  ('Silver Side Up',             '2001-08-21'), -- 5
  ('The Blueprint 3',            '2009-10-20'), -- 6
  ('Prism',                      '2013-12-17'), -- 7
  ('Hands All Over',             '2011-06-21'), -- 8
  ('Let Go',                     '2002-05-14'), -- 9
  ('The Writing''s on the Wall', '1999-11-07'); -- 10

INSERT INTO producers
  (producer_name)
VALUES
  ('Dust Brothers'),     -- 1
  ('Stephen Lironi'),    -- 2
  ('Roy Thomas Baker'),  -- 3
  ('Walter Afanasieff'), -- 4
  ('Benjamin Rice'),     -- 5
  ('Rick Parashar'),     -- 6
  ('Al Shux'),           -- 7
  ('Max Martin'),        -- 8
  ('Cirkut'),            -- 9
  ('Shellback'),         -- 10
  ('Benny Blanco'),      -- 11
  ('The Matrix'),        -- 12
  ('Darkchild');         -- 13

INSERT INTO albums_producers
  (album_id, producer_id)
VALUES
  (1,  1),
  (1,  2),
  (2,  3),
  (3,  4),
  (4,  5),
  (5,  6),
  (6,  7),
  (7,  8),
  (7,  9),
  (8,  10),
  (8,  11),
  (9,  12),
  (10, 13);

INSERT INTO songs
  (song_title, duration_in_seconds, album_id)
VALUES
  ('MMMBop',                 238, 1),  -- 1
  ('Bohemian Rhapsody',      355, 2),  -- 2
  ('One Sweet Day',          282, 3),  -- 3
  ('Shallow',                216, 4),  -- 4
  ('How You Remind Me',      223, 5),  -- 5
  ('New York State of Mind', 276, 6),  -- 6
  ('Dark Horse',             215, 7),  -- 7
  ('Moves Like Jagger',      201, 8),  -- 8
  ('Complicated',            244, 9),  -- 9
  ('Say My Name',            240, 10); -- 10

INSERT INTO artists
  (artist_name)
VALUES
  ('Hanson'),             -- 1
  ('Queen'),              -- 2
  ('Mariah Cary'),        -- 3
  ('Boyz II Men'),        -- 4
  ('Lady Gaga'),          -- 5
  ('Bradley Cooper'),     -- 6
  ('Nickelback'),         -- 7
  ('Jay Z'),              -- 8
  ('Alicia Keys'),        -- 9
  ('Katy Perry'),         -- 10
  ('Juicy J'),            -- 11
  ('Maroon 5'),           -- 12
  ('Christina Aguilera'), -- 13
  ('Avril Lavigne'),      -- 14
  ('Destiny''s Child');   -- 15

INSERT INTO songs_artists
  (song_id, artist_id)
VALUES
  (1,  1),
  (2,  2),
  (3,  3),
  (3,  4),
  (4,  5),
  (4,  6),
  (5,  7),
  (6,  8),
  (6,  9),
  (7,  10),
  (7,  11),
  (8,  12),
  (8,  13),
  (9,  14),
  (10, 15);
