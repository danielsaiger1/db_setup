-- Utilization of Production Lines
WITH time_interval AS (
    SELECT 
        '2024-12-01 00:00:00'::timestamp AS start_time,
        '2024-12-05 23:59:59'::timestamp AS end_time
),
used_time AS (
    SELECT 
        production_line_id,
        SUM(EXTRACT(EPOCH FROM LEAST(production_end, ti.end_time) - GREATEST(production_start, ti.start_time))) AS used_seconds
    FROM 
        order_batches, time_interval ti
    GROUP BY 
        production_line_id
)
SELECT 
    ut.production_line_id,
    ROUND((ut.used_seconds / EXTRACT(EPOCH FROM (ti.end_time - ti.start_time)) * 100), 2) AS utilization_percentage
FROM 
    used_time ut, time_interval ti;


-- Utilization of Production Stations
WITH time_interval AS (
    SELECT 
        '2024-12-02 08:00:00'::timestamp AS start_time,
        '2024-12-02 13:30:00'::timestamp AS end_time
),
used_time AS (
    SELECT 
        station_id,
        SUM(EXTRACT(EPOCH FROM LEAST(processing_end, ti.end_time) - GREATEST(processing_start, ti.start_time))) AS used_seconds
    FROM 
        track_trace, time_interval ti
    WHERE 
        processing_start < ti.end_time AND processing_end > ti.start_time
    GROUP BY 
        station_id
)
SELECT 
    ut.station_id,
    ROUND((ut.used_seconds / EXTRACT(EPOCH FROM (ti.end_time - ti.start_time)) * 100), 2) AS utilization_percentage
FROM 
    used_time ut, time_interval ti;


-- Statistical Metrics for Malfunctions
SELECT 
    station_id,
    COUNT(*) AS number_of_malfunctions,
    ROUND((SUM(EXTRACT(EPOCH FROM (end_time - start_time))) / 3600), 2) AS total_duration_hours,  -- Total duration of malfunctions in hours
    ROUND((AVG(EXTRACT(EPOCH FROM (end_time - start_time))) / 3600), 2) AS average_duration_hours,  -- Average duration of malfunctions in hours
    (PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY EXTRACT(EPOCH FROM (end_time - start_time))) / 3600)::decimal(8,2) AS q1_duration_hours,  -- 1st quartile
    (PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY EXTRACT(EPOCH FROM (end_time - start_time))) / 3600)::decimal(8,2) AS median_duration_hours,  -- Median
    (PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY EXTRACT(EPOCH FROM (end_time - start_time))) / 3600)::decimal(8,2) AS q3_duration_hours  -- 3rd quartile
FROM 
    alarm
WHERE 
    station_id IN (1, 14, 31) 
    AND start_time >= '2024-12-02'  
    AND end_time <= '2024-12-04' 
    AND type = 'Malfunction' 
GROUP BY 
    station_id
ORDER BY
    station_id;


-- Defective Parts per Order
SELECT 
    o.ID,
    ob.heat_pump_id,
    ob.production_line_id,
    ob.quantity,
    ob.production_start,
    ob.production_end,
    (ob.quantity - SUM(tt.defective_quantity)) AS number_of_good_parts,
    SUM(tt.defective_quantity) AS number_of_defective_parts
FROM
    orders o
JOIN
    order_batches ob ON o.ID = ob.order_id
JOIN
    track_trace tt ON ob.heat_pump_id = tt.heat_pump_id
GROUP BY
    o.ID,
    ob.heat_pump_id, ob.production_line_id, ob.quantity, ob.production_start, ob.production_end
ORDER BY
    o.ID ASC;


-- Evaluation of Measurement Values Responsible for Defective Parts
SELECT 
    tt.ID AS track_trace_id,
    tt.heat_pump_id,
    tt.station_id,
    tt.defective,
    tt.defective_quantity,
    tto.measurement_id,
    mt.name AS measurement_name,
    tto.value,
    tto.recorded_time
FROM 
    track_trace tt
JOIN 
    track_trace_optional tto ON tt.track_trace_optional_id = tto.ID
JOIN 
    measurement_types mt ON tto.measurement_id = mt.ID
WHERE 
    tto.defective = TRUE;
