-- Drop tables
DROP TABLE tb_documento_saude CASCADE CONSTRAINTS;
DROP TABLE tb_exame CASCADE CONSTRAINTS;
DROP TABLE tb_pessoa CASCADE CONSTRAINTS;
DROP TABLE tb_profissional_paciente CASCADE CONSTRAINTS;
DROP TABLE tb_profissional_saude CASCADE CONSTRAINTS;
DROP TABLE tb_telefone CASCADE CONSTRAINTS;
DROP TABLE tb_usuario CASCADE CONSTRAINTS;
DROP TABLE login CASCADE CONSTRAINTS;
drop table pessoa cascade CONSTRAINTS;

-- Create tables
CREATE TABLE tb_documento_saude (
    id_documento_saude NUMBER(19,0) GENERATED AS IDENTITY,
    estado VARCHAR2(255 CHAR),
    numero VARCHAR2(255 CHAR),
    sigla VARCHAR2(255 CHAR),
    PRIMARY KEY (id_documento_saude),
    CONSTRAINT UK_TB_DOCUMENTO_SAUDE_UNICO UNIQUE (estado, sigla, numero)
);

CREATE TABLE tb_exame (
    anos_ate_crise NUMBER(10,0),
    exam_egfrb FLOAT(53),
    hist_diabetes NUMBER(1,0) CHECK (hist_diabetes IN (0,1)),
    hist_dislipidemia NUMBER(1,0) CHECK (hist_dislipidemia IN (0,1)),
    hist_doenc_coronaria NUMBER(1,0) CHECK (hist_doenc_coronaria IN (0,1)),
    hist_doenc_vascular NUMBER(1,0) CHECK (hist_doenc_vascular IN (0,1)),
    hist_fumo NUMBER(1,0) CHECK (hist_fumo IN (0,1)),
    hist_hipertensao NUMBER(1,0) CHECK (hist_hipertensao IN (0,1)),
    hist_obesidade NUMBER(1,0) CHECK (hist_obesidade IN (0,1)),
    indc_massa_corp NUMBER(10,0),
    meses_ate_crise NUMBER(10,0),
    nvl_colesterol FLOAT(53),
    nvl_creatina FLOAT(53),
    pres_diastolica NUMBER(10,0),
    pres_sistolica NUMBER(10,0),
    remed_acei_arb NUMBER(1,0) CHECK (remed_acei_arb IN (0,1)),
    remed_diabetes NUMBER(1,0) CHECK (remed_diabetes IN (0,1)),
    remed_dislipidemia NUMBER(1,0) CHECK (remed_dislipidemia IN (0,1)),
    remed_hipertensao NUMBER(1,0) CHECK (remed_hipertensao IN (0,1)),
    id_historico_medico NUMBER(19,0) GENERATED AS IDENTITY,
    pessoa NUMBER(19,0),
    sexo VARCHAR2(255 CHAR),
    PRIMARY KEY (id_historico_medico)
);

CREATE TABLE tb_pessoa (
    dt_nascimento DATE,
    tipo_pessoa NUMBER(3,0) NOT NULL CHECK (tipo_pessoa BETWEEN 0 AND 1),
    id_pessoa NUMBER(19,0) GENERATED AS IDENTITY,
    cpf VARCHAR2(255 CHAR),
    email VARCHAR2(255 CHAR),
    nm_pessoa VARCHAR2(255 CHAR),
    PRIMARY KEY (id_pessoa),
    CONSTRAINT UK_TB_PESSOA_EMAIL UNIQUE (email),
    CONSTRAINT UK_TB_PESSOA_CPF UNIQUE (cpf)
);

CREATE TABLE tb_profissional_paciente (
    pessoa NUMBER(19,0) NOT NULL,
    profissional NUMBER(19,0) NOT NULL,
    PRIMARY KEY (pessoa, profissional)
);

CREATE TABLE tb_profissional_saude (
    documento NUMBER(19,0),
    id_profissional_saude NUMBER(19,0) GENERATED AS IDENTITY,
    pessoa NUMBER(19,0),
    PRIMARY KEY (id_profissional_saude),
    CONSTRAINT UK_TB_PROFISSIONAL_SAUDE_DOCUMENTO UNIQUE (documento),
    CONSTRAINT UK_TB_PROFISSIONAL_SAUDE_PESSOA UNIQUE (pessoa)
);

CREATE TABLE tb_telefone (
    id_telefone NUMBER(19,0) GENERATED AS IDENTITY,
    pessoa NUMBER(19,0),
    ddd VARCHAR2(255 CHAR),
    ddi VARCHAR2(255 CHAR),
    numero VARCHAR2(255 CHAR),
    PRIMARY KEY (id_telefone),
    CONSTRAINT UK_TB_TELEFONE UNIQUE (ddd, ddi, numero)
);

CREATE TABLE tb_usuario (
    id_usuario NUMBER(19,0) GENERATED AS IDENTITY,
    pessoa NUMBER(19,0),
    senha VARCHAR2(255 CHAR),
    username VARCHAR2(255 CHAR),
    PRIMARY KEY (id_usuario),
    CONSTRAINT UK_USUARIO_USERNAME UNIQUE (username),
    CONSTRAINT UK_USUARIO_PESSOA UNIQUE (pessoa)
);


CREATE TABLE Pessoa (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY,
    nome VARCHAR2(255) NOT NULL,
    nascimento DATE,
    email VARCHAR2(255) UNIQUE,
    tipoPessoa VARCHAR2(50),
    CONSTRAINT pessoa_pk PRIMARY KEY (id)
);

CREATE TABLE Login (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY,
    usuario VARCHAR2(255) UNIQUE NOT NULL,
    senha VARCHAR2(255) NOT NULL,  -- IMPORTANTE: Armazenar hash da senha!
    pessoa_id NUMBER,
    CONSTRAINT login_pk PRIMARY KEY (id),
    CONSTRAINT fk_login_pessoa FOREIGN KEY (pessoa_id) REFERENCES Pessoa(id)
);


     
select * from login;
select * from pessoa;

-- Add foreign key constraints
ALTER TABLE tb_exame ADD CONSTRAINT FK_EXAME_PESSOA FOREIGN KEY (pessoa) REFERENCES tb_pessoa;
ALTER TABLE tb_profissional_paciente ADD CONSTRAINT FK_PACIENTE_DO_PROFISSIONAL FOREIGN KEY (pessoa) REFERENCES tb_pessoa;
ALTER TABLE tb_profissional_paciente ADD CONSTRAINT FK_PROFISSIONAL_DO_PACIENTE FOREIGN KEY (profissional) REFERENCES tb_profissional_saude;
ALTER TABLE tb_profissional_saude ADD CONSTRAINT FK_DOCUMENTO_SAUDE_PROFISSIONAL FOREIGN KEY (documento) REFERENCES tb_documento_saude;
ALTER TABLE tb_profissional_saude ADD CONSTRAINT FK_PROFISSIONAL_PESSOA FOREIGN KEY (pessoa) REFERENCES tb_pessoa;
ALTER TABLE tb_telefone ADD CONSTRAINT FK_TELEFONE_PESSOA FOREIGN KEY (pessoa) REFERENCES tb_pessoa;
ALTER TABLE tb_usuario ADD CONSTRAINT FK_USUARIO_PESSOA FOREIGN KEY (pessoa) REFERENCES tb_pessoa;
