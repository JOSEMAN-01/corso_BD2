1 ) Q u a l i s o n o i cognomi d i s t i n t i d i t u t t i
 gli  strutturati ?
 
SELECT distinct cognome
FROM Persona

2)

SELECT nome,cognome
FROM Persona
WHERE posizione='Ricercatore';

3)

SELECT distinct nome,cognome
FROM Persona
WHERE posizione='Professore Associato' AND cognome like 'V%';

4)

SELECT id,nome,cognome
FROM Persona
WHERE (posizione='Professore Associato' OR posizione='Professore Ordinario') AND cognome like 'V%';

5)

SELECT *
FROM Progetto
WHERE fine<current_date

6)

SELECT id,nome
FROM Progetto
ORDER BY inizio asc;

8)

SELECT distinct a.tipo
FROM Assenza a, Persona p
WHERE a.persona=p.id

9)

SELECT distinct att.tipo
FROM AttivitaProgetto att, Persona p
WHERE att.persona=p.id

10)
	

