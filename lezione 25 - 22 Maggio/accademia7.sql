/*1. Qual è media e deviazione standard degli stipendi per ogni categoria di strutturati?
*/
SELECT posizione, avg(stipendio), stddev(stipendio)
FROM Persona
GROUP BY posizione

/*2. Quali sono i ricercatori (tutti gli attributi) con uno stipendio superiore alla media
della loro categoria?
*/

WITH 
Data AS(
	SELECT avg(stipendio) as stipendio_medio_ricerc
	FROM Persona
	WHERE posizione='Ricercatore'
	)

SELECT p.*
FROM Persona p CROSS JOIN Data D
WHERE posizione='Ricercatore' AND p.stipendio>D.stipendio_medio_ricerc


/*Osservazione: 
Se avessi calcolato la media dentro la seconda WHERE ... poiché la sottoquery è non correlata (non dipende dai valori della query esterna), quasi tutti i database moderni la calcolano una sola volta all'inizio dell'esecuzione e usano il risultato come costante. Non c'è quindi una perdita di performance rispetto alla tua versione.
*/

/*3. Per ogni categoria di strutturati quante sono le persone con uno stipendio che
differisce di al massimo una deviazione standard dalla media della loro categoria?
*/

WITH
Data AS(
	SELECT posizione, avg(stipendio) as media_stipendio_cat, stddev(stipendio) as stddev_stipendio_cat
	FROM Persona
	GROUP BY posizione
	)

SELECT posizione, count(id) as persone_stipendio_entro_stddev
FROM Persona JOIN Data D ON posizione=D.posizione
WHERE abs(stipendio-D.media_stipendio_cat)<=D.stddev_stipendio_cat
GROUP BY posizione


/*4. Chi sono gli strutturati che hanno lavorato almeno 20 ore complessive in attività
progettuali? Restituire tutti i loro dati e il numero di ore lavorate.
*/

SELECT p.*, sum(ap.oreDurata) as ore_lavorate
FROM Persona p JOIN AttivitaProgetto ap ON p.id=ap.persona
GROUP BY p.id
HAVING sum(ap.oreDurata)>=20;


/*5. Quali sono i progetti la cui durata è superiore alla media delle durate di tutti i
progetti? Restituire nome dei progetti e loro durata in giorni.*/

SELECT id, nome, (fine-inizio) as durata_giorni
FROM Progetto
WHERE (fine-inizio)>(
			SELECT avg(fine-inizio)
			FROM Progetto
			);
/*Fare la differenza di 2 date restituisce la loro differenza in GIORNI*/


/*6. Quali sono i progetti terminati in data odierna che hanno avuto attività di tipo
“Dimostrazione”? Restituire nome di ogni progetto e il numero complessivo delle ore dedicate a tali attività nel progetto.

ovvero Restituire il nome ed il numero di ore (almeno 1) dedicate  a "Dimostrazione" di tutti i progetti finiti oggi

Ambiguità: "Terminati in data odierna" cioé tutti i progetti completati fino adesso?
*/

SELECT p.id, p.nome, sum(ap.oreDurata) as ore_dimostrazione
FROM Progetto p JOIN AttivitaProgetto ap ON p.id=ap.progetto
WHERE ap.tipo='Dimostrazione'
GROUP BY p.id, p.nome
HAVING sum(ap.oreDurata)>0 AND p.fine<=CURRENT_DATE

/*Correzione IA: Potevo spostare la condizione "p.fine<=CURRENT_DATE" dentro WHERE*/


/*7. Quali sono i professori ordinari che hanno fatto più assenze per malattia del numero di assenze medio per malattia dei professori associati? Restituire id, nome e
cognome del professore e il numero di giorni di assenza per malattia.*/

WITH 
MediaAssenzeMalattiaAssociati AS(
	SELECT avg(T.giorni_malattia) as media
	FROM (
		SELECT p.id, count(*) as giorni_malattia
		FROM Persona p JOIN Assenza a ON p.id=a.persona
		WHERE p.posizione='Professore Associato' AND a.tipo='Malattia'
		GROUP BY p.id		
		) T
	)
	

SELECT profOrd.id, profOrd.nome, profOrd.cognome, count(*) as giorni_malattia
FROM Persona profOrd JOIN Assenza a ON profOrd.id=a.persona CROSS JOIN MediaAssenzeMalattiaAssociati M
WHERE profOrd.posizione='Professore Ordinario' AND a.tipo='Malattia'
GROUP BY profOrd.id, profOrd.nome, profOrd.cognome, M.media
HAVING count(*)>M.media

/*Osservazione: Non posso usare M.media se NON è inclusodentro GROUP BY*/

