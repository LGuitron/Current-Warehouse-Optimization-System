<?php

require("conectar.php");

// Revisamos que se reciban parametros

if(isset($_POST['beacon']))
    $beacon = $_POST['beacon'];

if(isset($_POST['floor']))
    $floor = $_POST['floor'];

if(isset($_POST['type']))
    $type = $_POST['type'];

if(isset($_POST['capacity']))
    $capacity = $_POST['capacity'];

if(isset($_POST['cost']))
    $cost = $_POST['cost'];

// Borramos la seccion existente a un beacon
$query = "DELETE FROM sections WHERE beacon_id='$beacon';";
$enlace = conectar();
$result = pg_query($enlace, $query) or die("010");
pg_close($enlace);

// Insertamos los pisos neesarios por cada piso de secciones
for($i=1;$i<=$floor;$i++){
    $query = "INSERT INTO sections (beacon_id, capacity, type, cost, floor) VALUES ('$beacon', '$capacity', '$type', '$cost', '$i');";
    $enlace = conectar();
    $result = pg_query($enlace, $query) or die($i."10");
    pg_close($enlace);
}

echo "001";
?>
