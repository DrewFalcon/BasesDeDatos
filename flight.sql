--
-- PostgreSQL database dump
--

-- Dumped from database version 10.15 (Ubuntu 10.15-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.15 (Ubuntu 10.15-0ubuntu0.18.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aircrafts_data; Type: TABLE; Schema: public; Owner: alumnodb
--

CREATE TABLE public.aircrafts_data (
    aircraft_code character(3) NOT NULL,
    model jsonb NOT NULL,
    range integer NOT NULL,
    CONSTRAINT aircrafts_range_check CHECK ((range > 0))
);


ALTER TABLE public.aircrafts_data OWNER TO alumnodb;

--
-- Name: TABLE aircrafts_data; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON TABLE public.aircrafts_data IS 'Aircrafts (internal data)';


--
-- Name: COLUMN aircrafts_data.aircraft_code; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.aircrafts_data.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN aircrafts_data.model; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.aircrafts_data.model IS 'Aircraft model';


--
-- Name: COLUMN aircrafts_data.range; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.aircrafts_data.range IS 'Maximal flying distance, km';


--
-- Name: airports_data; Type: TABLE; Schema: public; Owner: alumnodb
--

CREATE TABLE public.airports_data (
    airport_code character(3) NOT NULL,
    airport_name jsonb NOT NULL,
    city jsonb NOT NULL,
    coordinates point NOT NULL,
    timezone text NOT NULL
);


ALTER TABLE public.airports_data OWNER TO alumnodb;

--
-- Name: TABLE airports_data; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON TABLE public.airports_data IS 'Airports (internal data)';


--
-- Name: COLUMN airports_data.airport_code; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.airports_data.airport_code IS 'Airport code';


--
-- Name: COLUMN airports_data.airport_name; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.airports_data.airport_name IS 'Airport name';


--
-- Name: COLUMN airports_data.city; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.airports_data.city IS 'City';


--
-- Name: COLUMN airports_data.coordinates; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.airports_data.coordinates IS 'Airport coordinates (longitude and latitude)';


--
-- Name: COLUMN airports_data.timezone; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.airports_data.timezone IS 'Airport time zone';


--
-- Name: boarding_passes; Type: TABLE; Schema: public; Owner: alumnodb
--

CREATE TABLE public.boarding_passes (
    ticket_no character(13) NOT NULL,
    flight_id integer NOT NULL,
    boarding_no integer NOT NULL,
    seat_no character varying(4) NOT NULL
);


ALTER TABLE public.boarding_passes OWNER TO alumnodb;

--
-- Name: TABLE boarding_passes; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON TABLE public.boarding_passes IS 'Boarding passes';


--
-- Name: COLUMN boarding_passes.ticket_no; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.boarding_passes.ticket_no IS 'Ticket number';


--
-- Name: COLUMN boarding_passes.flight_id; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.boarding_passes.flight_id IS 'Flight ID';


--
-- Name: COLUMN boarding_passes.boarding_no; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.boarding_passes.boarding_no IS 'Boarding pass number';


--
-- Name: COLUMN boarding_passes.seat_no; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.boarding_passes.seat_no IS 'Seat number';


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: alumnodb
--

CREATE TABLE public.bookings (
    book_ref character(6) NOT NULL,
    book_date timestamp with time zone NOT NULL,
    total_amount numeric(10,2) NOT NULL
);


ALTER TABLE public.bookings OWNER TO alumnodb;

--
-- Name: TABLE bookings; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON TABLE public.bookings IS 'Bookings';


--
-- Name: COLUMN bookings.book_ref; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.bookings.book_ref IS 'Booking number';


--
-- Name: COLUMN bookings.book_date; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.bookings.book_date IS 'Booking date';


--
-- Name: COLUMN bookings.total_amount; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.bookings.total_amount IS 'Total booking cost';


--
-- Name: flights; Type: TABLE; Schema: public; Owner: alumnodb
--

CREATE TABLE public.flights (
    flight_id integer NOT NULL,
    flight_no character(6) NOT NULL,
    scheduled_departure timestamp with time zone NOT NULL,
    scheduled_arrival timestamp with time zone NOT NULL,
    departure_airport character(3) NOT NULL,
    arrival_airport character(3) NOT NULL,
    status character varying(20) NOT NULL,
    aircraft_code character(3) NOT NULL,
    actual_departure timestamp with time zone,
    actual_arrival timestamp with time zone,
    CONSTRAINT flights_check CHECK ((scheduled_arrival > scheduled_departure)),
    CONSTRAINT flights_check1 CHECK (((actual_arrival IS NULL) OR ((actual_departure IS NOT NULL) AND (actual_arrival IS NOT NULL) AND (actual_arrival > actual_departure)))),
    CONSTRAINT flights_status_check CHECK (((status)::text = ANY (ARRAY[('On Time'::character varying)::text, ('Delayed'::character varying)::text, ('Departed'::character varying)::text, ('Arrived'::character varying)::text, ('Scheduled'::character varying)::text, ('Cancelled'::character varying)::text])))
);


ALTER TABLE public.flights OWNER TO alumnodb;

--
-- Name: TABLE flights; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON TABLE public.flights IS 'Flights';


--
-- Name: COLUMN flights.flight_id; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.flights.flight_id IS 'Flight ID';


--
-- Name: COLUMN flights.flight_no; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.flights.flight_no IS 'Flight number';


--
-- Name: COLUMN flights.scheduled_departure; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.flights.scheduled_departure IS 'Scheduled departure time';


--
-- Name: COLUMN flights.scheduled_arrival; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.flights.scheduled_arrival IS 'Scheduled arrival time';


--
-- Name: COLUMN flights.departure_airport; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.flights.departure_airport IS 'Airport of departure';


--
-- Name: COLUMN flights.arrival_airport; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.flights.arrival_airport IS 'Airport of arrival';


--
-- Name: COLUMN flights.status; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.flights.status IS 'Flight status';


--
-- Name: COLUMN flights.aircraft_code; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.flights.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN flights.actual_departure; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.flights.actual_departure IS 'Actual departure time';


--
-- Name: COLUMN flights.actual_arrival; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.flights.actual_arrival IS 'Actual arrival time';


--
-- Name: flights_flight_id_seq; Type: SEQUENCE; Schema: public; Owner: alumnodb
--

CREATE SEQUENCE public.flights_flight_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.flights_flight_id_seq OWNER TO alumnodb;

--
-- Name: flights_flight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alumnodb
--

ALTER SEQUENCE public.flights_flight_id_seq OWNED BY public.flights.flight_id;


--
-- Name: seats; Type: TABLE; Schema: public; Owner: alumnodb
--

CREATE TABLE public.seats (
    aircraft_code character(3) NOT NULL,
    seat_no character varying(4) NOT NULL,
    fare_conditions character varying(10) NOT NULL,
    CONSTRAINT seats_fare_conditions_check CHECK (((fare_conditions)::text = ANY (ARRAY[('Economy'::character varying)::text, ('Comfort'::character varying)::text, ('Business'::character varying)::text])))
);


ALTER TABLE public.seats OWNER TO alumnodb;

--
-- Name: TABLE seats; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON TABLE public.seats IS 'Seats';


--
-- Name: COLUMN seats.aircraft_code; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.seats.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN seats.seat_no; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.seats.seat_no IS 'Seat number';


--
-- Name: COLUMN seats.fare_conditions; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.seats.fare_conditions IS 'Travel class';


--
-- Name: ticket_flights; Type: TABLE; Schema: public; Owner: alumnodb
--

CREATE TABLE public.ticket_flights (
    ticket_no character(13) NOT NULL,
    flight_id integer NOT NULL,
    fare_conditions character varying(10) NOT NULL,
    amount numeric(10,2) NOT NULL,
    CONSTRAINT ticket_flights_amount_check CHECK ((amount >= (0)::numeric)),
    CONSTRAINT ticket_flights_fare_conditions_check CHECK (((fare_conditions)::text = ANY (ARRAY[('Economy'::character varying)::text, ('Comfort'::character varying)::text, ('Business'::character varying)::text])))
);


ALTER TABLE public.ticket_flights OWNER TO alumnodb;

--
-- Name: TABLE ticket_flights; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON TABLE public.ticket_flights IS 'Flight segment';


--
-- Name: COLUMN ticket_flights.ticket_no; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.ticket_flights.ticket_no IS 'Ticket number';


--
-- Name: COLUMN ticket_flights.flight_id; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.ticket_flights.flight_id IS 'Flight ID';


--
-- Name: COLUMN ticket_flights.fare_conditions; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.ticket_flights.fare_conditions IS 'Travel class';


--
-- Name: COLUMN ticket_flights.amount; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.ticket_flights.amount IS 'Travel cost';


--
-- Name: tickets; Type: TABLE; Schema: public; Owner: alumnodb
--

CREATE TABLE public.tickets (
    ticket_no character(13) NOT NULL,
    book_ref character(6) NOT NULL,
    passenger_id character varying(20) NOT NULL,
    passenger_name text NOT NULL,
    contact_data jsonb
);


ALTER TABLE public.tickets OWNER TO alumnodb;

--
-- Name: TABLE tickets; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON TABLE public.tickets IS 'Tickets';


--
-- Name: COLUMN tickets.ticket_no; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.tickets.ticket_no IS 'Ticket number';


--
-- Name: COLUMN tickets.book_ref; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.tickets.book_ref IS 'Booking number';


--
-- Name: COLUMN tickets.passenger_id; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.tickets.passenger_id IS 'Passenger ID';


--
-- Name: COLUMN tickets.passenger_name; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.tickets.passenger_name IS 'Passenger name';


--
-- Name: COLUMN tickets.contact_data; Type: COMMENT; Schema: public; Owner: alumnodb
--

COMMENT ON COLUMN public.tickets.contact_data IS 'Passenger contact information';


--
-- Name: flights flight_id; Type: DEFAULT; Schema: public; Owner: alumnodb
--

ALTER TABLE ONLY public.flights ALTER COLUMN flight_id SET DEFAULT nextval('public.flights_flight_id_seq'::regclass);


--
-- Data for Name: aircrafts_data; Type: TABLE DATA; Schema: public; Owner: alumnodb
--

COPY public.aircrafts_data (aircraft_code, model, range) FROM stdin;
773	{"en": "Boeing 777-300", "ru": "Боинг 777-300"}	11100
763	{"en": "Boeing 767-300", "ru": "Боинг 767-300"}	7900
SU9	{"en": "Sukhoi Superjet-100", "ru": "Сухой Суперджет-100"}	3000
320	{"en": "Airbus A320-200", "ru": "Аэробус A320-200"}	5700
321	{"en": "Airbus A321-200", "ru": "Аэробус A321-200"}	5600
319	{"en": "Airbus A319-100", "ru": "Аэробус A319-100"}	6700
733	{"en": "Boeing 737-300", "ru": "Боинг 737-300"}	4200
CN1	{"en": "Cessna 208 Caravan", "ru": "Сессна 208 Караван"}	1200
CR2	{"en": "Bombardier CRJ-200", "ru": "Бомбардье CRJ-200"}	2700
\.


--
-- Data for Name: airports_data; Type: TABLE DATA; Schema: public; Owner: alumnodb
--

COPY public.airports_data (airport_code, airport_name, city, coordinates, timezone) FROM stdin;
YKS	{"en": "Yakutsk Airport", "ru": "Якутск"}	{"en": "Yakutsk", "ru": "Якутск"}	(129.77099609375,62.0932998657226562)	Asia/Yakutsk
MJZ	{"en": "Mirny Airport", "ru": "Мирный"}	{"en": "Mirnyj", "ru": "Мирный"}	(114.03900146484375,62.534698486328125)	Asia/Yakutsk
KHV	{"en": "Khabarovsk-Novy Airport", "ru": "Хабаровск-Новый"}	{"en": "Khabarovsk", "ru": "Хабаровск"}	(135.18800354004,48.5279998779300001)	Asia/Vladivostok
PKC	{"en": "Yelizovo Airport", "ru": "Елизово"}	{"en": "Petropavlovsk", "ru": "Петропавловск-Камчатский"}	(158.453994750976562,53.1679000854492188)	Asia/Kamchatka
UUS	{"en": "Yuzhno-Sakhalinsk Airport", "ru": "Хомутово"}	{"en": "Yuzhno-Sakhalinsk", "ru": "Южно-Сахалинск"}	(142.718002319335938,46.8886985778808594)	Asia/Sakhalin
VVO	{"en": "Vladivostok International Airport", "ru": "Владивосток"}	{"en": "Vladivostok", "ru": "Владивосток"}	(132.147994995117188,43.3989982604980469)	Asia/Vladivostok
LED	{"en": "Pulkovo Airport", "ru": "Пулково"}	{"en": "St. Petersburg", "ru": "Санкт-Петербург"}	(30.2625007629394531,59.8003005981445312)	Europe/Moscow
KGD	{"en": "Khrabrovo Airport", "ru": "Храброво"}	{"en": "Kaliningrad", "ru": "Калининград"}	(20.5925998687744141,54.8899993896484375)	Europe/Kaliningrad
KEJ	{"en": "Kemerovo Airport", "ru": "Кемерово"}	{"en": "Kemorovo", "ru": "Кемерово"}	(86.1072006225585938,55.2700996398925781)	Asia/Novokuznetsk
CEK	{"en": "Chelyabinsk Balandino Airport", "ru": "Челябинск"}	{"en": "Chelyabinsk", "ru": "Челябинск"}	(61.503300000000003,55.3058010000000024)	Asia/Yekaterinburg
MQF	{"en": "Magnitogorsk International Airport", "ru": "Магнитогорск"}	{"en": "Magnetiogorsk", "ru": "Магнитогорск"}	(58.7556991577148438,53.3931007385253906)	Asia/Yekaterinburg
PEE	{"en": "Bolshoye Savino Airport", "ru": "Пермь"}	{"en": "Perm", "ru": "Пермь"}	(56.021198272705,57.9145011901860016)	Asia/Yekaterinburg
SGC	{"en": "Surgut Airport", "ru": "Сургут"}	{"en": "Surgut", "ru": "Сургут"}	(73.4018020629882812,61.3437004089355469)	Asia/Yekaterinburg
BZK	{"en": "Bryansk Airport", "ru": "Брянск"}	{"en": "Bryansk", "ru": "Брянск"}	(34.1763992309999978,53.2141990661999955)	Europe/Moscow
MRV	{"en": "Mineralnyye Vody Airport", "ru": "Минеральные Воды"}	{"en": "Mineralnye Vody", "ru": "Минеральные Воды"}	(43.0819015502929688,44.2251014709472656)	Europe/Moscow
STW	{"en": "Stavropol Shpakovskoye Airport", "ru": "Ставрополь"}	{"en": "Stavropol", "ru": "Ставрополь"}	(42.1128005981445312,45.1091995239257812)	Europe/Moscow
ASF	{"en": "Astrakhan Airport", "ru": "Астрахань"}	{"en": "Astrakhan", "ru": "Астрахань"}	(48.0063018799000005,46.2832984924000002)	Europe/Samara
NJC	{"en": "Nizhnevartovsk Airport", "ru": "Нижневартовск"}	{"en": "Nizhnevartovsk", "ru": "Нижневартовск"}	(76.4835968017578125,60.9492988586425781)	Asia/Yekaterinburg
SVX	{"en": "Koltsovo Airport", "ru": "Кольцово"}	{"en": "Yekaterinburg", "ru": "Екатеринбург"}	(60.8027000427250002,56.7430992126460012)	Asia/Yekaterinburg
SVO	{"en": "Sheremetyevo International Airport", "ru": "Шереметьево"}	{"en": "Moscow", "ru": "Москва"}	(37.4146000000000001,55.9725990000000024)	Europe/Moscow
VOZ	{"en": "Voronezh International Airport", "ru": "Воронеж"}	{"en": "Voronezh", "ru": "Воронеж"}	(39.2295989990234375,51.8142013549804688)	Europe/Moscow
VKO	{"en": "Vnukovo International Airport", "ru": "Внуково"}	{"en": "Moscow", "ru": "Москва"}	(37.2615013122999983,55.5914993286000012)	Europe/Moscow
SCW	{"en": "Syktyvkar Airport", "ru": "Сыктывкар"}	{"en": "Syktyvkar", "ru": "Сыктывкар"}	(50.8451004028320312,61.6469993591308594)	Europe/Moscow
KUF	{"en": "Kurumoch International Airport", "ru": "Курумоч"}	{"en": "Samara", "ru": "Самара"}	(50.1642990112299998,53.5049018859860013)	Europe/Samara
DME	{"en": "Domodedovo International Airport", "ru": "Домодедово"}	{"en": "Moscow", "ru": "Москва"}	(37.9062995910644531,55.4087982177734375)	Europe/Moscow
TJM	{"en": "Roshchino International Airport", "ru": "Рощино"}	{"en": "Tyumen", "ru": "Тюмень"}	(65.3243026732999965,57.1896018981999958)	Asia/Yekaterinburg
GOJ	{"en": "Nizhny Novgorod Strigino International Airport", "ru": "Стригино"}	{"en": "Nizhniy Novgorod", "ru": "Нижний Новгород"}	(43.7840003967289988,56.2300987243649999)	Europe/Moscow
TOF	{"en": "Bogashevo Airport", "ru": "Богашёво"}	{"en": "Tomsk", "ru": "Томск"}	(85.2082977294920028,56.3802986145020029)	Asia/Krasnoyarsk
UIK	{"en": "Ust-Ilimsk Airport", "ru": "Усть-Илимск"}	{"en": "Ust Ilimsk", "ru": "Усть-Илимск"}	(102.56500244140625,58.1361007690429688)	Asia/Irkutsk
NSK	{"en": "Norilsk-Alykel Airport", "ru": "Норильск"}	{"en": "Norilsk", "ru": "Норильск"}	(87.3321990966796875,69.31109619140625)	Asia/Krasnoyarsk
ARH	{"en": "Talagi Airport", "ru": "Талаги"}	{"en": "Arkhangelsk", "ru": "Архангельск"}	(40.7167015075683594,64.6003036499023438)	Europe/Moscow
RTW	{"en": "Saratov Central Airport", "ru": "Саратов-Центральный"}	{"en": "Saratov", "ru": "Саратов"}	(46.0466995239257812,51.5649986267089844)	Europe/Volgograd
NUX	{"en": "Novy Urengoy Airport", "ru": "Новый Уренгой"}	{"en": "Novy Urengoy", "ru": "Новый Уренгой"}	(76.5203018188476562,66.06939697265625)	Asia/Yekaterinburg
NOJ	{"en": "Noyabrsk Airport", "ru": "Ноябрьск"}	{"en": "Noyabrsk", "ru": "Ноябрьск"}	(75.2699966430664062,63.1833000183105469)	Asia/Yekaterinburg
UCT	{"en": "Ukhta Airport", "ru": "Ухта"}	{"en": "Ukhta", "ru": "Ухта"}	(53.8046989440917969,63.5668983459472656)	Europe/Moscow
USK	{"en": "Usinsk Airport", "ru": "Усинск"}	{"en": "Usinsk", "ru": "Усинск"}	(57.3671989440917969,66.00469970703125)	Europe/Moscow
NNM	{"en": "Naryan Mar Airport", "ru": "Нарьян-Мар"}	{"en": "Naryan-Mar", "ru": "Нарьян-Мар"}	(53.1218986511230469,67.6399993896484375)	Europe/Moscow
PKV	{"en": "Pskov Airport", "ru": "Псков"}	{"en": "Pskov", "ru": "Псков"}	(28.395599365234375,57.7839012145996094)	Europe/Moscow
KGP	{"en": "Kogalym International Airport", "ru": "Когалым"}	{"en": "Kogalym", "ru": "Когалым"}	(74.5337982177734375,62.190399169921875)	Asia/Yekaterinburg
KJA	{"en": "Yemelyanovo Airport", "ru": "Емельяново"}	{"en": "Krasnoyarsk", "ru": "Красноярск"}	(92.493301391602003,56.1729011535639984)	Asia/Krasnoyarsk
URJ	{"en": "Uray Airport", "ru": "Петрозаводск"}	{"en": "Uraj", "ru": "Урай"}	(64.8266983032226562,60.1032981872558594)	Asia/Yekaterinburg
IWA	{"en": "Ivanovo South Airport", "ru": "Иваново-Южный"}	{"en": "Ivanovo", "ru": "Иваново"}	(40.9407997131347656,56.9393997192382812)	Europe/Moscow
PYJ	{"en": "Polyarny Airport", "ru": "Полярный"}	{"en": "Yakutia", "ru": "Удачный"}	(112.029998778999996,66.4003982544000024)	Asia/Yakutsk
KXK	{"en": "Komsomolsk-on-Amur Airport", "ru": "Хурба"}	{"en": "Komsomolsk-on-Amur", "ru": "Комсомольск-на-Амуре"}	(136.934005737304688,50.4090003967285156)	Asia/Vladivostok
DYR	{"en": "Ugolny Airport", "ru": "Анадырь"}	{"en": "Anadyr", "ru": "Анадырь"}	(177.740997314453125,64.7349014282226562)	Asia/Anadyr
PES	{"en": "Petrozavodsk Airport", "ru": "Бесовец"}	{"en": "Petrozavodsk", "ru": "Петрозаводск"}	(34.1547012329101562,61.8852005004882812)	Europe/Moscow
KYZ	{"en": "Kyzyl Airport", "ru": "Кызыл"}	{"en": "Kyzyl", "ru": "Кызыл"}	(94.4005966186523438,51.6693992614746094)	Asia/Krasnoyarsk
NOZ	{"en": "Spichenkovo Airport", "ru": "Спиченково"}	{"en": "Novokuznetsk", "ru": "Новокузнецк"}	(86.877197265625,53.8114013671875)	Asia/Novokuznetsk
GRV	{"en": "Khankala Air Base", "ru": "Грозный"}	{"en": "Grozny", "ru": "Грозный"}	(45.7840995788574219,43.2980995178222656)	Europe/Moscow
NAL	{"en": "Nalchik Airport", "ru": "Нальчик"}	{"en": "Nalchik", "ru": "Нальчик"}	(43.6366004943847656,43.5129013061523438)	Europe/Moscow
OGZ	{"en": "Beslan Airport", "ru": "Беслан"}	{"en": "Beslan", "ru": "Владикавказ"}	(44.6066017150999983,43.2051010132000002)	Europe/Moscow
ESL	{"en": "Elista Airport", "ru": "Элиста"}	{"en": "Elista", "ru": "Элиста"}	(44.3308982849121094,46.3739013671875)	Europe/Moscow
SLY	{"en": "Salekhard Airport", "ru": "Салехард"}	{"en": "Salekhard", "ru": "Салехард"}	(66.6110000610351562,66.5907974243164062)	Asia/Yekaterinburg
HMA	{"en": "Khanty Mansiysk Airport", "ru": "Ханты-Мансийск"}	{"en": "Khanty-Mansiysk", "ru": "Ханты-Мансийск"}	(69.0860977172851562,61.0284996032714844)	Asia/Yekaterinburg
NYA	{"en": "Nyagan Airport", "ru": "Нягань"}	{"en": "Nyagan", "ru": "Нягань"}	(65.6149978637695312,62.1100006103515625)	Asia/Yekaterinburg
OVS	{"en": "Sovetskiy Airport", "ru": "Советский"}	{"en": "Sovetskiy", "ru": "Советский"}	(63.6019134521484375,61.3266220092773438)	Asia/Yekaterinburg
IJK	{"en": "Izhevsk Airport", "ru": "Ижевск"}	{"en": "Izhevsk", "ru": "Ижевск"}	(53.4575004577636719,56.8280982971191406)	Europe/Samara
KVX	{"en": "Pobedilovo Airport", "ru": "Победилово"}	{"en": "Kirov", "ru": "Киров"}	(49.3483009338379972,58.5032997131350001)	Europe/Moscow
NYM	{"en": "Nadym Airport", "ru": "Надым"}	{"en": "Nadym", "ru": "Надым"}	(72.6988983154296875,65.4809036254882812)	Asia/Yekaterinburg
NFG	{"en": "Nefteyugansk Airport", "ru": "Нефтеюганск"}	{"en": "Nefteyugansk", "ru": "Нефтеюганск"}	(72.6500015258789062,61.1082992553710938)	Asia/Yekaterinburg
KRO	{"en": "Kurgan Airport", "ru": "Курган"}	{"en": "Kurgan", "ru": "Курган"}	(65.4156036376953125,55.4752998352050781)	Asia/Yekaterinburg
EGO	{"en": "Belgorod International Airport", "ru": "Белгород"}	{"en": "Belgorod", "ru": "Белгород"}	(36.5900993347167969,50.643798828125)	Europe/Moscow
URS	{"en": "Kursk East Airport", "ru": "Курск-Восточный"}	{"en": "Kursk", "ru": "Курск"}	(36.2956008911132812,51.7505989074707031)	Europe/Moscow
LPK	{"en": "Lipetsk Airport", "ru": "Липецк"}	{"en": "Lipetsk", "ru": "Липецк"}	(39.5377998352050781,52.7028007507324219)	Europe/Moscow
VKT	{"en": "Vorkuta Airport", "ru": "Воркута"}	{"en": "Vorkuta", "ru": "Воркута"}	(63.9930992126464844,67.4886016845703125)	Europe/Moscow
UUA	{"en": "Bugulma Airport", "ru": "Бугульма"}	{"en": "Bugulma", "ru": "Бугульма"}	(52.8017005920410156,54.6399993896484375)	Europe/Moscow
JOK	{"en": "Yoshkar-Ola Airport", "ru": "Йошкар-Ола"}	{"en": "Yoshkar-Ola", "ru": "Йошкар-Ола"}	(47.9047012329101562,56.7005996704101562)	Europe/Moscow
CSY	{"en": "Cheboksary Airport", "ru": "Чебоксары"}	{"en": "Cheboksary", "ru": "Чебоксары"}	(47.3473014831542969,56.090301513671875)	Europe/Moscow
ULY	{"en": "Ulyanovsk East Airport", "ru": "Ульяновск-Восточный"}	{"en": "Ulyanovsk", "ru": "Ульяновск"}	(48.8027000427246094,54.4010009765625)	Europe/Samara
OSW	{"en": "Orsk Airport", "ru": "Орск"}	{"en": "Orsk", "ru": "Орск"}	(58.5956001281738281,51.0724983215332031)	Asia/Yekaterinburg
PEZ	{"en": "Penza Airport", "ru": "Пенза"}	{"en": "Penza", "ru": "Пенза"}	(45.0210990905761719,53.1105995178222656)	Europe/Moscow
SKX	{"en": "Saransk Airport", "ru": "Саранск"}	{"en": "Saransk", "ru": "Саранск"}	(45.2122573852539062,54.1251296997070312)	Europe/Moscow
TBW	{"en": "Donskoye Airport", "ru": "Донское"}	{"en": "Tambow", "ru": "Тамбов"}	(41.4827995300289984,52.806098937987997)	Europe/Moscow
UKX	{"en": "Ust-Kut Airport", "ru": "Усть-Кут"}	{"en": "Ust-Kut", "ru": "Усть-Кут"}	(105.730003356933594,56.8567008972167969)	Asia/Irkutsk
GDZ	{"en": "Gelendzhik Airport", "ru": "Геленджик"}	{"en": "Gelendzhik", "ru": "Геленджик"}	(38.012480735799997,44.5820926295000035)	Europe/Moscow
IAR	{"en": "Tunoshna Airport", "ru": "Туношна"}	{"en": "Yaroslavl", "ru": "Ярославль"}	(40.1573982238769531,57.560699462890625)	Europe/Moscow
NBC	{"en": "Begishevo Airport", "ru": "Бегишево"}	{"en": "Nizhnekamsk", "ru": "Нижнекамск"}	(52.092498779296875,55.5647010803222656)	Europe/Moscow
ULV	{"en": "Ulyanovsk Baratayevka Airport", "ru": "Баратаевка"}	{"en": "Ulyanovsk", "ru": "Ульяновск"}	(48.2266998291000064,54.2682991027999932)	Europe/Samara
SWT	{"en": "Strezhevoy Airport", "ru": "Стрежевой"}	{"en": "Strezhevoy", "ru": "Стрежевой"}	(77.66000366210001,60.7094001769999991)	Asia/Krasnoyarsk
EYK	{"en": "Beloyarskiy Airport", "ru": "Белоярский"}	{"en": "Beloyarsky", "ru": "Белоярский"}	(66.6986007689999951,63.6869010924999941)	Asia/Yekaterinburg
KLF	{"en": "Grabtsevo Airport", "ru": "Калуга"}	{"en": "Kaluga", "ru": "Калуга"}	(36.3666687011999983,54.5499992371000033)	Europe/Moscow
RGK	{"en": "Gorno-Altaysk Airport", "ru": "Горно-Алтайск"}	{"en": "Gorno-Altaysk", "ru": "Горно-Алтайск"}	(85.8332977295000035,51.9667015075999998)	Asia/Krasnoyarsk
KRR	{"en": "Krasnodar Pashkovsky International Airport", "ru": "Краснодар"}	{"en": "Krasnodar", "ru": "Краснодар"}	(39.1705017089839984,45.0346984863279971)	Europe/Moscow
MCX	{"en": "Uytash Airport", "ru": "Уйташ"}	{"en": "Makhachkala", "ru": "Махачкала"}	(47.6523017883300781,42.8167991638183594)	Europe/Moscow
KZN	{"en": "Kazan International Airport", "ru": "Казань"}	{"en": "Kazan", "ru": "Казань"}	(49.278701782227003,55.606201171875)	Europe/Moscow
REN	{"en": "Orenburg Central Airport", "ru": "Оренбург-Центральный"}	{"en": "Orenburg", "ru": "Оренбург"}	(55.4566993713378906,51.7957992553710938)	Asia/Yekaterinburg
UFA	{"en": "Ufa International Airport", "ru": "Уфа"}	{"en": "Ufa", "ru": "Уфа"}	(55.8744010925289984,54.5574989318850001)	Asia/Yekaterinburg
OVB	{"en": "Tolmachevo Airport", "ru": "Толмачёво"}	{"en": "Novosibirsk", "ru": "Новосибирск"}	(82.6507034301759944,55.012599945067997)	Asia/Novosibirsk
CEE	{"en": "Cherepovets Airport", "ru": "Череповец"}	{"en": "Cherepovets", "ru": "Череповец"}	(38.0158004761000043,59.2736015320000007)	Europe/Moscow
OMS	{"en": "Omsk Central Airport", "ru": "Омск-Центральный"}	{"en": "Omsk", "ru": "Омск"}	(73.3105010986328125,54.9669990539550781)	Asia/Omsk
ROV	{"en": "Rostov-on-Don Airport", "ru": "Ростов-на-Дону"}	{"en": "Rostov", "ru": "Ростов-на-Дону"}	(39.8180999755999991,47.2582015990999977)	Europe/Moscow
AER	{"en": "Sochi International Airport", "ru": "Сочи"}	{"en": "Sochi", "ru": "Сочи"}	(39.9566001892089986,43.4499015808110016)	Europe/Moscow
VOG	{"en": "Volgograd International Airport", "ru": "Гумрак"}	{"en": "Volgograd", "ru": "Волгоград"}	(44.3455009460449219,48.782501220703125)	Europe/Volgograd
BQS	{"en": "Ignatyevo Airport", "ru": "Игнатьево"}	{"en": "Blagoveschensk", "ru": "Благовещенск"}	(127.412002563476562,50.4253997802734375)	Asia/Yakutsk
GDX	{"en": "Sokol Airport", "ru": "Магадан"}	{"en": "Magadan", "ru": "Магадан"}	(150.720001220703125,59.9109992980957031)	Asia/Magadan
HTA	{"en": "Chita-Kadala Airport", "ru": "Чита"}	{"en": "Chita", "ru": "Чита"}	(113.305999999999997,52.0262990000000016)	Asia/Chita
BTK	{"en": "Bratsk Airport", "ru": "Братск"}	{"en": "Bratsk", "ru": "Братск"}	(101.697998046875,56.3706016540527344)	Asia/Irkutsk
IKT	{"en": "Irkutsk Airport", "ru": "Иркутск"}	{"en": "Irkutsk", "ru": "Иркутск"}	(104.388999938959998,52.2680015563960012)	Asia/Irkutsk
UUD	{"en": "Ulan-Ude Airport (Mukhino)", "ru": "Байкал"}	{"en": "Ulan-ude", "ru": "Улан-Удэ"}	(107.438003540039062,51.80780029296875)	Asia/Irkutsk
MMK	{"en": "Murmansk Airport", "ru": "Мурманск"}	{"en": "Murmansk", "ru": "Мурманск"}	(32.7508010864257812,68.7817001342773438)	Europe/Moscow
ABA	{"en": "Abakan Airport", "ru": "Абакан"}	{"en": "Abakan", "ru": "Абакан"}	(91.3850021362304688,53.7400016784667969)	Asia/Krasnoyarsk
BAX	{"en": "Barnaul Airport", "ru": "Барнаул"}	{"en": "Barnaul", "ru": "Барнаул"}	(83.5384979248046875,53.363800048828125)	Asia/Krasnoyarsk
AAQ	{"en": "Anapa Vityazevo Airport", "ru": "Витязево"}	{"en": "Anapa", "ru": "Анапа"}	(37.3473014831539984,45.002101898192997)	Europe/Moscow
CNN	{"en": "Chulman Airport", "ru": "Чульман"}	{"en": "Neryungri", "ru": "Нерюнгри"}	(124.914001464839998,56.9138984680179973)	Asia/Yakutsk
\.


--
-- Data for Name: boarding_passes; Type: TABLE DATA; Schema: public; Owner: alumnodb
--

COPY public.boarding_passes (ticket_no, flight_id, boarding_no, seat_no) FROM stdin;
0005435212351	30625	1	2D
0005435212386	30625	2	3G
0005435212381	30625	3	4H
0005432211370	30625	4	5D
0005435212357	30625	5	11A
0005435212360	30625	6	11E
0005435212393	30625	7	11H
0005435212374	30625	8	12E
0005435212365	30625	9	13D
0005435212378	30625	10	14H
0005435212362	30625	11	15E
0005435212334	30625	12	15F
0005435212370	30625	13	15K
0005435212329	30625	14	15H
0005435725513	30625	15	16D
0005435212328	30625	16	16C
0005435630915	30625	17	16E
0005435212388	30625	18	17E
0005432159775	30625	19	17D
0005435212382	30625	20	17H
0005432211367	30625	21	19K
0005435212354	30625	22	20B
0005432211372	30625	23	20F
0005432159776	30625	24	2A
0005435212344	30625	25	20K
0005435212372	30625	26	22B
0005435212355	30625	27	22H
0005435212376	30625	28	23F
0005435725512	30625	29	25D
0005435212385	30625	30	25C
0005435212336	30625	31	26D
0005435212367	30625	32	26J
0005435212359	30625	33	27B
0005435212364	30625	34	27H
0005435725514	30625	35	27K
0005435212338	30625	36	28C
0005435212391	30625	37	28B
0005435212366	30625	38	28G
0005435212347	30625	39	28J
0005432211366	30625	40	28K
0005433656614	30625	41	29D
0005435212383	30625	42	29C
0005435212373	30625	43	29B
0005435212395	30625	44	29J
0005435212343	30625	45	30E
0005435212371	30625	46	30J
0005435212377	30625	47	31J
0005435212358	30625	48	32C
0005435212330	30625	49	32B
0005432211371	30625	50	32F
0005435212368	30625	51	32K
0005435212340	30625	52	33D
0005435212335	30625	53	33C
0005435212363	30625	54	33H
0005435212380	30625	55	35A
0005435212345	30625	56	35C
0005435212375	30625	57	35B
0005432211365	30625	58	35F
0005435212350	30625	59	35E
0005435212331	30625	60	35G
0005435212353	30625	61	36G
0005435630916	30625	62	36J
0005435212337	30625	63	37B
0005432211368	30625	64	37E
0005432211369	30625	65	37F
0005435212356	30625	66	37H
0005435212332	30625	67	38A
0005435212348	30625	68	38K
0005435212352	30625	69	39E
0005435212394	30625	70	40G
0005435212389	30625	71	40J
0005435212369	30625	72	42A
0005435212392	30625	73	41K
0005435212379	30625	74	42C
0005435725516	30625	75	42E
0005435212396	30625	76	42K
0005432159777	30625	77	43A
0005433656613	30625	78	43G
0005435725515	30625	79	43H
0005435212346	30625	80	43K
0005435212390	30625	81	45D
0005435212361	30625	82	45E
0005435212341	30625	83	45K
0005435725511	30625	84	46C
0005435212349	30625	85	46B
0005432159778	30625	86	46K
0005435212384	30625	87	47E
0005435630914	30625	88	49E
0005435212339	30625	89	49G
0005435212333	30625	90	50C
0005435212387	30625	91	50H
0005435212342	30625	92	51D
0005433367244	24836	1	1D
0005433367229	24836	2	1F
0005433367230	24836	3	2C
0005433367245	24836	4	2D
0005433367256	24836	5	3D
0005433367225	24836	6	3F
0005433367228	24836	7	4A
0005433367236	24836	8	4C
0005433367252	24836	9	4E
0005433367243	24836	10	5A
0005433367222	24836	11	5C
0005433367234	24836	12	5D
0005433367231	24836	13	5F
0005433367218	24836	14	6C
0005433367224	24836	15	6E
0005433367237	24836	16	7A
0005433367255	24836	17	7D
0005433367246	24836	18	7E
0005433367227	24836	19	8A
0005433367233	24836	20	8F
0005433367242	24836	21	9A
0005433367248	24836	22	9F
0005433367223	24836	23	10C
0005433367241	24836	24	10E
0005433367221	24836	25	10F
0005433367258	24836	26	11A
0005433367240	24836	27	13E
0005433367226	24836	28	13F
0005433367247	24836	29	14A
0005433367235	24836	30	14F
0005433367257	24836	31	15F
0005433367251	24836	32	16A
0005433367239	24836	33	16C
0005433367220	24836	34	16D
0005433367250	24836	35	16E
0005433367219	24836	36	17C
0005433367253	24836	37	17D
0005433367232	24836	38	18A
0005433367249	24836	39	18E
0005433367238	24836	40	19D
0005433367254	24836	41	19E
0005434979262	2055	1	1C
0005434979271	2055	2	1D
0005434979277	2055	3	2B
0005434979252	2055	4	2C
0005434979282	2055	5	2D
0005434979273	2055	6	3B
0005434979280	2055	7	3C
0005434979255	2055	8	4A
0005434979269	2055	9	4B
0005434979275	2055	10	4C
0005435801642	2055	11	4D
0005434979279	2055	12	5A
0005434979267	2055	13	5B
0005434979254	2055	14	5D
0005434979264	2055	15	6A
0005434979263	2055	16	6C
0005434979276	2055	17	7B
0005434979270	2055	18	18A
0005434979258	2055	19	18B
0005434979256	2055	20	18C
0005434979265	2055	21	18D
0005434979261	2055	22	19A
0005434979253	2055	23	19B
0005434979259	2055	24	19D
0005435801643	2055	25	20A
0005434979272	2055	26	20B
0005434979260	2055	27	20C
0005434979274	2055	28	20D
0005434979268	2055	29	21C
0005434979257	2055	30	21D
0005434979278	2055	31	22A
0005434979266	2055	32	22B
0005435801644	2055	33	22D
0005434979281	2055	34	23B
0005434952466	2575	1	1B
0005434952464	2575	2	4A
0005434952467	2575	3	5A
0005434952465	2575	4	4B
0005433256382	28205	1	1B
0005433256381	28205	2	5A
0005433111467	19732	1	1A
0005433111468	19732	2	3B
0005433112350	19732	3	4B
0005433111469	19732	4	6A
0005434190367	19092	1	1C
0005434190368	19092	2	7A
0005433534460	6786	1	1B
0005433534461	6786	2	2A
0005433534463	6786	3	2D
0005433538721	6786	4	3A
0005433538717	6786	5	4B
0005433538718	6786	6	4C
0005433534462	6786	7	5C
0005433538720	6786	8	21A
0005433538719	6786	9	21B
0005433538722	6786	10	21D
0005433538723	6786	11	22A
0005433538724	6786	12	23B
0005435259680	25029	1	3D
0005435259678	25029	2	4C
0005435259681	25029	3	18A
0005435259679	25029	4	19D
0005433511804	823	1	1D
0005433511803	823	2	4B
0005433511809	823	3	5D
0005433511807	823	4	6A
0005433511802	823	5	7B
0005433511801	823	6	19B
0005433511808	823	7	20B
0005433511806	823	8	21B
0005433511805	823	9	22B
0005432922454	16157	1	1C
0005432922455	16157	2	2D
0005432922453	16157	3	5A
0005433475633	4021	1	1D
0005433475632	4021	2	2D
0005433475631	4021	3	18D
0005433475630	4021	4	21A
0005435696849	3660	1	1B
0005435696846	3660	2	1D
0005434950451	3660	3	2A
0005435696864	3660	4	2B
0005435696862	3660	5	2D
0005435696847	3660	6	3A
0005435696850	3660	7	3D
0005435696866	3660	8	4A
0005435696843	3660	9	4C
0005435696863	3660	10	5A
0005435696851	3660	11	5B
0005434950450	3660	12	5D
0005435696870	3660	13	6B
0005434950452	3660	14	6D
0005435696859	3660	15	7A
0005435696871	3660	16	7B
0005435696855	3660	17	7D
0005435696869	3660	18	18A
0005435696852	3660	19	18C
0005435696857	3660	20	18D
0005435696853	3660	21	19A
0005435696845	3660	22	19B
0005435696844	3660	23	19C
0005435696856	3660	24	20B
0005435696858	3660	25	20C
0005435696865	3660	26	20D
0005435696848	3660	27	21C
0005435696861	3660	28	22A
0005435696860	3660	29	22B
0005435696854	3660	30	22D
0005435696868	3660	31	23B
0005435696867	3660	32	23A
0005435916119	16272	1	6A
0005435916118	16272	2	7B
0005432609659	3993	1	1A
0005432609661	3993	2	1B
0005432607495	3993	3	1C
0005434606760	3993	4	1D
0005432609658	3993	5	2D
0005434606759	3993	6	4A
0005434606763	3993	7	4D
0005433519378	3993	8	5B
0005432607494	3993	9	6B
0005433519379	3993	10	6D
0005434604838	3993	11	7A
0005434606761	3993	12	18B
0005433519377	3993	13	19B
0005432609660	3993	14	19C
0005434604839	3993	15	19D
0005434606762	3993	16	20B
0005433519380	3993	17	20C
0005432607496	3993	18	21B
0005434604837	3993	19	21C
0005435853578	22080	1	1D
0005435853580	22080	2	18C
0005435853579	22080	3	22C
0005435628670	728	1	1A
0005435628672	728	2	2A
0005435628669	728	3	4B
0005435628671	728	4	6A
0005433348889	15900	1	1A
0005433348891	15900	2	2A
0005433348887	15900	3	3B
0005433348888	15900	4	5B
0005433348890	15900	5	6B
0005433159275	17677	1	4A
0005433159274	17677	2	6A
0005433159276	17677	3	6B
0005435132700	7862	1	2B
0005435132696	7862	2	2D
0005435132694	7862	3	3D
0005435132695	7862	4	4B
0005435132698	7862	5	5A
0005435132697	7862	6	6A
0005435132699	7862	7	7D
0005435132703	7862	8	19B
0005435132704	7862	9	20A
0005435132702	7862	10	21C
0005435132701	7862	11	23A
0005435383058	33092	1	1A
0005435383057	33092	2	5C
0005435383056	33092	3	6B
0005435383059	33092	4	18B
0005435383055	33092	5	22B
0005435160112	7477	1	4C
0005435160111	7477	2	6A
0005435160104	7477	3	7C
0005435160106	7477	4	7B
0005435160109	7477	5	18B
0005435160103	7477	6	18D
0005435160105	7477	7	20A
0005435160110	7477	8	21B
0005435160113	7477	9	21C
0005435160107	7477	10	21D
0005435160108	7477	11	23B
0005435390116	29573	1	1A
0005435390120	29573	2	4A
0005435390121	29573	3	4B
0005435390122	29573	4	5C
0005435390118	29573	5	7C
0005435390117	29573	6	21A
0005435390119	29573	7	21D
0005434503467	6547	1	2C
0005434503492	6547	2	2F
0005434503487	6547	3	4A
0005434503465	6547	4	4C
0005434503495	6547	5	4F
0005434503472	6547	6	5A
0005434503463	6547	7	5D
0005434503469	6547	8	5E
0005434503460	6547	9	5F
0005434503488	6547	10	6C
0005434503484	6547	11	6D
0005434503490	6547	12	6E
0005434503468	6547	13	6F
0005434503482	6547	14	7A
0005435103797	6547	15	7D
0005435103796	6547	16	7E
0005434503479	6547	17	8A
0005435103802	6547	18	8C
0005434503471	6547	19	8D
0005434503494	6547	20	8E
0005434503483	6547	21	8F
0005434503474	6547	22	9C
0005434503464	6547	23	9D
0005434503476	6547	24	9E
0005435103803	6547	25	10A
0005434503462	6547	26	10C
0005434503459	6547	27	10E
0005435103799	6547	28	10F
0005434503458	6547	29	11C
0005434503466	6547	30	11F
0005434503478	6547	31	12A
0005434503470	6547	32	12C
0005434503486	6547	33	13C
0005434503489	6547	34	13F
0005434503491	6547	35	14A
0005435103793	6547	36	14D
0005435103795	6547	37	14E
0005434503485	6547	38	14F
0005434503477	6547	39	15C
0005434503461	6547	40	15E
0005434503473	6547	41	15F
0005434503496	6547	42	16D
0005435103794	6547	43	16E
0005434503475	6547	44	17E
0005434503493	6547	45	17F
0005435103801	6547	46	18D
0005435103798	6547	47	19A
0005435103800	6547	48	20A
0005434503481	6547	49	20C
0005434503480	6547	50	20E
0005435652274	1654	1	1A
0005435652282	1654	2	1D
0005435652261	1654	3	2C
0005435652269	1654	4	2F
0005435652292	1654	5	3C
0005435652275	1654	6	4A
0005435652281	1654	7	4C
0005435652283	1654	8	5D
0005435652263	1654	9	5E
0005435652260	1654	10	6D
0005435652264	1654	11	6F
0005435652278	1654	12	7A
0005435652266	1654	13	7D
0005435652272	1654	14	7F
0005435652250	1654	15	8A
0005435652254	1654	16	8C
0005435652268	1654	17	8E
0005435652253	1654	18	9C
0005435652279	1654	19	9D
0005435652276	1654	20	9E
0005435652251	1654	21	10A
0005435652273	1654	22	10C
0005435652252	1654	23	11A
0005435652295	1654	24	11C
0005435652284	1654	25	11D
0005435652259	1654	26	11E
0005435652265	1654	27	12C
0005435652262	1654	28	12D
0005435652267	1654	29	12E
0005435652280	1654	30	13A
0005435652294	1654	31	13C
0005435652296	1654	32	13D
0005435652257	1654	33	13E
0005435652288	1654	34	14C
0005435652271	1654	35	14D
0005435652285	1654	36	15D
0005435652258	1654	37	15E
0005435652286	1654	38	15F
0005435652291	1654	39	16A
0005435652293	1654	40	16E
0005435652256	1654	41	16D
0005435652270	1654	42	17C
0005435652289	1654	43	18C
0005435652287	1654	44	18D
0005435652290	1654	45	19E
0005435652277	1654	46	19F
0005435652255	1654	47	20D
0005433367257	21707	1	1C
0005433367244	21707	2	1D
0005433367258	21707	3	1F
0005433367221	21707	4	2F
0005433367224	21707	5	4A
0005433367218	21707	6	4D
0005433367240	21707	7	4E
0005433367222	21707	8	6D
0005433367227	21707	9	6E
0005433367252	21707	10	6F
0005433367256	21707	11	7C
0005433367245	21707	12	7F
0005433367247	21707	13	8A
0005433367248	21707	14	8D
0005433367251	21707	15	8E
0005433367235	21707	16	9E
0005433367246	21707	17	10A
0005433367237	21707	18	10C
0005433367242	21707	19	10D
0005433367241	21707	20	10E
0005433367234	21707	21	10F
0005433367253	21707	22	11D
0005433367250	21707	23	11F
0005433367255	21707	24	13D
0005433367231	21707	25	13E
0005433367228	21707	26	14D
0005433367220	21707	27	14E
0005433367238	21707	28	15A
0005433367219	21707	29	15D
0005433367225	21707	30	16A
0005433367226	21707	31	16C
0005433367236	21707	32	16D
0005433367230	21707	33	17A
0005433367254	21707	34	17C
0005433367239	21707	35	18F
0005433367229	21707	36	19A
0005433367232	21707	37	19C
0005433367233	21707	38	19D
0005433367249	21707	39	19E
0005433367243	21707	40	20A
0005433367223	21707	41	20D
0005433985127	4135	1	1D
0005433985129	4135	2	1F
0005433985123	4135	3	2A
0005433985126	4135	4	2C
0005433985160	4135	5	2F
0005435788725	4135	6	3A
0005433985140	4135	7	3D
0005433985155	4135	8	3F
0005433985137	4135	9	4A
0005433985159	4135	10	4E
0005433985125	4135	11	5A
0005433985154	4135	12	5D
0005433985161	4135	13	5E
0005433985122	4135	14	5F
0005433985136	4135	15	7D
0005433985148	4135	16	8A
0005433985143	4135	17	8E
0005433985131	4135	18	9A
0005433985133	4135	19	9C
0005433985158	4135	20	9D
0005433985141	4135	21	10A
0005433985134	4135	22	10D
0005433985139	4135	23	10F
0005435788726	4135	24	11A
0005433985145	4135	25	11E
0005433985152	4135	26	12A
0005433985144	4135	27	12C
0005433985147	4135	28	12F
0005433985146	4135	29	13A
0005435788727	4135	30	13C
0005433985124	4135	31	13D
0005435788728	4135	32	13E
0005433985153	4135	33	14A
0005433985156	4135	34	14D
0005433985130	4135	35	14E
0005433985150	4135	36	17A
0005433985132	4135	37	17D
0005433985151	4135	38	17E
0005433985157	4135	39	18F
0005433985135	4135	40	19A
0005433985142	4135	41	19E
0005433985128	4135	42	19F
0005433985149	4135	43	20D
0005433985138	4135	44	20E
0005433168301	21332	1	3B
0005433168299	21332	2	3D
0005433168302	21332	3	6C
0005433168300	21332	4	20A
0005432869415	17856	1	3F
0005432869416	17856	2	8F
0005432869413	17856	3	9A
0005434151654	17856	4	12D
0005434151656	17856	5	18E
0005432869412	17856	6	19D
0005434151655	17856	7	20C
0005432869414	17856	8	20F
0005432327913	3108	1	1D
0005432327892	3108	2	2D
0005432327911	3108	3	2F
0005432327914	3108	4	3F
0005432287105	3108	5	4D
0005432287101	3108	6	4F
0005432287104	3108	7	4E
0005432327915	3108	8	5C
0005432327904	3108	9	5E
0005432327907	3108	10	5F
0005432327925	3108	11	6A
0005432327930	3108	12	6C
0005432327894	3108	13	6D
0005432287100	3108	14	6E
0005433438767	3108	15	6F
0005432327931	3108	16	7A
0005432327923	3108	17	7C
0005432327898	3108	18	7D
0005432327920	3108	19	7E
0005432327928	3108	20	8A
0005432327893	3108	21	8C
0005432327921	3108	22	8E
0005432327934	3108	23	8F
0005432327912	3108	24	9A
0005432327901	3108	25	9C
