CONNECT OrderUser/OrderUser@//localhost:1521/FREEPDB1;

CREATE OR REPLACE PACKAGE PKG_ORDERS AS
  PROCEDURE PROCESS(ORDER_XML IN CLOB);
  FUNCTION GET_ITEMS_ORDER(N_ORDER_ID INTEGER) RETURN SYS_REFCURSOR;
END PKG_ORDERS;
/
