CONNECT OrderUser/OrderUser@//localhost:1521/FREEPDB1;

CREATE OR REPLACE PACKAGE BODY PKG_ORDERS AS

  PROCEDURE process(order_xml IN CLOB) IS
    new_order_id orders.OrderId%TYPE;
    customer_name orders.CUSTOMERNAME%TYPE;
    order_date ORDERS.ORDERDATE%TYPE;
    cod_item NUMBER := 1;
  BEGIN
    SET TRANSACTION NAME 'INSERTING ORDER AND ITEMS';
    SELECT TRIM(UPPER(OrderData.CustomerName)),
           OrderData.OrderDate
    INTO  customer_name,
          order_date
    FROM XMLTABLE('/Order' 
                  PASSING XMLTYPE(order_xml)
                  COLUMNS
                    CustomerName PATH 'CustomerName',
                    OrderDate date PATH 'OrderDate') OrderData;

    INSERT INTO ORDERS (CUSTOMERNAME, ORDERDATE)
    VALUES (customer_name, order_date)
    RETURNING ORDERID INTO new_order_id;

    FOR item IN (
      SELECT new_order_id,
        TRIM(UPPER(items.ProductName)) as ProductName,
        items.Quantity,
        items.Price
      FROM XMLTABLE('/Order/Items/Item' 
                    PASSING XMLTYPE(order_xml)
                    COLUMNS
                      ProductName PATH 'ProductName',
                      Quantity PATH 'Quantity',
                      Price PATH 'Price') items

    ) LOOP
      --Validacao dos itens, como quantidade negativa, nome invalidao, etc.
      IF item.Quantity < 1 THEN
        raise_application_error( -20001, 'Item ' || item.ProductName ||' with quantity less than 1: ' || item.Quantity);
      END IF;
      IF LENGTH(item.ProductName) = 0 THEN
        raise_application_error( -20003, 'Order with blank name item');
      END IF;

      INSERT INTO ORDERITEMS (ORDERID, ORDERITEMID, PRODUCTNAME, QUANTITY, PRICE)
      VALUES (new_order_id, cod_item, item.ProductName, item.Quantity, item.price);
      
      cod_item := cod_item + 1;
      
    END LOOP;

    IF cod_item - 1 = 0 THEN
      raise_application_error( -20002, 'Order has no items');
    END IF;
    
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      raise_application_error(-20004, 'Order refused: ' || SQLERRM);
  END process;

  FUNCTION get_items_order(n_order_id INTEGER) RETURN SYS_REFCURSOR IS
    RF_CURSOR SYS_REFCURSOR;
  BEGIN
    OPEN RF_CURSOR FOR
      SELECT *
      FROM ORDERITEMS
      WHERE ORDERID = n_order_id;

    RETURN RF_CURSOR;
  END get_items_order;

END PKG_ORDERS;
/
