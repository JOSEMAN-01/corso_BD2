/*1. Qual è la durata media, per ogni compagnia, dei voli che partono da un aeroporto
situato in Italia?

ovvero Per ogni compagnia (che ha almeno 1 volo dall Italia) dire la durata media dei suoi voli dall Italia
*/
--
SELECT comp.nome, avg(volo.durataMinuti)
FROM ArrPart ap, Volo volo, LuogoAeroporto luogo, Compagnia comp
WHERE comp.nome=ap.comp AND ap.codice=volo.codice AND ap.comp=volo.comp AND ap.partenza=luogo.aeroporto AND luogo.nazione='Italy'
GROUP BY comp.nome
--- Non saprei come implementarlo in altro modo
-- CORREZIONE IA: In realtà non mi serve la tabella Compagnia, posso usare volo.comp

2. Quali sono le compagnie che operano voli con durata media maggiore della durata
media di tutti i voli?

ovvero Quali compagnie hanno almeno 1 volo di una durata sopra la media (generale)

WITH 
DurataMedia AS(
	SELECT avg(durataMinuti) as media
	FROM Volo
)

SELECT comp.nome
FROM Compagnia comp
WHERE EXISTS ( 
	SELECT 1
	FROM Volo volo, DurataMedia media
	WHERE comp.nome=volo.comp AND volo.durataMinuti>media.media
	)

-- Ho capito male la domanda
Quali compagnie hanno una durata media dei suoi voli che va sopra la media generale


WITH --Attenzione alla sintassi di WITH
DurataMedia AS(
	SELECT avg(durataMinuti) as media
	FROM Volo
),--virgola
CompDurataMediaVolo AS(
	SELECT comp.nome, avg(volo.durataMinuti) as durataMediaVolo
	FROM Volo volo, Compagnia comp
	WHERE volo.comp=comp.nome
	GROUP BY comp.nome
	-- potevo usare HAVING durataMediaVolo>media??
)--niente virgola

SELECT comp.nome, comp.durataMediaVolo
FROM CompDurataMediaVolo comp, DurataMedia media
WHERE comp.durataMediaVolo>media.media;

3. Quali sono le città dove il numero totale di voli in arrivo è maggiore del numero medio dei voli in arrivo per ogni città?

ovvero quali sono le città dove ci sono più voli in arrivo (rispetto alla media)

WITH

/*Notare la LEFT JOIN, che mi permette di contare
considerare le città con 0 voli in arrivo*/
TotVoliInArrivoPerCitta AS(
	SELECT luogo.citta as citta, count(ap.arrivo) as tot_voli_arrivo
	FROM LuogoAeroporto luogo LEFT JOIN ArrPart ap ON ap.arrivo=luogo.aeroporto
	GROUP BY luogo.citta
	),

MediaVoliInArrivo AS(
	SELECT avg(totVA.tot_voli_arrivo) as media_voli_arrivo
	FROM TotVoliInArrivoPerCitta totVA
	)

SELECT  T.citta as citta, T.tot_voli_arrivo as tot_voli_arrivo
FROM TotVoliInArrivoPerCitta T, MediaVoliInArrivo M
WHERE T.tot_voli_arrivo>M.media_voli_arrivo
	


/*4. Quali sono le compagnie aeree che hanno voli in partenza da aeroporti in Italia con
una durata media inferiore alla durata media di tutti i voli in partenza da aeroporti
in Italia?*/

-- Nota: L'output mostrato nel pdf pare sbagliato

WITH

DurataMediaVoliDaItaliaPerComp AS(
	SELECT volo.comp as compagnia, avg(volo.durataMinuti) as durataMediaVoloDiComp
	FROM Volo volo, ArrPart ap, LuogoAeroporto luogo
	WHERE volo.codice=ap.codice AND volo.comp=ap.comp AND ap.partenza=luogo.aeroporto AND luogo.nazione='Italy'
	GROUP BY volo.comp
	),

DurataMediaVoliDaItalia AS(
	SELECT avg(D.durataMediaVoloDiComp) as durataMedia
	FROM DurataMediaVoliDaItaliaPerComp D
	)

SELECT D.compagnia, D.durataMediaVoloDiComp
FROM DurataMediaVoliDaItaliaPerComp D, DurataMediaVoliDaItalia M
WHERE D.durataMediaVoloDiComp<M.durataMedia

/*MEDIE:: Apitalia=471 Caimanair=491.5*/

--CORREZIONE 4: Ho calcolato la media generale in maniera sbagliata

MediaVoliTotaliDaItalia AS (
    SELECT avg(volo.durataMinuti) as durataMediaGenerale
    FROM Volo volo, ArrPart ap, LuogoAeroporto luogo
    WHERE volo.codice=ap.codice AND volo.comp=ap.comp 
      AND ap.partenza=luogo.aeroporto AND luogo.nazione='Italy'
)


/*5. Quali sono le città i cui voli in arrivo hanno una durata media che differisce di più
di una deviazione standard dalla durata media di tutti i voli? Restituire città e durate medie dei voli in arrivo.
*/

WITH 
Data AS(
	SELECT stddev(durataMinuti) as dev_std_voli_arrivo, avg(durataMinuti) as durata_media_voli_arrivo
	FROM Volo
	)

SELECT luogo.citta as citta, avg(volo.durataMinuti) as durata_media_voli_arrivo
FROM LuogoAeroporto luogo JOIN ArrPart ap ON luogo.aeroporto=ap.arrivo JOIN Volo volo ON
ap.codice=volo.codice AND ap.comp=volo.comp CROSS JOIN Data D
GROUP BY luogo.citta
HAVING avg(volo.durataMinuti)- D.durata_media_voli_arrivo > D.dev_std_voli_arrivo

/*Correzione 5
1: Sto calcolando solo le deviazioni "positive" quando dovrei controllare anche quelle negative -> Soluzione: usare la funzione abs()

2: Having NON acceta colonne che non compaiono in GROUP BY
*/

WITH Data AS (
    -- Calcola le statistiche globali su tutti i voli 
    SELECT stddev(durataMinuti) as dev_std_globale, 
           avg(durataMinuti) as media_globale
    FROM Volo
)

SELECT 
    luogo.citta, 
    avg(volo.durataMinuti) as durata_media_arrivi_citta
FROM LuogoAeroporto luogo
JOIN ArrPart ap ON luogo.aeroporto = ap.arrivo -- Filtra per voli in arrivo 
JOIN Volo volo ON (ap.codice = volo.codice AND ap.comp = volo.comp) -- Join corretta 
CROSS JOIN Data D
GROUP BY luogo.citta, D.media_globale, D.dev_std_globale -- Colonne aggiunte qui per standard SQL
HAVING abs(avg(volo.durataMinuti) - D.media_globale) > D.dev_std_globale; -- Uso di abs()

6. Quali sono le nazioni che hanno il maggior numero di città dalle quali partono voli
diretti in altre nazioni?


