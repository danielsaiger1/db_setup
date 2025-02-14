SELECT 
    auftrag.ID AS auftrag_id, 
	kunde.firmenname AS kunde_name,
    auftrag.bestelldatum, 
    auftrag.lieferdatum 
FROM 
    auftrag
JOIN 
    kunde 
    ON auftrag.kunde_id = kunde.ID
ORDER BY 
    auftrag.bestelldatum;




SELECT 
    alarm.bezeichnung AS alarm_name, 
	fertigungsstation.bezeichnung AS station_name,
    alarm.start AS alarm_startzeit
FROM 
    alarm
JOIN 
    fertigungsstation 
    ON alarm.station_id = fertigungsstation.ID
ORDER BY 
    alarm.start;




SELECT 
    auftrag.ID AS auftrag_id, 
    auftrag.status, 
    kunde.firmenname AS kunde_name
FROM 
    auftrag
JOIN 
    kunde 
    ON auftrag.kunde_id = kunde.ID
ORDER BY 
    auftrag.status;




SELECT 
    kunde.firmenname AS kunde_name,
    SUM(auftrag_batches.anzahl) AS gesamt_produktionsmenge
FROM 
    auftrag_batches
JOIN 
    auftrag ON auftrag_batches.auftrag_id = auftrag.ID
JOIN 
    kunde ON auftrag.kunde_id = kunde.ID
GROUP BY 
    kunde.firmenname
ORDER BY 
    gesamt_produktionsmenge DESC;




SELECT 
    waermepumpe.typ AS waermepumpentyp,
    SUM(auftrag_batches.anzahl) AS gesamt_produzierte_menge
FROM 
    auftrag_batches
JOIN 
    waermepumpe ON auftrag_batches.waermepumpe_id = waermepumpe.ID
JOIN 
    auftrag ON auftrag_batches.auftrag_id = auftrag.ID
GROUP BY 
    waermepumpe.typ
ORDER BY 
    gesamt_produzierte_menge DESC;




SELECT 
    kunde.firmenname AS kunde_name,
    (SELECT SUM(anzahl) 
     FROM auftrag_batches 
     JOIN auftrag ON auftrag_batches.auftrag_id = auftrag.ID
     WHERE auftrag.kunde_id = kunde.ID) AS gesamt_anzahl_waermepumpen
FROM 
    kunde
WHERE 
    (SELECT SUM(anzahl) 
     FROM auftrag_batches 
     JOIN auftrag ON auftrag_batches.auftrag_id = auftrag.ID
     WHERE auftrag.kunde_id = kunde.ID) >= 20000
ORDER BY 
    gesamt_anzahl_waermepumpen DESC;




SELECT 
    fertigungslinie.bezeichnung AS linie_name,
    (SELECT SUM(anzahl_ausschuss) 
     FROM track_trace 
     JOIN fertigungsstation ON track_trace.station_id = fertigungsstation.ID 
     WHERE fertigungsstation.fertigungslinie_id = fertigungslinie.ID AND anzahl_ausschuss > 500) AS gesamt_ausschuss
FROM 
    fertigungslinie
WHERE 
    ID IN (
        SELECT fertigungslinie_id 
        FROM track_trace 
        JOIN fertigungsstation ON track_trace.station_id = fertigungsstation.ID 
        WHERE anzahl_ausschuss > 500
    )
ORDER BY 
    gesamt_ausschuss DESC;