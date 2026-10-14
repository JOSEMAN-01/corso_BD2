/*1. Quali sono le persone (id, nome e cognome) che hanno avuto assenze solo nei
giorni in cui non avevano alcuna attivitÃ (progettuali o non progettuali)?

ovvero, quali persone hanno fatto assenze solo nei giorni
senza attività incaricate

*/

SELECT distinct p.id, p.nome, p.cognome
FROM Persona p LEFT OUTER JOIN Assenza a ON p.id=a.persona
WHERE a.persona=NULL OR (a.giorno not in(
		SELECT ap.giorno
		FROM AttivitaProgetto ap
		WHERE p.id=ap.persona
	)
	AND a.giorno not in(
		SELECT anp.giorno
		FROM AttivitaNonProgettuale anp
		WHERE p.id=anp.persona
	))
ORDER BY p.id;

/*Correzione: La mia query restituisce una persona se almeno una delle sue righe (risultanti dalla LEFT JOIN) soddisfa i criteri del WHERE. Se una persona ha due assenze, una "buona" (in un giorno senza attività) e una "cattiva" (in un giorno con attività) verrà erroneamente inclusa nell'output!!*/

SELECT id, nome, cognome FROM Persona
EXCEPT
SELECT p.id, p.nome, p.cognome
FROM Persona p
JOIN Assenza a ON p.id = a.persona
WHERE a.giorno IN (SELECT giorno FROM AttivitaProgetto WHERE persona = p.id)
   OR a.giorno IN (SELECT giorno FROM AttivitaNonProgettuale WHERE persona = p.id)
ORDER BY id;

/***2. Quali sono le persone (id, nome e cognome) che non hanno mai partecipato ad alcun progetto durante la durata del progetto “Pegasus”?*/

WITH Data AS(
	SELECT inizio, fine
	FROM Progetto
	WHERE nome='Pegasus'
)

SELECT id, nome, cognome FROM Persona
EXCEPT
SELECT p.id, p.nome, p.cognome
FROM Persona p 
JOIN AttivitaProgetto ap ON p.id=ap.persona
CROSS JOIN Data D
WHERE   ap.giorno BETWEEN D.inizio AND D.fine
ORDER BY id

/*Osservazione: MINUS non esiste come operatore in POSTGRESQL, ma EXCEPT ha la stesssa funzionalità*/

/***3. Quali sono id, nome, cognome e stipendio dei ricercatori con stipendio maggiore
di tutti i professori (associati e ordinari)?*/

SELECT id,nome,cognome, stipendio, posizione
FROM Persona
WHERE posizione='Ricercatore' AND stipendio > (
	SELECT max(p1.stipendio)
	FROM Persona p1
	WHERE p1.posizione='Professore Associato'
	)
	AND
	stipendio >(
	SELECT max(p2.stipendio)
	FROM Persona p2
	WHERE p2.posizione='Professore Ordinario'
	);

/**4. Quali sono le persone che hanno lavorato su progetti con un budget superiore alla media dei budget di tutti i progetti?

Ambiguità: Tutti i progetti su cui ha lavorato o basta uno che sia sopra la media?

Interpretazione: Persone che hanno lavorato su almeno un progetto che ha budget sopra la media
*/

/**Versione 1**/
WITH ProgettiBudgetAlto AS(
	SELECT p1.id as proj_id
	FROM Progetto p1
	WHERE p1.budget>(
		SELECT avg(p2.budget)
		FROM Progetto p2
		)
	)

SELECT p.id, p.nome, p.cognome
FROM Persona p
WHERE EXISTS(
	SELECT 1
	FROM AttivitaProgetto ap
	CROSS JOIN ProgettiBudgetAlto proj
	WHERE p.id=ap.persona AND ap.progetto in (proj.proj_id)
	);
	
/**Versione 2**/
SELECT p.id, p.nome, p.cognome
FROM Persona p
WHERE EXISTS(
	SELECT 1
	FROM AttivitaProgetto ap
	WHERE p.id=ap.persona AND ap.progetto in (
		SELECT p1.id
		FROM Progetto p1
		WHERE p1.budget>(
			SELECT avg(p2.budget)
			FROM Progetto p2
			)
		)
	);
/**Correzione: Le versioni 1 e 2 funzionano ma sono inutilmente complicate*/

SELECT DISTINCT p.id, p.nome, p.cognome
FROM Persona p
JOIN AttivitaProgetto ap ON p.id = ap.persona
JOIN Progetto pr ON ap.progetto = pr.id
WHERE pr.budget > (SELECT avg(budget) FROM Progetto);


/**5. Quali sono i progetti con un budget inferiore alla media, ma con un numero complessivo di ore dedicate alle attività di ricerca sopra la media?**/

WITH MediaOreRicerca AS(
	SELECT avg(T.tot_ore_ricerca) as media_ore_ricerca
	FROM (
		SELECT sum(oreDurata) as tot_ore_ricerca
		FROM AttivitaProgetto
		WHERE tipo='Ricerca'
		GROUP BY progetto
		) T
	)

SELECT ap.progetto, sum(ap.oreDurata) as ore_ricerca
FROM Progetto p
JOIN AttivitaProgetto ap
ON p.id=ap.progetto
CROSS JOIN MediaOreRicerca M
WHERE ap.tipo='Ricerca e Sviluppo' AND budget<(
	SELECT avg(budget)
	FROM Progetto
	)
GROUP BY ap.progetto
HAVING sum(ap.oreDurata)> M.media_ore_ricerca

/*Correzione: 
In PostgreSQL, ogni colonna presente nella SELECT o nella clausola HAVING che non sia una funzione aggregata deve essere inclusa nella clausola GROUP BY
. Pertanto, la colonna M.media_ore_ricerca (derivante dal CROSS JOIN) deve apparire nel raggruppamento.*/

WITH MediaOreRicerca AS (
    SELECT avg(T.tot_ore_ricerca) as media_ore_ricerca
    FROM (
        SELECT sum(oreDurata) as tot_ore_ricerca
        FROM AttivitaProgetto
        WHERE tipo = 'Ricerca e Sviluppo' -- Corretto enum [1]
        GROUP BY progetto
    ) T
)
SELECT proj.id, proj.nome, sum(ap.oreDurata) as ore_ricerca
FROM Progetto proj
JOIN AttivitaProgetto ap ON proj.id = ap.progetto
CROSS JOIN MediaOreRicerca M
WHERE ap.tipo = 'Ricerca e Sviluppo' 
  AND proj.budget < (SELECT avg(budget) FROM Progetto)
GROUP BY proj.id, proj.nome, ap.progetto, M.media_ore_ricerca -- Inclusa colonna per standard SQL [2]
HAVING sum(ap.oreDurata) > M.media_ore_ricerca;
