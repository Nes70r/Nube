CREATE TABLE usuarios(
	id_usuario VARCHAR2(18) PRIMARY KEY,
	user_name VARCHAR2(30) UNIQUE NOT NULL,
	password VARCHAR2(30) NOT NULL,
	nombre VARCHAR2(30) NOT NULL,
	apPAt VARCHAR2(30) NOT NULL,
	apMat VARCHAR2(30),
	fechaNac DATE NOT NULL,
	correo VARCHAR2(30) UNIQUE NOT NULL,
	fechaReg DATE DEFAULT SYSDATE,
	status NUMBER(1) DEFAULT 1 CHECK(status IN (1,0))
);
insert into usuarios values(
	'AAON010316HMCNRSA9',
	'nestor777',
	'nestor123',
	'Nestor',
	'Anaya',
	'Ortega',
	'16/03/2001',
	'nest@gmail.com',
	'16/03/2001',
	1
);

COMMENT ON TABLE USUARIOS IS
'LA TABLA USUARIOS CONTIENE DATOS PERSONALES DE LOS USUARIOS Y OTROS DATOS INDISPENSABLES PARA SU REGISTRO EN LA PLATAFORMA. SE RELACIONA CON LAS TABLAS "PREFERENCIAS_DEL_USUARIO","TELEFONOS_USUARIOS","SUSCRIPCION_USUARIO" E "INSCRIPCION_A_CURSOS". CONSTRAINTEL CAMPO "STATUS" ES UTILIZADO PARA REALIZAR BORRADOS LOGICOS, DONDE "1" ES ACTIVO Y "0" INACTIVO .';


CREATE TABLE telefonos_usuarios(
	id_usuario REFERENCES usuarios(id_usuario),
	categoria VARCHAR2(1) CHECK(categoria IN ('P','S')),
	telefono NUMBER(10) UNIQUE NOT NULL,
	UNIQUE (id_usuario,categoria)
);

insert into telefonos_usuarios values(
	'AAON010316HMCNRSA9',
	'P',
	7221041429
);

insert into telefonos_usuarios values(
	'AAON010316HMCNRSA9',
	'S',
	7221041429
);

insert into telefonos_usuarios values(
	'AAON010316HMCNRSA9',
	'S',
	7226139490
);

insert into telefonos_usuarios values(
	'AAON010316HMCNRSA9',
	'P',
	7226138000
);

insert into telefonos_usuarios values(
	'AAON010316HMCNRSA9',
	'S',
	7225376859
);


COMMENT ON TABLE TELEFONOS_USUARIOS IS
'EN LA TABLA TELEFONOS_USUARIOS SE ALMACENAN MAXIMO DOS NUMERO TELEFONICOS POR USUARIO. SE RELACIONA CON LA TABLA "USUARIOS". EL CAMPO "CATEGORIA" INDICA SI EL TELEFONO INGRESADO ES EL PRINCIPAL O EL SECUNDARIO CON LAS LETRAS "P" Y "S" RESPECTIVAMENTE (YA QUE EL USUARIO TIENE LA OPCION DE REGISTRAR DOS NUMEROS TELEFONICOS)';

CREATE TABLE suscripcion_anual(
	id_suscripcion NUMBER(6) PRIMARY KEY,
	monto NUMBER(7,2) NOT NULL,
	fecha_alta DATE DEFAULT SYSDATE,
	status VARCHAR2(1) CHECK(status IN('A','I'))
);

COMMENT ON TABLE SUSCRIPCION_ANUAL IS
'LA TABLA SUSCRIPCION_ANUAL CONTIENE EL REGISTRO DE LOS CAMBIOS QUE HA TENIDO EL PRECIO DE LA SUSCRIPCION ANUAL. ESTA RELACIONADA CON LA TABLA "SUSCRIPCION_USUARIO". CONSTRAINTEL CAMPO "STATUS" ES UTILIZADO PARA REALIZAR BORRADOS LOGICOS, DONDE "1" ES ACTIVO Y "0" INACTIVO .';

CREATE TABLE suscripcion_usuario(
	id_suscripcion REFERENCES suscripcion_anual(id_suscripcion) NOT NULL,
	id_usuario REFERENCES usuarios(id_usuario) NOT NULL,
	refencia_pago NUMBER(20),
	status NUMBER(1) CHECK(status IN (0,1)),
	fecha_alta DATE DEFAULT SYSDATE,
	fecha_fin DATE DEFAULT SYSDATE+1
);

COMMENT ON TABLE SUSCRIPCION_USUARIO IS
'LA TABLA SUSCRIPCION_USUARIO CONTIENE INFORMACION ACERCA DE LA SUSCRIPCION DE LOS USUARIOS, COMO EL ESTATUS DE PAGO, FECHA DE PAGO Y VENCIMIENTO DE LA SUSCRIPCION. ESTA RELACIONADA CON LAS TABLAS "USUARIOS" Y "SUSCRIPCION_ANUAL". EL CAMPO "STATUS_PAGO" INDICA SI EL USUARIO HA REALIZADO UN PAGO POR LA SUSCRIPCION ANULA O NO, UTILIZANDO LOS DIGITOS "1" Y "0" RESPECTIVMENTE';

