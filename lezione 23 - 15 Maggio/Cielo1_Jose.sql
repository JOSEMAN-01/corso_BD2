/*
Volo (codice: PosInteger, comp: StringaM, durataMinuti: PosInteger)
primary key: (codice,comp)
[VincoloDB.1] foreign key: comp references Compagnia(nome)
[VincoloDB.2] foreign key: (codice, comp) references ArrPart(codice, comp)

ArrPart (codice: PosInteger, comp: StringaM, arrivo: CodIATA, partenza: CodIATA)
primary key: (codice,comp)
[VincoloDB.3] foreign key: (codice, comp) references Volo(codice, comp)
[VincoloDB.4] foreign key: arrivo references Aeroporto(codice)
[VincoloDB.5] foreign key: partenza references Peroporto(codice)

Aeroporto (codice: CodIATA, nome: StringaM)
primary key: codice
[VincoloDB.6] foreign key: codice references LuogoAeroporto(aeroporto)

LuogoAeroporto (aeroporto: CodIATA, citta: StringaM, nazione: StringaM)
primary key: aeroporto
[VincoloDB.7] foreign key: aeroporto references Aeroporto(codice)

Compagnia (nome: StringaM, annoFondaz*: PosInteger)
primary key: nome
(*): può essere NULL

*/

--3
SELECT v.codice, v.comp
FROM Volo v, ArrPart ap
WHERE v.codice=ap.codice AND v.comp=ap.comp AND ap.partenza='CIA';

--7
/*Ho barato perché in realtà non c'è una foreign key tra ArrPart e LuogoAeroporto*/
SELECT distinct ap.comp
FROM ArrPart ap, LuogoAeroporto luogoArr,LuogoAeroporto luogoPart
WHERE ap.arrivo=luogoArr.aeroporto AND ap.partenza=luogoPart.aeroporto AND luogoArr.citta='New York' 
AND luogoPart.citta='Roma'

--8
SELECT aeroport.codice, aeroport.nome, luogo.citta
FROM Aeroporto aeroport, LuogoAeroporto luogo, ArrPart ap
WHERE aeroport.codice= luogo.aeroporto AND ap.partenza=aeroport.codice AND ap.comp='MagicFly'

--9
SELECT volo.codice, volo.comp, ap.arrivo, ap.partenza
FROM Volo volo, ArrPart ap, LuogoAeroporto luogoArr, LuogoAeroporto luogoPart
WHERE volo.codice=ap.codice AND volo.comp=ap.comp AND
ap.arrivo=luogoArr.aeroporto AND ap.partenza=luogoPart.aeroporto
AND luogoArr.citta='New York' AND luogoPart.citta='Roma'

--10

--11
