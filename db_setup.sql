-- Tabelle: Waermepumpen
CREATE TABLE waermepumpe (
    ID SERIAL PRIMARY KEY, 
    interne_bezeichnung VARCHAR,
    typ VARCHAR
);

-- Tabelle: Fertigungslinien
CREATE TABLE fertigungslinie (
    ID SERIAL PRIMARY KEY, 
    bezeichnung VARCHAR
);

-- Tabelle: Waermepumpe_Fertigungslinie
CREATE TABLE waermepumpe_fertigungslinie (
    waermepumpe_id INT, 
    fertigungslinie_id INT, 
    PRIMARY KEY (waermepumpe_id, fertigungslinie_id),
    FOREIGN KEY (waermepumpe_id) REFERENCES waermepumpe(ID),
    FOREIGN KEY (fertigungslinie_id) REFERENCES fertigungslinie(ID)
);


-- Tabelle: Fertigungsstationen
CREATE TABLE fertigungsstation (
    ID SERIAL PRIMARY KEY, 
    bezeichnung VARCHAR,
    fertigungslinie_id INT, 
    FOREIGN KEY (fertigungslinie_id) REFERENCES fertigungslinie(ID)
);

-- Tabelle: Kunden
CREATE TABLE kunde (
    ID SERIAL PRIMARY KEY, 
    firmenname VARCHAR, 
    strasse VARCHAR, 
    hausnummer VARCHAR,
    postleitzahl VARCHAR, 
    stadt VARCHAR,
    land VARCHAR,
    ansprechpartner_vorname VARCHAR,
    ansprechpartner_nachname VARCHAR,
    ansprechpartner_handynummer VARCHAR
);

-- Tabelle: Auftraege
CREATE TABLE auftrag (
    ID SERIAL PRIMARY KEY, 
    kunde_id INT, 
    bestelldatum TIMESTAMP, 
    lieferdatum TIMESTAMP, 
    status VARCHAR,
    FOREIGN KEY (kunde_id) REFERENCES kunde(ID)
);

-- Tabelle: Auftragsbatches
CREATE TABLE auftrag_batches (
    ID SERIAL PRIMARY KEY, 
    auftrag_id INT, 
    waermepumpe_id INT, 
    fertigungslinie_id INT, 
    anzahl INT, 
    produktion_start TIMESTAMP, 
    produktion_ende TIMESTAMP, 
    FOREIGN KEY (auftrag_id) REFERENCES auftrag(ID), 
    FOREIGN KEY (waermepumpe_id) REFERENCES waermepumpe(ID), 
    FOREIGN KEY (fertigungslinie_id) REFERENCES fertigungslinie(ID)
);

-- Tabelle: Alarm
CREATE TYPE warnung_typ AS ENUM ('Störung', 'Warnung');

CREATE TABLE alarm (
    ID SERIAL PRIMARY KEY, 
    start TIMESTAMP, 
    ende TIMESTAMP, 
    bezeichnung VARCHAR, 
    typ warnung_typ, 
    station_id INT, 
    FOREIGN KEY (station_id) REFERENCES fertigungsstation(ID)
);

-- Tabelle: messwert_typen
CREATE TABLE messwert_typen (
    ID INT PRIMARY KEY,
    bezeichnung VARCHAR UNIQUE
);

-- Tabelle: track_trace_optional 
CREATE TABLE track_trace_optional (
    ID SERIAL PRIMARY KEY,
    messwert_id INT,
    wert FLOAT,
    ausschuss BOOLEAN,
    zeit_aufzeichnung TIMESTAMP,
    FOREIGN KEY (messwert_id) REFERENCES messwert_typen(ID)
);

-- Tabelle: track_trace
CREATE TABLE track_trace (
    ID SERIAL PRIMARY KEY,
    station_id INT,
    bearbeitungsstart TIMESTAMP,
    bearbeitungsende TIMESTAMP,
    waermepumpe_id INT,
    ausschuss BOOLEAN, -- TRUE = Ausschuss, FALSE = Kein Ausschuss
    anzahl_ausschuss INT,  
    track_trace_optional_id INT, 
    FOREIGN KEY (station_id) REFERENCES fertigungsstation(ID), 
    FOREIGN KEY (waermepumpe_id) REFERENCES waermepumpe(ID),
    FOREIGN KEY (track_trace_optional_id) REFERENCES track_trace_optional(ID)
); 


