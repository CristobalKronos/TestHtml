--Comentario simple
/*Comentario complejo*/

/*
A. Crear e ingresar datos a las tablas
*/
--Estudiante (rut,nombre, carreraMayor, carreraMinor)
CREATE TABLE Estudiante (rut varchar2(255) NOT NULL, nombre varchar2(255) NOT NULL, carreraMayor number(10) NOT NULL, carreraMinor number(10) NOT NULL, PRIMARY KEY (rut));
DROP TABLE Estudiante CASCADE CONSTRAINTS;
SELECT rut, nombre, carreraMayor, carreraMinor FROM Estudiante;
INSERT INTO Estudiante(rut, nombre, carreraMayor, carreraMinor) VALUES (?, ?, ?, ?);
UPDATE Estudiante SET nombre = ?, carreraMayor = ?, carreraMinor = ? WHERE rut = ?;
DELETE FROM Estudiante WHERE rut = ?;

--Carrera (codigo, nombre)
CREATE TABLE Carrera (codigo number(10) GENERATED AS IDENTITY, nombre varchar2(255) NOT NULL, PRIMARY KEY (codigo));
DROP TABLE Carrera CASCADE CONSTRAINTS;
SELECT codigo, nombre FROM Carrera;
INSERT INTO Carrera(codigo, nombre) VALUES (?, ?);
UPDATE Carrera SET nombre = ? WHERE codigo = ?;
DELETE FROM Carrera WHERE codigo = ?;

--Curso (codigo, nombre, codCarrera)
CREATE TABLE Curso (codigo number(10) GENERATED AS IDENTITY, nombre varchar2(255) NOT NULL, codCarrera number(10) NOT NULL, PRIMARY KEY (codigo));
DROP TABLE Curso CASCADE CONSTRAINTS;
SELECT codigo, nombre, codCarrera FROM Curso;
INSERT INTO Curso(codigo, nombre, codCarrera) VALUES (?, ?, ?);
UPDATE Curso SET nombre = ?, codCarrera = ? WHERE codigo = ?;
DELETE FROM Curso WHERE codigo = ?;

--Profesor (rut, nombre)
CREATE TABLE Profesor (rut varchar2(255) NOT NULL, nombre varchar2(255) NOT NULL, PRIMARY KEY (rut));
DROP TABLE Profesor CASCADE CONSTRAINTS;
SELECT rut, nombre FROM Profesor;
INSERT INTO Profesor(rut, nombre) VALUES (?, ?);
UPDATE Profesor SET nombre = ? WHERE rut = ?;
DELETE FROM Profesor WHERE rut = ?;

--ProfesorParalelo (correlativoPP, rutProfesor, codCurso, numParalelo, semestre, año)
CREATE TABLE ProfesorParalelo (correlativoPP number(10) GENERATED AS IDENTITY, numParalelo number(10) NOT NULL, semestre number(10) NOT NULL, año number(10) NOT NULL, codCurso number(10) NOT NULL, rutProfesor varchar2(255) NOT NULL, PRIMARY KEY (correlativoPP));
DROP TABLE ProfesorParalelo CASCADE CONSTRAINTS;
SELECT correlativoPP, numParalelo, semestre, año, codCurso, rutProfesor FROM ProfesorParalelo;
INSERT INTO ProfesorParalelo(correlativoPP, numParalelo, semestre, año, codCurso, rutProfesor) VALUES (?, ?, ?, ?, ?, ?);
UPDATE ProfesorParalelo SET numParalelo = ?, semestre = ?, año = ?, codCurso = ?, rutProfesor = ? WHERE correlativoPP = ?;
DELETE FROM ProfesorParalelo WHERE correlativoPP = ?;

--Notas (correlativoN, rutEstud, correlativoPP, nota)
CREATE TABLE Notas (correlativoN number(10) GENERATED AS IDENTITY, nota float(10), Estudianterut varchar2(255) NOT NULL, ProfesorParalelocorrelativoPP number(10) NOT NULL, PRIMARY KEY (correlativoN));
DROP TABLE Notas CASCADE CONSTRAINTS;
SELECT correlativoN, nota, Estudianterut, ProfesorParalelocorrelativoPP FROM Notas;
INSERT INTO Notas(correlativoN, nota, Estudianterut, ProfesorParalelocorrelativoPP) VALUES (?, ?, ?, ?);
UPDATE Notas SET nota = ?, Estudianterut = ?, ProfesorParalelocorrelativoPP = ? WHERE correlativoN = ?;
DELETE FROM Notas WHERE correlativoN = ?;

