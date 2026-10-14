CREATE DOMAIN CodiceFiscale AS varchar CHECK(
	VALUE ~* '...'
);

CREATE DOMAIN Email AS varchar CHECK(
	VALUE ~* '...'
);



CREATE DOMAIN String100_not_null AS varchar(100) CHECK (value IS NOT NULL);

CREATE DOMAIN Int_gz_not_null AS Integer CHECK (value IS NOT NULL AND value>0);

CREATE TYPE Indirizzo AS(
	via String100_not_null,
	civico Int_gz_not_null,
	nome_citofono String100_not_null
)

CREATE DOMAIN Periodo AS TSTZRANGE;
-- Può NON avere data di inizio nè data di fine
-- Il vincolo da<=a è imposto automaticamente
-- Ma ora ogni volta che vogliamo inserire una nuova riga
-- INSERT INTO prenotazioni (periodo) 
-- VALUES (tstzrange('2026-08-01 10:00:00+02', '2026-08-10 10:00:00+02', '[)'))
-- La funzione Periodo.interseca() sarà definita più avanti

CREATE TYPE CapienzaStanza_Type AS(
	n_letti_tipico Int_gz_not_null,
	n_letti_max Int_gz_not_null

);

CREATE DOMAIN CapienzaStanza AS CapienzaStanza_Type
CHECK (
    (VALUE).n_letti_tipico < (VALUE).n_letti_max
);


/***********************************************/
-- Nuovi domini dopo l'eliminazione delle generalizzazioni
CREATE TYPE TipoPrestazione AS ENUM('Ricovero', 'PrestazioneEsterna')

