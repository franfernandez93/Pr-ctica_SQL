
--Creación de La tabla Alumnos

CREATE TABLE students (
	id_student  SERIAL PRIMARY KEY,	-- Crea un id de clave primaria  auto-incrementable
	student_name VARCHAR(50) NOT NULL,
	student_email VARCHAR(150) UNIQUE NOT NULL,
	student_n_telephone INT,
	student_adress VARCHAR(100),
	student_date_birth DATE,
	student_registration_date DATE,
	student_state VARCHAR(50) NOT NULL,
	nif_student INT NOT NULL 
);

ALTER TABLE students
Alter column student_surname DROP NOT NULL;



CREATE TABLE registration (
	id_registration SERIAL PRIMARY KEY, 
	id_student INT REFERENCES students(id_student),
	id_bootcamp INT REFERENCES bootcamp(id_bootcamp),
	registration_date DATE NOT NULL,
	registration_state VARCHAR(50) NOT NULL
);

CREATE TABLE bootcamp(
	id_bootcamp SERIAL PRIMARY KEY,
	name_bootcamp VARCHAR(100) NOT NULL,
	description_bootcamp VARCHAR(300) NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	price_bootcamp INT NOT NULL
);

CREATE TABLE teacher (
	id_teacher  SERIAL PRIMARY KEY,
	teacher_name VARCHAR(50) NOT NULL,
	teacher_surname VARCHAR(100) NOT NULL,
	teacher_email VARCHAR(100) NOT NULL,
	teacher_n_telephone INT,
	nif_teacher INT NOT NULL
);

CREATE TABLE module_bootcamp (
	id_teacher INT REFERENCES teacher(id_teacher),
	id_bootcamp INT REFERENCES bootcamp(id_bootcamp),
	start_date_module DATE NOT NULL,
	end_date_module DATE NOT NULL,
	description_module VARCHAR(300) NOT NULL
);

ALTER TABLE module_bootcamp
ADD  name_module VARCHAR(100) NOT NULL DEFAULT 'Nombre por defecto';

CREATE TABLE payment (
	id_stundet INT REFERENCES students(id_student),
	id_bootcamp INT REFERENCES bootcamp(id_bootcamp),
	payment_date DATE NOT NULL,
	payment_method VARCHAR(50) NOT NULL,
	payment_state VARCHAR(50)
);

-- Consulta para ver que alumnos aparecen con estado de ALTA
SELECT students.student_name AS students_ALTA


FROM students
WHERE student_state = 'ALTA';



--Selecciona el nombre del estudiante y la fecha de matrícula utilizando un LEFT JOIN

SELECT students.student_name, registration.registration_date
FROM students 
LEFT JOIN registration ON students.id_student = registration.id_student;


--selecciona los profesores que tienen un correo con la palabra gmail y lo ordena ascendentemente
SELECT teacher.teacher_email AS EMAIL_PROFESORES_CON_arroba

FROM teacher

WHERE teacher_email LIKE '%gmail%'

ORDER BY teacher.teacher_email ASC;

-- Suma el total de precios de todos los bootcamps
SELECT SUM(price_bootcamp) AS SUMA_PRECIO_BOOTCAMPS

FROM bootcamp;




