CONNECT OrderUser/OrderUser@//localhost:1521/FREEPDB1;

CREATE OR REPLACE PROCEDURE TEST_PROCESS AS 
    C_ITEMS_ORDER SYS_REFCURSOR;
    R_ITEMS_ORDERS ORDERITEMS%ROWTYPE;
BEGIN
    -- Execute the test files
    FOR TEST IN (   SELECT *
                    FROM ORDERTESTS)
    LOOP 
        BEGIN 
            DBMS_OUTPUT.PUT_LINE('=========================================');
            DBMS_OUTPUT.PUT_LINE('Testing: ' || TEST.DESCRIPTION);
            PKG_ORDERS.PROCESS(TEST.XML);
        EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
        END;
    END LOOP;

    --Return items
    DBMS_OUTPUT.PUT_LINE('=========================================');
    DBMS_OUTPUT.PUT_LINE('=========================================');
    DBMS_OUTPUT.PUT_LINE('Returning items from OrderId 5:');
    C_ITEMS_ORDER := PKG_ORDERS.GET_ITEMS_ORDER(5);
    LOOP 
        FETCH C_ITEMS_ORDER INTO R_ITEMS_ORDERS;
        EXIT WHEN C_ITEMS_ORDER%notfound;
        DBMS_OUTPUT.PUT_LINE('Product: ' || R_ITEMS_ORDERS.PRODUCTNAME);
        DBMS_OUTPUT.PUT_LINE('Quantity: ' || R_ITEMS_ORDERS.QUANTITY);
        DBMS_OUTPUT.PUT_LINE('Price: ' || R_ITEMS_ORDERS.PRICE);
        DBMS_OUTPUT.PUT_LINE('=========================================');
    END LOOP;
    CLOSE C_ITEMS_ORDER;
END;
/
