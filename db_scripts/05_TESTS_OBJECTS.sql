CONNECT OrderUser/OrderUser@//localhost:1521/FREEPDB1;

CREATE TABLE OrderTests (
    Description VARCHAR(255),
    Xml CLOB
);

INSERT INTO OrderTests
VALUES ('RAISE EXCEPTION - Invalid Quantity in item',
'<Order>
    <CustomerName>John Doe</CustomerName>
    <OrderDate>2024-08-19</OrderDate>
    <Items>
        <Item>
            <ProductName>Product A</ProductName>
            <Quantity>z</Quantity>
            <Price>19.99</Price>
        </Item>
        <Item>
            <ProductName>Product B</ProductName>
            <Quantity>1</Quantity>
            <Price>9.99</Price>
        </Item>
    </Items>
</Order>');

INSERT INTO OrderTests
VALUES ('RAISE EXCEPTION - Double item',
'<Order>
    <CustomerName>John Doe</CustomerName>
    <OrderDate>2024-08-19</OrderDate>
    <Items>
        <Item>
            <ProductName>Product A</ProductName>
            <Quantity>5</Quantity>
            <Price>19.99</Price>
        </Item>
        <Item>
            <ProductName>Product A</ProductName>
            <Quantity>1</Quantity>
            <Price>9.99</Price>
        </Item>
    </Items>
</Order>');

INSERT INTO OrderTests
VALUES ('RAISE EXCEPTION - Invalid quantity',
'<Order>
    <CustomerName>John Doe</CustomerName>
    <OrderDate>2024-08-19</OrderDate>
    <Items>
        <Item>
            <ProductName>Product A</ProductName>
            <Quantity>-5</Quantity>
            <Price>19.99</Price>
        </Item>
        <Item>
            <ProductName>Product B</ProductName>
            <Quantity>1</Quantity>
            <Price>9.99</Price>
        </Item>
    </Items>
</Order>');

INSERT INTO OrderTests
VALUES ('RAISE EXCEPTION - Order without items',
'<Order>
    <CustomerName>John Doe</CustomerName>
    <OrderDate>2024-08-19</OrderDate>
    <Items>
    </Items>
</Order>');

INSERT INTO OrderTests
VALUES ('Valid order with 2 items',
'<Order>
    <CustomerName>John Doe</CustomerName>
    <OrderDate>2024-08-19</OrderDate>
    <Items>
        <Item>
            <ProductName>Product A</ProductName>
            <Quantity>5</Quantity>
            <Price>19.99</Price>
        </Item>
        <Item>
            <ProductName>Product B</ProductName>
            <Quantity>1</Quantity>
            <Price>9.99</Price>
        </Item>
    </Items>
</Order>');

COMMIT;
EXIT;