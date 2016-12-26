CREATE OR REPLACE PACKAGE  BODY CRUD_OPS AS
  PROCEDURE ADD_ORDER(
    CUSTOMER_FIRST_NAME  CUSTOMERS.FIRSTNAME%TYPE,
    CUSTOMER_MIDDLE_NAME CUSTOMERS.MIDDLENAME%TYPE,
    CUSTOMER_LAST_NAME CUSTOMERS.LASTNAME%TYPE,
    CUSTOMER_REGISTER_ADDERESS CUSTOMERS.REGISTER_ADDRESS%TYPE,
    COUNTRY COUNTRIES.NAME%TYPE,
    PRODUCT PHONES.NAME%TYPE
  ) IS
    CUSTOMER_CIT_COUNTRY_ID CUSTOMERS.CITIZENSHIP_COUNTRY_ID%TYPE;
    CUST_ID CUSTOMERS.ID%TYPE;
    ORDER_ID ORDERS.ID%TYPE;
    PRODUCT_ID ORDERS.PRODUCT_ID%TYPE;
    INVALID_PRODUCT_NAME EXCEPTION;
    BEGIN
      PRODUCT_ID:=-1;
      CUSTOMER_CIT_COUNTRY_ID:=-1;
      SELECT ID
        INTO CUSTOMER_CIT_COUNTRY_ID
        FROM COUNTRIES
        WHERE NAME=COUNTRY;
      IF (CUSTOMER_CIT_COUNTRY_ID=-1) THEN
        INSERT INTO COUNTRIES(NAME) VALUES (COUNTRY)
          RETURNING ID INTO CUSTOMER_CIT_COUNTRY_ID;
      END IF;
      INSERT INTO CUSTOMERS (FIRSTNAME, LASTNAME, MIDDLENAME, REGISTER_ADDRESS, CITIZENSHIP_COUNTRY_ID)
        VALUES (CUSTOMER_FIRST_NAME, CUSTOMER_LAST_NAME, CUSTOMER_MIDDLE_NAME, CUSTOMER_REGISTER_ADDERESS, CUSTOMER_CIT_COUNTRY_ID)
        RETURNING ID INTO CUST_ID;
      SELECT ID
        INTO PRODUCT_ID
        FROM PRODUCTION
        WHERE PHONE_ID IN
              ( SELECT ID FROM PHONES WHERE NAME=PRODUCT );
      IF (PRODUCT_ID=-1) THEN
        RAISE INVALID_PRODUCT_NAME;
      END IF;
      INSERT INTO ORDERS (PRODUCT_ID, CUSTOMER_ID) VALUES (PRODUCT_ID, CUST_ID)
          RETURNING ID INTO ORDER_ID;

    EXCEPTION
      WHEN INVALID_PRODUCT_NAME THEN NULL;
      WHEN OTHERS THEN NULL;
    END;

  FUNCTION COUNT_ORDERS_OF_CUSTOMER(CUST_ID INT) RETURN int IS
    RES INT;
    BEGIN
      SELECT COUNT(*) INTO RES FROM ORDERS WHERE CUSTOMER_ID=CUST_ID;
      RETURN res;
    END;

  PROCEDURE UPDATE_CUSTOMER_INFO(
    CUSTOMER_FIRSTNAME CUSTOMERS.FIRSTNAME%TYPE,
    CUSTOMER_MIDDLENAME CUSTOMERS.MIDDLENAME%TYPE,
    CUSTOMER_LASTNAME CUSTOMERS.LASTNAME%TYPE,
    NEXT_CUSTOMER_FIRSTNAME CUSTOMERS.FIRSTNAME%TYPE,
    NEXT_CUSTOMER_MIDDLENAME CUSTOMERS.MIDDLENAME%TYPE,
    NEXT_CUSTOMER_LASTNAME CUSTOMERS.LASTNAME%TYPE,
    CUSTOMER_REGISTER_ADDERESS CUSTOMERS.REGISTER_ADDRESS%TYPE,
    COUNTRY COUNTRIES.NAME%TYPE
  ) IS
    CUSTOMER_ID CUSTOMERS.ID%TYPE;
    CUSTOMER_CIT_COUNTRY_ID CUSTOMERS.CITIZENSHIP_COUNTRY_ID%TYPE;
    INVALID_COUNTRY_NAME EXCEPTION;
    BEGIN
      SELECT ID INTO CUSTOMER_ID
        FROM CUSTOMERS WHERE
          FIRSTNAME=CUSTOMER_FIRSTNAME AND
          LASTNAME=CUSTOMER_LASTNAME AND
          MIDDLENAME=CUSTOMER_MIDDLENAME;
      IF (LENGTH(NEXT_CUSTOMER_LASTNAME) > 0) THEN
        UPDATE CUSTOMERS SET
          LASTNAME=NEXT_CUSTOMER_LASTNAME
        WHERE ID=CUSTOMER_ID;
      END IF;
      IF (LENGTH(NEXT_CUSTOMER_FIRSTNAME) > 0) THEN
        UPDATE CUSTOMERS SET
          FIRSTNAME=NEXT_CUSTOMER_FIRSTNAME
        WHERE ID=CUSTOMER_ID;
      END IF;
      IF (LENGTH(NEXT_CUSTOMER_MIDDLENAME) > 0) THEN
        UPDATE CUSTOMERS SET
          MIDDLENAME=NEXT_CUSTOMER_MIDDLENAME
        WHERE ID=CUSTOMER_ID;
      END IF;
      IF (LENGTH(CUSTOMER_REGISTER_ADDERESS) > 0) THEN
        UPDATE CUSTOMERS SET
            REGISTER_ADDRESS=CUSTOMER_REGISTER_ADDERESS
          WHERE ID=CUSTOMER_ID;
      END IF;
      IF (LENGTH(COUNTRY) > 0) THEN
        CUSTOMER_CIT_COUNTRY_ID:=0;
        SELECT ID INTO CUSTOMER_CIT_COUNTRY_ID FROM COUNTRIES
          WHERE NAME=COUNTRY;
        IF (CUSTOMER_CIT_COUNTRY_ID=0) THEN
          RAISE INVALID_COUNTRY_NAME;
        END IF;
        UPDATE CUSTOMERS SET
          CITIZENSHIP_COUNTRY_ID=CUSTOMER_CIT_COUNTRY_ID
        WHERE ID=CUSTOMER_ID;
      END IF;
    EXCEPTION
      WHEN INVALID_COUNTRY_NAME THEN NULL;
      WHEN OTHERS THEN NULL;
    END;

  PROCEDURE DELETE_CUSTOMER(
    CUSTOMER_FIRSTNAME CUSTOMERS.FIRSTNAME%TYPE,
    CUSTOMER_MIDDLENAME CUSTOMERS.MIDDLENAME%TYPE,
    CUSTOMER_LASTNAME CUSTOMERS.LASTNAME%TYPE
  ) IS
    BEGIN
      DELETE FROM CUSTOMERS
        WHERE
          FIRSTNAME=CUSTOMER_FIRSTNAME AND
          LASTNAME=CUSTOMER_LASTNAME AND
          MIDDLENAME=CUSTOMER_MIDDLENAME;
    END;
END CRUD_OPS;