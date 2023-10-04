CREATE TABLE "sales_dept" (
"sp_id" SERIAL,
"first_name" VARCHAR(150),
"last_name" VARCHAR(150),
PRIMARY KEY ("sp_id")
)

insert into sales_dept (sp_id,first_name,last_name)
values (5648,'Ryan','Schales')

insert into sales_dept (sp_id,first_name,last_name)
values (5648,'Steve','Salesman')

CREATE TABLE "mechanic_dept" (
"m_id" SERIAL,
"first_name" VARCHAR(150),
"last_name" VARCHAR(150),
PRIMARY KEY ("m_id")
)

insert into mechanic_dept (m_id,first_name,last_name)
values
(1234,'Jennifer','Hardy'),
(1235,'Mike','Grease')


CREATE TABLE "customers_index" (
"cust_id" SERIAL,
"acquisition_date" DATE,
"first_name" VARCHAR(150),
"last_name" VARCHAR(150),
PRIMARY KEY ("cust_id")
);

insert into customers_index (cust_id,acquisition_date,first_name,last_name)
values
(0123,'2023-01-01','MAtthew','Roxso'),
(0124,'2023-01-01','Rianne','Scove')

CREATE TABLE "sales_transaction" (
"sales_invoice" SERIAL,
"sp_id" SERIAL,
"inventory_id" SERIAL,
"cust_id" SERIAL,
"sales_date" DATE,
PRIMARY KEY ("sales_invoice"),
CONSTRAINT "FK_sales_transaction.sp_id"
FOREIGN KEY ("sp_id")
REFERENCES "sales_dept"("sp_id"),
CONSTRAINT "FK_sales_transaction.cust_id"
FOREIGN KEY ("cust_id")
REFERENCES "customers_index"("cust_id")
);

insert into sales_transaction (sales_invoice,sp_id,inventory_id,cust_id,sales_date)
values

(13,5648,24,0123,'2023-01-02'),
(12,5648,25,0124,'2023-01-02')



CREATE TABLE "Inventory_index" (
"inventory_id" SERIAL,
"is_new" BOOLEAN,
PRIMARY KEY ("inventory_id")
);

insert into "Inventory_index" (inventory_id,is_new)
values 
(50,TRUE),
(51,FALSE)

CREATE TABLE "vehicle_history" (
"vehicle_id" SERIAL,
"inventory_id" SERIAL,
PRIMARY KEY ("vehicle_id")
);

insert into vehicle_history (vehicle_id,inventory_id)
values
(60,50),
(61,NULL)


CREATE TABLE "parts_inventory" (
"part_serial" SERIAL,
"qty" int,
"next_shipment_arrival_date" DATE,
PRIMARY KEY ("part_serial")
);

insert into parts_inventory (part_serial,qty,next_shipment_arrival_date)
values
(80,250,'2023-02-01'),
(81,600,'2023-02-01')



CREATE TABLE "service_shop" (
"service_ticket" SERIAL,
"cust_id" SERIAL,
"m_id" SERIAL,
"vehicle_id" SERIAL,
"service_reason" VARCHAR(250),
"part_serial" SERIAL,
"date_of_service" DATE,
PRIMARY KEY ("service_ticket"),
CONSTRAINT "FK_service_shop.cust_id"
FOREIGN KEY ("cust_id")
REFERENCES "customers_index"("cust_id"),
CONSTRAINT "FK_service_shop.m_id"
FOREIGN KEY ("m_id")
REFERENCES "mechanic_dept"("m_id"),
CONSTRAINT "FK_service_shop.vehicle_id"
FOREIGN KEY ("vehicle_id")
REFERENCES "vehicle_history"("vehicle_id")
);



alter table service_shop 
alter column part_serial drop not null


insert into service_shop (service_ticket,cust_id,m_id,vehicle_id,service_reason,part_serial,date_of_service)
values 
(2985,0123,1234,60,'Broken Windsheild Whipper',80,'2023-01-23'),
(2986,0124,1235,61,'Oil Change',NULL,'2023-01-24')

-- functions 

CREATE OR REPLACE FUNCTION currentPartsQuantity(part_serial int)
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
UPDATE parts_inventory
SET count()
WHERE parts_inventory.part_serial = service_shop.part_serial;
END;
$$;


CREATE OR REPLACE FUNCTION salesbyPerson(
sp_id integer
) RETURNS integer AS $$
DECLARE
sales integer;
BEGIN
SELECT COUNT(DISTINCT sales_transaction.sales_invoice)
INTO sales
FROM sales_dept
WHERE sales_dept.sp_id = sales_transaction.sp_id;

RETURN attribution_count;
END;
$$ LANGUAGE plpgsql;
