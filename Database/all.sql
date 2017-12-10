--
-- DROP ALL TABLES
--

DROP TABLE IF EXISTS lift_trucks CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS routes CASCADE;
DROP TABLE IF EXISTS vertexes CASCADE;
DROP TABLE IF EXISTS sections CASCADE;
DROP TABLE IF EXISTS results CASCADE;
DROP TABLE IF EXISTS solutions CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS beacons CASCADE;
DROP TABLE IF EXISTS adjacencies CASCADE;
DROP TABLE IF EXISTS rearrangements CASCADE;
DROP TABLE IF EXISTS wh_types CASCADE;
DROP TABLE IF EXISTS logs CASCADE;
--
-- Base de datos: ge
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla lift_trucks
--

CREATE TABLE lift_trucks (
  id serial NOT NULL,
  type varchar(255) DEFAULT NULL,
  status integer NOT NULL DEFAULT 0,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla locations
--

CREATE TABLE locations (
  id serial NOT NULL,
  route_id integer NULL DEFAULT NULL,
  lift_truck_id integer NULL,
  section_id integer NULL DEFAULT NULL,
  pos_x real NULL DEFAULT NULL,
  pos_y real NULL DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla routes
--

CREATE TABLE routes (
  id serial NOT NULL,
  lift_truck_id integer NOT NULL,
  initial_section integer NULL DEFAULT NULL,
  final_section integer NULL DEFAULT NULL,
  ean varchar(50) NULL,
  product_id text NULL,
  time integer NULL DEFAULT NULL,
  date_time time NULL DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla vertexes
--

CREATE TABLE vertexes (
  id serial NOT NULL,
  x real NOT NULL,
  y real NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla sections
--

CREATE TABLE sections (
  id serial NOT NULL,
  beacon_id integer NULL,
  capacity integer NULL,
  type integer NOT NULL,
  cost float NOT NULL,
  floor integer NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla results
--

CREATE TABLE results (
  id serial NOT NULL,
  section_id integer NOT NULL,
  data text[] NOT NULL,
  solution_id integer NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla solutions
--

CREATE TABLE solutions (
  id serial NOT NULL,
  user_id integer NOT NULL,
  since timestamp NOT NULL,
  until timestamp NOT NULL,
  time_reduction double precision NOT NULL DEFAULT 0,
  distance_reduction double precision NOT NULL DEFAULT 0,
  reservePerc float NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla users
--

CREATE TABLE users (
  id serial NOT NULL,
  name varchar(45) NULL,
  username varchar(50) UNIQUE NOT NULL,
  password varchar(500) NOT NULL,
  no_lt integer NULL DEFAULT NULL,
  energy_costs real NULL DEFAULT NULL,
  energy_consumption real NULL DEFAULT NULL,
  transport_type text NULL DEFAULT NULL,
  employee_cost real NULL DEFAULT NULL,
  maintaince real NULL DEFAULT NULL,
  main_freq integer NULL DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla products
--

CREATE TABLE products (
  id serial NOT NULL,
  name text NULL,
  ean varchar(50) NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla containers
--

CREATE TABLE inventory (
  id serial NOT NULL,
  section_id integer NOT NULL,
  data text[] NULL DEFAULT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla beacons
--

CREATE TABLE beacons (
  id serial NOT NULL,
  uuid text NOT NULL,
  major integer NOT NULL,
  minor integer UNIQUE NULL,
  position text NULL DEFAULT NULL,
  vertex_1 integer NOT NULL,
  vertex_2 integer NOT NULL,
  has_beacon boolean NOT NULL DEFAULT FALSE,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla adjacencies
--

CREATE TABLE adjacencies (
  id serial NOT NULL,
  beacon_id integer NOT NULL,
  adjacent_beacon_id integer NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla rearrangements
--

CREATE TABLE rearrangements (
  id serial NOT NULL,
  initial_section integer NOT NULL,
  final_section integer NOT NULL,
  ean varchar(50) NOT NULL,
  solution_id integer NOT NULL,
  step integer NULL DEFAULT NULL,
  completed boolean NOT NULL DEFAULT FALSE,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla wh_types
--

CREATE TABLE wh_types (
  id serial NOT NULL,
  type integer NOT NULL UNIQUE,
  name text NULL DEFAULT NULL,
  move boolean NOT NULL DEFAULT TRUE,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla logs
--

CREATE TABLE logs (
  id serial NOT NULL,
  type integer NOT NULL,
  log text NULL DEFAULT NULL,
  route_id integer NOT NULL,
  created_at timestamp NOT NULL DEFAULT now(),
  updated_at timestamp NOT NULL DEFAULT now()
) ;
--
-- ADD PRIMARY KEYS
--

--
-- Indices de la tabla lift_trucks
--
ALTER TABLE lift_trucks
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla locations
--
ALTER TABLE locations
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla routes
--
ALTER TABLE routes
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla vertexes
--
ALTER TABLE vertexes
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla sections
--
ALTER TABLE sections
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla results
--
ALTER TABLE results
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla solutions
--
ALTER TABLE solutions
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla users
--
ALTER TABLE users
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla products
--
ALTER TABLE products
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla inventory
--
ALTER TABLE inventory
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla beacons
--
ALTER TABLE beacons
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla adjacencies
--
ALTER TABLE adjacencies
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla rearrangements
--
ALTER TABLE rearrangements
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla wh_types
--
ALTER TABLE wh_types
  ADD PRIMARY KEY (id);

--
-- Indices de la tabla logs
--
ALTER TABLE logs
  ADD PRIMARY KEY (id);

--ALTER TABLE locations ADD CONSTRAINT lifttruck_fk FOREIGN KEY (lift_truck_id)
-- REFERENCES lift_trucks(id) MATCH FULL;

--ALTER TABLE locations ADD CONSTRAINT route_fk FOREIGN KEY (route_id)
-- REFERENCES routes(id) MATCH FULL;

--ALTER TABLE locations ADD CONSTRAINT section_fk FOREIGN KEY (section_id)
-- REFERENCES sections(id) MATCH FULL;

ALTER TABLE sections ADD CONSTRAINT beacon_fk FOREIGN KEY (beacon_id)
 REFERENCES beacons(id) ON DELETE CASCADE;

ALTER TABLE sections ADD CONSTRAINT type_fk FOREIGN KEY (type)
 REFERENCES wh_types(type) MATCH FULL;

ALTER TABLE routes ADD CONSTRAINT lifttruck_fk FOREIGN KEY (lift_truck_id)
 REFERENCES lift_trucks(id) MATCH FULL;

ALTER TABLE routes ADD CONSTRAINT i_section_fk FOREIGN KEY (initial_section)
 REFERENCES sections(id) ON DELETE CASCADE;

ALTER TABLE routes ADD CONSTRAINT f_section_fk FOREIGN KEY (final_section)
 REFERENCES sections(id) ON DELETE CASCADE;

ALTER TABLE results ADD CONSTRAINT section_fk FOREIGN KEY (section_id)
 REFERENCES sections(id) ON DELETE CASCADE;

ALTER TABLE solutions ADD CONSTRAINT user_fk FOREIGN KEY (user_id)
 REFERENCES users(id) MATCH FULL;

ALTER TABLE results ADD CONSTRAINT solution_fk FOREIGN KEY (solution_id)
 REFERENCES solutions(id) MATCH FULL;

ALTER TABLE inventory ADD CONSTRAINT section_fk FOREIGN KEY (section_id)
 REFERENCES sections(id) ON DELETE CASCADE;

ALTER TABLE beacons ADD CONSTRAINT vertex_1_fk FOREIGN KEY (vertex_1)
 REFERENCES vertexes(id) MATCH FULL;

ALTER TABLE beacons ADD CONSTRAINT vertex_2_fk FOREIGN KEY (vertex_2)
 REFERENCES vertexes(id) MATCH FULL;

ALTER TABLE adjacencies ADD CONSTRAINT beacon_fk FOREIGN KEY (beacon_id)
 REFERENCES beacons(id) MATCH FULL;

ALTER TABLE adjacencies ADD CONSTRAINT adjacent_fk FOREIGN KEY (adjacent_beacon_id)
 REFERENCES beacons(id) MATCH FULL;

ALTER TABLE rearrangements ADD CONSTRAINT i_section_fk FOREIGN KEY (initial_section)
 REFERENCES sections(id) ON DELETE CASCADE;

ALTER TABLE rearrangements ADD CONSTRAINT f_section_fk FOREIGN KEY (final_section)
 REFERENCES sections(id) ON DELETE CASCADE;

ALTER TABLE logs ADD CONSTRAINT route_fk FOREIGN KEY (route_id)
 REFERENCES routes(id) ON DELETE CASCADE;
--
-- Triggers de updated_at
--

CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
NEW.updated_at = now();
RETURN NEW;
END;
$$ language 'plpgsql';


--
-- Triggers para todas las tablas
--

CREATE TRIGGER update_updated_at BEFORE UPDATE ON lift_trucks FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON locations FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON routes FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON vertexes FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON sections FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON results FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON solutions FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON products FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON inventory FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON beacons FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON adjacencies FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON rearrangements FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON wh_types FOR EACH ROW EXECUTE PROCEDURE update_modified_column();
CREATE TRIGGER update_updated_at BEFORE UPDATE ON logs FOR EACH ROW EXECUTE PROCEDURE update_modified_column();


--
-- Entradas para users
--

INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Fernando', 'fer541@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 10, 71, 43, 'Electricos', 100, 97, 7);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Isaac', 'isaac912@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 2, 58, 73, 'Electricos', 19, 14, 10);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Gualberto', 'Gual81@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 8, 71, 29, 'Electricos', 39, 56, 10);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Arnulfo', 'arnu812@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 3, 78, 14, 'Electricos', 91, 77, 1);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Arnold', 'cabezadebalon@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 2, 38, 26, 'Electricos', 56, 3, 5);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Cebollin', 'picante71@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 8, 99, 20, 'Electricos', 17, 97, 1);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Juan', 'juan@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 8, 20, 65, 'Electricos', 47, 22, 8);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Pablo', 'pablo91@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 4, 11, 47, 'Electricos', 58, 35, 10);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Luis', 'luis12@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 6, 68, 75, 'Electricos', 61, 54, 5);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Seiji', 'pokemon12@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 7, 73, 82, 'Electricos', 84, 22, 9);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Daniela', 'dan516@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 3, 93, 83, 'Electricos', 43, 100, 8);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Alejandra', 'ale91@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 5, 75, 90, 'Electricos', 15, 13, 2);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Victor', 'victor83@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 8, 51, 20, 'Electricos', 29, 99, 5);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Juan Pablo', 'juanpablo42@ge.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 2, 55, 18, 'Electricos', 92, 7, 7);
INSERT INTO users (name, username, password, no_lt, energy_costs, energy_consumption, transport_type, employee_cost, maintaince, main_freq) VALUES ('Alejandra Tubilla', 'alejandra.tubilla@gmail.com', 'ff960cb55673958c594d0daaab1e368651c75c02f9687192a1811e7b180336a7', 2, 55, 18, 'Electricos', 92, 7, 7);
-- Entradas para lift_trucks

INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');
INSERT INTO lift_trucks (type) VALUES ('Electrico');

--
-- Tipos de WH dentro de un mismo almacen
--

INSERT INTO wh_types (type, name, move) VALUES (0, 'Pasillos', FALSE);
INSERT INTO wh_types (type, name, move) VALUES (1, 'Zona de carga/descarga o produccion', FALSE);
INSERT INTO wh_types (type, name, move) VALUES (2, 'Rack con producto directo', TRUE);
INSERT INTO wh_types (type, name, move) VALUES (3, 'Rack de tarimas', TRUE);
INSERT INTO wh_types (type, name, move) VALUES (4, 'Espacio para productos pequenos', TRUE);

-- Entradas de vertices

INSERT INTO vertexes (x, y) VALUES (0, 0);
INSERT INTO vertexes (x, y) VALUES (0, 1);
INSERT INTO vertexes (x, y) VALUES (0, 2);
INSERT INTO vertexes (x, y) VALUES (0, 3);
INSERT INTO vertexes (x, y) VALUES (0, 4);
INSERT INTO vertexes (x, y) VALUES (0, 5);
INSERT INTO vertexes (x, y) VALUES (0, 6);
INSERT INTO vertexes (x, y) VALUES (1, 0);
INSERT INTO vertexes (x, y) VALUES (1, 1);
INSERT INTO vertexes (x, y) VALUES (1, 2);
INSERT INTO vertexes (x, y) VALUES (1, 3);
INSERT INTO vertexes (x, y) VALUES (1, 4);
INSERT INTO vertexes (x, y) VALUES (1, 5);
INSERT INTO vertexes (x, y) VALUES (1, 6);
INSERT INTO vertexes (x, y) VALUES (2, 0);
INSERT INTO vertexes (x, y) VALUES (2, 1);
INSERT INTO vertexes (x, y) VALUES (2, 2);
INSERT INTO vertexes (x, y) VALUES (2, 3);
INSERT INTO vertexes (x, y) VALUES (2, 4);
INSERT INTO vertexes (x, y) VALUES (2, 5);
INSERT INTO vertexes (x, y) VALUES (2, 6);
INSERT INTO vertexes (x, y) VALUES (3, 0);
INSERT INTO vertexes (x, y) VALUES (3, 1);
INSERT INTO vertexes (x, y) VALUES (3, 2);
INSERT INTO vertexes (x, y) VALUES (3, 3);
INSERT INTO vertexes (x, y) VALUES (3, 4);
INSERT INTO vertexes (x, y) VALUES (3, 5);
INSERT INTO vertexes (x, y) VALUES (3, 6);
INSERT INTO vertexes (x, y) VALUES (4, 0);
INSERT INTO vertexes (x, y) VALUES (4, 1);
INSERT INTO vertexes (x, y) VALUES (4, 2);
INSERT INTO vertexes (x, y) VALUES (4, 3);
INSERT INTO vertexes (x, y) VALUES (4, 4);
INSERT INTO vertexes (x, y) VALUES (4, 5);
INSERT INTO vertexes (x, y) VALUES (4, 6);
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Entradas de Beacons con vertices


-- Verticales

INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 1, 2, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 2, 3);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 3, 4, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 4, 5, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 5, 6, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 6, 7);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 9, 10);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 10, 11, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 11, 12, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 12, 13, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 13, 14);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 15, 16, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 16, 17);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 17, 18, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 18, 19, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 19, 20, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 20, 21);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 23, 24);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 24, 25, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 25, 26, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 26, 27, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 27, 28, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 29, 30, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 30, 31);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 31, 32);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 32, 33);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 33, 34);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 34, 35, TRUE);

-- Horizontales

INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 1, 8, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 8, 15, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 15, 22, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 22, 29, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 2, 9, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 9, 16, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 16, 23, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 23, 30, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 3, 10);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 10, 17);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 17, 24);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 24, 31);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 25, 32);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 26, 33);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 6, 13);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 13, 20);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 20, 27);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 27, 34, TRUE);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 7, 14);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 14, 21);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 21, 28);
INSERT INTO beacons (uuid, major, minor, vertex_1, vertex_2, has_beacon) VALUES ('4e6ed5ab-b3ed-4e10-8247-c5f5524d4b21', 12, NULL, 28, 35, TRUE);
INSERT INTO sections (beacon_id, type, cost) VALUES (1, 1, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (2, 5, 3, 3, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (3, 8, 2, 4, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (3, 8, 2, 4, 2);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (3, 8, 2, 4, 3);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (3, 8, 2, 4, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (4, 8, 2, 4, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (4, 8, 2, 4, 2);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (4, 8, 2, 4, 3);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (4, 8, 2, 4, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (5, 8, 2, 4, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (5, 8, 2, 4, 2);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (5, 8, 2, 4, 3);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (5, 8, 2, 4, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (6, 5, 3, 3, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (7, 5, 3, 3, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (8, 8, 2, 4, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (8, 8, 2, 4, 2);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (8, 8, 2, 4, 3);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (8, 8, 2, 4, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (9, 8, 2, 4, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (9, 8, 2, 4, 2);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (9, 8, 2, 4, 3);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (9, 8, 2, 4, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (10, 8, 2, 4, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (10, 8, 2, 4, 2);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (10, 8, 2, 4, 3);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (10, 8, 2, 4, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (11, 5, 3, 3, 1);
INSERT INTO sections (beacon_id, type, cost) VALUES (12, 1, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (13, 5, 3, 3, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (14, 8, 2, 4, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (14, 8, 2, 4, 2);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (14, 8, 2, 4, 3);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (14, 8, 2, 4, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (15, 8, 2, 4, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (15, 8, 2, 4, 2);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (15, 8, 2, 4, 3);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (15, 8, 2, 4, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (16, 8, 2, 4, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (16, 8, 2, 4, 2);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (16, 8, 2, 4, 3);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (16, 8, 2, 4, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (17, 5, 3, 3, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (18, 5, 3, 3, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (19, 8, 2, 4, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (19, 8, 2, 4, 2);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (19, 8, 2, 4, 3);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (19, 8, 2, 4, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (20, 8, 2, 4, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (20, 8, 2, 4, 2);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (20, 8, 2, 4, 3);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (20, 8, 2, 4, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (21, 8, 2, 4, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (21, 8, 2, 4, 2);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (21, 8, 2, 4, 3);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (21, 8, 2, 4, 4);
INSERT INTO sections (beacon_id, type, cost) VALUES (22, 1, 4);
INSERT INTO sections (beacon_id, type, cost) VALUES (23, 1, 4);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (24, 5, 3, 3, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (25, 5, 3, 3, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (26, 5, 3, 3, 1);
INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES (27, 5, 3, 3, 1);
INSERT INTO sections (beacon_id, type, cost) VALUES (28, 1, 4);
INSERT INTO sections (beacon_id, type, cost) VALUES (29, 1, 4);
INSERT INTO sections (beacon_id, type, cost) VALUES (30, 1, 4);
INSERT INTO sections (beacon_id, type, cost) VALUES (31, 1, 4);
INSERT INTO sections (beacon_id, type, cost) VALUES (32, 1, 4);
INSERT INTO sections (beacon_id, type, cost) VALUES (33, 1, 4);
INSERT INTO sections (beacon_id, type, cost) VALUES (34, 1, 4);
INSERT INTO sections (beacon_id, type, cost) VALUES (35, 1, 4);
INSERT INTO sections (beacon_id, type, cost) VALUES (36, 1, 4);
INSERT INTO sections (beacon_id, type, cost) VALUES (37, 0, 3);
INSERT INTO sections (beacon_id, type, cost) VALUES (38, 0, 3);
INSERT INTO sections (beacon_id, type, cost) VALUES (39, 0, 3);
INSERT INTO sections (beacon_id, type, cost) VALUES (40, 0, 3);
INSERT INTO sections (beacon_id, type, cost) VALUES (41, 0, 3);
INSERT INTO sections (beacon_id, type, cost) VALUES (42, 0, 3);
INSERT INTO sections (beacon_id, type, cost) VALUES (43, 0, 3);
INSERT INTO sections (beacon_id, type, cost) VALUES (44, 0, 3);
INSERT INTO sections (beacon_id, type, cost) VALUES (45, 0, 3);
INSERT INTO sections (beacon_id, type, cost) VALUES (46, 1, 4);
INSERT INTO sections (beacon_id, type, cost) VALUES (47, 0, 3);
INSERT INTO sections (beacon_id, type, cost) VALUES (48, 0, 3);
INSERT INTO sections (beacon_id, type, cost) VALUES (49, 0, 3);
INSERT INTO sections (beacon_id, type, cost) VALUES (50, 1, 4);

--
-- Entradas de rutas ejemplos
--
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 46, 82, '8412345678905', 21, '79');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 6, 65, '1234567654324', 10, '235');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 33, 66, '5012345678900', 14, '256');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 51, 65, '712345678911', 8, '41');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 37, 68, '1234567654324', 10, '207');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 11, 70, '7861234500123', 20, '159');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 12, 72, '701197952225', 6, '59');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 51, 66, '7501234567893', 19, '197');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 53, 59, '7861234500123', 20, '291');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 52, 58, '712345678911', 8, '73');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 32, 30, '5014016150821', 15, '229');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 22, 82, '012345678905', 0, '159');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 34, 65, '5060123456783', 16, '163');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 54, 72, '9310779300005', 23, '268');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 34, 66, '791234567901', 9, '222');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 9, 71, '9780201379624', 25, '204');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 55, 68, '791234567901', 9, '37');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 36, 86, '9781234567897', 26, '24');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 18, 71, '9780201379624', 25, '122');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 39, 1, '705632085943', 7, '73');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 25, 65, '0123456789104', 2, '299');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 57, 72, '3800065711135', 12, '24');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 50, 68, '8412345678905', 21, '196');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 27, 70, '701197952225', 6, '91');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 32, 72, '8412345678905', 21, '223');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 43, 58, '9781234567897', 26, '283');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 55, 70, '7123456789015', 18, '75');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 4, 59, '9771234567003', 24, '158');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 11, 69, '5901234123457', 17, '87');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 56, 72, '705632085943', 7, '99');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 28, 65, '8412345678905', 21, '65');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 38, 86, '9002236311036', 22, '263');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 3, 82, '7123456789015', 18, '259');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 9, 71, '9780201379624', 25, '259');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 53, 68, '705632085943', 7, '57');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 6, 70, '8412345678905', 21, '246');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 25, 71, '640509040147', 5, '145');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 20, 69, '0123456789104', 2, '96');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 20, 1, '9781234567897', 26, '296');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 27, 59, '7861234500123', 20, '203');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 48, 72, '9780201379624', 25, '136');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 27, 71, '012345678905', 0, '97');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 49, 86, '5012345678900', 14, '170');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 41, 71, '416000336108', 4, '247');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 26, 70, '3800065711135', 12, '229');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 28, 69, '7501234567893', 19, '134');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 14, 59, '5014016150821', 15, '102');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 13, 58, '123456789104', 3, '256');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 9, 58, '791234567901', 9, '295');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 4, 58, '3800065711135', 12, '136');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 10, 58, '123456789012', 1, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 13, 30, '8412345678905', 21, '174');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 19, 71, '1234567654324', 10, '243');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 19, 1, '5012345678900', 14, '211');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 28, 69, '9771234567003', 24, '150');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 5, 68, '9781234567897', 26, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 21, 82, '701197952225', 6, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 7, 71, '012345678905', 0, '105');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 7, 67, '712345678911', 8, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 36, 70, '8412345678905', 21, '167');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 43, 65, '712345678911', 8, '154');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 47, 82, '7861234500123', 20, '254');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 42, 67, '5014016150821', 15, '283');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 48, 1, '123456789012', 1, '159');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 47, 67, '9310779300005', 23, '228');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 41, 82, '8412345678905', 21, '186');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 34, 66, '0123456789104', 2, '146');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 7, 69, '9310779300005', 23, '131');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 36, 82, '7501234567893', 19, '27');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 26, 72, '416000336108', 4, '93');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 19, 66, '012345678905', 0, '215');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 32, 69, '416000336108', 4, '146');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 27, 71, '0123456789104', 2, '127');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 26, 72, '9781234567897', 26, '263');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 50, 67, '5012345678900', 14, '119');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 6, 58, '7123456789015', 18, '300');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 22, 71, '640509040147', 5, '231');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 49, 30, '0123456789104', 2, '231');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 47, 70, '9310779300005', 23, '105');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 57, 71, '7123456789015', 18, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 14, 86, '123456789104', 3, '33');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 11, 59, '712345678911', 8, '224');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 7, 58, '7123456789015', 18, '209');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 25, 58, '0123456789104', 2, '83');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 27, 66, '712345678911', 8, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 3, 68, '5012345678900', 14, '90');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 46, 71, '9781234567897', 26, '21');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 41, 70, '5060123456783', 16, '224');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 22, 65, '5014016150821', 15, '168');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 32, 67, '701197952225', 6, '79');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 53, 65, '5014016150821', 15, '208');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 47, 82, '1234567891231', 11, '177');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 47, 1, '5901234123457', 17, '125');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 9, 67, '123456789012', 1, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 8, 59, '123456789104', 3, '259');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 14, 65, '9781234567897', 26, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 38, 72, '791234567901', 9, '53');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 34, 1, '123456789104', 3, '121');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 24, 65, '5012345678900', 14, '73');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (1, 43, 72, '123456789104', 3, '128');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 41, 58, '7861234500123', 20, '173');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 39, 66, '8412345678905', 21, '22');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 14, 67, '3800065711135', 12, '56');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 28, 69, '640509040147', 5, '299');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 50, 86, '9780201379624', 25, '59');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 27, 1, '416000336108', 4, '114');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 39, 69, '123456789012', 1, '58');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 8, 65, '9780201379624', 25, '168');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 4, 82, '791234567901', 9, '128');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 13, 86, '8412345678905', 21, '165');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 40, 65, '9002236311036', 22, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 46, 65, '791234567901', 9, '172');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 48, 59, '123456789104', 3, '136');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 36, 59, '712345678911', 8, '223');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 23, 82, '123456789104', 3, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 18, 67, '705632085943', 7, '70');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 48, 82, '712345678911', 8, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 40, 59, '640509040147', 5, '156');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 25, 58, '9781234567897', 26, '272');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 27, 70, '3800065711135', 12, '235');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 56, 86, '5014016150821', 15, '43');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 50, 58, '701197952225', 6, '107');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 14, 72, '9771234567003', 24, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 11, 59, '3800065711135', 12, '248');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 4, 30, '9310779300005', 23, '254');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 8, 59, '712345678911', 8, '27');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 7, 72, '791234567901', 9, '59');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 47, 72, '8412345678905', 21, '175');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 49, 69, '5060123456783', 16, '77');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 25, 71, '123456789012', 1, '85');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 46, 66, '701197952225', 6, '95');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 32, 86, '640509040147', 5, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 13, 59, '7501234567893', 19, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 32, 59, '3800065711135', 12, '148');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 24, 59, '701197952225', 6, '55');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 47, 1, '7501234567893', 19, '155');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 20, 70, '123456789104', 3, '287');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 11, 64, '123456789012', 1, '255');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 52, 68, '123456789104', 3, '219');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 55, 66, '416000336108', 4, '140');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 37, 66, '123456789104', 3, '147');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 26, 59, '123456789012', 1, '20');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 43, 68, '3800065711135', 12, '242');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 46, 65, '7123456789015', 18, '86');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 52, 69, '705632085943', 7, '42');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 50, 1, '5901234123457', 17, '103');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 52, 59, '0123456789104', 2, '170');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 39, 64, '1234567891231', 11, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 48, 59, '791234567901', 9, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 22, 69, '4007630000116', 13, '278');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 25, 58, '7861234500123', 20, '288');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 27, 59, '123456789012', 1, '106');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 56, 59, '640509040147', 5, '191');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 14, 64, '5014016150821', 15, '228');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 28, 86, '7861234500123', 20, '195');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 49, 1, '640509040147', 5, '56');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 12, 66, '0123456789104', 2, '277');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 52, 59, '1234567891231', 11, '245');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 36, 67, '7123456789015', 18, '99');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 47, 59, '9310779300005', 23, '30');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 55, 69, '1234567654324', 10, '208');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 13, 66, '9781234567897', 26, '241');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 9, 65, '9788679912077', 27, '39');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 39, 70, '0123456789104', 2, '83');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 46, 72, '0123456789104', 2, '280');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 17, 64, '3800065711135', 12, '121');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 7, 82, '701197952225', 6, '209');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 54, 1, '5012345678900', 14, '136');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 18, 86, '8412345678905', 21, '216');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 39, 59, '705632085943', 7, '285');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 53, 66, '791234567901', 9, '200');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 54, 65, '7123456789015', 18, '285');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 24, 59, '9310779300005', 23, '219');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 27, 65, '712345678911', 8, '290');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 23, 70, '1234567891231', 11, '290');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 11, 64, '0123456789104', 2, '254');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 52, 72, '3800065711135', 12, '298');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 32, 86, '9002236311036', 22, '277');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 8, 71, '9781234567897', 26, '146');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 40, 71, '7501234567893', 19, '61');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 21, 72, '9310779300005', 23, '108');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 53, 1, '4007630000116', 13, '174');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 5, 71, '9310779300005', 23, '293');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 48, 66, '0123456789104', 2, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 14, 71, '7501234567893', 19, '42');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 7, 68, '9780201379624', 25, '231');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 40, 69, '416000336108', 4, '96');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 49, 86, '4007630000116', 13, '197');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 12, 58, '9780201379624', 25, '192');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 7, 70, '5014016150821', 15, '279');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 47, 70, '640509040147', 5, '108');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 40, 71, '5014016150821', 15, '255');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 20, 82, '5901234123457', 17, '235');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 3, 66, '791234567901', 9, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 32, 64, '640509040147', 5, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 27, 1, '9780201379624', 25, '294');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 26, 65, '640509040147', 5, '210');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 48, 72, '123456789104', 3, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 52, 67, '8412345678905', 21, '153');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 19, 70, '705632085943', 7, '98');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 11, 69, '8412345678905', 21, '146');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 53, 1, '9310779300005', 23, '87');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 55, 58, '9781234567897', 26, '31');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 11, 64, '9781234567897', 26, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (2, 17, 70, '416000336108', 4, '181');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 26, 72, '7501234567893', 19, '43');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 37, 65, '640509040147', 5, '274');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 54, 65, '640509040147', 5, '63');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 24, 69, '012345678905', 0, '271');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 10, 82, '791234567901', 9, '88');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 27, 64, '9771234567003', 24, '232');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 32, 72, '9002236311036', 22, '219');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 41, 72, '705632085943', 7, '208');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 27, 86, '5901234123457', 17, '130');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 7, 82, '791234567901', 9, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 54, 64, '5060123456783', 16, '184');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 52, 58, '0123456789104', 2, '256');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 12, 65, '123456789104', 3, '45');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 26, 67, '640509040147', 5, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 6, 72, '701197952225', 6, '44');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 24, 65, '9310779300005', 23, '153');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 3, 59, '9002236311036', 22, '114');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 46, 58, '3800065711135', 12, '299');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 37, 65, '791234567901', 9, '239');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 32, 59, '416000336108', 4, '258');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 6, 30, '712345678911', 8, '274');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 21, 67, '4007630000116', 13, '59');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 19, 69, '5012345678900', 14, '144');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 26, 72, '9788679912077', 27, '34');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 52, 59, '123456789012', 1, '197');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 48, 68, '416000336108', 4, '118');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 46, 86, '9310779300005', 23, '75');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 8, 67, '5014016150821', 15, '128');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 19, 71, '3800065711135', 12, '220');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 41, 68, '705632085943', 7, '22');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 9, 82, '123456789012', 1, '255');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 48, 66, '123456789104', 3, '83');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 24, 68, '416000336108', 4, '105');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 54, 1, '0123456789104', 2, '61');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 32, 82, '9771234567003', 24, '61');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 5, 82, '416000336108', 4, '75');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 28, 67, '0123456789104', 2, '201');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 4, 66, '1234567891231', 11, '88');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 35, 58, '4007630000116', 13, '148');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 22, 86, '5060123456783', 16, '219');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 47, 82, '712345678911', 8, '138');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 5, 1, '123456789012', 1, '36');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 54, 66, '9771234567003', 24, '41');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 57, 66, '9310779300005', 23, '295');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 21, 30, '5014016150821', 15, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 43, 30, '791234567901', 9, '289');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 52, 1, '5014016150821', 15, '221');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 57, 70, '1234567654324', 10, '198');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 40, 66, '705632085943', 7, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 36, 64, '1234567654324', 10, '142');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 27, 72, '5012345678900', 14, '86');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 25, 72, '1234567654324', 10, '167');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 6, 71, '791234567901', 9, '228');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 51, 66, '0123456789104', 2, '57');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 47, 82, '7123456789015', 18, '261');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 12, 59, '701197952225', 6, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 43, 68, '012345678905', 0, '67');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 36, 64, '123456789012', 1, '258');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 54, 67, '3800065711135', 12, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 43, 67, '012345678905', 0, '293');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 35, 58, '9788679912077', 27, '96');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 49, 64, '791234567901', 9, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 34, 64, '640509040147', 5, '68');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 51, 68, '9780201379624', 25, '177');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 35, 70, '9310779300005', 23, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 57, 58, '9781234567897', 26, '206');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 26, 82, '791234567901', 9, '299');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 18, 58, '5060123456783', 16, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 14, 68, '9310779300005', 23, '58');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 42, 82, '9771234567003', 24, '53');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 7, 1, '416000336108', 4, '23');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 43, 58, '791234567901', 9, '293');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 19, 72, '012345678905', 0, '79');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 5, 82, '791234567901', 9, '270');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 12, 70, '8412345678905', 21, '68');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 10, 67, '123456789012', 1, '260');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 56, 66, '9771234567003', 24, '184');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 32, 66, '0123456789104', 2, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 32, 68, '3800065711135', 12, '279');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 35, 30, '9310779300005', 23, '31');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 48, 58, '0123456789104', 2, '75');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 13, 59, '7861234500123', 20, '88');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 20, 30, '5060123456783', 16, '217');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 9, 69, '5012345678900', 14, '138');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 25, 72, '0123456789104', 2, '100');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 38, 69, '5012345678900', 14, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 40, 86, '705632085943', 7, '172');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 23, 86, '4007630000116', 13, '184');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 4, 69, '9788679912077', 27, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 27, 30, '5012345678900', 14, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 43, 70, '5060123456783', 16, '277');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 8, 64, '9310779300005', 23, '176');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 21, 30, '3800065711135', 12, '247');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 51, 71, '712345678911', 8, '43');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 3, 59, '123456789012', 1, '296');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 47, 59, '9310779300005', 23, '54');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 53, 59, '701197952225', 6, '169');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 20, 64, '8412345678905', 21, '70');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 56, 70, '5012345678900', 14, '50');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 35, 58, '9788679912077', 27, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 47, 66, '4007630000116', 13, '278');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 17, 86, '640509040147', 5, '160');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 48, 71, '0123456789104', 2, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 9, 59, '7123456789015', 18, '28');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 17, 59, '7123456789015', 18, '256');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 50, 72, '8412345678905', 21, '277');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 23, 69, '9781234567897', 26, '111');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 12, 86, '4007630000116', 13, '135');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 3, 64, '0123456789104', 2, '92');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 12, 70, '123456789012', 1, '202');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 8, 82, '9781234567897', 26, '182');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 53, 66, '5060123456783', 16, '282');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 8, 68, '9002236311036', 22, '219');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 55, 64, '4007630000116', 13, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 17, 58, '1234567891231', 11, '294');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 33, 69, '712345678911', 8, '74');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 43, 59, '8412345678905', 21, '24');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 22, 69, '5060123456783', 16, '229');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 3, 65, '5901234123457', 17, '42');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 34, 86, '1234567654324', 10, '192');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 41, 65, '1234567654324', 10, '87');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 42, 86, '701197952225', 6, '191');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 27, 66, '8412345678905', 21, '300');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 6, 65, '9002236311036', 22, '128');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 55, 66, '701197952225', 6, '188');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 34, 65, '4007630000116', 13, '95');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 51, 72, '701197952225', 6, '210');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 49, 69, '5012345678900', 14, '22');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 46, 66, '5014016150821', 15, '157');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 34, 66, '1234567891231', 11, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 11, 64, '701197952225', 6, '95');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 14, 69, '9788679912077', 27, '150');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 27, 70, '3800065711135', 12, '156');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 22, 69, '1234567891231', 11, '109');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 55, 59, '701197952225', 6, '82');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 11, 64, '712345678911', 8, '74');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 54, 66, '705632085943', 7, '240');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 4, 66, '416000336108', 4, '35');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 6, 1, '9310779300005', 23, '122');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 13, 59, '4007630000116', 13, '278');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 27, 64, '1234567891231', 11, '50');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 24, 82, '5901234123457', 17, '99');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 8, 66, '3800065711135', 12, '144');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 23, 72, '701197952225', 6, '244');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 56, 67, '9310779300005', 23, '270');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 47, 86, '123456789012', 1, '141');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 19, 72, '416000336108', 4, '140');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 47, 70, '5060123456783', 16, '36');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 8, 1, '123456789104', 3, '227');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 11, 59, '1234567654324', 10, '77');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 23, 64, '4007630000116', 13, '80');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 24, 64, '712345678911', 8, '72');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 4, 67, '640509040147', 5, '277');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 53, 82, '123456789104', 3, '202');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 20, 82, '640509040147', 5, '152');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 46, 65, '8412345678905', 21, '175');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 4, 86, '705632085943', 7, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 28, 1, '9780201379624', 25, '289');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 7, 66, '123456789104', 3, '234');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 19, 1, '123456789012', 1, '85');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 21, 66, '791234567901', 9, '111');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 32, 30, '123456789012', 1, '132');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 22, 59, '9771234567003', 24, '97');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 49, 69, '9002236311036', 22, '216');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 10, 64, '712345678911', 8, '106');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 8, 82, '3800065711135', 12, '255');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 33, 72, '5012345678900', 14, '226');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 22, 58, '7123456789015', 18, '171');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 20, 59, '0123456789104', 2, '30');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 18, 68, '9771234567003', 24, '74');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 33, 82, '7123456789015', 18, '250');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (3, 41, 65, '712345678911', 8, '150');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 57, 72, '012345678905', 0, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 24, 67, '7501234567893', 19, '249');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 19, 72, '701197952225', 6, '217');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 52, 65, '4007630000116', 13, '199');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 18, 1, '1234567654324', 10, '258');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 52, 71, '7501234567893', 19, '161');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 34, 64, '9781234567897', 26, '24');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 5, 64, '791234567901', 9, '27');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 24, 86, '9788679912077', 27, '115');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 50, 70, '7501234567893', 19, '208');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 9, 65, '1234567654324', 10, '210');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 25, 71, '9002236311036', 22, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 46, 1, '5014016150821', 15, '206');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 17, 64, '7501234567893', 19, '76');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 39, 82, '123456789012', 1, '217');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 18, 69, '9780201379624', 25, '90');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 7, 1, '0123456789104', 2, '293');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 39, 67, '640509040147', 5, '193');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 57, 68, '640509040147', 5, '103');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 12, 86, '0123456789104', 2, '39');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 27, 65, '4007630000116', 13, '25');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 43, 65, '1234567654324', 10, '143');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 33, 71, '5060123456783', 16, '48');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 56, 67, '9781234567897', 26, '159');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 53, 58, '7861234500123', 20, '64');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 23, 65, '7861234500123', 20, '209');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 7, 72, '9788679912077', 27, '231');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 11, 82, '791234567901', 9, '189');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 3, 72, '712345678911', 8, '52');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 52, 58, '9002236311036', 22, '204');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 5, 64, '712345678911', 8, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 18, 64, '5012345678900', 14, '127');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 42, 72, '640509040147', 5, '57');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 38, 70, '9310779300005', 23, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 55, 86, '5012345678900', 14, '27');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 37, 82, '1234567654324', 10, '137');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 42, 64, '5901234123457', 17, '57');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 50, 65, '7501234567893', 19, '224');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 34, 59, '9780201379624', 25, '232');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 25, 86, '7861234500123', 20, '183');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 11, 72, '1234567654324', 10, '283');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 32, 70, '7861234500123', 20, '263');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 51, 64, '5012345678900', 14, '28');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 51, 69, '5012345678900', 14, '30');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 24, 66, '9781234567897', 26, '123');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 9, 1, '7123456789015', 18, '281');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 47, 66, '712345678911', 8, '151');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 36, 68, '5060123456783', 16, '265');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 7, 86, '9002236311036', 22, '105');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 14, 30, '705632085943', 7, '114');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 57, 70, '705632085943', 7, '213');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 36, 68, '8412345678905', 21, '165');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 26, 66, '791234567901', 9, '245');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 19, 65, '712345678911', 8, '266');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 28, 1, '1234567654324', 10, '267');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 12, 69, '791234567901', 9, '230');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 32, 1, '123456789104', 3, '177');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 23, 70, '9788679912077', 27, '237');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 23, 69, '9002236311036', 22, '272');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 41, 65, '8412345678905', 21, '277');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 47, 86, '8412345678905', 21, '228');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 20, 64, '7501234567893', 19, '148');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 43, 70, '712345678911', 8, '72');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 35, 30, '9780201379624', 25, '38');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 43, 30, '791234567901', 9, '78');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 7, 1, '640509040147', 5, '222');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 23, 30, '9002236311036', 22, '184');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 33, 65, '0123456789104', 2, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 11, 67, '640509040147', 5, '84');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 18, 66, '701197952225', 6, '93');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 37, 68, '9781234567897', 26, '92');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 51, 70, '7861234500123', 20, '144');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 43, 64, '123456789104', 3, '218');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 54, 86, '012345678905', 0, '78');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 42, 30, '712345678911', 8, '180');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 3, 68, '5012345678900', 14, '48');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 27, 69, '9780201379624', 25, '166');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 8, 70, '7861234500123', 20, '119');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 27, 64, '701197952225', 6, '169');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 23, 64, '7123456789015', 18, '141');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 17, 68, '7501234567893', 19, '252');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 26, 1, '640509040147', 5, '21');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 10, 1, '9002236311036', 22, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 38, 66, '1234567654324', 10, '265');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 53, 66, '705632085943', 7, '245');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 46, 65, '7123456789015', 18, '66');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 9, 30, '1234567891231', 11, '208');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 49, 66, '9788679912077', 27, '82');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 25, 64, '791234567901', 9, '71');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 46, 59, '1234567891231', 11, '281');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 43, 69, '123456789104', 3, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 18, 69, '5014016150821', 15, '51');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 6, 58, '9310779300005', 23, '149');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 13, 59, '1234567654324', 10, '31');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 42, 82, '5901234123457', 17, '93');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 28, 71, '4007630000116', 13, '179');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 24, 71, '5014016150821', 15, '215');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 10, 67, '640509040147', 5, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 46, 65, '9002236311036', 22, '206');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 11, 69, '7861234500123', 20, '282');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 12, 68, '123456789104', 3, '273');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 12, 65, '7501234567893', 19, '148');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 14, 58, '705632085943', 7, '244');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 42, 66, '7123456789015', 18, '102');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 54, 58, '9788679912077', 27, '179');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 21, 72, '4007630000116', 13, '254');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 5, 67, '4007630000116', 13, '93');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 48, 71, '8412345678905', 21, '146');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 3, 82, '9310779300005', 23, '66');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 13, 1, '4007630000116', 13, '171');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 55, 1, '5014016150821', 15, '274');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 48, 1, '0123456789104', 2, '85');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 7, 72, '705632085943', 7, '100');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 24, 72, '640509040147', 5, '165');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 56, 1, '791234567901', 9, '151');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 57, 70, '705632085943', 7, '24');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 39, 30, '712345678911', 8, '135');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 24, 67, '7123456789015', 18, '43');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 27, 69, '5060123456783', 16, '277');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 4, 1, '416000336108', 4, '87');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 13, 65, '7861234500123', 20, '104');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 38, 30, '0123456789104', 2, '60');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 5, 30, '1234567891231', 11, '129');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 5, 82, '701197952225', 6, '164');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 26, 70, '012345678905', 0, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 6, 1, '0123456789104', 2, '59');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 18, 59, '5060123456783', 16, '113');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 25, 72, '1234567891231', 11, '95');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 22, 1, '712345678911', 8, '25');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 54, 64, '9771234567003', 24, '222');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 50, 1, '5014016150821', 15, '40');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 21, 72, '123456789012', 1, '205');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 37, 70, '712345678911', 8, '171');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 41, 58, '9310779300005', 23, '256');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 20, 72, '7123456789015', 18, '77');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 21, 82, '1234567891231', 11, '152');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 22, 70, '123456789012', 1, '251');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 40, 66, '8412345678905', 21, '228');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 24, 71, '1234567654324', 10, '81');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 13, 72, '5901234123457', 17, '260');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 25, 59, '701197952225', 6, '252');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 51, 82, '416000336108', 4, '287');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 56, 64, '8412345678905', 21, '236');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 25, 82, '5012345678900', 14, '77');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 12, 66, '701197952225', 6, '271');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 36, 65, '9771234567003', 24, '91');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 18, 70, '012345678905', 0, '48');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 38, 82, '3800065711135', 12, '188');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 32, 58, '5901234123457', 17, '246');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 33, 69, '5060123456783', 16, '70');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 32, 64, '123456789104', 3, '104');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 23, 86, '123456789104', 3, '260');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 6, 30, '416000336108', 4, '290');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 36, 68, '5901234123457', 17, '106');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (4, 51, 69, '7123456789015', 18, '63');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 14, 1, '791234567901', 9, '108');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 46, 69, '5060123456783', 16, '123');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 22, 59, '0123456789104', 2, '164');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 52, 30, '5012345678900', 14, '163');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 23, 69, '416000336108', 4, '87');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 12, 68, '701197952225', 6, '125');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 36, 70, '012345678905', 0, '107');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 11, 71, '1234567654324', 10, '223');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 53, 82, '5901234123457', 17, '210');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 50, 66, '5901234123457', 17, '245');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 26, 1, '9771234567003', 24, '214');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 56, 71, '4007630000116', 13, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 36, 1, '012345678905', 0, '99');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 39, 70, '9771234567003', 24, '54');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 8, 82, '123456789012', 1, '71');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 38, 65, '123456789012', 1, '233');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 33, 30, '012345678905', 0, '243');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 3, 67, '1234567891231', 11, '243');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 53, 82, '4007630000116', 13, '83');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 8, 65, '012345678905', 0, '103');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 56, 70, '791234567901', 9, '144');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 46, 71, '1234567654324', 10, '55');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 25, 66, '1234567654324', 10, '103');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 46, 67, '1234567891231', 11, '38');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 43, 1, '7123456789015', 18, '66');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 21, 69, '7861234500123', 20, '99');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 38, 68, '9780201379624', 25, '284');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 52, 65, '701197952225', 6, '240');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 38, 58, '5012345678900', 14, '182');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 23, 30, '123456789104', 3, '102');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 19, 71, '1234567891231', 11, '84');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 41, 59, '5012345678900', 14, '44');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 39, 68, '791234567901', 9, '266');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 23, 72, '0123456789104', 2, '197');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 9, 67, '0123456789104', 2, '73');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 19, 30, '7861234500123', 20, '186');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 3, 1, '5012345678900', 14, '294');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 51, 59, '7123456789015', 18, '115');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 57, 68, '9310779300005', 23, '91');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 50, 58, '123456789012', 1, '248');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 39, 71, '8412345678905', 21, '52');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 42, 66, '712345678911', 8, '196');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 32, 1, '3800065711135', 12, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 21, 66, '705632085943', 7, '56');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 4, 82, '705632085943', 7, '152');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 25, 1, '0123456789104', 2, '252');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 49, 59, '7861234500123', 20, '54');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 6, 1, '712345678911', 8, '111');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 51, 64, '9788679912077', 27, '237');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 10, 71, '0123456789104', 2, '140');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 23, 71, '791234567901', 9, '98');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 7, 1, '012345678905', 0, '132');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 49, 58, '5060123456783', 16, '277');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 37, 68, '9310779300005', 23, '287');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 35, 69, '7123456789015', 18, '123');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 17, 86, '791234567901', 9, '70');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 6, 69, '123456789104', 3, '174');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 56, 70, '640509040147', 5, '136');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 10, 65, '9781234567897', 26, '264');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 35, 66, '1234567891231', 11, '188');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 23, 86, '7501234567893', 19, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 42, 72, '640509040147', 5, '184');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 37, 68, '5060123456783', 16, '165');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 47, 59, '5901234123457', 17, '97');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 57, 66, '705632085943', 7, '119');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 51, 69, '7123456789015', 18, '140');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 57, 68, '640509040147', 5, '47');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 20, 82, '4007630000116', 13, '284');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 49, 65, '7861234500123', 20, '155');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 56, 82, '9310779300005', 23, '47');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 47, 67, '9002236311036', 22, '137');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 39, 67, '4007630000116', 13, '253');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 36, 72, '7123456789015', 18, '46');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 51, 69, '9781234567897', 26, '40');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 41, 59, '712345678911', 8, '65');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 13, 72, '7501234567893', 19, '273');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 24, 1, '4007630000116', 13, '235');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 39, 72, '3800065711135', 12, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 26, 65, '712345678911', 8, '213');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 24, 64, '123456789012', 1, '47');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 19, 30, '9310779300005', 23, '222');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 53, 71, '712345678911', 8, '38');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 8, 58, '705632085943', 7, '272');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 35, 58, '7123456789015', 18, '176');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 54, 68, '3800065711135', 12, '106');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 9, 58, '640509040147', 5, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 53, 71, '1234567891231', 11, '67');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 17, 71, '701197952225', 6, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 13, 70, '9002236311036', 22, '182');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 32, 86, '416000336108', 4, '116');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 5, 70, '712345678911', 8, '267');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 10, 82, '9781234567897', 26, '42');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 48, 1, '5060123456783', 16, '249');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 53, 65, '5014016150821', 15, '30');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 35, 72, '7123456789015', 18, '198');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 36, 86, '9781234567897', 26, '156');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 13, 68, '701197952225', 6, '43');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 20, 30, '0123456789104', 2, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 50, 1, '123456789012', 1, '294');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 13, 64, '0123456789104', 2, '94');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 27, 65, '416000336108', 4, '243');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 57, 70, '4007630000116', 13, '167');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 8, 59, '701197952225', 6, '203');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 10, 82, '123456789012', 1, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 3, 59, '640509040147', 5, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 49, 59, '640509040147', 5, '65');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 25, 64, '1234567891231', 11, '31');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 25, 30, '712345678911', 8, '279');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 14, 70, '1234567654324', 10, '264');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 7, 30, '123456789104', 3, '25');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 8, 69, '1234567891231', 11, '199');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 40, 1, '9002236311036', 22, '254');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 57, 69, '9310779300005', 23, '43');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 17, 68, '712345678911', 8, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 54, 71, '0123456789104', 2, '283');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 27, 30, '712345678911', 8, '288');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 50, 67, '9310779300005', 23, '155');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 52, 68, '123456789104', 3, '100');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 22, 69, '012345678905', 0, '54');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 53, 65, '712345678911', 8, '83');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 25, 65, '5012345678900', 14, '79');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 4, 71, '5012345678900', 14, '217');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 19, 82, '123456789104', 3, '268');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 10, 30, '123456789104', 3, '100');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 23, 86, '7501234567893', 19, '270');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 3, 72, '1234567891231', 11, '252');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (5, 52, 30, '7123456789015', 18, '152');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 4, 66, '9310779300005', 23, '56');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 50, 70, '012345678905', 0, '58');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 51, 69, '7501234567893', 19, '235');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 36, 66, '7123456789015', 18, '266');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 17, 67, '640509040147', 5, '196');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 46, 58, '9310779300005', 23, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 27, 69, '9781234567897', 26, '196');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 28, 64, '416000336108', 4, '142');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 51, 65, '1234567891231', 11, '200');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 21, 65, '7861234500123', 20, '25');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 51, 67, '9771234567003', 24, '48');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 47, 82, '5901234123457', 17, '32');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 18, 71, '9310779300005', 23, '210');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 48, 59, '5012345678900', 14, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 54, 65, '7861234500123', 20, '133');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 17, 65, '123456789104', 3, '54');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 8, 72, '701197952225', 6, '194');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 6, 59, '9771234567003', 24, '21');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 14, 69, '8412345678905', 21, '188');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 55, 1, '9780201379624', 25, '158');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 14, 59, '7861234500123', 20, '257');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 8, 58, '712345678911', 8, '217');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 37, 65, '9771234567003', 24, '96');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 19, 66, '9310779300005', 23, '39');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 37, 82, '7861234500123', 20, '239');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 7, 68, '7501234567893', 19, '154');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 53, 72, '701197952225', 6, '112');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 24, 82, '7861234500123', 20, '157');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 49, 59, '5060123456783', 16, '245');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 41, 71, '123456789104', 3, '135');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 9, 68, '7501234567893', 19, '52');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 46, 70, '9780201379624', 25, '293');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 34, 64, '9780201379624', 25, '136');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 8, 71, '4007630000116', 13, '134');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 37, 66, '9310779300005', 23, '141');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 22, 64, '9788679912077', 27, '176');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 48, 68, '416000336108', 4, '244');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 53, 70, '9788679912077', 27, '75');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 56, 58, '9780201379624', 25, '160');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 25, 65, '9780201379624', 25, '96');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 35, 65, '9780201379624', 25, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 40, 82, '9771234567003', 24, '299');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 53, 82, '705632085943', 7, '194');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 28, 68, '1234567891231', 11, '205');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 34, 67, '9002236311036', 22, '248');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 21, 67, '9780201379624', 25, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 36, 71, '416000336108', 4, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 25, 67, '7861234500123', 20, '86');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 4, 72, '9788679912077', 27, '190');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 46, 59, '640509040147', 5, '299');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 9, 72, '9002236311036', 22, '140');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 4, 69, '7861234500123', 20, '284');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 21, 64, '640509040147', 5, '253');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 39, 72, '012345678905', 0, '34');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 26, 64, '791234567901', 9, '86');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 40, 69, '9002236311036', 22, '150');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 27, 71, '5014016150821', 15, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 3, 70, '416000336108', 4, '213');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 25, 1, '1234567654324', 10, '136');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 54, 65, '416000336108', 4, '106');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 27, 69, '9771234567003', 24, '153');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 49, 65, '5014016150821', 15, '74');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 8, 64, '7501234567893', 19, '208');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 23, 69, '012345678905', 0, '219');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 49, 68, '012345678905', 0, '232');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 18, 70, '7501234567893', 19, '150');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 37, 30, '416000336108', 4, '206');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 5, 59, '791234567901', 9, '290');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 14, 71, '0123456789104', 2, '245');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 25, 86, '7861234500123', 20, '26');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 9, 58, '7123456789015', 18, '259');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 39, 65, '5901234123457', 17, '83');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 18, 65, '9002236311036', 22, '186');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 26, 30, '7861234500123', 20, '189');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 35, 1, '5014016150821', 15, '244');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 34, 69, '123456789012', 1, '289');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 18, 64, '712345678911', 8, '224');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 17, 30, '701197952225', 6, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 17, 66, '012345678905', 0, '266');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 40, 64, '9788679912077', 27, '51');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 22, 70, '7123456789015', 18, '79');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 23, 1, '5012345678900', 14, '189');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 4, 30, '8412345678905', 21, '157');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 36, 58, '7501234567893', 19, '247');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 19, 59, '705632085943', 7, '279');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 11, 86, '123456789104', 3, '231');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 23, 86, '7861234500123', 20, '30');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 53, 67, '9310779300005', 23, '266');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 18, 59, '123456789104', 3, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 55, 30, '0123456789104', 2, '221');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 37, 69, '9310779300005', 23, '241');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 52, 72, '123456789012', 1, '86');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 22, 64, '5060123456783', 16, '132');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 35, 58, '712345678911', 8, '26');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 56, 70, '123456789104', 3, '183');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 57, 71, '012345678905', 0, '56');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 28, 65, '0123456789104', 2, '143');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 22, 58, '9780201379624', 25, '265');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 19, 86, '7861234500123', 20, '31');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 51, 68, '7861234500123', 20, '82');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 11, 59, '123456789104', 3, '161');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 19, 86, '416000336108', 4, '125');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 54, 59, '012345678905', 0, '174');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 54, 66, '705632085943', 7, '217');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 35, 58, '9310779300005', 23, '261');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 42, 70, '7501234567893', 19, '35');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 22, 59, '123456789104', 3, '20');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 7, 66, '9788679912077', 27, '230');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 50, 86, '705632085943', 7, '47');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 42, 69, '9780201379624', 25, '291');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 39, 86, '9780201379624', 25, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 47, 30, '705632085943', 7, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 27, 86, '5901234123457', 17, '201');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 46, 65, '701197952225', 6, '266');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 40, 68, '9781234567897', 26, '224');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 13, 59, '1234567891231', 11, '221');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 5, 71, '123456789012', 1, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 39, 70, '3800065711135', 12, '149');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 19, 70, '9788679912077', 27, '196');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 54, 69, '705632085943', 7, '122');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 36, 64, '3800065711135', 12, '284');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 37, 30, '8412345678905', 21, '251');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 13, 65, '791234567901', 9, '91');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 33, 64, '1234567654324', 10, '148');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 25, 68, '1234567891231', 11, '285');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 41, 71, '1234567654324', 10, '122');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 6, 58, '123456789104', 3, '291');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 56, 71, '4007630000116', 13, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 22, 70, '3800065711135', 12, '171');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 53, 82, '9780201379624', 25, '197');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 47, 64, '123456789012', 1, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 18, 69, '9771234567003', 24, '71');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 54, 71, '7501234567893', 19, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 41, 65, '9780201379624', 25, '126');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 42, 69, '712345678911', 8, '56');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 21, 67, '5012345678900', 14, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 33, 82, '640509040147', 5, '172');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 27, 59, '701197952225', 6, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 53, 64, '9310779300005', 23, '249');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 52, 65, '1234567654324', 10, '239');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 10, 86, '416000336108', 4, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 47, 69, '0123456789104', 2, '118');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 21, 66, '5060123456783', 16, '216');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 39, 71, '5060123456783', 16, '37');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 39, 59, '5901234123457', 17, '85');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 56, 65, '5901234123457', 17, '31');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 42, 1, '1234567654324', 10, '88');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 10, 69, '0123456789104', 2, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 24, 71, '640509040147', 5, '104');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 23, 66, '0123456789104', 2, '128');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 49, 64, '9002236311036', 22, '271');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 19, 68, '712345678911', 8, '177');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 46, 59, '0123456789104', 2, '125');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 3, 86, '9788679912077', 27, '276');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 6, 69, '1234567891231', 11, '26');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 11, 71, '9002236311036', 22, '244');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 12, 68, '1234567891231', 11, '245');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 4, 82, '640509040147', 5, '299');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 13, 69, '712345678911', 8, '154');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 34, 82, '5901234123457', 17, '129');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 28, 72, '4007630000116', 13, '88');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 50, 68, '9781234567897', 26, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 43, 70, '9771234567003', 24, '118');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 14, 1, '705632085943', 7, '116');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 56, 59, '705632085943', 7, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 19, 1, '9788679912077', 27, '179');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 28, 1, '9788679912077', 27, '221');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 56, 71, '9780201379624', 25, '74');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 11, 65, '705632085943', 7, '40');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 32, 86, '8412345678905', 21, '254');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 13, 68, '705632085943', 7, '123');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 25, 72, '7123456789015', 18, '202');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 47, 66, '0123456789104', 2, '141');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 50, 71, '4007630000116', 13, '300');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 49, 65, '4007630000116', 13, '298');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 27, 64, '712345678911', 8, '92');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 10, 59, '5060123456783', 16, '134');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 20, 66, '0123456789104', 2, '125');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 40, 71, '012345678905', 0, '91');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 21, 66, '1234567891231', 11, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 53, 59, '9780201379624', 25, '204');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 54, 1, '7123456789015', 18, '79');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 50, 30, '8412345678905', 21, '187');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 48, 30, '5014016150821', 15, '127');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 57, 30, '9310779300005', 23, '27');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 47, 68, '705632085943', 7, '92');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (6, 19, 71, '791234567901', 9, '85');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 7, 68, '1234567654324', 10, '269');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 27, 65, '7861234500123', 20, '232');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 55, 30, '012345678905', 0, '244');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 32, 65, '701197952225', 6, '80');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 57, 67, '0123456789104', 2, '103');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 23, 69, '9310779300005', 23, '141');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 32, 30, '3800065711135', 12, '206');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 14, 58, '9310779300005', 23, '176');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 20, 64, '5901234123457', 17, '176');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 12, 69, '5012345678900', 14, '25');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 53, 30, '1234567891231', 11, '279');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 24, 71, '7861234500123', 20, '134');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 26, 69, '7861234500123', 20, '70');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 40, 30, '416000336108', 4, '20');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 19, 72, '9781234567897', 26, '48');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 12, 68, '416000336108', 4, '59');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 41, 68, '123456789012', 1, '164');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 43, 59, '123456789012', 1, '208');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 21, 71, '640509040147', 5, '161');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 40, 59, '5012345678900', 14, '122');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 12, 70, '640509040147', 5, '213');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 57, 30, '9780201379624', 25, '204');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 12, 72, '9788679912077', 27, '36');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 42, 65, '3800065711135', 12, '96');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 56, 58, '3800065711135', 12, '85');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 57, 1, '416000336108', 4, '237');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 42, 70, '701197952225', 6, '33');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 5, 30, '7861234500123', 20, '77');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 3, 58, '123456789012', 1, '238');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 18, 59, '416000336108', 4, '137');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 27, 65, '4007630000116', 13, '108');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 19, 86, '7861234500123', 20, '149');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 6, 67, '5060123456783', 16, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 11, 69, '9310779300005', 23, '76');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 55, 59, '9310779300005', 23, '33');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 11, 64, '5012345678900', 14, '202');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 13, 67, '712345678911', 8, '299');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 27, 1, '7123456789015', 18, '82');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 53, 69, '9781234567897', 26, '252');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 53, 58, '791234567901', 9, '145');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 54, 86, '1234567891231', 11, '129');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 41, 67, '416000336108', 4, '130');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 33, 30, '9780201379624', 25, '257');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 32, 82, '8412345678905', 21, '229');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 3, 68, '7501234567893', 19, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 14, 68, '123456789012', 1, '105');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 4, 71, '701197952225', 6, '250');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 43, 72, '416000336108', 4, '98');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 27, 66, '791234567901', 9, '140');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 41, 1, '4007630000116', 13, '100');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 49, 72, '9781234567897', 26, '30');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 35, 1, '701197952225', 6, '48');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 28, 82, '8412345678905', 21, '72');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 9, 70, '123456789104', 3, '146');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 13, 1, '5012345678900', 14, '76');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 54, 64, '416000336108', 4, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 25, 71, '123456789104', 3, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 9, 1, '9788679912077', 27, '82');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 24, 69, '0123456789104', 2, '55');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 24, 58, '123456789104', 3, '268');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 50, 69, '9788679912077', 27, '36');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 28, 68, '9788679912077', 27, '149');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 57, 86, '9780201379624', 25, '203');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 53, 86, '4007630000116', 13, '60');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 50, 59, '9771234567003', 24, '116');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 52, 70, '1234567891231', 11, '61');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 10, 68, '012345678905', 0, '213');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 49, 1, '791234567901', 9, '22');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 7, 72, '9781234567897', 26, '213');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 21, 71, '123456789104', 3, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 25, 64, '123456789104', 3, '169');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 46, 67, '4007630000116', 13, '98');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 53, 68, '5060123456783', 16, '210');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 23, 72, '9780201379624', 25, '272');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 24, 30, '9002236311036', 22, '84');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 22, 59, '5012345678900', 14, '184');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 3, 82, '4007630000116', 13, '141');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 18, 69, '705632085943', 7, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 19, 64, '8412345678905', 21, '215');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 48, 64, '012345678905', 0, '165');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 25, 70, '123456789012', 1, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 32, 58, '1234567654324', 10, '274');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 36, 86, '7123456789015', 18, '186');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 28, 68, '9771234567003', 24, '99');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 35, 66, '8412345678905', 21, '222');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 47, 70, '791234567901', 9, '291');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 38, 66, '9771234567003', 24, '236');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 10, 86, '7861234500123', 20, '94');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 37, 64, '7861234500123', 20, '201');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 3, 58, '5901234123457', 17, '270');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 7, 82, '0123456789104', 2, '227');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 3, 82, '5901234123457', 17, '25');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 41, 72, '4007630000116', 13, '279');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 34, 30, '7123456789015', 18, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 28, 82, '3800065711135', 12, '110');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 56, 86, '3800065711135', 12, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 54, 66, '123456789104', 3, '255');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 22, 71, '1234567891231', 11, '232');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 52, 72, '1234567891231', 11, '75');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 32, 68, '9788679912077', 27, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 5, 65, '5014016150821', 15, '286');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 43, 65, '640509040147', 5, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 13, 82, '9781234567897', 26, '232');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 11, 59, '7123456789015', 18, '228');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 47, 1, '9771234567003', 24, '263');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 9, 70, '8412345678905', 21, '234');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 5, 66, '9780201379624', 25, '112');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 19, 86, '3800065711135', 12, '26');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 54, 82, '123456789012', 1, '193');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 51, 66, '701197952225', 6, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 26, 64, '705632085943', 7, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 19, 82, '5901234123457', 17, '145');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 4, 65, '4007630000116', 13, '239');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 43, 67, '7123456789015', 18, '206');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 9, 30, '3800065711135', 12, '240');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 11, 86, '705632085943', 7, '66');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 40, 64, '3800065711135', 12, '92');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 19, 70, '8412345678905', 21, '42');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 10, 70, '9781234567897', 26, '239');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 56, 69, '5012345678900', 14, '286');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 32, 68, '123456789012', 1, '73');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 51, 66, '7123456789015', 18, '192');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 33, 1, '9781234567897', 26, '38');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 8, 67, '9788679912077', 27, '165');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 51, 64, '123456789012', 1, '160');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 10, 65, '9002236311036', 22, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 22, 59, '7861234500123', 20, '208');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 43, 30, '012345678905', 0, '167');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 28, 69, '705632085943', 7, '282');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 6, 65, '791234567901', 9, '96');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 48, 66, '012345678905', 0, '20');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 8, 66, '9771234567003', 24, '153');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 41, 71, '9771234567003', 24, '22');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 37, 1, '5014016150821', 15, '204');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 50, 66, '123456789012', 1, '153');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 46, 66, '5014016150821', 15, '60');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 39, 58, '012345678905', 0, '200');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 54, 59, '123456789012', 1, '135');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 52, 66, '4007630000116', 13, '235');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 19, 66, '3800065711135', 12, '245');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 54, 67, '8412345678905', 21, '99');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 49, 68, '0123456789104', 2, '284');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 55, 65, '791234567901', 9, '63');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 57, 69, '9780201379624', 25, '226');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 13, 64, '705632085943', 7, '145');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 32, 1, '4007630000116', 13, '26');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 13, 58, '3800065711135', 12, '30');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 13, 58, '9771234567003', 24, '57');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 42, 30, '123456789104', 3, '127');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 14, 82, '9771234567003', 24, '199');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 55, 70, '705632085943', 7, '159');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 52, 64, '712345678911', 8, '293');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 23, 68, '1234567891231', 11, '230');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 55, 65, '5901234123457', 17, '116');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 14, 71, '8412345678905', 21, '54');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 56, 65, '9002236311036', 22, '92');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 27, 59, '5014016150821', 15, '226');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 54, 69, '123456789012', 1, '138');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 48, 69, '712345678911', 8, '219');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 14, 70, '701197952225', 6, '238');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 11, 58, '5060123456783', 16, '106');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 23, 86, '1234567654324', 10, '141');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 34, 71, '712345678911', 8, '95');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 20, 64, '1234567891231', 11, '221');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 50, 67, '9788679912077', 27, '239');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 11, 1, '5060123456783', 16, '160');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 32, 66, '5901234123457', 17, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 6, 64, '123456789104', 3, '83');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 46, 68, '7123456789015', 18, '218');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 53, 66, '8412345678905', 21, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 25, 65, '9781234567897', 26, '87');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 13, 71, '4007630000116', 13, '127');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 51, 69, '5012345678900', 14, '299');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (7, 40, 86, '7501234567893', 19, '49');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 37, 65, '123456789012', 1, '22');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 50, 70, '1234567654324', 10, '210');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 46, 68, '9780201379624', 25, '187');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 33, 1, '9788679912077', 27, '161');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 33, 1, '123456789104', 3, '84');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 6, 69, '416000336108', 4, '34');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 18, 67, '640509040147', 5, '213');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 17, 58, '640509040147', 5, '189');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 43, 86, '9771234567003', 24, '126');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 14, 86, '9780201379624', 25, '44');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 37, 71, '7501234567893', 19, '196');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 28, 64, '0123456789104', 2, '73');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 34, 66, '012345678905', 0, '74');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 9, 1, '5014016150821', 15, '256');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 34, 71, '9771234567003', 24, '105');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 32, 64, '7123456789015', 18, '268');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 51, 86, '5014016150821', 15, '58');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 54, 68, '1234567891231', 11, '244');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 47, 66, '8412345678905', 21, '61');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 55, 1, '9780201379624', 25, '43');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 35, 64, '5014016150821', 15, '152');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 5, 68, '1234567891231', 11, '70');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 26, 82, '640509040147', 5, '226');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 35, 58, '640509040147', 5, '243');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 22, 58, '791234567901', 9, '272');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 12, 86, '640509040147', 5, '284');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 54, 59, '9771234567003', 24, '232');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 38, 86, '0123456789104', 2, '252');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 51, 82, '123456789012', 1, '131');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 48, 58, '7123456789015', 18, '144');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 37, 67, '701197952225', 6, '270');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 10, 70, '123456789104', 3, '209');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 47, 66, '705632085943', 7, '284');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 46, 66, '5014016150821', 15, '98');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 50, 59, '1234567654324', 10, '288');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 11, 86, '123456789104', 3, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 6, 59, '9780201379624', 25, '44');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 28, 1, '8412345678905', 21, '110');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 17, 82, '7861234500123', 20, '35');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 41, 69, '701197952225', 6, '134');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 48, 67, '7123456789015', 18, '32');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 5, 59, '012345678905', 0, '23');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 10, 30, '9002236311036', 22, '269');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 25, 72, '012345678905', 0, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 21, 69, '123456789012', 1, '116');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 33, 68, '7501234567893', 19, '270');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 21, 67, '5060123456783', 16, '62');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 54, 71, '9780201379624', 25, '41');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 54, 1, '701197952225', 6, '48');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 17, 72, '0123456789104', 2, '179');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 55, 69, '5901234123457', 17, '55');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 48, 86, '9310779300005', 23, '183');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 37, 71, '7861234500123', 20, '37');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 57, 67, '4007630000116', 13, '271');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 10, 30, '7861234500123', 20, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 32, 69, '9002236311036', 22, '135');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 51, 58, '712345678911', 8, '232');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 57, 66, '8412345678905', 21, '137');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 9, 65, '3800065711135', 12, '197');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 18, 30, '7861234500123', 20, '36');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 8, 58, '123456789104', 3, '258');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 47, 68, '5012345678900', 14, '33');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 24, 30, '9002236311036', 22, '63');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 8, 59, '1234567654324', 10, '65');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 12, 58, '123456789104', 3, '94');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 4, 82, '9002236311036', 22, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 33, 86, '5012345678900', 14, '174');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 49, 30, '705632085943', 7, '67');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 5, 69, '7123456789015', 18, '74');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 43, 58, '5012345678900', 14, '80');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 52, 67, '9002236311036', 22, '159');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 21, 59, '5012345678900', 14, '123');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 42, 70, '5901234123457', 17, '175');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 12, 71, '7861234500123', 20, '86');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 25, 69, '416000336108', 4, '131');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 52, 82, '791234567901', 9, '297');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 10, 65, '1234567891231', 11, '141');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 33, 66, '712345678911', 8, '45');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 52, 59, '5014016150821', 15, '36');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 49, 66, '5012345678900', 14, '170');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 32, 70, '5060123456783', 16, '58');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 33, 71, '7861234500123', 20, '287');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 42, 86, '7501234567893', 19, '109');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 25, 30, '1234567891231', 11, '215');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 11, 66, '5901234123457', 17, '291');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 39, 72, '7123456789015', 18, '291');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 42, 1, '8412345678905', 21, '215');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 35, 30, '9002236311036', 22, '51');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 50, 1, '5014016150821', 15, '85');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 4, 67, '5060123456783', 16, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 8, 82, '7501234567893', 19, '153');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 17, 67, '7123456789015', 18, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 23, 1, '9002236311036', 22, '200');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 23, 66, '3800065711135', 12, '203');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 39, 65, '7501234567893', 19, '74');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 18, 71, '123456789012', 1, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 28, 1, '8412345678905', 21, '26');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 20, 72, '712345678911', 8, '230');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 17, 71, '9002236311036', 22, '69');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 28, 1, '416000336108', 4, '165');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 7, 66, '416000336108', 4, '81');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 4, 71, '012345678905', 0, '255');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 3, 68, '5901234123457', 17, '288');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 40, 66, '5060123456783', 16, '250');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 36, 82, '7123456789015', 18, '170');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 33, 70, '791234567901', 9, '226');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 28, 59, '123456789012', 1, '249');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 48, 69, '9780201379624', 25, '267');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 33, 66, '5060123456783', 16, '99');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 26, 1, '7501234567893', 19, '276');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 55, 1, '701197952225', 6, '55');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 50, 70, '9002236311036', 22, '68');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 40, 65, '416000336108', 4, '81');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 21, 59, '9771234567003', 24, '249');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 37, 82, '9771234567003', 24, '163');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 26, 72, '123456789104', 3, '64');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 51, 70, '8412345678905', 21, '173');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 23, 82, '123456789012', 1, '96');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 11, 67, '9771234567003', 24, '125');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 34, 68, '712345678911', 8, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 27, 69, '416000336108', 4, '297');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 22, 69, '705632085943', 7, '268');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 53, 30, '640509040147', 5, '130');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 8, 82, '416000336108', 4, '115');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 43, 68, '5060123456783', 16, '70');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (8, 25, 69, '9002236311036', 22, '55');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 3, 69, '416000336108', 4, '27');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 32, 68, '7861234500123', 20, '231');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 21, 30, '416000336108', 4, '122');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 6, 59, '3800065711135', 12, '179');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 3, 70, '7861234500123', 20, '147');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 19, 82, '5901234123457', 17, '71');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 46, 30, '5901234123457', 17, '297');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 25, 66, '8412345678905', 21, '153');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 34, 71, '640509040147', 5, '259');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 41, 30, '9781234567897', 26, '173');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 41, 30, '705632085943', 7, '97');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 25, 69, '5060123456783', 16, '229');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 40, 67, '9310779300005', 23, '207');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 5, 30, '9788679912077', 27, '46');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 8, 69, '8412345678905', 21, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 54, 66, '7501234567893', 19, '245');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 10, 65, '416000336108', 4, '217');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 19, 67, '4007630000116', 13, '111');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 18, 68, '7123456789015', 18, '58');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 40, 82, '5060123456783', 16, '33');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 17, 65, '701197952225', 6, '179');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 35, 58, '4007630000116', 13, '297');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 37, 82, '9771234567003', 24, '213');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 21, 65, '8412345678905', 21, '280');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 52, 59, '9002236311036', 22, '32');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 56, 68, '9781234567897', 26, '260');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 20, 1, '7123456789015', 18, '223');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 47, 68, '8412345678905', 21, '195');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 41, 65, '4007630000116', 13, '132');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 25, 70, '4007630000116', 13, '34');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 49, 71, '4007630000116', 13, '222');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 19, 65, '7123456789015', 18, '126');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 3, 1, '9781234567897', 26, '181');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 19, 70, '123456789012', 1, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 50, 70, '9002236311036', 22, '176');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 5, 70, '7861234500123', 20, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 13, 67, '7861234500123', 20, '183');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 33, 69, '640509040147', 5, '170');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 54, 67, '5901234123457', 17, '175');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 22, 69, '8412345678905', 21, '186');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 10, 82, '4007630000116', 13, '241');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 33, 59, '640509040147', 5, '75');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 35, 58, '123456789012', 1, '277');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 55, 58, '9781234567897', 26, '45');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 36, 64, '640509040147', 5, '180');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 28, 64, '9310779300005', 23, '27');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 41, 66, '9310779300005', 23, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 55, 72, '712345678911', 8, '271');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 8, 86, '5060123456783', 16, '122');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 40, 86, '5012345678900', 14, '112');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 17, 82, '5060123456783', 16, '224');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 6, 30, '9780201379624', 25, '157');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 17, 59, '712345678911', 8, '149');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 49, 86, '123456789104', 3, '65');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 21, 64, '8412345678905', 21, '285');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 20, 69, '7123456789015', 18, '289');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 27, 71, '712345678911', 8, '272');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 34, 72, '701197952225', 6, '239');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 43, 69, '7861234500123', 20, '226');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 46, 86, '5060123456783', 16, '240');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 10, 86, '3800065711135', 12, '231');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 35, 58, '5014016150821', 15, '196');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 7, 64, '5012345678900', 14, '53');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 37, 69, '9310779300005', 23, '147');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 18, 65, '416000336108', 4, '88');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 11, 70, '5012345678900', 14, '256');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 56, 67, '5012345678900', 14, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 55, 30, '5012345678900', 14, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 57, 66, '712345678911', 8, '193');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 41, 66, '712345678911', 8, '47');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 12, 59, '416000336108', 4, '286');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 14, 86, '123456789012', 1, '25');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 53, 66, '791234567901', 9, '167');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 57, 64, '4007630000116', 13, '127');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 56, 30, '416000336108', 4, '213');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 48, 71, '012345678905', 0, '57');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 47, 1, '3800065711135', 12, '272');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 12, 72, '1234567654324', 10, '289');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 11, 68, '5014016150821', 15, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 52, 65, '7501234567893', 19, '263');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 28, 30, '3800065711135', 12, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 11, 69, '416000336108', 4, '68');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 34, 67, '9310779300005', 23, '43');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 53, 65, '0123456789104', 2, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 18, 30, '1234567891231', 11, '144');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 53, 64, '9002236311036', 22, '138');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 9, 69, '0123456789104', 2, '256');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 12, 70, '012345678905', 0, '156');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 34, 69, '712345678911', 8, '152');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 43, 58, '012345678905', 0, '260');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 36, 71, '3800065711135', 12, '59');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 18, 69, '791234567901', 9, '70');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 22, 70, '9780201379624', 25, '88');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 55, 68, '5012345678900', 14, '250');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 33, 82, '0123456789104', 2, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 12, 30, '012345678905', 0, '34');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 35, 58, '7861234500123', 20, '244');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 4, 30, '7501234567893', 19, '199');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 49, 66, '791234567901', 9, '172');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 19, 67, '416000336108', 4, '218');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 5, 64, '791234567901', 9, '251');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 12, 72, '9002236311036', 22, '132');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 10, 71, '705632085943', 7, '46');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 6, 1, '705632085943', 7, '238');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 43, 59, '3800065711135', 12, '183');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 19, 82, '9002236311036', 22, '248');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 35, 67, '9780201379624', 25, '49');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 6, 72, '416000336108', 4, '125');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 8, 82, '9781234567897', 26, '69');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 41, 68, '791234567901', 9, '213');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 20, 1, '0123456789104', 2, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 23, 82, '791234567901', 9, '149');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 3, 1, '8412345678905', 21, '130');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 43, 58, '5012345678900', 14, '64');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 13, 86, '712345678911', 8, '100');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 12, 1, '1234567654324', 10, '98');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 39, 86, '7501234567893', 19, '221');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 50, 71, '9771234567003', 24, '174');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 25, 30, '791234567901', 9, '221');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (9, 49, 67, '012345678905', 0, '237');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 5, 72, '9780201379624', 25, '105');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 39, 82, '4007630000116', 13, '39');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 27, 82, '640509040147', 5, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 26, 65, '701197952225', 6, '235');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 22, 82, '9771234567003', 24, '114');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 25, 1, '7123456789015', 18, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 28, 30, '705632085943', 7, '135');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 12, 72, '7861234500123', 20, '116');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 19, 64, '701197952225', 6, '27');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 37, 30, '7501234567893', 19, '291');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 22, 1, '416000336108', 4, '150');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 10, 82, '5901234123457', 17, '82');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 47, 72, '7861234500123', 20, '107');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 9, 86, '7123456789015', 18, '46');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 12, 69, '0123456789104', 2, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 50, 82, '5901234123457', 17, '278');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 50, 30, '4007630000116', 13, '177');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 38, 67, '4007630000116', 13, '87');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 57, 70, '9781234567897', 26, '190');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 19, 68, '012345678905', 0, '58');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 18, 71, '416000336108', 4, '188');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 64, '4007630000116', 13, '214');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 57, 71, '5014016150821', 15, '83');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 18, 72, '640509040147', 5, '132');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 27, 65, '5014016150821', 15, '244');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 58, '9788679912077', 27, '78');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 42, 1, '5012345678900', 14, '228');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 23, 67, '9781234567897', 26, '100');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 39, 72, '640509040147', 5, '71');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 41, 69, '5060123456783', 16, '42');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 28, 67, '9002236311036', 22, '126');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 58, '5901234123457', 17, '269');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 23, 66, '712345678911', 8, '163');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 57, 82, '7123456789015', 18, '216');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 5, 82, '712345678911', 8, '219');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 28, 69, '9781234567897', 26, '229');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 46, 72, '7861234500123', 20, '255');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 3, 70, '9310779300005', 23, '258');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 55, 86, '8412345678905', 21, '189');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 11, 59, '7501234567893', 19, '182');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 40, 72, '640509040147', 5, '115');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 14, 30, '123456789104', 3, '232');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 4, 71, '1234567891231', 11, '176');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 72, '640509040147', 5, '248');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 7, 70, '416000336108', 4, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 13, 58, '5060123456783', 16, '182');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 46, 71, '7501234567893', 19, '92');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 14, 1, '640509040147', 5, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 4, 72, '7123456789015', 18, '143');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 39, 66, '5060123456783', 16, '23');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 36, 59, '640509040147', 5, '195');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 58, '416000336108', 4, '125');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 58, '8412345678905', 21, '169');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 18, 69, '8412345678905', 21, '193');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 48, 58, '705632085943', 7, '217');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 8, 66, '9781234567897', 26, '43');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 8, 68, '7501234567893', 19, '111');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 11, 64, '123456789104', 3, '115');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 51, 86, '5060123456783', 16, '21');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 56, 65, '416000336108', 4, '31');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 48, 30, '416000336108', 4, '60');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 47, 67, '712345678911', 8, '93');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 20, 68, '012345678905', 0, '47');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 43, 72, '012345678905', 0, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 22, 64, '012345678905', 0, '218');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 8, 1, '5901234123457', 17, '160');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 33, 82, '9781234567897', 26, '195');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 39, 82, '1234567654324', 10, '270');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 36, 59, '8412345678905', 21, '75');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 33, 82, '7501234567893', 19, '181');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 10, 68, '416000336108', 4, '92');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 50, 70, '5014016150821', 15, '81');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 54, 72, '5901234123457', 17, '248');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 39, 69, '9781234567897', 26, '211');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 17, 68, '123456789104', 3, '54');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 25, 68, '5014016150821', 15, '85');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 37, 68, '791234567901', 9, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 11, 82, '7501234567893', 19, '201');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 32, 65, '705632085943', 7, '250');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 39, 1, '4007630000116', 13, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 39, 70, '9310779300005', 23, '282');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 53, 58, '7123456789015', 18, '43');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 47, 82, '5060123456783', 16, '249');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 43, 86, '712345678911', 8, '226');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 58, '7501234567893', 19, '161');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 52, 1, '701197952225', 6, '300');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 24, 58, '5014016150821', 15, '72');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 50, 58, '416000336108', 4, '107');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 57, 69, '5012345678900', 14, '108');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 17, 72, '9780201379624', 25, '75');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 13, 67, '9310779300005', 23, '235');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 20, 86, '416000336108', 4, '135');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 8, 64, '5012345678900', 14, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 25, 71, '640509040147', 5, '42');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 51, 30, '8412345678905', 21, '221');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 9, 30, '7123456789015', 18, '98');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 17, 58, '7501234567893', 19, '68');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 43, 64, '7123456789015', 18, '174');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 27, 69, '7123456789015', 18, '30');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 23, 1, '9310779300005', 23, '44');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 17, 70, '5060123456783', 16, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 54, 1, '712345678911', 8, '205');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 36, 71, '701197952225', 6, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 34, 65, '123456789104', 3, '129');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 26, 82, '123456789012', 1, '232');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 36, 1, '8412345678905', 21, '118');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 72, '5012345678900', 14, '278');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 40, 69, '012345678905', 0, '104');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 18, 71, '416000336108', 4, '83');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 47, 72, '705632085943', 7, '107');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 30, '7123456789015', 18, '28');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 56, 68, '712345678911', 8, '80');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 32, 86, '8412345678905', 21, '115');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 19, 70, '9780201379624', 25, '70');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 9, 69, '7123456789015', 18, '235');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 39, 65, '9771234567003', 24, '265');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 22, 64, '640509040147', 5, '183');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 7, 30, '123456789012', 1, '98');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 56, 30, '012345678905', 0, '163');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 10, 64, '701197952225', 6, '106');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 39, 58, '7861234500123', 20, '175');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 39, 59, '1234567891231', 11, '149');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 3, 69, '4007630000116', 13, '150');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 17, 58, '7861234500123', 20, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 22, 68, '7501234567893', 19, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 5, 70, '5014016150821', 15, '207');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 57, 68, '5014016150821', 15, '22');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 4, 59, '4007630000116', 13, '134');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 57, 68, '7501234567893', 19, '247');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 6, 59, '712345678911', 8, '244');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 52, 71, '701197952225', 6, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 28, 71, '0123456789104', 2, '38');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 18, 86, '123456789104', 3, '73');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 48, 69, '9788679912077', 27, '276');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 50, 64, '416000336108', 4, '46');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 46, 71, '4007630000116', 13, '132');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 58, '701197952225', 6, '93');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 49, 65, '9771234567003', 24, '161');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 19, 71, '7861234500123', 20, '56');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 34, 30, '9771234567003', 24, '161');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 7, 71, '7501234567893', 19, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 36, 65, '7861234500123', 20, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 21, 72, '012345678905', 0, '228');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 9, 86, '640509040147', 5, '181');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 9, 82, '791234567901', 9, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 42, 71, '8412345678905', 21, '186');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 36, 65, '7861234500123', 20, '140');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 69, '701197952225', 6, '75');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 39, 30, '9310779300005', 23, '145');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 23, 58, '791234567901', 9, '151');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 47, 67, '9781234567897', 26, '60');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 43, 58, '012345678905', 0, '223');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 58, '7501234567893', 19, '110');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 10, 59, '701197952225', 6, '193');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 49, 71, '7123456789015', 18, '129');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 5, 65, '1234567891231', 11, '32');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 35, 58, '705632085943', 7, '154');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 25, 86, '8412345678905', 21, '122');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 51, 68, '123456789012', 1, '56');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 40, 58, '7501234567893', 19, '234');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 22, 66, '123456789104', 3, '114');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 38, 59, '5014016150821', 15, '57');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 13, 58, '416000336108', 4, '268');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 13, 82, '640509040147', 5, '195');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (10, 23, 59, '1234567654324', 10, '279');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 47, 65, '012345678905', 0, '61');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 40, 70, '9002236311036', 22, '265');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 55, 67, '5012345678900', 14, '91');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 20, 1, '123456789012', 1, '276');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 28, 58, '7501234567893', 19, '255');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 36, 67, '1234567654324', 10, '188');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 55, 67, '9781234567897', 26, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 56, 69, '8412345678905', 21, '60');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 22, 66, '9781234567897', 26, '292');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 35, 72, '9781234567897', 26, '131');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 54, 69, '5014016150821', 15, '69');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 46, 72, '012345678905', 0, '137');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 56, 64, '0123456789104', 2, '107');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 51, 69, '9780201379624', 25, '95');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 22, 68, '705632085943', 7, '286');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 11, 30, '4007630000116', 13, '49');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 6, 59, '0123456789104', 2, '172');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 13, 82, '7861234500123', 20, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 35, 58, '012345678905', 0, '44');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 52, 59, '5014016150821', 15, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 20, 64, '1234567891231', 11, '296');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 3, 64, '9310779300005', 23, '289');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 17, 64, '640509040147', 5, '206');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 35, 58, '7861234500123', 20, '187');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 33, 67, '9310779300005', 23, '163');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 54, 64, '8412345678905', 21, '300');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 34, 86, '123456789012', 1, '130');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 46, 59, '9788679912077', 27, '226');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 40, 64, '5012345678900', 14, '93');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 35, 58, '705632085943', 7, '244');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 28, 86, '7861234500123', 20, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 20, 69, '7861234500123', 20, '51');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 9, 71, '123456789012', 1, '67');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 14, 69, '701197952225', 6, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 48, 30, '5014016150821', 15, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 37, 82, '9780201379624', 25, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 7, 70, '1234567891231', 11, '240');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 25, 30, '705632085943', 7, '147');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 14, 70, '416000336108', 4, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 55, 68, '9771234567003', 24, '25');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 27, 70, '701197952225', 6, '158');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 12, 59, '701197952225', 6, '64');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 36, 66, '705632085943', 7, '114');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 18, 66, '9781234567897', 26, '128');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 3, 82, '3800065711135', 12, '128');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 5, 1, '7123456789015', 18, '95');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 56, 1, '9781234567897', 26, '184');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 34, 64, '7501234567893', 19, '224');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 33, 59, '5014016150821', 15, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 22, 68, '9781234567897', 26, '37');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 4, 65, '701197952225', 6, '218');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 17, 72, '4007630000116', 13, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 5, 70, '791234567901', 9, '172');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 25, 69, '123456789104', 3, '150');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 3, 68, '9002236311036', 22, '32');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 12, 1, '9781234567897', 26, '171');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 53, 68, '791234567901', 9, '184');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 28, 68, '9780201379624', 25, '264');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 10, 67, '7501234567893', 19, '281');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 32, 67, '712345678911', 8, '179');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 20, 72, '5012345678900', 14, '182');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 49, 69, '1234567891231', 11, '176');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 33, 67, '9310779300005', 23, '149');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 4, 69, '5060123456783', 16, '266');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 24, 66, '7501234567893', 19, '290');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 46, 69, '8412345678905', 21, '249');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 40, 65, '9780201379624', 25, '201');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 48, 70, '640509040147', 5, '90');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 43, 64, '7861234500123', 20, '216');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 39, 70, '5014016150821', 15, '93');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 20, 65, '705632085943', 7, '148');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 8, 65, '701197952225', 6, '254');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 23, 64, '640509040147', 5, '238');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 35, 58, '5060123456783', 16, '188');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 17, 1, '5060123456783', 16, '108');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 38, 71, '9780201379624', 25, '181');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 50, 30, '7501234567893', 19, '259');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 26, 1, '5012345678900', 14, '126');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 41, 86, '9780201379624', 25, '67');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 41, 1, '1234567654324', 10, '131');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 34, 69, '416000336108', 4, '116');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 55, 68, '8412345678905', 21, '179');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 50, 70, '9002236311036', 22, '182');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 50, 82, '012345678905', 0, '233');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 43, 30, '3800065711135', 12, '93');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 50, 70, '1234567891231', 11, '166');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 8, 71, '5014016150821', 15, '282');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 36, 68, '9310779300005', 23, '237');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 19, 65, '5012345678900', 14, '287');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 4, 82, '705632085943', 7, '223');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 48, 70, '8412345678905', 21, '44');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 39, 58, '5012345678900', 14, '36');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 43, 64, '3800065711135', 12, '50');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 18, 58, '9771234567003', 24, '20');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 50, 69, '3800065711135', 12, '221');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 3, 67, '7123456789015', 18, '199');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 46, 71, '705632085943', 7, '85');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 9, 58, '705632085943', 7, '260');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 6, 59, '416000336108', 4, '196');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 21, 67, '1234567654324', 10, '73');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 54, 66, '3800065711135', 12, '69');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 47, 65, '9771234567003', 24, '31');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 14, 66, '7123456789015', 18, '273');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 33, 59, '5014016150821', 15, '252');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 17, 66, '712345678911', 8, '215');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 52, 1, '123456789104', 3, '164');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 6, 59, '7861234500123', 20, '134');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 36, 66, '0123456789104', 2, '294');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 47, 86, '9780201379624', 25, '210');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 47, 30, '1234567654324', 10, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 19, 86, '712345678911', 8, '173');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 26, 70, '712345678911', 8, '242');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 27, 1, '9781234567897', 26, '78');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 24, 64, '5012345678900', 14, '152');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 40, 70, '123456789012', 1, '39');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 3, 1, '8412345678905', 21, '208');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 28, 69, '4007630000116', 13, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 33, 64, '9780201379624', 25, '232');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 32, 65, '4007630000116', 13, '266');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 9, 1, '012345678905', 0, '152');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 40, 67, '9771234567003', 24, '67');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 55, 59, '8412345678905', 21, '294');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 53, 58, '7861234500123', 20, '39');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 56, 65, '416000336108', 4, '69');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 47, 86, '8412345678905', 21, '293');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 21, 67, '5901234123457', 17, '51');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 39, 71, '9780201379624', 25, '45');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 21, 86, '640509040147', 5, '213');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 55, 69, '705632085943', 7, '168');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 42, 86, '640509040147', 5, '210');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 8, 30, '5012345678900', 14, '36');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 36, 86, '705632085943', 7, '48');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 56, 1, '640509040147', 5, '77');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 17, 72, '5014016150821', 15, '146');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 4, 69, '5012345678900', 14, '279');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 3, 30, '9310779300005', 23, '119');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 14, 68, '8412345678905', 21, '131');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 55, 86, '1234567891231', 11, '240');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 9, 65, '9780201379624', 25, '227');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 21, 66, '705632085943', 7, '209');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 34, 64, '9780201379624', 25, '196');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 13, 65, '012345678905', 0, '201');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 52, 1, '5060123456783', 16, '252');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 20, 67, '705632085943', 7, '170');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 40, 71, '123456789012', 1, '122');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 21, 64, '9781234567897', 26, '103');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 24, 30, '712345678911', 8, '154');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 36, 72, '1234567654324', 10, '219');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 35, 58, '701197952225', 6, '57');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 24, 58, '012345678905', 0, '152');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 5, 58, '9781234567897', 26, '208');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 28, 30, '9788679912077', 27, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 25, 30, '9771234567003', 24, '105');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 20, 72, '640509040147', 5, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 3, 59, '123456789012', 1, '208');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 57, 86, '5901234123457', 17, '255');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 32, 64, '705632085943', 7, '151');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 39, 69, '791234567901', 9, '159');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 5, 70, '9781234567897', 26, '93');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 56, 65, '705632085943', 7, '57');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 22, 71, '012345678905', 0, '127');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 22, 65, '3800065711135', 12, '145');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 4, 86, '9780201379624', 25, '264');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 54, 72, '5060123456783', 16, '97');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 27, 64, '9310779300005', 23, '211');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 27, 68, '7123456789015', 18, '189');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 35, 58, '9780201379624', 25, '210');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 27, 64, '701197952225', 6, '256');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 42, 59, '7861234500123', 20, '241');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 5, 82, '7861234500123', 20, '279');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 55, 30, '7501234567893', 19, '122');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 42, 71, '9781234567897', 26, '82');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 26, 67, '123456789104', 3, '176');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 25, 30, '123456789104', 3, '129');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 36, 59, '9002236311036', 22, '227');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 12, 68, '1234567891231', 11, '167');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 27, 70, '9788679912077', 27, '276');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 8, 72, '791234567901', 9, '215');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 37, 69, '1234567654324', 10, '263');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 8, 58, '9771234567003', 24, '239');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 4, 58, '416000336108', 4, '96');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 8, 71, '712345678911', 8, '189');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 40, 58, '8412345678905', 21, '186');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 50, 67, '123456789104', 3, '26');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 34, 66, '701197952225', 6, '87');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 33, 1, '1234567654324', 10, '196');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 48, 70, '5012345678900', 14, '261');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 48, 1, '7861234500123', 20, '263');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 5, 67, '5014016150821', 15, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 40, 72, '1234567891231', 11, '128');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 53, 66, '4007630000116', 13, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 49, 1, '701197952225', 6, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 36, 65, '5901234123457', 17, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 28, 66, '1234567891231', 11, '58');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 36, 82, '7501234567893', 19, '241');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 46, 59, '123456789104', 3, '100');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 17, 71, '1234567654324', 10, '193');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 53, 68, '712345678911', 8, '45');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (11, 56, 82, '5014016150821', 15, '241');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 20, 67, '9002236311036', 22, '200');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 17, 68, '012345678905', 0, '52');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 12, 65, '791234567901', 9, '40');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 57, 58, '4007630000116', 13, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 36, 66, '9771234567003', 24, '220');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 8, 72, '7861234500123', 20, '49');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 50, 68, '5901234123457', 17, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 22, 59, '9002236311036', 22, '184');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 24, 64, '9310779300005', 23, '106');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 32, 82, '5901234123457', 17, '216');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 48, 82, '012345678905', 0, '174');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 37, 66, '012345678905', 0, '147');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 5, 65, '1234567891231', 11, '290');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 56, 82, '9771234567003', 24, '132');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 8, 59, '012345678905', 0, '67');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 4, 66, '712345678911', 8, '233');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 33, 69, '5014016150821', 15, '239');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 40, 1, '5901234123457', 17, '267');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 49, 66, '1234567891231', 11, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 51, 68, '9788679912077', 27, '50');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 54, 67, '3800065711135', 12, '141');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 12, 30, '9771234567003', 24, '113');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 17, 68, '791234567901', 9, '107');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 57, 67, '640509040147', 5, '232');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 56, 30, '123456789012', 1, '174');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 23, 30, '791234567901', 9, '133');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 9, 67, '123456789012', 1, '133');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 48, 86, '712345678911', 8, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 49, 58, '5012345678900', 14, '173');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 26, 66, '701197952225', 6, '72');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 21, 67, '012345678905', 0, '296');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 9, 69, '1234567654324', 10, '61');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 6, 65, '7861234500123', 20, '230');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 5, 86, '9310779300005', 23, '257');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 40, 72, '9788679912077', 27, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 14, 64, '012345678905', 0, '189');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 42, 64, '416000336108', 4, '252');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 21, 68, '640509040147', 5, '246');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 49, 72, '7501234567893', 19, '176');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 28, 70, '8412345678905', 21, '135');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 3, 68, '9002236311036', 22, '294');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 49, 67, '9002236311036', 22, '135');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 50, 70, '5012345678900', 14, '66');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 34, 59, '1234567654324', 10, '219');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 47, 68, '5901234123457', 17, '209');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 35, 58, '9771234567003', 24, '297');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 12, 68, '3800065711135', 12, '25');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 52, 1, '8412345678905', 21, '61');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 14, 1, '9310779300005', 23, '113');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 43, 70, '012345678905', 0, '159');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 25, 86, '5012345678900', 14, '190');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 54, 86, '7861234500123', 20, '78');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 20, 30, '701197952225', 6, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 57, 69, '705632085943', 7, '30');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 43, 69, '1234567891231', 11, '96');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 9, 86, '7501234567893', 19, '77');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 42, 72, '7501234567893', 19, '24');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 22, 67, '9310779300005', 23, '260');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 46, 59, '5060123456783', 16, '169');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 40, 1, '123456789104', 3, '199');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 24, 1, '9780201379624', 25, '192');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 28, 68, '9310779300005', 23, '280');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 11, 69, '3800065711135', 12, '75');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 18, 67, '416000336108', 4, '55');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 28, 68, '640509040147', 5, '105');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 35, 58, '1234567654324', 10, '166');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 40, 71, '123456789104', 3, '54');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 35, 58, '012345678905', 0, '247');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 56, 66, '1234567891231', 11, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 4, 59, '712345678911', 8, '144');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 25, 82, '1234567891231', 11, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 24, 59, '9781234567897', 26, '134');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 3, 59, '705632085943', 7, '224');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 26, 86, '1234567891231', 11, '201');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 12, 72, '9002236311036', 22, '276');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 43, 59, '416000336108', 4, '34');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 23, 70, '9771234567003', 24, '282');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 5, 82, '5060123456783', 16, '241');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 17, 70, '416000336108', 4, '153');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 3, 59, '416000336108', 4, '160');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 34, 86, '012345678905', 0, '143');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 9, 59, '701197952225', 6, '142');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 27, 1, '123456789012', 1, '249');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 24, 68, '012345678905', 0, '95');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 50, 66, '8412345678905', 21, '82');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 56, 67, '0123456789104', 2, '159');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 56, 58, '9310779300005', 23, '242');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 46, 66, '8412345678905', 21, '294');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 9, 1, '416000336108', 4, '193');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 10, 65, '9002236311036', 22, '210');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 10, 71, '5014016150821', 15, '50');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 40, 65, '1234567891231', 11, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 46, 1, '9771234567003', 24, '217');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 35, 86, '9310779300005', 23, '85');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 10, 67, '7861234500123', 20, '119');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 8, 86, '7123456789015', 18, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 24, 1, '123456789012', 1, '246');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 4, 1, '5014016150821', 15, '149');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 12, 58, '9780201379624', 25, '184');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 56, 68, '5014016150821', 15, '204');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 4, 58, '701197952225', 6, '51');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 52, 59, '7501234567893', 19, '130');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 37, 86, '9771234567003', 24, '101');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 19, 58, '123456789012', 1, '173');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 28, 65, '9788679912077', 27, '112');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 25, 71, '9788679912077', 27, '257');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 56, 66, '012345678905', 0, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 4, 66, '1234567891231', 11, '88');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 4, 67, '012345678905', 0, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 32, 86, '123456789012', 1, '291');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 19, 59, '8412345678905', 21, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 38, 69, '123456789012', 1, '61');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 9, 69, '9310779300005', 23, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 53, 58, '0123456789104', 2, '149');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 8, 66, '012345678905', 0, '45');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 7, 1, '8412345678905', 21, '60');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 25, 71, '7861234500123', 20, '215');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 42, 70, '5060123456783', 16, '239');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 27, 59, '012345678905', 0, '69');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 55, 82, '701197952225', 6, '233');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 57, 64, '712345678911', 8, '292');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 46, 66, '7861234500123', 20, '131');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 20, 1, '9781234567897', 26, '32');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 26, 30, '3800065711135', 12, '259');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 42, 68, '0123456789104', 2, '195');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 32, 59, '1234567891231', 11, '110');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 3, 1, '9771234567003', 24, '227');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 51, 67, '7861234500123', 20, '49');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 8, 72, '5012345678900', 14, '257');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 28, 70, '701197952225', 6, '282');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 56, 67, '9310779300005', 23, '116');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 52, 66, '712345678911', 8, '31');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 7, 71, '9771234567003', 24, '192');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 3, 70, '5012345678900', 14, '88');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 37, 72, '7501234567893', 19, '69');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 5, 71, '7861234500123', 20, '138');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 34, 82, '9780201379624', 25, '259');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 55, 58, '7861234500123', 20, '156');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 28, 71, '1234567891231', 11, '192');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 24, 67, '123456789012', 1, '146');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 28, 1, '8412345678905', 21, '191');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 18, 67, '9788679912077', 27, '198');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 28, 59, '1234567891231', 11, '79');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 53, 86, '5901234123457', 17, '84');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (12, 26, 66, '1234567891231', 11, '37');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 11, 30, '9771234567003', 24, '153');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 25, 70, '640509040147', 5, '160');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 49, 72, '8412345678905', 21, '159');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 40, 71, '9780201379624', 25, '197');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 51, 64, '7123456789015', 18, '142');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 19, 69, '9780201379624', 25, '194');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 20, 72, '9002236311036', 22, '145');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 5, 64, '9310779300005', 23, '191');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 34, 67, '9310779300005', 23, '271');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 34, 70, '7501234567893', 19, '154');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 35, 1, '5012345678900', 14, '189');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 53, 1, '123456789104', 3, '125');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 24, 68, '123456789104', 3, '281');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 48, 65, '640509040147', 5, '190');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 19, 72, '123456789012', 1, '192');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 32, 58, '5014016150821', 15, '286');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 21, 71, '012345678905', 0, '99');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 8, 59, '123456789104', 3, '131');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 56, 59, '712345678911', 8, '66');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 22, 58, '9788679912077', 27, '215');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 28, 68, '0123456789104', 2, '51');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 12, 72, '712345678911', 8, '243');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 46, 59, '012345678905', 0, '23');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 19, 66, '3800065711135', 12, '235');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 54, 82, '5901234123457', 17, '182');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 21, 71, '5012345678900', 14, '88');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 38, 86, '0123456789104', 2, '290');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 50, 65, '5014016150821', 15, '216');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 9, 66, '9771234567003', 24, '198');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 37, 66, '012345678905', 0, '267');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 40, 69, '3800065711135', 12, '129');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 13, 65, '791234567901', 9, '254');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 17, 69, '7861234500123', 20, '165');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 24, 68, '123456789012', 1, '33');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 22, 65, '1234567891231', 11, '205');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 25, 72, '7861234500123', 20, '45');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 12, 86, '123456789012', 1, '187');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 9, 71, '7123456789015', 18, '110');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 27, 69, '9310779300005', 23, '107');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 56, 64, '9788679912077', 27, '289');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 13, 82, '701197952225', 6, '92');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 24, 58, '0123456789104', 2, '82');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 43, 86, '701197952225', 6, '129');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 51, 67, '9780201379624', 25, '78');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 48, 72, '1234567891231', 11, '177');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 33, 68, '712345678911', 8, '27');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 48, 67, '1234567654324', 10, '216');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 42, 30, '8412345678905', 21, '54');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 37, 68, '5012345678900', 14, '172');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 37, 68, '9788679912077', 27, '194');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 23, 68, '5012345678900', 14, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 43, 30, '0123456789104', 2, '168');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 21, 66, '791234567901', 9, '20');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 52, 68, '9310779300005', 23, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 27, 70, '4007630000116', 13, '113');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 56, 69, '5901234123457', 17, '67');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 11, 1, '705632085943', 7, '204');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 21, 1, '5014016150821', 15, '87');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 14, 68, '1234567654324', 10, '175');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 23, 68, '9788679912077', 27, '277');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 33, 86, '9780201379624', 25, '21');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 50, 70, '9310779300005', 23, '126');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 11, 65, '9771234567003', 24, '193');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 41, 70, '3800065711135', 12, '115');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 55, 30, '1234567891231', 11, '153');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 19, 1, '5014016150821', 15, '87');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 14, 30, '1234567891231', 11, '95');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 33, 1, '7861234500123', 20, '78');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 43, 68, '3800065711135', 12, '122');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 25, 68, '8412345678905', 21, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 4, 59, '7861234500123', 20, '63');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 7, 72, '123456789012', 1, '241');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 42, 67, '5014016150821', 15, '195');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 12, 86, '1234567891231', 11, '203');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 26, 72, '7501234567893', 19, '103');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 10, 30, '9002236311036', 22, '104');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 6, 58, '7501234567893', 19, '264');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 42, 67, '5012345678900', 14, '149');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 27, 69, '5901234123457', 17, '48');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 10, 67, '1234567891231', 11, '214');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 55, 65, '0123456789104', 2, '249');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 17, 69, '4007630000116', 13, '230');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 55, 65, '1234567654324', 10, '300');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 13, 82, '5012345678900', 14, '151');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 33, 59, '5012345678900', 14, '187');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 19, 59, '5012345678900', 14, '79');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 9, 66, '5060123456783', 16, '76');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 41, 30, '416000336108', 4, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 42, 82, '012345678905', 0, '127');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 12, 67, '7123456789015', 18, '141');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 37, 67, '7861234500123', 20, '97');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 39, 66, '640509040147', 5, '211');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 49, 30, '8412345678905', 21, '298');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 40, 64, '1234567654324', 10, '123');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 48, 1, '0123456789104', 2, '180');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 56, 59, '9771234567003', 24, '71');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 49, 69, '5012345678900', 14, '195');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 55, 30, '3800065711135', 12, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 13, 66, '5901234123457', 17, '81');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 13, 69, '1234567891231', 11, '221');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 9, 70, '012345678905', 0, '175');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 27, 1, '123456789104', 3, '274');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 49, 67, '5901234123457', 17, '258');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 25, 66, '9781234567897', 26, '221');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 4, 70, '9310779300005', 23, '128');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 54, 1, '9780201379624', 25, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 14, 59, '705632085943', 7, '105');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 42, 67, '1234567654324', 10, '298');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 40, 1, '705632085943', 7, '137');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 14, 70, '712345678911', 8, '200');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 3, 72, '5901234123457', 17, '156');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 4, 65, '7861234500123', 20, '176');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 47, 68, '9780201379624', 25, '128');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 54, 58, '7123456789015', 18, '159');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 53, 66, '123456789104', 3, '170');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 55, 86, '9310779300005', 23, '67');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 7, 58, '9788679912077', 27, '155');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 18, 30, '5060123456783', 16, '161');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 56, 59, '9780201379624', 25, '160');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 13, 66, '9780201379624', 25, '145');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 3, 69, '0123456789104', 2, '182');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 56, 70, '1234567891231', 11, '158');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 56, 69, '791234567901', 9, '134');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 23, 64, '701197952225', 6, '40');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 49, 64, '9310779300005', 23, '187');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 7, 67, '1234567654324', 10, '65');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 42, 30, '9771234567003', 24, '172');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 51, 59, '9002236311036', 22, '36');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 7, 58, '705632085943', 7, '68');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 50, 70, '712345678911', 8, '21');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 46, 72, '5014016150821', 15, '202');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 8, 71, '7861234500123', 20, '126');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 9, 1, '5901234123457', 17, '57');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 24, 65, '791234567901', 9, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 34, 86, '4007630000116', 13, '56');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 54, 58, '5901234123457', 17, '291');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 50, 66, '5012345678900', 14, '265');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 37, 71, '8412345678905', 21, '280');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 51, 71, '701197952225', 6, '128');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 56, 1, '9310779300005', 23, '134');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 57, 66, '123456789104', 3, '249');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 19, 30, '5901234123457', 17, '291');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 43, 67, '9780201379624', 25, '41');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 50, 71, '1234567891231', 11, '28');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 52, 82, '701197952225', 6, '144');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 13, 68, '1234567654324', 10, '197');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 14, 86, '9780201379624', 25, '282');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 22, 71, '7501234567893', 19, '76');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 20, 70, '0123456789104', 2, '284');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 5, 30, '3800065711135', 12, '239');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 46, 66, '123456789012', 1, '94');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 51, 68, '791234567901', 9, '80');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 55, 71, '8412345678905', 21, '205');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 51, 66, '416000336108', 4, '102');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 57, 67, '3800065711135', 12, '251');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 11, 72, '0123456789104', 2, '52');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 39, 82, '7501234567893', 19, '33');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 17, 30, '5901234123457', 17, '103');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 4, 58, '712345678911', 8, '129');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 27, 66, '9788679912077', 27, '278');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (13, 18, 70, '701197952225', 6, '241');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 53, 66, '7861234500123', 20, '263');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 24, 68, '1234567654324', 10, '256');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 17, 67, '791234567901', 9, '223');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 49, 71, '640509040147', 5, '51');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 53, 30, '123456789104', 3, '240');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 54, 82, '7501234567893', 19, '119');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 39, 58, '5012345678900', 14, '257');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 49, 70, '7861234500123', 20, '246');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 56, 86, '8412345678905', 21, '107');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 36, 67, '705632085943', 7, '281');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 8, 82, '9771234567003', 24, '105');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 42, 67, '9788679912077', 27, '45');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 5, 30, '012345678905', 0, '158');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 56, 70, '712345678911', 8, '136');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 22, 58, '7123456789015', 18, '163');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 11, 30, '7123456789015', 18, '168');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 7, 65, '1234567654324', 10, '294');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 22, 86, '7501234567893', 19, '198');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 28, 64, '9310779300005', 23, '158');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 40, 58, '9780201379624', 25, '164');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 57, 70, '123456789012', 1, '40');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 26, 70, '712345678911', 8, '177');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 40, 65, '0123456789104', 2, '282');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 22, 1, '1234567654324', 10, '202');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 36, 59, '1234567654324', 10, '240');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 55, 59, '9780201379624', 25, '120');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 10, 59, '1234567891231', 11, '180');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 49, 82, '640509040147', 5, '20');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 39, 64, '791234567901', 9, '222');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 38, 70, '5060123456783', 16, '70');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 35, 58, '705632085943', 7, '38');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 27, 67, '1234567654324', 10, '286');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 22, 1, '791234567901', 9, '43');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 49, 70, '7501234567893', 19, '263');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 27, 71, '416000336108', 4, '255');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 9, 67, '5014016150821', 15, '82');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 14, 86, '0123456789104', 2, '24');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 26, 71, '5014016150821', 15, '93');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 25, 59, '5014016150821', 15, '202');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 20, 69, '7861234500123', 20, '134');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 35, 68, '9771234567003', 24, '252');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 12, 67, '9310779300005', 23, '277');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 52, 66, '5014016150821', 15, '259');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 46, 66, '1234567891231', 11, '76');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 48, 67, '012345678905', 0, '242');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 46, 70, '5014016150821', 15, '209');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 51, 72, '701197952225', 6, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 51, 1, '640509040147', 5, '278');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 17, 65, '5014016150821', 15, '237');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 56, 69, '9771234567003', 24, '234');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 8, 30, '1234567891231', 11, '81');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 4, 64, '3800065711135', 12, '221');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 53, 72, '701197952225', 6, '297');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 34, 65, '7501234567893', 19, '199');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 10, 86, '705632085943', 7, '107');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 7, 72, '8412345678905', 21, '178');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 22, 82, '9781234567897', 26, '230');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 55, 86, '1234567654324', 10, '147');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 21, 66, '9771234567003', 24, '86');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 48, 86, '791234567901', 9, '111');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 20, 64, '5014016150821', 15, '64');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 11, 30, '1234567891231', 11, '253');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 14, 66, '123456789012', 1, '173');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 3, 70, '3800065711135', 12, '97');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 19, 59, '9781234567897', 26, '163');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 42, 86, '9310779300005', 23, '294');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 4, 71, '123456789104', 3, '164');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 24, 72, '7123456789015', 18, '77');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 35, 58, '9771234567003', 24, '292');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 14, 64, '701197952225', 6, '40');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 23, 64, '9771234567003', 24, '277');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 22, 86, '8412345678905', 21, '86');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 36, 71, '640509040147', 5, '52');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 11, 58, '9780201379624', 25, '20');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 8, 1, '9310779300005', 23, '139');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 32, 82, '4007630000116', 13, '76');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 37, 59, '640509040147', 5, '133');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 53, 65, '4007630000116', 13, '58');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 11, 86, '9780201379624', 25, '138');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 34, 69, '9310779300005', 23, '230');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 36, 66, '5060123456783', 16, '90');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 41, 86, '9780201379624', 25, '73');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 35, 71, '3800065711135', 12, '131');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 22, 82, '5901234123457', 17, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 23, 67, '1234567891231', 11, '133');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 38, 68, '1234567891231', 11, '244');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 27, 69, '640509040147', 5, '259');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 12, 69, '012345678905', 0, '35');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 32, 72, '9002236311036', 22, '290');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 53, 69, '5060123456783', 16, '222');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 19, 59, '9788679912077', 27, '86');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 32, 68, '705632085943', 7, '94');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 55, 82, '1234567654324', 10, '110');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 13, 1, '1234567654324', 10, '58');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 7, 1, '4007630000116', 13, '266');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 47, 70, '0123456789104', 2, '171');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 42, 69, '705632085943', 7, '248');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 26, 1, '123456789012', 1, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 13, 1, '123456789012', 1, '115');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 12, 58, '9781234567897', 26, '53');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 18, 64, '7861234500123', 20, '73');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 36, 69, '701197952225', 6, '291');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 27, 70, '416000336108', 4, '258');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 49, 58, '9788679912077', 27, '115');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 27, 65, '416000336108', 4, '52');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 56, 58, '705632085943', 7, '74');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 7, 66, '3800065711135', 12, '165');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 25, 64, '1234567654324', 10, '235');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 51, 72, '1234567654324', 10, '235');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 8, 72, '7123456789015', 18, '115');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 54, 59, '416000336108', 4, '269');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 9, 64, '7861234500123', 20, '20');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 5, 1, '705632085943', 7, '92');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 4, 70, '4007630000116', 13, '192');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 21, 59, '712345678911', 8, '38');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 39, 64, '5901234123457', 17, '130');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 39, 86, '123456789012', 1, '22');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 50, 66, '0123456789104', 2, '156');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 19, 70, '9310779300005', 23, '227');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 40, 70, '123456789104', 3, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 9, 72, '0123456789104', 2, '191');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 10, 58, '9788679912077', 27, '142');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 47, 82, '705632085943', 7, '85');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 9, 30, '123456789012', 1, '82');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 8, 68, '7123456789015', 18, '225');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 57, 66, '123456789012', 1, '132');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 17, 30, '1234567891231', 11, '119');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 50, 69, '3800065711135', 12, '63');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 19, 59, '701197952225', 6, '241');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 46, 68, '5901234123457', 17, '49');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 21, 70, '0123456789104', 2, '102');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 35, 58, '712345678911', 8, '22');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 18, 65, '7501234567893', 19, '283');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 8, 30, '701197952225', 6, '65');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 33, 68, '9781234567897', 26, '242');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 25, 86, '9780201379624', 25, '181');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 47, 82, '1234567891231', 11, '47');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 51, 65, '0123456789104', 2, '53');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 55, 70, '791234567901', 9, '81');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 40, 72, '791234567901', 9, '156');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 6, 58, '4007630000116', 13, '287');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 50, 67, '701197952225', 6, '268');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 18, 64, '712345678911', 8, '63');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (14, 32, 69, '012345678905', 0, '104');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 33, 69, '5901234123457', 17, '258');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 43, 67, '0123456789104', 2, '183');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 19, 64, '5014016150821', 15, '126');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 34, 65, '3800065711135', 12, '90');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 21, 69, '701197952225', 6, '267');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 9, 65, '1234567654324', 10, '175');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 40, 82, '0123456789104', 2, '32');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 43, 82, '5060123456783', 16, '226');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 25, 67, '640509040147', 5, '258');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 51, 30, '5060123456783', 16, '20');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 4, 86, '5901234123457', 17, '27');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 34, 65, '416000336108', 4, '207');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 19, 71, '9002236311036', 22, '135');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 3, 59, '9002236311036', 22, '199');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 11, 69, '8412345678905', 21, '252');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 19, 64, '791234567901', 9, '121');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 28, 71, '9781234567897', 26, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 12, 64, '9788679912077', 27, '37');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 56, 59, '416000336108', 4, '132');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 7, 67, '712345678911', 8, '135');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 11, 1, '123456789104', 3, '162');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 54, 30, '9310779300005', 23, '264');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 8, 69, '9771234567003', 24, '252');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 48, 66, '1234567654324', 10, '138');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 37, 69, '1234567891231', 11, '282');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 14, 67, '640509040147', 5, '98');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 6, 68, '5014016150821', 15, '108');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 3, 70, '5060123456783', 16, '284');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 39, 67, '5012345678900', 14, '65');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 49, 59, '701197952225', 6, '260');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 39, 64, '712345678911', 8, '44');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 32, 64, '012345678905', 0, '109');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 21, 1, '705632085943', 7, '263');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 54, 86, '3800065711135', 12, '190');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 17, 58, '5014016150821', 15, '85');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 38, 67, '791234567901', 9, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 17, 86, '9002236311036', 22, '102');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 10, 64, '640509040147', 5, '77');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 20, 30, '0123456789104', 2, '27');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 54, 67, '640509040147', 5, '185');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 38, 67, '416000336108', 4, '202');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 12, 72, '5014016150821', 15, '97');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 50, 82, '123456789104', 3, '109');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 17, 71, '9002236311036', 22, '26');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 46, 69, '123456789012', 1, '159');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 24, 1, '7123456789015', 18, '103');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 51, 66, '701197952225', 6, '112');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 3, 71, '8412345678905', 21, '229');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 25, 82, '4007630000116', 13, '29');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 53, 70, '012345678905', 0, '51');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 23, 70, '9310779300005', 23, '217');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 18, 64, '7861234500123', 20, '31');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 36, 64, '7501234567893', 19, '198');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 40, 59, '791234567901', 9, '242');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 48, 86, '9002236311036', 22, '155');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 11, 68, '5060123456783', 16, '34');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 22, 67, '5060123456783', 16, '234');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 19, 70, '9781234567897', 26, '107');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 23, 65, '123456789012', 1, '21');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 8, 82, '9310779300005', 23, '212');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 26, 65, '5060123456783', 16, '50');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 18, 58, '123456789104', 3, '99');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 42, 30, '7861234500123', 20, '124');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 56, 65, '123456789104', 3, '117');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 54, 59, '7123456789015', 18, '228');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 41, 30, '416000336108', 4, '91');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 6, 66, '9310779300005', 23, '39');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 24, 30, '712345678911', 8, '77');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 4, 30, '3800065711135', 12, '278');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 24, 68, '9771234567003', 24, '226');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 48, 68, '9002236311036', 22, '116');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 33, 82, '9310779300005', 23, '81');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 10, 66, '5901234123457', 17, '92');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 42, 1, '7501234567893', 19, '171');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 56, 70, '5060123456783', 16, '57');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 49, 86, '5012345678900', 14, '194');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 8, 68, '012345678905', 0, '79');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 5, 68, '1234567654324', 10, '250');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 4, 58, '123456789104', 3, '253');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 34, 1, '012345678905', 0, '31');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 18, 66, '9771234567003', 24, '260');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 21, 86, '0123456789104', 2, '259');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 25, 82, '640509040147', 5, '89');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 48, 70, '416000336108', 4, '229');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 49, 65, '8412345678905', 21, '114');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 57, 82, '791234567901', 9, '201');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 22, 71, '9002236311036', 22, '227');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 41, 86, '640509040147', 5, '71');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 32, 1, '8412345678905', 21, '299');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 41, 68, '9781234567897', 26, '275');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 21, 71, '7861234500123', 20, '297');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 32, 67, '9310779300005', 23, '299');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 54, 67, '9310779300005', 23, '123');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 3, 69, '640509040147', 5, '46');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 14, 86, '7861234500123', 20, '228');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 40, 71, '701197952225', 6, '131');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 5, 64, '9310779300005', 23, '30');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 4, 70, '7501234567893', 19, '262');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 21, 67, '1234567891231', 11, '147');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 51, 69, '4007630000116', 13, '234');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 52, 1, '3800065711135', 12, '194');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 33, 30, '712345678911', 8, '183');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 52, 70, '416000336108', 4, '71');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 14, 67, '123456789012', 1, '182');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 55, 71, '5012345678900', 14, '76');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 37, 86, '701197952225', 6, '175');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 12, 68, '9780201379624', 25, '56');
INSERT INTO routes (lift_truck_id, initial_section, final_section, ean, product_id, time) VALUES (15, 3, 58, '5901234123457', 17, '138');