CREATE TABLE CATEGORIA_CURSO (
    ID_CATEGORIA NUMBER(6) PRIMARY KEY,
	NOMBRE VARCHAR2(30) NOT NULL,
	FECHA_ALTA DATE DEFAULT SYSDATE,
    STATUS NUMBER(1) DEFAULT 1 CHECK (STATUS IN (0, 1)),
	RANGO_EDAD NUMBER(1) CHECK (RANGO_EDAD IN (0,1))
);

COMMENT ON TABLE CATEGORIA_CURSO IS
'LA TABLA CATEGORIA_CURSO FUNGE COMO UN CATÁLOGO DE OPCIONES EN QUE SE PUEDEN CLASIFICAR LOS CURSOS DE LA PLATAFORMA. SE RELACIONA CON LAS TABLAS "PREFERENCIAS_DEL_USUARIO" Y "CURSOS_CATALOGO". CONSTRAINTEL CAMPO "STATUS" ES UTILIZADO PARA REALIZAR BORRADOS LOGICOS, DONDE "1" ES ACTIVO Y "0" INACTIVO. EL CAMPO "RANGOEDAD" INDICA SI EL CURSO ES PARA MENORES DE EDAD O MAYORES CON LOS DIGITOS "0" Y "1" RESPECTIVAMENTE ';

CREATE TABLE preferencias_del_usuario(
	id_preferencia NUMBER(6) PRIMARY KEY,
	ID_CATEGORIA REFERENCES CATEGORIA_CURSO(ID_CATEGORIA),
	id_usuario REFERENCES usuarios(id_usuario),
	fechaAlta DATE DEFAULT SYSDATE NOT NULL,
	status NUMBER(1) NOT NULL CHECK(status IN(1,0))
);

COMMENT ON TABLE PREFERENCIAS_DEL_USUARIO IS
'SE RELACIONA CON LAS TABLAS "USUARIOS" Y "CATEGORIA_CURSO". CONSTRAINTEL CAMPO "STATUS" ES UTILIZADO PARA REALIZAR BORRADOS LOGICOS, DONDE "1" ES ACTIVO Y "0" INACTIVO .';

CREATE TABLE AUTORES_DE_CURSOS(
	ID_AUTOR NUMBER(6) PRIMARY KEY,
	NOMBRE VARCHAR2(30) NOT NULL,
	APPAT VARCHAR2(30) NOT NULL,
	APMAT VARCHAR2(30),
	BIOGRAFIA VARCHAR2(150) NOT NULL
);

COMMENT ON TABLE AUTORES_DE_CURSOS IS
'LA TABLA AUTORES_DE_CURSOS PROPORCIONA INFORMACION SOBRE EL AUTOR DEL CURSO AL CUAL LOS USUARIOS INTERESADOS PUEDEN INSCRIBIRSE. ESTA RELACIONADA CON LA TABLA "CURSOS_CATALOGO".';

CREATE TABLE CURSOS_CATALOGO (
    ID_CURSO NUMBER(6) PRIMARY KEY,
    ID_CATEGORIA NUMBER(6),
    ID_AUTOR NUMBER(6),
    NOMBRE VARCHAR2(50) NOT NULL,
    DESCRIPCION VARCHAR2(100) NOT NULL,
    STATUS NUMBER(1) DEFAULT 1 CHECK (STATUS IN (0, 1)),
    FOREIGN KEY (ID_CATEGORIA) REFERENCES CATEGORIA_CURSO(ID_CATEGORIA),
    FOREIGN KEY (ID_AUTOR) REFERENCES AUTORES_DE_CURSOS(ID_AUTOR)
);

COMMENT ON TABLE CURSOS_CATALOGO IS
'EN LA TABLA CURSOS_CATALOGO ESTÁ LA LISTA DE TODOS LOS CURSOS ACTIVOS E INACTIVOS DENTRO DE LA PLATAFORMA. SE RELACIONA CON "CATEGORIA_CURSO", "INSCRIPCION_A_CURSOS", "TEMARIO_DEL_CURSO" y "AUTORES_DE_CURSOS". CONSTRAINTEL CAMPO "STATUS" ES UTILIZADO PARA REALIZAR BORRADOS LOGICOS, DONDE "1" ES ACTIVO Y "0" INACTIVO .';

CREATE TABLE TEMARIO_DEL_CURSO(
    ID_TEMA NUMBER(6) PRIMARY KEY,
    ID_CURSO NUMBER(6) NOT NULL,
    NOMBRE_TEMA VARCHAR2(30) NOT NULL,
    ACCESO VARCHAR(1) CHECK (ACCESO IN ('F', 'D')),
    STATUS VARCHAR2(1) CHECK (STATUS IN ('A', 'I')),
    FOREIGN KEY (ID_CURSO) REFERENCES CURSOS_CATALOGO(ID_CURSO)
);

