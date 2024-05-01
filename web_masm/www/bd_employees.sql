CREATE TABLE employees(
   nombre          VARCHAR(13) NOT NULL PRIMARY KEY
  ,id_departamento INTEGER  NOT NULL
  ,puesto          VARCHAR(33) NOT NULL
);
INSERT INTO employees(nombre,id_departamento,puesto) VALUES ('Dave Smith',001,'Gerente de Marketing de Producto');
INSERT INTO employees(nombre,id_departamento,puesto) VALUES ('Julie Jones',002,'Ingeniera de Software');
INSERT INTO employees(nombre,id_departamento,puesto) VALUES ('Scott Tanner',001,'Director de Generación de Demanda');
INSERT INTO employees(nombre,id_departamento,puesto) VALUES ('Ted Connors',002,'Ingeniera de Software');
INSERT INTO employees(nombre,id_departamento,puesto) VALUES ('Margaret Lane',001,'Vicepresidente de Marketing');
INSERT INTO employees(nombre,id_departamento,puesto) VALUES ('Mary Martin',005,'Recepcionista');
