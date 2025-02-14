-- Table: Heat Pumps
CREATE TABLE heat_pump (
    ID SERIAL PRIMARY KEY, 
    internal_name VARCHAR,
    type VARCHAR
);

-- Table: Production Lines
CREATE TABLE production_line (
    ID SERIAL PRIMARY KEY, 
    name VARCHAR
);

-- Table: Heat Pump - Production Line (Many-to-Many)
CREATE TABLE heat_pump_production_line (
    heat_pump_id INT, 
    production_line_id INT, 
    PRIMARY KEY (heat_pump_id, production_line_id),
    FOREIGN KEY (heat_pump_id) REFERENCES heat_pump(ID),
    FOREIGN KEY (production_line_id) REFERENCES production_line(ID)
);

-- Table: Production Stations
CREATE TABLE production_station (
    ID SERIAL PRIMARY KEY, 
    name VARCHAR,
    production_line_id INT, 
    FOREIGN KEY (production_line_id) REFERENCES production_line(ID)
);

-- Table: Customers
CREATE TABLE customer (
    ID SERIAL PRIMARY KEY, 
    company_name VARCHAR, 
    street VARCHAR, 
    house_number VARCHAR,
    postal_code VARCHAR, 
    city VARCHAR,
    country VARCHAR,
    contact_first_name VARCHAR,
    contact_last_name VARCHAR,
    contact_mobile_number VARCHAR
);

-- Table: Orders
CREATE TABLE order (
    ID SERIAL PRIMARY KEY, 
    customer_id INT, 
    order_date TIMESTAMP, 
    delivery_date TIMESTAMP, 
    status VARCHAR,
    FOREIGN KEY (customer_id) REFERENCES customer(ID)
);

-- Table: Order Batches
CREATE TABLE order_batches (
    ID SERIAL PRIMARY KEY, 
    order_id INT, 
    heat_pump_id INT, 
    production_line_id INT, 
    quantity INT, 
    production_start TIMESTAMP, 
    production_end TIMESTAMP, 
    FOREIGN KEY (order_id) REFERENCES order(ID), 
    FOREIGN KEY (heat_pump_id) REFERENCES heat_pump(ID), 
    FOREIGN KEY (production_line_id) REFERENCES production_line(ID)
);

-- Table: Alarm
CREATE TYPE warning_type AS ENUM ('Error', 'Warning');

CREATE TABLE alarm (
    ID SERIAL PRIMARY KEY, 
    start TIMESTAMP, 
    end TIMESTAMP, 
    name VARCHAR, 
    type warning_type, 
    station_id INT, 
    FOREIGN KEY (station_id) REFERENCES production_station(ID)
);

-- Table: Measurement Types
CREATE TABLE measurement_types (
    ID INT PRIMARY KEY,
    name VARCHAR UNIQUE
);

-- Table: Track & Trace Optional 
CREATE TABLE track_trace_optional (
    ID SERIAL PRIMARY KEY,
    measurement_id INT,
    value FLOAT,
    rejected BOOLEAN,
    recording_time TIMESTAMP,
    FOREIGN KEY (measurement_id) REFERENCES measurement_types(ID)
);

-- Table: Track & Trace
CREATE TABLE track_trace (
    ID SERIAL PRIMARY KEY,
    station_id INT,
    processing_start TIMESTAMP,
    processing_end TIMESTAMP,
    heat_pump_id INT,
    rejected BOOLEAN, -- TRUE = Rejected, FALSE = Not Rejected
    rejected_count INT,  
    track_trace_optional_id INT, 
    FOREIGN KEY (station_id) REFERENCES production_station(ID), 
    FOREIGN KEY (heat_pump_id) REFERENCES heat_pump(ID),
    FOREIGN KEY (track_trace_optional_id) REFERENCES track_trace_optional(ID)
);
