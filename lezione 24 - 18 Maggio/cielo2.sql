1. Quante sono le compagnie che operano (sia in arrivo che in partenza) nei diversi aeroporti?

ovvero Per ogni aeroporto dire quante compagnie ne fanno uso

SELECT aer.codice, aer.nome, count(distinct ap.comp)
FROM Aeroporto aer, ArrPart ap
WHERE (aer.codice=ap.arrivo OR aer.codice=ap.partenza)
GROUP BY aer.codice, aer.nome


2. Quanti sono i voli che partono dall’aeroporto ‘HTR’ e hanno una durata di almeno 100 minuti?

SELECT count(*) as num_voli
FROM ArrPart ap, Aeroporto aer, Volo volo
WHERE ap.partenza=aer.codice AND ap.codice=volo.codice AND ap.comp=volo.comp AND aer.codice='HTR' AND volo.durataMinuti>=100 

--CORREZIONE: Non serviva la tabella Aeroporto
-- potevo usare ap.partenza='HTR'


3. Quanti sono gli aeroporti sui quali opera la compagnia ‘Apitalia’, per ogni nazione nella quale opera?


SELECT luogo.nazione as nazione, count(distinct aer.codice) as num_aeroporti
FROM Aeroporto aer, LuogoAeroporto luogo, ArrPart ap
WHERE luogo.aeroporto=aer.codice AND (aer.codice=ap.arrivo OR aer.codice=ap.partenza) AND ap.comp='Apitalia'
GROUP BY luogo.nazione



4. Qual è la media, il massimo e il minimo della durata dei voli effettuati dalla compagnia ‘MagicFly’ ?

SELECT avg(durataMinuti) as VoloDurataMedia, max(durataMinuti) as VoloDurataMassima, min(durataMinuti) as VoloDurataMinima
FROM Volo v
WHERE v.comp='MagicFly'

5. Qual è l’anno di fondazione della compagnia più vecchia che opera in ognuno degli aeroporti?

ovvero

Per ogni aeroporto, dire qual è la compagnia più vecchia che ne fa uso

SELECT aer.codice, aer.nome, min(comp.annoFondaz)
FROM Aeroporto aer, Compagnia comp, ArrPart ap1, ArrPart ap2
WHERE aer.codice=ap1.arrivo AND aer.codice=ap2.partenza AND (ap1.comp=comp.nome OR ap2.comp=comp.nome)
GROUP BY aer.codice, aer.nome

--CORREZIONE:
SELECT aer.codice, aer.nome, min(comp.annoFondaz)
FROM Aeroporto aer, Compagnia comp, ArrPart ap
WHERE (aer.codice=ap.arrivo OR aer.codice=ap.partenza) AND ap.comp=comp.nome
GROUP BY aer.codice, aer.nome



6. Quante sono le nazioni (diverse) raggiungibili da ogni nazione tramite uno o più voli?

ovvero Per ogni nazione dire quante altre nazioni sono raggiungibili da essa

SELECT luogo1.nazione as nazione, count(distinct luogo2.nazione)
FROM LuogoAeroporto luogo1, LuogoAeroporto luogo2, Aeroporto aer1, Aeroporto aer2, ArrPart ap
WHERE luogo1.aeroporto=aer1.codice AND luogo2.aeroporto=aer2.codice AND luogo1.nazione<>luogo2.nazione AND aer1.codice=ap.partenza AND aer2.codice=ap.arrivo
GROUP BY luogo1.nazione

7. Qual è la durata media dei voli che partono da ognuno degli aeroporti?

ovvero Per ogni aeroporto, dire la media della durata dei suoi voli in partenza

SELECT aer.codice, aer.nome, avg(volo.durataMinuti)
FROM Aeroporto aer, Volo volo, ArrPart ap
WHERE ap.codice=volo.codice AND ap.comp=volo.comp AND aer.codice=ap.partenza
GROUP BY aer.codice, aer.nome

8. Qual è la durata complessiva dei voli operati da ognuna delle compagnie fondate
a partire dal 1950?

Per ogni compagnia fondata dal 1950 (incluso), dire qual è il totale di minuti "in volo"

SELECT comp.nome, sum(volo.durataMinuti) as durata_tot
FROM Compagnia comp, Volo volo
WHERE comp.annoFondaz is not null AND (comp.annoFondaz)>=1950 AND comp.nome=volo.comp
GROUP BY comp.nome


9. Quali sono gli aeroporti nei quali operano esattamente due compagnie?

SELECT aer.codice, aer.nome
FROM Aeroporto aer, ArrPart ap
WHERE (aer.codice=ap.arrivo OR aer.codice=ap.partenza)
GROUP BY aer.codice, aer.nome
HAVING count(distinct ap.comp)=2

10. Quali sono le città con almeno due aeroporti?
11. Qual è il nome delle compagnie i cui voli hanno una durata media maggiore di 6
ore?
12. Qual è il nome delle compagnie i cui voli hanno tutti una durata maggiore di 100
minuti?
