CREATE DATABASE Venue;
USE Venue;

CREATE TABLE TBL_LOCAL(
	id BIGINT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(50),
	foto_local VARCHAR(255) NOT NULL,
	foto_feed VARCHAR(255),
    
    -- Endereço
    cep VARCHAR(10),
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado CHAR(2),
    
    -- Capacidade
    capacidade_maxima INT NOT NULL,
    
    -- Dono
    id_dono BIGINT NOT NULL,
    FOREIGN KEY (id_dono) REFERENCES TBL_USUARIO(id),

	-- Serviços
	id_servico BIGINT NOT NULL,
    FOREIGN KEY (id_servico) REFERENCES TBL_SERVICO(id),

	-- Reserva
	id_reserva BIGINT NOT NULL,
    FOREIGN KEY (id_reserva) REFERENCES TBL_RESERVA(id),
    
    -- Metadados
    data_cadastro DATETIME DEFAULT GETDATE(),
    ativo BIT DEFAULT 1,
    destacado BIT DEFAULT 0,
    
    -- Avaliações
    nota_media DECIMAL(3,2) DEFAULT 0.00,
    total_avaliacoes INT DEFAULT 0,
    total_reservas INT DEFAULT 0
);

CREATE TABLE TBL_RESERVA(
	id BIGINT PRIMARY KEY IDENTITY,
	categoria VARCHAR(20),
	horario_inicio TIME NOT NULL,
	horario_termino TIME NOT NULL,
	data_reserva DATE,

	-- Serviços
	id_servico BIGINT NOT NULL,
    FOREIGN KEY (id_servico) REFERENCES TBL_SERVICO(id),
	id_servico_escolhido BIGINT NOT NULL,
	FOREIGN KEY (id_servico_escolhido) REFERENCES TBL_SERVICO_ESCOLHIDO(id_servico_escolhido),

	preco DECIMAL,

	-- Disponibilidade
	disponivel BIT DEFAULT 1
);

CREATE TABLE TBL_SERVICO(
	id BIGINT PRIMARY KEY IDENTITY,
	nome VARCHAR(100) NOT NULL,
	descricao TEXT,
	foto VARCHAR(255),
	preco DECIMAL
);

CREATE TABLE TBL_SERVICO_ESCOLHIDO(
	id_servico_escolhido BIGINT NOT NULL,
	PRIMARY KEY (id_servico_escolhido),
    FOREIGN KEY (id_servico_escolhido) REFERENCES TBL_SERVICO(id),
);

CREATE TABLE TBL_USUARIO(
	id BIGINT PRIMARY KEY IDENTITY,
	nome VARCHAR(100) NOT NULL,
	username VARCHAR(50) UNIQUE NOT NULL,
	telefone VARCHAR(20),
	email VARCHAR(100) UNIQUE NOT NULL,
	senha VARCHAR(255) NOT NULL,
	data_cadastro DATETIME DEFAULT GETDATE(),
	foto VARCHAR(255),
    
    -- Endereço
    cep VARCHAR(10),
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado CHAR(2)
);

CREATE TABLE TBL_USUARIO_PERFIL (
    id_usuario BIGINT,
    perfil VARCHAR(20),
    PRIMARY KEY (id_usuario, perfil),
    FOREIGN KEY (id_usuario) REFERENCES TBL_USUARIO(id)
);

CREATE TABLE TBL_CONTRATO(
	id BIGINT PRIMARY KEY IDENTITY,
	status_contrato BIT DEFAULT 0,

	-- Cliente
	id_cliente BIGINT,
	FOREIGN KEY (id_dono) REFERENCES TBL_USUARIO(id),

	-- Dono
	id_dono BIGINT,
	FOREIGN KEY (id_dono) REFERENCES TBL_USUARIO(id),

	-- Reserva
	id_reserva BIGINT,
	FOREIGN KEY (id_reserva) REFERENCES TBL_RESERVA(id),

	-- Informações
	preco DECIMAL
);