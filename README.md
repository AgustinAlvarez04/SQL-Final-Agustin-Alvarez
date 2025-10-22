Descripción

Este proyecto consiste en un conjunto de scripts SQL para modelar, poblar y consultar una base de datos relacional que gestiona datos de usuarios y viviendas. Está pensado para demostrar conocimientos en diseño de esquemas, carga masiva de datos desde archivos CSV y ejecución de consultas complejas.

Tecnologías y formatos utilizados

SQL (dialecto según el gestor que uses — por ejemplo MySQL, PostgreSQL, etc.)

Archivos CSV para carga de datos (usuarios.csv, viviendas.csv)

Scripts de construcción y carga:

PreEntrega - Limpia.sql — script de pre-entrega limpio

Final - No Comentarios.sql — script final sin comentarios


Documento PDF que describe el enunciado y entregables: Final Sql - Agustin Alvarez.pdf

Flujo para ejecución

Para ejecutar correctamente el proyecto, sigue estos pasos:

1. Crear el esquema / base de datos en tu gestor SQL.


2. Ejecutar el script que define las tablas (la parte correspondiente en PreEntrega - Limpia.sql o Final - No Comentarios.sql).


3. Cargar los datos desde los archivos CSV (usuarios.csv, viviendas.csv) en las tablas correspondientes.


4. Una vez cargados los datos, ejecutar el resto del script SQL (Final - No Comentarios.sql) para consultas, informes o manipulación adicional.


5. Verificar que no se presentan errores durante la ejecución de las consultas.



Contenido principal

Definición de tablas y relaciones entre usuarios y viviendas.

Inserción de datos en bloque desde CSV.

Consultas de extracción que pueden incluir filtros, joins, agregaciones y ordenamientos.

Limpieza y preparación del entorno (en caso de necesitar eliminar datos previos o reiniciar el esquema
