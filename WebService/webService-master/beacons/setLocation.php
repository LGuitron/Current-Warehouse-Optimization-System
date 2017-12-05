<?php
require("conectar.php");
//$_POST = json_decode(file_get_contents('php://input'), true);

// Revisamos que recibimos parametros
if(isset($_POST["route_id"]) && isset($_POST["lift_truck_id"]) && isset($_POST["section_id"]) && isset($_POST["pos_x"]) && isset($_POST["pos_y"]))
{
	$route_id = $_POST["route_id"];
	$lift_truck_id = $_POST["lift_truck_id"];
	$section_id = $_POST["section_id"];
	$pos_x = $_POST["pos_x"];
	$pos_y = $_POST["pos_y"];
}
else
	die("020");

// Inserta una nueva ubicacion
$query = "INSERT INTO locations (route_id,lift_truck_id,section_id,pos_x,pos_y) VALUES($route_id,$lift_truck_id,$section_id,$pos_x,$pos_y);";
$enlace = conectar();
$result = pg_query($enlace, $query) or die("010");
pg_close($enlace);
echo "001";
?>
