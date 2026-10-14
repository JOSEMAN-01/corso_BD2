1)
SELECT wp.id,wp.nome,wp.inizio,wp.fine
FROM WP wp, Progetto p
WHERE wp.progetto=p.id AND p.nome='Pegasus';

2)

SELECT distinct p.id,p.nome,p.cognome,p.posizione
FROM Persona p, AttivitaProgetto att, Progetto proj
WHERE att.persona=p.id AND att.progetto=proj.id AND proj.nome='Pegasus'
ORDER BY p.cognome desc;

3)

SELECT distinct p.id,p.nome,p.cognome,p.posizione
FROM Persona p, AttivitaProgetto att1, AttivitaProgetto att2, Progetto proj
WHERE att1.persona=att2.persona AND att1.persona=p.id AND att1.progetto=proj.id AND proj.nome='Pegasus' AND att1.id<>att2.id


SELECT *
FROM AttivitaProgetto att1, AttivitaProgetto att2
WHERE att1.persona=att2.persona

4)
SELECT distinct p.id, p.nome, p.cognome
FROM Assenza a, Persona p
WHERE a.persona=p.id AND p.posizione='Professore Ordinario' AND a.tipo='Malattia';

5)
 Q u a l i s o n o i l nome e i l cognome d e i P r o f e s s o r i O r d i n a r i
c h e hanno f a t t o p i u ’ d i una a s s e n z a p e r m a l a t t i a ?

SELECT distinct p.id, p.nome, p.cognome
FROM Assenza a1, Assenza a2, Persona p
WHERE a1.persona=a2.persona AND a1.persona=p.id AND 
		p.posizione='Professore Ordinario' AND a1.tipo='Malattia' AND a1.id<>a2.id;
		
		
8)

SELECT distinct p.id, p.nome, p.cognome
FROM Persona p, AttivitaProgetto attP, AttivitaNonProgettuale attNP
WHERE attP.persona=p.id AND attP.persona=attNP.persona AND attP.giorno=attNP.giorno

9)

SELECT distinct p.id, p.nome, p.cognome, attP.giorno as giorno, prj.nome as prj, attP.oredurata as h_prj, attNP.tipo as att_noprj, attNP.oredurata as h_noprj
FROM Persona p, AttivitaProgetto attP, AttivitaNonProgettuale attNP, Progetto prj
WHERE attP.persona=p.id AND attP.persona=attNP.persona AND attP.giorno=attNP.giorno AND attP.progetto=prj.id

10)
SELECT p.id, p.nome, p.cognome
FROM Assenza a, AttivitaProgetto attP, Persona p
WHERE a.persona=p.id AND attP.persona=p.id AND a.giorno=attP.giorno

11)
SELECT distinct wp1.nome
FROM WP wp1, WP wp2, Progetto p1, Progetto p2
WHERE wp1.nome=wp2.nome AND wp1.progetto=p1.id AND wp2.progetto=p2.id AND p1.nome<>p2.nome

