-- Orders with Customer Information
SELECT 
    orders.ID AS order_id, 
    customer.company_name AS customer_name,
    orders.order_date, 
    orders.delivery_date 
FROM 
    orders
JOIN 
    customer 
    ON orders.customer_id = customer.ID
ORDER BY 
    orders.order_date;


-- Alarms with Associated Production Stations
SELECT 
    alarm.name AS alarm_name, 
    production_station.name AS station_name,
    alarm.start_time AS alarm_start_time
FROM 
    alarm
JOIN 
    production_station 
    ON alarm.station_id = production_station.ID
ORDER BY 
    alarm.start_time;


-- Orders by Status
SELECT 
    orders.ID AS order_id, 
    orders.status, 
    customer.company_name AS customer_name
FROM 
    orders
JOIN 
    customer 
    ON orders.customer_id = customer.ID
ORDER BY 
    orders.status;


-- Total Production Quantity per Customer
SELECT 
    customer.company_name AS customer_name,
    SUM(order_batches.quantity) AS total_production_quantity
FROM 
    order_batches
JOIN 
    orders ON order_batches.order_id = orders.ID
JOIN 
    customer ON orders.customer_id = customer.ID
GROUP BY 
    customer.company_name
ORDER BY 
    total_production_quantity DESC;


-- Total Produced Quantity per Heat Pump Type
SELECT 
    heat_pump.type AS heat_pump_type,
    SUM(order_batches.quantity) AS total_produced_quantity
FROM 
    order_batches
JOIN 
    heat_pump ON order_batches.heat_pump_id = heat_pump.ID
JOIN 
    orders ON order_batches.order_id = orders.ID
GROUP BY 
    heat_pump.type
ORDER BY 
    total_produced_quantity DESC;


-- Customers with Total Heat Pump Orders ≥ 20,000
SELECT 
    customer.company_name AS customer_name,
    (SELECT SUM(quantity) 
     FROM order_batches 
     JOIN orders ON order_batches.order_id = orders.ID
     WHERE orders.customer_id = customer.ID) AS total_heat_pump_quantity
FROM 
    customer
WHERE 
    (SELECT SUM(quantity) 
     FROM order_batches 
     JOIN orders ON order_batches.order_id = orders.ID
     WHERE orders.customer_id = customer.ID) >= 20000
ORDER BY 
    total_heat_pump_quantity DESC;


-- Production Lines with High Defect Count
SELECT 
    production_line.name AS line_name,
    (SELECT SUM(defective_quantity) 
     FROM track_trace 
     JOIN production_station ON track_trace.station_id = production_station.ID 
     WHERE production_station.production_line_id = production_line.ID AND defective_quantity > 500) AS total_defects
FROM 
    production_line
WHERE 
    ID IN (
        SELECT production_line_id 
        FROM track_trace 
        JOIN production_station ON track_trace.station_id = production_station.ID 
        WHERE defective_quantity > 500
    )
ORDER BY 
    total_defects DESC;
