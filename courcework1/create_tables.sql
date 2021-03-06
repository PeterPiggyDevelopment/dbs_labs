CREATE TYPE CAMERA AS OBJECT
(
  REAR_CAMERA_MP INT,
  FRONT_CAMERA_MP INT
);

CREATE OR REPLACE PACKAGE cam_acts AS
  PROCEDURE insert_cam (up_id int, rear int, front int);
end cam_acts;

CREATE OR REPLACE PACKAGE body cam_acts AS
  PROCEDURE insert_cam (up_id int, rear int, front int) IS
    cam CAMERA;
    BEGIN
      cam := camera(rear, front);
      update PHONES set CAMERA = cam where id = up_id;
    END;
end cam_acts;

CREATE TABLE MANUFACTURERS
(
  ID INT PRIMARY KEY NOT NULL,
  NAME VARCHAR(255),
  COUNTRY_ID INT,
  ADDRESS VARCHAR(255)
);

CREATE TABLE SUPPLIERS
(
  ID INT PRIMARY KEY NOT NULL,
  NAME VARCHAR(255),
  COUNTRY_ID INT,
  ADDRESS VARCHAR(255)
);

CREATE TABLE SHOP
(
  ID INT PRIMARY KEY NOT NULL,
  NAME VARCHAR(255),
  COUNTRY_ID INT,
  ADDRESS VARCHAR(255)
);

CREATE TABLE PRODUCTION
(
  ID INT PRIMARY KEY NOT NULL,
  MANUFACTURER_ID INT,
  PHONE_ID INT,
  SUPPLIER_ID INT,
  SHOP_ID INT,
);

CREATE TABLE PHONES
(
  ID INT PRIMARY KEY NOT NULL,
  NAME VARCHAR(255),
  CPU_ID INT,
  GPU_ID INT,
  MEMORY_CAP INT,
  STORAGE_CAP INT,
  CAMERA_CHARS CAMERA,
  PIC BLOB
);

CREATE TABLE GPUS
(
  ID INT PRIMARY KEY NOT NULL,
  GPU_NAME VARCHAR(255)
);

CREATE TABLE CPUS
(
  ID INT PRIMARY KEY NOT NULL,
  CPU_NAME VARCHAR(255)
);

CREATE TABLE ORDERS
(
  ID INT PRIMARY KEY NOT NULL,
  PRODUCT_ID INT,
  CUSTOMER_ID INT
);

CREATE TABLE CUSTOMERS
(
  ID INT PRIMARY KEY NOT NULL,
  FIRSTNAME VARCHAR(255),
  LASTNAME VARCHAR(255),
  MIDDLENAME VARCHAR(255),
  REGISTER_ADDRESS VARCHAR(255),
  CITIZENSHIP_COUNTRY_ID INT
);

CREATE TABLE COUNTRIES
(
  ID INT PRIMARY KEY NOT NULL,
  NAME VARCHAR(255)
);

create SEQUENCE cpu_seq_key start with 1;
create SEQUENCE gpu_seq_key start with 1;
create SEQUENCE prod_seq_key start with 1;
create SEQUENCE shop_seq_key start with 1;
create SEQUENCE phone_seq_key start with 1;
create SEQUENCE orders_seq_key start with 1;
create SEQUENCE suppl_seq_key start with 1;
create SEQUENCE countr_seq_key START WITH 1;
create SEQUENCE cstmr_seq_key START WITH 1;
create SEQUENCE man_seq_key START WITH 1;

CREATE OR REPLACE TRIGGER cpu_bir
BEFORE INSERT ON CPUS
FOR EACH ROW
  BEGIN
    SELECT cpu_seq_key.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;

CREATE OR REPLACE TRIGGER gpu_bir
BEFORE INSERT ON GPUS
FOR EACH ROW
  BEGIN
    SELECT gpu_seq_key.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;

CREATE OR REPLACE TRIGGER man_bir
BEFORE INSERT ON MANUFACTURERS
FOR EACH ROW
  BEGIN
    SELECT man_seq_key.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;

CREATE OR REPLACE TRIGGER cstmr_bir
BEFORE INSERT ON CUSTOMERS
FOR EACH ROW
  BEGIN
    SELECT cstmr_seq_key.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;

CREATE OR REPLACE TRIGGER counrt_bir
BEFORE INSERT ON COUNTRIES
FOR EACH ROW
  BEGIN
    SELECT countr_seq_key.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;

CREATE OR REPLACE TRIGGER prod_bir
BEFORE INSERT ON PRODUCTION
FOR EACH ROW
  BEGIN
    SELECT prod_seq_key.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;

CREATE OR REPLACE TRIGGER shop_bir
BEFORE INSERT ON SHOP
FOR EACH ROW
  BEGIN
    SELECT shop_seq_key.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;

CREATE OR REPLACE TRIGGER phone_bir
BEFORE INSERT ON PHONES
FOR EACH ROW
  BEGIN
    SELECT phone_seq_key.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;

CREATE OR REPLACE TRIGGER orders_bir
BEFORE INSERT ON ORDERS
FOR EACH ROW
  BEGIN
    SELECT orders_seq_key.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;

CREATE OR REPLACE TRIGGER suppl_bir
BEFORE INSERT ON SUPPLIERS
FOR EACH ROW
  BEGIN
    SELECT suppl_seq_key.NEXTVAL
    INTO   :new.id
    FROM   dual;
  END;
