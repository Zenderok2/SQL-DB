-- Удаление существующих таблиц (если нужно)
DROP TABLE IF EXISTS 
  public."Bookings_discounts",
  public."Bookings_services",
  public."History",
  public."Bookings",
  public."Discounts",
  public."Rooms",
  public."Hotels",
  public."Services",
  public."Users" CASCADE;

-- Создание таблиц с явным указанием схемы и правильным порядком
CREATE TABLE public."Hotels" (
  hotel_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  location VARCHAR(200) NOT NULL,
  rating NUMERIC(3,2) NOT NULL  -- Исправлено: raiting -> rating
);

CREATE TABLE public."Rooms" (
  room_id SERIAL PRIMARY KEY,
  hotel_id INTEGER NOT NULL REFERENCES public."Hotels"(hotel_id),
  room_count INTEGER NOT NULL,
  price NUMERIC(10,2) NOT NULL,
  status VARCHAR(15) NOT NULL,
  fridge BOOLEAN,
  airconditioner BOOLEAN,
  balcony BOOLEAN
);

CREATE TABLE public."Users" (
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL,
  fullname VARCHAR(100) NOT NULL,
  dateofbirth DATE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL
);

CREATE TABLE public."Bookings" (
  booking_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES public."Users"(user_id),
  room_id INTEGER NOT NULL REFERENCES public."Rooms"(room_id),
  checkindate DATE NOT NULL,
  checkoutdate DATE NOT NULL,
  datecreated DATE DEFAULT CURRENT_DATE,
  totalprice NUMERIC(10,2) NOT NULL,
  paystatus VARCHAR(15) NOT NULL
);

CREATE TABLE public."Discounts" (
  discount_id SERIAL PRIMARY KEY,
  code VARCHAR(50) UNIQUE NOT NULL,
  type VARCHAR(20) NOT NULL,
  value NUMERIC(10,2) NOT NULL,
  datestart DATE,
  dateend DATE
);

CREATE TABLE public."Services" (
  service_id SERIAL PRIMARY KEY,
  servicename VARCHAR(100) NOT NULL,
  description TEXT,
  price NUMERIC(10,2)
);

-- Связующие таблицы
CREATE TABLE public."Bookings_discounts" (
  booking_id INTEGER REFERENCES public."Bookings"(booking_id),
  discount_id INTEGER REFERENCES public."Discounts"(discount_id),
  PRIMARY KEY (booking_id, discount_id)
);

CREATE TABLE public."Bookings_services" (
  booking_id INTEGER REFERENCES public."Bookings"(booking_id),
  service_id INTEGER REFERENCES public."Services"(service_id),
  quantity INTEGER,
  PRIMARY KEY (booking_id, service_id)
);

CREATE TABLE public."History" (
  history_id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES public."Users"(user_id),
  booking_id INTEGER REFERENCES public."Bookings"(booking_id)
);

-- Вставка тестовых данных
INSERT INTO public."Hotels" (name, location, rating) VALUES 
('Москва', 'Центр', 4.5),
('СПб', 'Исторический центр', 4.7),
('Краснод', 'Центр', 4.3);

INSERT INTO public."Rooms" (hotel_id, room_count, price, status, fridge, airconditioner, balcony) VALUES
(1, 10, 10000, 'Люкс', true, true, true),
(1, 20, 5000, 'Эконом', false, true, false),
(2, 15, 12000, 'Люкс', true, true, true),
(2, 25, 6000, 'Эконом', false, true, false),
(3, 8, 8000, 'Люкс', true, true, true),
(3, 15, 4000, 'Эконом', false, true, false);