/*TODO: Aplicar seeders*/
--Estudiante
INSERT INTO Estudiante(rut, nombre, carreraMayor, carreraMinor) VALUES (191000137, "Cristobal", "Informatica", "Ingenieria");
INSERT INTO Estudiante(rut, nombre, carreraMayor, carreraMinor) VALUES (112223334, "Pepe", "Industrial", "Ingenieria");
INSERT INTO Estudiante(rut, nombre, carreraMayor, carreraMinor) VALUES (443332221, "Felipe", "Informatica", "Ingenieria");

--Carrera
INSERT INTO Carrera(codigo, nombre) VALUES (1, "Ingenieria");
INSERT INTO Carrera(codigo, nombre) VALUES (2, "Informatica");
INSERT INTO Carrera(codigo, nombre) VALUES (3, "Industrial");

--Curso
INSERT INTO Curso(codigo, nombre, codCarrera) VALUES (1, "Programacion", 2);
INSERT INTO Curso(codigo, nombre, codCarrera) VALUES (2, "Bases", 1);
INSERT INTO Curso(codigo, nombre, codCarrera) VALUES (3, "Arquitectura", 3);

--Profesor
INSERT INTO Profesor(rut, nombre) VALUES (998887776, "Carlos");
INSERT INTO Profesor(rut, nombre) VALUES (778889996, "Sebastian");
INSERT INTO Profesor(rut, nombre) VALUES (445556669, "Luis");

--ProfesorParalelo
INSERT INTO ProfesorParalelo(correlativoPP, numParalelo, semestre, año, codCurso, rutProfesor) VALUES (1, 10, 1, 2020, 2, 2);
INSERT INTO ProfesorParalelo(correlativoPP, numParalelo, semestre, año, codCurso, rutProfesor) VALUES (2, 20, 1, 2020, 1, 1);
INSERT INTO ProfesorParalelo(correlativoPP, numParalelo, semestre, año, codCurso, rutProfesor) VALUES (3, 30, 1, 2020, 1, 1);

--Notas
INSERT INTO Notas(correlativoN, nota, Estudianterut, ProfesorParalelocorrelativoPP) VALUES (1, 4, 191000137, 1);
INSERT INTO Notas(correlativoN, nota, Estudianterut, ProfesorParalelocorrelativoPP) VALUES (2, 5, 112223334, 1);
INSERT INTO Notas(correlativoN, nota, Estudianterut, ProfesorParalelocorrelativoPP) VALUES (3, 6, 443332221, 1);


/*
B Aplicar consultas y cambios a la base de datos
TODO: TERMINAR CON LOS METODOS
*/
--1
SELECT e.rut, e.nombre, c.carreraMinor 
FROM Estudiante e INNER JOIN carrera c on e.carreraMinor = c.codigo 
WHERE carrera = c.nombre and e.carreraMayor = (SELECT m.codigo from carrera m WHERE m.codigo = e.carreraMayor);
--2
SELECT e.rut, e.nombre 
FROM Estudiante e inner join Notas n ON n.rutEstud = e.rut 
WHERE n.correlativoPP = (SELECT pp.correlativoPP FROM ProfesorParalelo pp WHERE rutProfesor = pp.rutProfesor); 
--3
SELECT e.rut, e.nombre 
FROM Estudiante e INNER JOIN Notas n ON n.rutEstud = e.rut 
WHERE NOT EXIST(SELECT * FROM ProfesorParalelo pp INNER JOIN Profesor p ON pp.rutProfesor = p.rut WHERE n.correlativoPP = pp.correlativoPP and p.nombre = nombre);
--4
SELECT c.nombre, COUNT() 
FROM Carrera c INNER JOIN Estudiante e in c.codigo = e.carreraMayor 
GROUP BY(c.nombre) 
ORDER BY(COUNT);

/*
* C Programa PL-SQL
*/
--Procedimiento de inserción (Hecho por mi)
/*
PROCEDURE insert_employee (my_rut varchar(255), my_name varchar(255), my_salary NUMBER, my_bossrut varchar(255), my_deptCode) IS
    aux NUMBER(1) := 0;
BEGIN
    --Buscar en la base de datos si el empleado existe, guardandolo en una variablable auxiliar
    aux = SELECT COUNT(*) FROM Empleado WHERE Empleado.rut = my_rut;
    IF aux = 1 THEN
        RAISE employee_found;
    ELSE
        INSERT INTO Empleado VALUES (my_rut, my_name, my_salary, my_bossrut, my_deptCode);
    END IF;
EXCEPTION
    --Cuando no existe el empleado
    WHEN employee_found THEN
        --Actualizar el salario del empleado, llamando al procedimiento A

END;
*/

PROCEDURE I_type (rut movimiento.rut%TYPE, nombre movimiento.nombre%TYPE, 
salario movimiento.salario%TYPE, rutJefe movimiento.rutJefe%TYPE, 
codDepto movimiento.codDepto%TYPE, accion movimiento.accion%TYPE)

