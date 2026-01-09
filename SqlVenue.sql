CREATE DATABASE Venue;
USE Venue;

CREATE TABLE TBL_USUARIO(
	id BIGINT PRIMARY KEY IDENTITY,
	nome VARCHAR(100) NOT NULL,
	username VARCHAR(50) UNIQUE NOT NULL,
	telefone VARCHAR(20) NOT NULL,
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

CREATE TABLE TBL_LOCAL(
	id BIGINT PRIMARY KEY IDENTITY(1,1),
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(50) NOT NULL,
	foto_local VARCHAR(255) NOT NULL,
    
    -- Endereço
    cep VARCHAR(10) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(50),
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado CHAR(2) NOT NULL,
    
    -- Capacidade
    capacidade_maxima INT NOT NULL,
    
    -- Dono
    id_usuario_dono BIGINT NOT NULL,
    FOREIGN KEY (id_usuario_dono) REFERENCES TBL_USUARIO(id),
    
    -- Metadados
    data_cadastro DATETIME DEFAULT GETDATE(),
    ativo BIT DEFAULT 1 NOT NULL,
    
    -- Avaliações
    nota_media DECIMAL(3,2) DEFAULT 0.00,
);

CREATE TABLE TBL_FOTO_FEED(
	id BIGINT PRIMARY KEY IDENTITY,
	foto VARCHAR(255),
	id_local BIGINT NOT NULL,
	FOREIGN KEY (id_local) REFERENCES TBL_LOCAL(id)
);

CREATE TABLE TBL_AVALIACAO(
	id BIGINT PRIMARY KEY IDENTITY,
	id_usuario BIGINT NOT NULL,
	id_local BIGINT NOT NULL,
	nota INT NOT NULL,
	descricao TEXT,
	
	FOREIGN KEY (id_usuario) REFERENCES TBL_USUARIO(id),
	FOREIGN KEY (id_local) REFERENCES TBL_LOCAL(id),

	CONSTRAINT UK_AVALIACAO UNIQUE (id_usuario, id_local)
);

CREATE TABLE TBL_SERVICO(
	id BIGINT PRIMARY KEY IDENTITY,
	nome VARCHAR(100) NOT NULL,
	descricao TEXT,
	foto VARCHAR(255),
	preco DECIMAL(10,2) NOT NULL
);

CREATE TABLE TBL_LOCAL_SERVICO (
	id_local BIGINT,
	id_servico BIGINT,
	PRIMARY KEY (id_local, id_servico),
	FOREIGN KEY (id_local) REFERENCES TBL_LOCAL(id),
	FOREIGN KEY (id_servico) REFERENCES TBL_SERVICO(id)
);

CREATE TABLE TBL_RESERVA(
	id BIGINT PRIMARY KEY IDENTITY,
	id_local BIGINT NOT NULL,
	tipo_reserva VARCHAR(10) NOT NULL,
	horario_inicio TIME NOT NULL,
	horario_termino TIME NOT NULL,
	data_reserva DATE NOT NULL,
	preco DECIMAL(10,2) NOT NULL,

	-- DISPONÍVEL, RESERVADA, REALIZADA
	status_reserva VARCHAR(30) NOT NULL,

	FOREIGN KEY (id_local) REFERENCES TBL_LOCAL(id)
);

CREATE TABLE TBL_RESERVA_SERVICO(
	id_reserva BIGINT,
	id_servico BIGINT,
	PRIMARY KEY (id_reserva, id_servico),
	FOREIGN KEY (id_reserva) REFERENCES TBL_RESERVA(id),
	FOREIGN KEY (id_servico) REFERENCES TBL_SERVICO(id)
);

CREATE TABLE TBL_CONTRATO(
	id BIGINT PRIMARY KEY IDENTITY,

	-- SOLICITADO, PENDENTE, CONFIRMADO, COCLUÍDO, CANCELADO
	status_contrato VARCHAR(30) NOT NULL,

	-- Cliente
	id_cliente BIGINT NOT NULL,
	FOREIGN KEY (id_cliente) REFERENCES TBL_USUARIO(id),

	-- Local
	id_local BIGINT NOT NULL,
	FOREIGN KEY (id_local) REFERENCES TBL_LOCAL(id),

    -- Reserva
	id_reserva BIGINT NOT NULL,
	FOREIGN KEY (id_reserva) REFERENCES TBL_RESERVA(id),

	-- Informações
	preco DECIMAL(10,2) NOT NULL
);

CREATE TABLE TBL_CONTRATO_SERVICO(
	id_contrato BIGINT,
	id_servico BIGINT,
	PRIMARY KEY (id_contrato, id_servico),
	FOREIGN KEY (id_contrato) REFERENCES TBL_CONTRATO(id),
	FOREIGN KEY (id_servico) REFERENCES TBL_SERVICO(id)
);

CREATE TABLE TBL_CHAT(
    id BIGINT PRIMARY KEY IDENTITY,
    id_contrato BIGINT NOT NULL UNIQUE,
    data_inicio DATETIME DEFAULT GETDATE(),
    data_fim DATETIME,
    ativo BIT DEFAULT 1 NOT NULL,

    FOREIGN KEY (id_contrato) REFERENCES TBL_CONTRATO(id)
);

CREATE TABLE TBL_CHAT_PARTICIPANTE(
    id_chat BIGINT,
    id_usuario BIGINT,
    PRIMARY KEY (id_chat, id_usuario),
    FOREIGN KEY (id_chat) REFERENCES TBL_CHAT(id),
    FOREIGN KEY (id_usuario) REFERENCES TBL_USUARIO(id)
);

CREATE TABLE TBL_CHAT_MENSAGEM(
    id BIGINT PRIMARY KEY IDENTITY,
    id_chat BIGINT NOT NULL,
    id_remetente BIGINT NOT NULL,
    mensagem TEXT NOT NULL,
    data_envio DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (id_chat) REFERENCES TBL_CHAT(id),
    FOREIGN KEY (id_remetente) REFERENCES TBL_USUARIO(id)
);