--
-- Entradas de productos ejemplos
--
INSERT INTO products (name, ean) VALUES ('MARTILLO', '012345678905');
INSERT INTO products (name, ean) VALUES ('MINI ESMERILES 4.5 820W', '123456789012');
INSERT INTO products (name, ean) VALUES ('HERRAMIENTAS PARA ELECTRICISTA 22PC HUSKY', '0123456789104');
INSERT INTO products (name, ean) VALUES ('INFLADOR COMPACTO ONE+ DE 18 V RYOBI', '123456789104');
INSERT INTO products (name, ean) VALUES ('SOLDADURA 211 MP 0.035 CARRETE 1 LB', '416000336108');
INSERT INTO products (name, ean) VALUES ('BISAGRA 2 1/2 ACERO PULIDO', '640509040147');
INSERT INTO products (name, ean) VALUES ('BALASTROS ESSENTIAL 3 X 14 W', '701197952225');
INSERT INTO products (name, ean) VALUES ('TOMAS PARA CARGA USB 1A 127VCA BLANCO', '705632085943');
INSERT INTO products (name, ean) VALUES ('ALAMBRE THW BLANCO CALIBRE 14', '712345678911');
INSERT INTO products (name, ean) VALUES ('FOCOS PILOTO LED VERDE 0.7 MA 127 VCA SCHNEIDER', '791234567901');
INSERT INTO products (name, ean) VALUES ('CABLES WRAPTOR GRANDE GARDNER BENDER', '1234567654324');
INSERT INTO products (name, ean) VALUES ('JUEGO 5 FIBRODISCOS 4.5 G-36', '1234567891231');
INSERT INTO products (name, ean) VALUES ('TOMA TELÉFONO 1 MÓDULO TITANIO 6 HILOS', '3800065711135');
INSERT INTO products (name, ean) VALUES ('JUEGO DE 37 PIEZAS CON ESTUCHE RIGIDO', '4007630000116');
INSERT INTO products (name, ean) VALUES ('MINIESMERILADORA FLEXVOLT 60V DEWALT', '5012345678900');
INSERT INTO products (name, ean) VALUES ('COMBO FLEX VOLT ROTO+LLAVE IMPACTO', '5014016150821');
INSERT INTO products (name, ean) VALUES ('JUEGO BOSCH V-LINE 34 PIEZAS', '5060123456783');
INSERT INTO products (name, ean) VALUES ('ARANDELAS DE PRESIÓN 3/8', '5901234123457');
INSERT INTO products (name, ean) VALUES ('TORNILLOS U 5/16 X2 X4 1/4', '7123456789015');
INSERT INTO products (name, ean) VALUES ('TUERCAS HEXAGONAL 5/8-11', '7501234567893');
INSERT INTO products (name, ean) VALUES ('DIVISORES DE 2 SALIDAS PARA ANTENA AÉREA', '7861234500123');
INSERT INTO products (name, ean) VALUES ('ADAPTADORES 2 JACKS A 2 JACKS RCA', '8412345678905');
INSERT INTO products (name, ean) VALUES ('COPLES DE UNIÓN PARA CABLE COAXIAL', '9002236311036');
INSERT INTO products (name, ean) VALUES ('MULTICONTACTOS 6 TOMAS CABLE 5 PIES', '9310779300005');
INSERT INTO products (name, ean) VALUES ('TEMPORIZADOR MECANICO', '9771234567003');
INSERT INTO products (name, ean) VALUES ('CARGADOR BATERIA PORTÁTIL 8000 MAH', '9780201379624');
INSERT INTO products (name, ean) VALUES ('SUPRESORES DE PICOS SS-550-USB', '9781234567897');
INSERT INTO products (name, ean) VALUES ('ENCHUFEs 10 SALIDAS CON BALE', '9788679912077');