BEGIN
    INSERT INTO Empleado VALUES (rut, nombre, salario, rutJefe, codDepto);
END; 

-- Procedimiento de Actualización
/*PROCEDURE update_salary
begin
  
exception
  when no_data_found then
    ;
end;*/

PROCEDURE A_type (rutEmpleado movimiento.rut%TYPE, 
salarioNuevo movimiento.salario%TYPE)

BEGIN
    UPDATE Empleado SET salario = salarioNuevo WHERE rut = rutEmpleado;
END; 

-- Procedimiento de Eliminación

PROCEDURE E_type (rutEmpleado movimiento.rut%TYPE)

BEGIN
    DELETE FROM movimiento WHERE rut = rutEmpleado;
END; 

-- Main (Chamorro)
DECLARE
rut             movimiento.rut%TYPE;
nombre          movimiento.nombre%TYPE;
salario         movimiento.salario%TYPE;
rutJefe         movimiento.rutJefe%TYPE;
codDepto        movimiento.codDepto%TYPE;
accion          movimiento.accion%TYPE;
aux             NUMBER(1);
CURSOR my_cursor IS SELECT rut, nombre, salario, rutJefe, codDepto, accion FROM
movimiento
BEGIN
aux = 0;
OPEN my_cursor;
LOOP
    FETCH my_cursor INTO rut, nombre, salario, rutJefe, codDepto, accion;
    EXIT WHEN my_cursor%NOTFOUND;
    IF accion = 'I' THEN
        aux = SELECT COUNT() FROM movimiento m WHERE m.rut = rut; 
        IF AUX = 0 THEN
            I_type(rut, nombre, salario, rutJefe, codDepto);
        ELSE
            A_type(rut, salario);
        END IF;
    ELSE
        IF accion = 'A' THEN
            aux = SELECT COUNT() FROM movimiento m WHERE m.rut = rut; 
            IF AUX = 0 THEN
                I_type(rut, nombre, salario, rutJefe, codDepto);
            ELSE
                A_type(rut, salario);
            END IF;
        ELSE
            IF accion = 'E' THEN
                aux = SELECT COUNT(*) FROM movimiento m WHERE m.rut = rut; 
                IF AUX = 0 THEN
                    DBMS_OUTPUT.PUT_LINE ('No existe el rut en el sistema.');
                ELSE
                    E_type(rut);
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE ('No existe esa accion en el sistema.');
            END IF;
        END IF;
    END IF;
END LOOP;
CLOSE my_cursor;
COMMIT;
END;

/*
* D Trigger PL-SQL 
*/
CREATE TRIGGER verificacion_salarios
BEFORE INSERT ON Empleado
DECLARE
    salaux  Empleado.salario%TYPE;
BEGIN
    salaux := SELECT SUM(salario) FROM Empleado WHERE codDepto = :new.codDepto;
    salaux := salaux + :new.salario;
    IF salaux > 50000000 THEN
         DBMS_OUTPUT.PUT_LINE ('Inserción rechazada.');
            RAISE_APPLICATION_ERROR
            (-20501,'Error: El sueldo de los empleados del departamento' +
              ' supera el monto maximo.');
    ELSE
        DBMS_OUTPUT.PUT_LINE ('Inserción exitosa.');
    END IF;
END; 
 /*
* E Trigger PL-SQL
*/
TRIGGER E

CREATE TRIGGER verificacion_depto
BEFORE INSERT ON Empleado
DECLARE
    codaux  Empleado.codDepto%TYPE;
BEGIN
    codaux := SELECT codDepto FROM Empleado WHERE rut = :new.rutJefe;
    IF :new.codDepto != codaux THEN
        DBMS_OUTPUT.PUT_LINE ('Inserción rechazada');
        RAISE_APPLICATION_ERROR
            (-20501,'Error: El empleado no corresponde al departamento de su jefe');
    ELSE
        DBMS_OUTPUT.PUT_LINE ('Inserción exitosa');
    END IF;
END;

/*
* F Trigger PL-SQL
*/
CREATE TRIGGER verificacion_subordinados
BEFORE INSERT ON Empleado
DECLARE
    aux  NUM(1) := 0;
BEGIN
    aux := SELECT COUNT(*) FROM Empleado WHERE rutJefe = :new.rutJefe;
    IF aux > 4 THEN
         DBMS_OUTPUT.PUT_LINE ('Inserción rechazada.');
            RAISE_APPLICATION_ERROR
            (-20501,'Error: Se alcanzo el maximo de subordinados del ' +
             'jefe asignado.');
    ELSE
        DBMS_OUTPUT.PUT_LINE ('Inserción exitosa.');
    END IF;
END;
