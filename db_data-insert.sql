INSERT INTO heat_pump (internal_designation, type)
VALUES
    ('HP-AW-001', 'Air-Water'),
    ('HP-GE-002', 'Geothermal'),
    ('HP-GW-003', 'Groundwater'),
    ('HP-A-004', 'Air'),
    ('HP-HY-005', 'Hybrid');

INSERT INTO production_line (designation)
VALUES 
    ('Line 1'),
    ('Line 2'),
    ('Line 3'),
    ('Line 4'),
    ('Line 5');

INSERT INTO heat_pump_production_line (heat_pump_id, production_line_id)
VALUES
    (1, 1),
    (3, 1),
    (5, 1),
    (3, 2),
    (5, 2),
    (3, 3),
    (4, 3),
    (4, 4),
    (1, 5),
    (2, 5),
    (3, 5),
    (4, 5);

INSERT INTO production_station (designation, production_line_id) VALUES
    ('Station 1-1', 1),
    ('Station 1-2', 1),
    ('Station 1-3', 1),
    ('Station 1-4', 1),
    ('Station 1-5', 1),
    ('Station 1-6', 1),
    ('Station 1-7', 1),
    
    ('Station 2-1', 2),
    ('Station 2-2', 2),
    ('Station 2-3', 2),
    ('Station 2-4', 2),
    ('Station 2-5', 2),
    ('Station 2-6', 2),
    ('Station 2-7', 2),
    
    ('Station 3-1', 3),
    ('Station 3-2', 3),
    ('Station 3-3', 3),
    ('Station 3-4', 3),
    ('Station 3-5', 3),
    ('Station 3-6', 3),
    ('Station 3-7', 3),
    
    ('Station 4-1', 4),
    ('Station 4-2', 4),
    ('Station 4-3', 4),
    ('Station 4-4', 4),
    ('Station 4-5', 4),
    ('Station 4-6', 4),
    ('Station 4-7', 4),
    
    ('Station 5-1', 5),
    ('Station 5-2', 5),
    ('Station 5-3', 5),
    ('Station 5-4', 5),
    ('Station 5-5', 5),
    ('Station 5-6', 5),
    ('Station 5-7', 5);

INSERT INTO customer (
    company_name, street, house_number, postal_code, city, country,
    contact_first_name, contact_last_name, contact_phone_number
) 
VALUES 
    ('Sample Company LLC', 'Main St.', '12', '10115', 'Berlin', 'Germany', 'Max', 'Mustermann', '01701234567'),
    ('TechSolutions AG', 'Industry St.', '3', '70173', 'Stuttgart', 'Germany', 'Laura', 'Schmidt', '01709876543'),
    ('GreenTech Innovations', 'Park St.', '45', '20095', 'Hamburg', 'Germany', 'John', 'Doe', '01707654321'),
    ('SmartEnergy LLC', 'Field St.', '23', '80331', 'Munich', 'Germany', 'Anna', 'Müller', '01706543210'),
    ('EcoPower Systems', 'Forest St.', '15', '90402', 'Nuremberg', 'Germany', 'Peter', 'Schneider', '01702345678'),
    ('SolarTech Industries', 'Berlin St.', '56', '10785', 'Berlin', 'Germany', 'Jana', 'Fischer', '01705678901'),
    ('WindTurbine Solutions', 'Linden St.', '77', '40210', 'Düsseldorf', 'Germany', 'Markus', 'Bauer', '01709876567'),
    ('FutureEnergy LLC', 'Station St.', '9', '50667', 'Cologne', 'Germany', 'Lena', 'Weber', '01703456789'),
    ('CleanEnergy Co.', 'School St.', '34', '30159', 'Hanover', 'Germany', 'Tom', 'Klein', '01708901234'),
    ('PowerTech LLC', 'Bridge St.', '10', '41061', 'Mönchengladbach', 'Germany', 'Sophie', 'Wagner', '01704567890'),
    ('BioEnergy Systems', 'Sun Way', '8', '67059', 'Kaiserslautern', 'Germany', 'Paul', 'Zimmermann', '01706123456');
