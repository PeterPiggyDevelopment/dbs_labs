INSERT INTO CPUS (CPU_NAME) VALUES
    ('qualcomm 820');
INSERT INTO CPUS (CPU_NAME) VALUES
    ('qualcomm 620');
INSERT INTO CPUS (CPU_NAME) VALUES
    ('qualcomm 610');
INSERT INTO CPUS (CPU_NAME) VALUES
    ('qualcomm 615');
INSERT INTO CPUS (CPU_NAME) VALUES
    ('qualcomm 520');
INSERT INTO CPUS (CPU_NAME) VALUES
    ('qualcomm 420');

INSERT INTO GPUS (GPU_NAME) VALUES
    ('qualcomm adreno 820');
INSERT INTO GPUS (GPU_NAME) VALUES
    ('qualcomm adreno 620');
INSERT INTO GPUS (GPU_NAME) VALUES
    ('qualcomm adreno 610');
INSERT INTO GPUS (GPU_NAME) VALUES
    ('qualcomm adreno 615');
INSERT INTO GPUS (GPU_NAME) VALUES
    ('qualcomm adreno 520');
INSERT INTO GPUS (GPU_NAME) VALUES
    ('qualcomm adreno 420');

INSERT INTO COUNTRIES (NAME) VALUES ( 'usa' );
INSERT INTO COUNTRIES (NAME) VALUES ( 'uk' );
INSERT INTO COUNTRIES (NAME) VALUES ( 'russia' );
INSERT INTO COUNTRIES (NAME) VALUES ( 'south korea' );

insert into SUPPLIERS (NAME, COUNTRY_ID, ADDRESS) VALUES
    ('gaselkin', 3, 'д. Простоквашино, пр. Ленина, д. 1');
insert into SUPPLIERS (NAME, COUNTRY_ID, ADDRESS) VALUES
    ('lg-sup', 2, '13, Abbey Road, London');

insert into SHOP (NAME, COUNTRY_ID, ADDRESS) VALUES
    ('samsung store', 3, 'г. Санкт Петербург, пр. Науки, д. 1');
insert into SHOP (NAME, COUNTRY_ID, ADDRESS) VALUES
    ('lg store', 2, 'Manchester c., Portland st., 31');

insert into MANUFACTURERS (NAME, COUNTRY_ID, ADDRESS) VALUES
    ('samsung', 4, '11, Seocho-daero 74-gil, Seocho District, Seoul');
insert into MANUFACTURERS (NAME, COUNTRY_ID, ADDRESS) VALUES
    ('lg', 4, 'Yeouido-dong, Seoul');

insert into CUSTOMERS
(FIRSTNAME, LASTNAME, MIDDLENAME, REGISTER_ADDRESS, CITIZENSHIP_COUNTRY_ID) values
    ('Иван', 'Иванович', 'Качанов', 'д. Простоквашино, ул. Путина, д. 14', 3);
insert into CUSTOMERS
(FIRSTNAME, LASTNAME, MIDDLENAME, REGISTER_ADDRESS, CITIZENSHIP_COUNTRY_ID) values
    ('John', 'Smith', 'Paper', 'Manchester c., Princess st., 54', 2);

insert into PHONES
(NAME, CPU_ID, GPU_ID, MEMORY_CAP, STORAGE_CAP) VALUES
    ('samsung galaxy s7', 1, 1, 3, 64);
insert into PHONES
(NAME, CPU_ID, GPU_ID, MEMORY_CAP, STORAGE_CAP) VALUES
    ('lg g5', 2, 2, 3, 64);

insert into PRODUCTION
(SUPPLIER_ID, SHOP_ID, MANUFACTURER_ID, PHONE_ID) VALUES
    (1, 1, 1, 1);
insert into PRODUCTION
(SUPPLIER_ID, SHOP_ID, MANUFACTURER_ID, PHONE_ID) VALUES
    (2, 2, 2, 2);

insert into orders(PRODUCT_ID, CUSTOMER_ID)
    VALUES (1, 1);
insert into orders(PRODUCT_ID, CUSTOMER_ID)
    VALUES (2, 2);

BEGIN
    cam_acts.insert_cam(2, 16, 12);
end;