--
-- Entradas de Inventory
--

INSERT INTO inventory (section_id, data) VALUES (3, '{"791234567901", "1234567654324", "0123456789104", "1234567891231", "9781234567897", "640509040147", "7123456789015", "0123456789104"}');
INSERT INTO inventory (section_id, data) VALUES (4, '{"9002236311036", "9788679912077", "7861234500123"}');
INSERT INTO inventory (section_id, data) VALUES (5, '{"1234567654324", "7861234500123", "4007630000116", "5012345678900", "9771234567003", "9781234567897", "9002236311036", "7501234567893"}');
INSERT INTO inventory (section_id, data) VALUES (6, '{"7501234567893", "7123456789015", "701197952225"}');
INSERT INTO inventory (section_id, data) VALUES (7, '{"4007630000116", "123456789104", "9781234567897", "7501234567893", "5014016150821", "9780201379624"}');
INSERT INTO inventory (section_id, data) VALUES (8, '{"0123456789104", "9780201379624"}');
INSERT INTO inventory (section_id, data) VALUES (9, '{"712345678911", "9780201379624", "7501234567893", "123456789104", "123456789104", "5901234123457", "5012345678900"}');
INSERT INTO inventory (section_id, data) VALUES (10, '{"9310779300005", "9310779300005", "640509040147"}');
INSERT INTO inventory (section_id, data) VALUES (11, '{"791234567901", "5060123456783", "123456789104", "7123456789015", "5012345678900", "5901234123457", "9771234567003"}');
INSERT INTO inventory (section_id, data) VALUES (12, '{"705632085943", "7123456789015"}');
INSERT INTO inventory (section_id, data) VALUES (13, '{"5012345678900", "7123456789015", "5012345678900", "5012345678900"}');
INSERT INTO inventory (section_id, data) VALUES (14, '{"0123456789104", "9781234567897", "640509040147", "012345678905"}');
INSERT INTO inventory (section_id, data) VALUES (17, '{"416000336108"}');
INSERT INTO inventory (section_id, data) VALUES (18, '{"5012345678900", "1234567891231"}');
INSERT INTO inventory (section_id, data) VALUES (19, '{"123456789012"}');
INSERT INTO inventory (section_id, data) VALUES (20, '{"7501234567893", "7123456789015", "1234567654324"}');
INSERT INTO inventory (section_id, data) VALUES (21, '{"123456789012", "9771234567003", "8412345678905", "416000336108", "123456789012"}');
INSERT INTO inventory (section_id, data) VALUES (22, '{"3800065711135", "9788679912077", "012345678905", "9310779300005", "9780201379624", "9771234567003", "012345678905", "7501234567893"}');
INSERT INTO inventory (section_id, data) VALUES (23, '{"9771234567003", "8412345678905", "640509040147", "1234567891231", "123456789012", "1234567891231"}');
INSERT INTO inventory (section_id, data) VALUES (24, '{"712345678911"}');
INSERT INTO inventory (section_id, data) VALUES (25, '{}');
INSERT INTO inventory (section_id, data) VALUES (26, '{"9781234567897", "012345678905", "701197952225", "5014016150821", "4007630000116", "640509040147", "1234567891231"}');
INSERT INTO inventory (section_id, data) VALUES (27, '{"9781234567897", "1234567891231", "712345678911"}');
INSERT INTO inventory (section_id, data) VALUES (28, '{"9780201379624", "123456789104"}');
INSERT INTO inventory (section_id, data) VALUES (32, '{"7501234567893", "5012345678900", "7861234500123", "416000336108"}');
INSERT INTO inventory (section_id, data) VALUES (33, '{"705632085943", "1234567891231", "712345678911", "712345678911", "9788679912077", "1234567654324"}');
INSERT INTO inventory (section_id, data) VALUES (34, '{"791234567901", "9780201379624", "791234567901"}');
INSERT INTO inventory (section_id, data) VALUES (35, '{"5060123456783", "9781234567897", "1234567654324", "1234567891231", "5012345678900"}');
INSERT INTO inventory (section_id, data) VALUES (36, '{"1234567891231", "0123456789104", "5014016150821", "5060123456783", "9310779300005", "3800065711135"}');
INSERT INTO inventory (section_id, data) VALUES (37, '{"705632085943", "9788679912077", "9781234567897", "4007630000116", "712345678911", "4007630000116"}');
INSERT INTO inventory (section_id, data) VALUES (38, '{"3800065711135", "1234567891231", "701197952225", "9788679912077", "3800065711135", "123456789104"}');
INSERT INTO inventory (section_id, data) VALUES (39, '{"9781234567897", "0123456789104", "3800065711135", "9771234567003", "0123456789104", "9781234567897", "9771234567003", "705632085943"}');
INSERT INTO inventory (section_id, data) VALUES (40, '{"1234567654324", "705632085943", "5060123456783", "3800065711135", "9780201379624"}');
INSERT INTO inventory (section_id, data) VALUES (41, '{"7501234567893"}');
INSERT INTO inventory (section_id, data) VALUES (42, '{"7501234567893", "4007630000116", "012345678905", "3800065711135", "7861234500123", "705632085943", "9781234567897", "5014016150821"}');
INSERT INTO inventory (section_id, data) VALUES (43, '{"712345678911", "640509040147", "9310779300005"}');
INSERT INTO inventory (section_id, data) VALUES (46, '{"3800065711135", "5060123456783", "9788679912077", "712345678911", "5012345678900"}');
INSERT INTO inventory (section_id, data) VALUES (47, '{"4007630000116"}');
INSERT INTO inventory (section_id, data) VALUES (48, '{"7861234500123", "1234567891231", "1234567654324", "705632085943", "9780201379624"}');
INSERT INTO inventory (section_id, data) VALUES (49, '{"640509040147", "701197952225", "705632085943"}');
INSERT INTO inventory (section_id, data) VALUES (50, '{"7123456789015", "7123456789015"}');
INSERT INTO inventory (section_id, data) VALUES (51, '{"5060123456783", "7501234567893", "9780201379624", "123456789012", "701197952225", "640509040147", "712345678911", "123456789012"}');
INSERT INTO inventory (section_id, data) VALUES (52, '{"9310779300005", "012345678905", "012345678905", "9788679912077"}');
INSERT INTO inventory (section_id, data) VALUES (53, '{"5060123456783", "012345678905", "123456789012", "1234567891231", "5014016150821", "5901234123457", "3800065711135", "5060123456783"}');
INSERT INTO inventory (section_id, data) VALUES (54, '{"705632085943", "5014016150821", "1234567891231", "0123456789104", "7123456789015"}');
INSERT INTO inventory (section_id, data) VALUES (55, '{"4007630000116", "9780201379624", "7123456789015", "8412345678905", "1234567891231", "416000336108"}');
INSERT INTO inventory (section_id, data) VALUES (56, '{"7861234500123", "1234567891231", "5014016150821", "012345678905", "123456789104", "701197952225", "4007630000116", "791234567901"}');
INSERT INTO inventory (section_id, data) VALUES (57, '{"9788679912077", "9788679912077", "9310779300005", "9771234567003", "012345678905"}');
INSERT INTO inventory (section_id, data) VALUES (2, '{"9781234567897", "5060123456783", "791234567901"}');
INSERT INTO inventory (section_id, data) VALUES (15, '{"705632085943", "7861234500123", "7501234567893"}');
INSERT INTO inventory (section_id, data) VALUES (16, '{}');
INSERT INTO inventory (section_id, data) VALUES (29, '{"9781234567897", "705632085943", "712345678911", "5014016150821", "9781234567897"}');
INSERT INTO inventory (section_id, data) VALUES (31, '{}');
INSERT INTO inventory (section_id, data) VALUES (44, '{"640509040147", "9788679912077", "8412345678905"}');
INSERT INTO inventory (section_id, data) VALUES (45, '{"7123456789015", "640509040147", "9002236311036", "5060123456783"}');
INSERT INTO inventory (section_id, data) VALUES (60, '{"5060123456783", "701197952225", "9780201379624", "9788679912077"}');
INSERT INTO inventory (section_id, data) VALUES (61, '{"3800065711135"}');
INSERT INTO inventory (section_id, data) VALUES (62, '{"5014016150821", "9310779300005"}');
INSERT INTO inventory (section_id, data) VALUES (63, '{"0123456789104", "9788679912077"}');