COMMENT ON TABLE TEMARIO_DEL_CURSO IS
'EN LA TABLA TEMARIO_DEL_CURSO SE ENCUENTRAN TODOS LOS TEMAS DISPONIBLES DE UN CURSO. ESTA RELACIONADA CON LAS TABLAS "CURSOS_CATALOGO" Y "LECCIONES_DEL_TEMA". EL CAMPO "STATUS" INDICA SI UN TEMA ESTA ACTIVO O NO USANDO LAS LETRAS "A" Y "I" RESPECTIVAMENTE. EL CAMPO "ACCESO" INDICA SI EL USUARIO TIENE ACCESO COMPLETO AL TEMA DEL CURSO O SI SOLO SERA VISIBLE A MODO DE DEMOSTRACION, USANDO LAS LETRAS "F" Y "D" RESPECTIVAMENTE.';

CREATE TABLE LECCIONES_DEL_TEMA(
	ID_LECCION NUMBER(6) PRIMARY KEY,
	ID_TEMA NUMBER(6),
	NOMBRE_LECCION VARCHAR2(30) NOT NULL,
	URL VARCHAR2(100) UNIQUE NOT NULL,
	STATUS NUMBER(1) CHECK (STATUS IN (0,1)),
	FOREIGN KEY (ID_TEMA) REFERENCES TEMARIO_DEL_CURSO(ID_TEMA)
);

COMMENT ON TABLE LECCIONES_DEL_TEMA IS
'EN LA TABLA LECCIONES_DEL_TEMA SE ENCUENTRAN TODAS LAS LECCIONES QUE CONSTITUYEN A UN TEMA DEL CURSO. ESTA RELACIONADA CON LAS TABLAS "INSCRIPCION_A_CURSOS" Y "TEMARIO_DEL_CURSO". EL CAMPO "STATUS" INDICA SI UNA LECCION ESTA ACTIVA O NO USANDO LOS DIGITOS "1" Y "0" RESPECTIVAMENTE.';

CREATE TABLE inscripcion_a_curso(
	ID_INSCRIPCION NUMBER(6) PRIMARY KEY,
	id_usuario REFERENCES usuarios(id_usuario),
	ID_CURSO REFERENCES CURSOS_CATALOGO(ID_CURSO),
	ultimaLeccion NUMBER(6),
	STATUS VARCHAR2(1) CHECK(STATUS IN ('A','B','F')),
	FECHA_INICIO DATE DEFAULT SYSDATE NOT NULL,
	FECHA_FIN DATE,
	LECCIONES_TERMINADAS NUMBER(3) DEFAULT(0),
	ULTIMA_CONEXION DATE DEFAULT SYSDATE NOT NULL,
	UNIQUE (ID_USUARIO,ID_CURSO)
);

ALTER TABLE inscripcion_a_curso
ADD CONSTRAINT FK_ultimaLecc FOREIGN KEY (ultimaLeccion) REFERENCES LECCIONES_DEL_TEMA(ID_LECCION);

COMMENT ON TABLE INSCRIPCION_A_CURSO IS
'LA TABLA INSCRIPCION_A_CURSOS REGISTRA LOS CURSOS EN LOS QUE EL USUARIO ESTA INSCRITO, SEÑALANDO LA ULTIMA LECCION A LA QUE INGRESO Y SU ULTIMA CONEXION, EL STATUS DE SU AVANCE EN EL CURSO CON EL CAMPO "STATUS", LA FECHA DE INICIO Y TERMINO DEL MISMO Y LA CANTIDAD DE LECCIONES TERMINADAS. ESTA RELACIONADA CON LAS TABLAS "USUARIOS", "CURSOS_CATALOGO", "CERTIFICADOS_DE_FINALIZACION" Y "LECCIONES_DEL_TEMA",PARA "STATUS" "A" SIGNIFICA ALTA, "B" BAJA Y "F" FINALIZADO.';

CREATE TABLE CERTIFICADO_DE_FINALIZACION(
	ID_CERTIFICADO NUMBER(6) PRIMARY KEY,
	ID_INSCRIPCION REFERENCES inscripcion_a_curso(ID_INSCRIPCION),
	FECHA_EXP DATE DEFAULT SYSDATE NOT NULL
);

COMMENT ON TABLE CERTIFICADO_DE_FINALIZACION IS
'EN LA TABLA CERTIFICADOS_DE_FINALIZACION SE REGISTRAN LOS CERTIFICADOS EXPEDIDOS A AQUELLOS USUARIOS QUE HAN FINALIZADO UN CURSO DE LA PLATAFORMA. ESTA RELACIONADA CON LA TABLA "INSCRIPCION_A_CURSOS".';
