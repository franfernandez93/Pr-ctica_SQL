Mi modelo entidad relación consta de 6 Tablas , que son las siguientes: STUNDENT,TEACHER,BOOTCAMP,MODULE,PAYMENT,REGISTRATION.

Cada tabla tiene una PRIMARY KEY y unos campos.

La tabla Student conecta con la tabla Registration, Esta tiene clave foránea hacia Student y hacía Bootcamp , la razón es por que una matrícula puede tener un alumno , y un alumno puede estar matriculado en varias matrículas, y un registro , puede tener un bootcamp, y un bootcamp puede constar de varios registros de matricula.

La tabla Payment se compone de dos claves foráneas una hacía Student , por que un pago puede pertenecer a un alumno y a bootcamp, por que ese pago esta asociado a un bootcamp.

Por otro lado tenemos la Tabla Bootcamp , que conecta con module , registration y payment , con una PRIMARY KEY llamada id_bootcamp.

También tenemos la tabla MODULE la cual tiene su clave principal y dos claves Foráneas , las cuales hacen referencia a TEACHER, por que un modulo puede tener varios profesores
y un profesor puede dar varios modulos.También tenemos una foránea hacía BOOTCAMP , porque un modulo puede estar asociado a un BOOTCAMP , y unBOOTCAMP puede tener varios modulos.

Todas estas tablas tienen la restricción de NOT NULL en su mayoría de campos por que he decidido que sea así para poder tener campos rellenos , para hacer pruebas con ellos.