--
-- Queries para BEACONS
--

INSERT INTO adjacencies (beacon_id, adjacent_beacon_id) VALUES ('5', '9');
INSERT INTO adjacencies (beacon_id, adjacent_beacon_id) VALUES ('5', '16');
INSERT INTO adjacencies (beacon_id, adjacent_beacon_id) VALUES ('5', '17');
INSERT INTO adjacencies (beacon_id, adjacent_beacon_id) VALUES ('9', '5');
INSERT INTO adjacencies (beacon_id, adjacent_beacon_id) VALUES ('9', '16');
INSERT INTO adjacencies (beacon_id, adjacent_beacon_id) VALUES ('9', '17');
INSERT INTO adjacencies (beacon_id, adjacent_beacon_id) VALUES ('17', '5');
INSERT INTO adjacencies (beacon_id, adjacent_beacon_id) VALUES ('17', '9');
INSERT INTO adjacencies (beacon_id, adjacent_beacon_id) VALUES ('17', '16');
INSERT INTO adjacencies (beacon_id, adjacent_beacon_id) VALUES ('16', '5');
INSERT INTO adjacencies (beacon_id, adjacent_beacon_id) VALUES ('16', '9');
INSERT INTO adjacencies (beacon_id, adjacent_beacon_id) VALUES ('16', '17');
