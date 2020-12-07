<?php
// Archivo de conexión a MySQL.
// Definimos los 4 datos de la conexión.
$db_host = "localhost";
$db_user = "root";
$db_pass = "";
$db_base = "midv";

// Abrimos la conexión.
$conexion = mysqli_connect($db_host, $db_user, $db_pass, $db_base);

// Verificamos que haya abierto correctamente.
if(!$conexion) {
    echo "Error al conectar con MySQL";
    exit;
}

// Aclaramos que queremos todos los textos en UTF-8.
mysqli_set_charset($conexion, 'utf8mb4');







