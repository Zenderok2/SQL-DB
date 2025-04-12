SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

CREATE TABLE public."Bookings" (
    booking_id integer NOT NULL,
    user_id integer NOT NULL,
    room_id integer NOT NULL,
    checkindate date,
    checkoutdate date,
    datecreated date,
    totalprice numeric(10,2) NOT NULL,
    paystatus character varying(15) NOT NULL
);


ALTER TABLE public."Bookings" OWNER TO postgres;

COMMENT ON TABLE public."Bookings" IS 'Забронированный номер';

CREATE TABLE public."Bookings_discounts" (
    booking_id integer NOT NULL,
    discount_id integer NOT NULL
);


ALTER TABLE public."Bookings_discounts" OWNER TO postgres;

COMMENT ON TABLE public."Bookings_discounts" IS 'Связь скидок с бронированием';

CREATE TABLE public."Bookings_services" (
    booking_id integer NOT NULL,
    service_id integer NOT NULL,
    quantity integer
);


ALTER TABLE public."Bookings_services" OWNER TO postgres;

COMMENT ON TABLE public."Bookings_services" IS 'Связь с дополнительными услушами';

CREATE TABLE public."Discounts" (
    discount_id integer NOT NULL,
    code character varying(50) NOT NULL,
    type character varying(20) NOT NULL,
    value numeric(10,2) NOT NULL,
    datestart date,
    dateend date
);


ALTER TABLE public."Discounts" OWNER TO postgres;

COMMENT ON TABLE public."Discounts" IS 'Скидки зависящие от времени';

CREATE TABLE public."History" (
    history_id integer NOT NULL,
    user_id integer NOT NULL,
    booking_id integer NOT NULL
);

ALTER TABLE public."History" OWNER TO postgres;

COMMENT ON TABLE public."History" IS 'История бронирования';

CREATE TABLE public."Hotels" (
    hotel_id integer NOT NULL,
    name character varying(100) NOT NULL,
    location character varying(200) NOT NULL,
    raiting numeric(3,2) NOT NULL
);


ALTER TABLE public."Hotels" OWNER TO postgres;

COMMENT ON TABLE public."Hotels" IS 'Отели';

CREATE TABLE public."Rooms" (
    room_id integer NOT NULL,
    hotel_id integer NOT NULL,
    roomcount integer NOT NULL,
    price numeric(10,2),
    status character varying(15),
    fridge boolean,
    airconditioner boolean,
    balcony boolean
);

ALTER TABLE public."Rooms" OWNER TO postgres;

COMMENT ON TABLE public."Rooms" IS 'Комнаты';

CREATE TABLE public."Services" (
    service_id integer NOT NULL,
    servicename character varying(100) NOT NULL,
    description text,
    price numeric(10,2)
);

ALTER TABLE public."Services" OWNER TO postgres;

COMMENT ON TABLE public."Services" IS 'Услуги (Спа, столик, бассейн и др)';

CREATE TABLE public."Users" (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(100) NOT NULL,
    fullname character varying(100) NOT NULL,
    dataofbirth date NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20) NOT NULL
);

ALTER TABLE public."Users" OWNER TO postgres;

ALTER TABLE ONLY public."Bookings"
    ADD CONSTRAINT "Bookings_pkey" PRIMARY KEY (booking_id);

ALTER TABLE ONLY public."Discounts"
    ADD CONSTRAINT "Discounts_pkey" PRIMARY KEY (discount_id);

ALTER TABLE ONLY public."History"
    ADD CONSTRAINT "History_pkey" PRIMARY KEY (history_id);

ALTER TABLE ONLY public."Hotels"
    ADD CONSTRAINT "Hotels_pkey" PRIMARY KEY (hotel_id);

ALTER TABLE ONLY public."Rooms"
    ADD CONSTRAINT "Rooms_pkey" PRIMARY KEY (room_id);

ALTER TABLE ONLY public."Services"
    ADD CONSTRAINT "Services_pkey" PRIMARY KEY (service_id);

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (user_id);

ALTER TABLE ONLY public."History"
    ADD CONSTRAINT fk_booking_id FOREIGN KEY (booking_id) REFERENCES public."Bookings"(booking_id);

ALTER TABLE ONLY public."Bookings_discounts"
    ADD CONSTRAINT fk_booking_id FOREIGN KEY (booking_id) REFERENCES public."Bookings"(booking_id);

ALTER TABLE ONLY public."Bookings_services"
    ADD CONSTRAINT fk_bookings_id FOREIGN KEY (booking_id) REFERENCES public."Bookings"(booking_id);

ALTER TABLE ONLY public."Bookings_discounts"
    ADD CONSTRAINT fk_discount_id FOREIGN KEY (discount_id) REFERENCES public."Discounts"(discount_id);

ALTER TABLE ONLY public."Rooms"
    ADD CONSTRAINT fk_hotel_id FOREIGN KEY (hotel_id) REFERENCES public."Hotels"(hotel_id);

ALTER TABLE ONLY public."Bookings_services"
    ADD CONSTRAINT fk_service_id FOREIGN KEY (service_id) REFERENCES public."Services"(service_id);

ALTER TABLE ONLY public."History"
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public."Users"(user_id);




INSERT INTO "Hotels" (hotel_id, name, location, raiting) VALUES 
(1, 'Москва', 'Центр', 4.5),
(2, 'СПб', 'Исторический центр', 4.7),
(3, 'Краснод', 'Центр', 4.3);

INSERT INTO "Rooms" (room_id, hotel_id, roomcount, price, status, fridge, airconditioner, balcony) VALUES
(1, 1, 10, 10000, 'Люкс', true, true, true),
(2, 1, 20, 5000, 'Эконом', false, true, false),
(3, 2, 15, 12000, 'Люкс', true, true, true),
(4, 2, 25, 6000, 'Эконом', false, true, false),
(5, 3, 8, 8000, 'Люкс', true, true, true),
(6, 3, 15, 4000, 'Эконом', false, true, false);