create table Progetto (
	id PosInteger not null,
	nome StringaM not null,
	inizio date not null,
	fine date not null,
	budget Denaro not null,
	PRIMARY KEY (id),
	UNIQUE (nome),
	CHECK (inizio<fine)
)

CREATE TABLE WP(
	progetto PosInteger not null,
	id PosInteger not null,
	nome StringaM not null,
	inizio date not null,
	fine date not null,
	CHECK (inizio<fine),
	PRIMARY KEY(progetto,id),
	FOREIGN KEY (progetto) references Progetto(id)
)

CREATE TABLE AttivitaProgetto(
	id PosInteger not null,
	persona PosInteger not null,
	progetto PosInteger not null,
	wp PosInteger not null,
	giorno date not null,
	tipo LavoroProgetto not null,
	oreDurata NumeroOre not null,
	FOREIGN KEY(persona) references Persona(id),
	FOREIGN KEY(progetto, wp) references WP(progetto, id)
)

CREATE TABLE Assenza(
	id PosInteger not null,
	persona PosInteger not null,
	tipo CausaAssenza not null,
	giorno date not null,
	UNIQUE(persona,giorno),
	PRIMARY KEY(id),
	FOREIGN KEY(persona) references Persona(id)
)
