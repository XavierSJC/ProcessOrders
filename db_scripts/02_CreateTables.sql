CONNECT OrderUser/OrderUser@//localhost:1521/FREEPDB1;

CREATE TABLE Orders (
    OrderId INTEGER GENERATED ALWAYS AS IDENTITY,
    CustomerName VARCHAR(255),
    OrderDate DATE,
    PRIMARY KEY (OrderId)
);

CREATE TABLE OrderItems (
    OrderItemId INTEGER,
    OrderId INTEGER,
    ProductName VARCHAR(255),
    Quantity INTEGER,
    Price DECIMAL,
    PRIMARY KEY (OrderItemId, OrderId),
    FOREIGN KEY (OrderId) REFERENCES Orders(OrderId),
    CONSTRAINT OrderItems_unique_item UNIQUE (OrderId, ProductName)
);

EXIT;