-- Create Independent Dimension Tables
CREATE TABLE "sub_category"(
    "sub_category_id" SERIAL NOT NULL,
    "sub_category" VARCHAR(255) NOT NULL
);
ALTER TABLE "sub_category" ADD PRIMARY KEY("sub_category_id");

CREATE TABLE "segment"(
    "segment_id" SERIAL NOT NULL,
    "segment" VARCHAR(255) NOT NULL
);
ALTER TABLE "segment" ADD PRIMARY KEY("segment_id");

CREATE TABLE "product"(
    "product_id" VARCHAR(255) NOT NULL,
    "product_name" VARCHAR(255) NOT NULL
);
ALTER TABLE "product" ADD PRIMARY KEY("product_id");

CREATE TABLE "location"(
    "location_id" SERIAL NOT NULL,
    "postal_code" INTEGER,
    "city" VARCHAR(255),
    "state" VARCHAR(255),
    "country" VARCHAR(255),
    "region" VARCHAR(255)
);
ALTER TABLE "location" ADD PRIMARY KEY("location_id");

-- Create Dependent Dimension Tables
CREATE TABLE "category"(
    "category_id" SERIAL NOT NULL,
    "category" VARCHAR(255) NOT NULL,
    "sub_category_id" INTEGER NOT NULL
);
ALTER TABLE "category" ADD PRIMARY KEY("category_id");

CREATE TABLE "customer"(
    "customer_id" VARCHAR(255) NOT NULL,
    "customer_name" VARCHAR(255) NOT NULL,
    "segment_id" INTEGER NOT NULL
);
ALTER TABLE "customer" ADD PRIMARY KEY("customer_id");

-- Create Fact and Junction Tables
CREATE TABLE "orders"(
    "order_id" VARCHAR(255) NOT NULL,
    "sales" DOUBLE PRECISION NOT NULL,
    "quantity" BIGINT NOT NULL,
    "discount" DOUBLE PRECISION NOT NULL,
    "profit" DOUBLE PRECISION NOT NULL,
    "customer_id" VARCHAR(255) NOT NULL,
    "order_date" DATE NOT NULL,
    "ship_mode" VARCHAR(255) NOT NULL,
    "ship_date" DATE NOT NULL,
    "location_id" INTEGER NOT NULL
);
ALTER TABLE "orders" ADD PRIMARY KEY("order_id");

CREATE TABLE "product_to_category"(
    "product_id" VARCHAR(255) NOT NULL,
    "category_id" INTEGER NOT NULL,
    PRIMARY KEY ("product_id", "category_id")
);

CREATE TABLE "products_to_orders"(
    "order_id" VARCHAR(255) NOT NULL,
    "product_id" VARCHAR(255) NOT NULL,
    PRIMARY KEY ("order_id", "product_id")
);

-- Add all Foreign Key Constraints
ALTER TABLE "category" ADD CONSTRAINT "category_sub_category_id_fkey" FOREIGN KEY("sub_category_id") REFERENCES "sub_category"("sub_category_id");
ALTER TABLE "customer" ADD CONSTRAINT "customer_segment_id_fkey" FOREIGN KEY("segment_id") REFERENCES "segment"("segment_id");
ALTER TABLE "orders" ADD CONSTRAINT "orders_customer_id_fkey" FOREIGN KEY("customer_id") REFERENCES "customer"("customer_id");
ALTER TABLE "orders" ADD CONSTRAINT "orders_location_id_fkey" FOREIGN KEY("location_id") REFERENCES "location"("location_id");
ALTER TABLE "product_to_category" ADD CONSTRAINT "product_to_category_product_id_fkey" FOREIGN KEY("product_id") REFERENCES "product"("product_id");
ALTER TABLE "product_to_category" ADD CONSTRAINT "product_to_category_category_id_fkey" FOREIGN KEY("category_id") REFERENCES "category"("category_id");
ALTER TABLE "products_to_orders" ADD CONSTRAINT "products_to_orders_order_id_fkey" FOREIGN KEY("order_id") REFERENCES "orders"("order_id");
ALTER TABLE "products_to_orders" ADD CONSTRAINT "products_to_orders_product_id_fkey" FOREIGN KEY("product_id") REFERENCES "product"("product_id");
