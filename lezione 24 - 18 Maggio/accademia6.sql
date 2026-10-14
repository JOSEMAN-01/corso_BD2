1. Quanti sono gli strutturati di ogni fascia?

SELECT posizione, count(id) as numero
FROM Persona
GROUP BY posizione

2. Quanti sono gli strutturati con stipendio ≥ 40000?

SELECT count(id) as numero
FROM Persona
WHERE stipendio>=40000

3. Quanti sono i progetti già finiti che superano il budget di 50000?

SELECT count(id) as numero
FROM Progetto
WHERE (fine is not null) AND budget>50000

4. Qual è la media, il massimo e il minimo delle ore delle attività relative al progetto ‘Pegasus’ ?

SELECT avg(attp.oredurata), max(attp.oredurata), min(attp.oredurata) 
FROM AttivitaProgetto attp, Progetto p
WHERE attp.progetto=p.id AND p.nome='Pegasus'

5. Quali sono le medie, i massimi e i minimi delle ore giornaliere dedicate al progetto ‘Pegasus’ da ogni singolo docente?

SELECT p.id, p.nome, p.cognome, avg(att.oreDurata), max(att.oreDurata), min(att.oreDurata)
FROM Persona p, AttivitaProgetto att, Progetto proj
WHERE att.persona=p.id AND att.progetto=proj.id AND proj.nome='Pegasus'
GROUP BY p.id, p.nome, p.cognome
ORDER BY p.id asc
--Correzione:
--ORDER BY p.id, p.nome, p.cognome

6. Qual è il numero totale di ore dedicate alla didattica da ogni docente?

SELECT p.id, p.nome, p.cognome, sum(attNP.oredurata)
FROM Persona p, AttivitaNonProgettuale attNP
WHERE attNP.tipo='Didattica' AND attNP.persona=p.id
GROUP BY p.id, p.nome, p.cognome

7. Qual è la media, il massimo e il minimo degli stipendi dei ricercatori?

SELECT avg(p.stipendio), max(p.stipendio), min(p.stipendio)
FROM Persona p
WHERE p.posizione='Ricercatore'


8. Quali sono le medie, i massimi e i minimi degli stipendi dei ricercatori, dei professori associati e dei professori ordinari?

SELECT p.posizione, avg(p.stipendio), min(p.stipendio), max(p.stipendio)
FROM Persona p
GROUP BY p.posizione

----------------------------------------------DIFFICILI

9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel quale ha lavorato?

SELECT proj.id, proj.nome, sum(attP.oredurata)
FROM Progetto proj, AttivitaProgetto attP, Persona p
WHERE attP.persona=p.id AND p.nome='Ginevra' AND p.cognome='Riva' AND attP.progetto=proj.id
GROUP BY proj.id, proj.nome


10. Qual è il nome dei progetti su cui lavorano più di due strutturati (persone)?

SELECT attP.progetto, proj.nome
FROM AttivitaProgetto attP, Progetto proj
WHERE attP.progetto=proj.id
GROUP BY attP.progetto, proj.nome
HAVING count(distinct attP.persona)>2


11. Quali sono i professori associati che hanno lavorato su più di un progetto?

SELECT p.id, p.nome, p.cognome
FROM Persona p, AttivitaProgetto attP
WHERE p.id=attP.persona AND p.posizione='Professore Associato'
GROUP BY p.id, p.nome
HAVING count(distinct attP.progetto)>1

/*
un altro modo

SELECT distinct pers.id, pers.nome, pers.cognome
FROM Persona pers, AttivitaProgetto a1, AttivitaProgetto a2
WHERE a1.persona=pers.id AND a2.persona=pers.id AND a1.progetto<>a2.progetto

*/
