CREATE TABLE "Orders"(
    "Order_ID" VARCHAR(255) NOT NULL,
    "Sales" DOUBLE PRECISION NOT NULL,
    "Quantity" BIGINT NOT NULL,
    "Discount" DOUBLE PRECISION NOT NULL,
    "Profit" DOUBLE PRECISION NOT NULL,
    "Customer_ID" VARCHAR(255) NOT NULL,
    "Order_Date" DATE NOT NULL,
    "Ship_Mode" VARCHAR(255) NOT NULL,
    "Ship_Date" DATE NOT NULL,
    "Order_Code" VARCHAR(255) NOT NULL,
    "Country_ID" INTEGER NOT NULL
);
ALTER TABLE
    "Orders" ADD PRIMARY KEY("Order_ID");
CREATE TABLE "Customer"(
    "Customer_ID" VARCHAR(255) NOT NULL,
    "Customer_Name" VARCHAR(255) NOT NULL,
    "Segment" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Customer" ADD PRIMARY KEY("Customer_ID");
CREATE TABLE "Product"(
    "Product_ID" VARCHAR(255) NOT NULL,
    "Product_Name" VARCHAR(255) NOT NULL,
    "Category_ID" INTEGER NOT NULL
);
ALTER TABLE
    "Product" ADD PRIMARY KEY("Product_ID");
CREATE TABLE "Country"(
    "Country_ID" INTEGER NOT NULL,
    "Region_ID" INTEGER NOT NULL,
    "Country" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Country" ADD PRIMARY KEY("Country_ID");
CREATE TABLE "Category"(
    "Category_ID" INTEGER NOT NULL,
    "Category" VARCHAR(255) NOT NULL,
    "Sub_Category" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Category" ADD PRIMARY KEY("Category_ID");
CREATE TABLE "Region"(
    "Region_ID" INTEGER NOT NULL,
    "Region" VARCHAR(255) NOT NULL,
    "State_ID" INTEGER NOT NULL
);
ALTER TABLE
    "Region" ADD PRIMARY KEY("Region_ID");
CREATE TABLE "State"(
    "State_ID" INTEGER NOT NULL,
    "State" VARCHAR(255) NOT NULL,
    "City_ID" INTEGER NOT NULL
);
ALTER TABLE
    "State" ADD PRIMARY KEY("State_ID");
CREATE TABLE "City"(
    "City_ID" INTEGER NOT NULL,
    "City" VARCHAR(255) NOT NULL,
    "Postal_Code_ID" INTEGER NOT NULL
);
ALTER TABLE
    "City" ADD PRIMARY KEY("City_ID");
CREATE TABLE "Postal_Code"(
    "Postal_Code_ID" INTEGER NOT NULL,
    "Postal_Code" INTEGER NOT NULL
);
ALTER TABLE
    "Postal_Code" ADD PRIMARY KEY("Postal_Code_ID");
CREATE TABLE "Products_Orders"(
    "Row_ID" INTEGER NOT NULL,
    "Product_ID" VARCHAR(255) NOT NULL,
    "Order_ID" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "Products_Orders" ADD PRIMARY KEY("Row_ID");
ALTER TABLE
    "Product" ADD CONSTRAINT "product_category_id_foreign" FOREIGN KEY("Category_ID") REFERENCES "Category"("Category_ID");
ALTER TABLE
    "Region" ADD CONSTRAINT "region_state_id_foreign" FOREIGN KEY("State_ID") REFERENCES "State"("State_ID");
ALTER TABLE
    "Products_Orders" ADD CONSTRAINT "products_orders_product_id_foreign" FOREIGN KEY("Product_ID") REFERENCES "Product"("Product_ID");
ALTER TABLE
    "City" ADD CONSTRAINT "city_postal_code_id_foreign" FOREIGN KEY("Postal_Code_ID") REFERENCES "Postal_Code"("Postal_Code_ID");
ALTER TABLE
    "State" ADD CONSTRAINT "state_city_id_foreign" FOREIGN KEY("City_ID") REFERENCES "City"("City_ID");
ALTER TABLE
    "Products_Orders" ADD CONSTRAINT "products_orders_order_id_foreign" FOREIGN KEY("Order_ID") REFERENCES "Orders"("Order_ID");
ALTER TABLE
    "Country" ADD CONSTRAINT "country_region_id_foreign" FOREIGN KEY("Region_ID") REFERENCES "Region"("Region_ID");
ALTER TABLE
    "Orders" ADD CONSTRAINT "orders_country_id_foreign" FOREIGN KEY("Country_ID") REFERENCES "Country"("Country_ID");
ALTER TABLE
    "Orders" ADD CONSTRAINT "orders_customer_id_foreign" FOREIGN KEY("Customer_ID") REFERENCES "Customer"("Customer_ID");