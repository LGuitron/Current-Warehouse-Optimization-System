<?php
	require("conectar.php");
	$_POST = $_POST[0];

	// Revisamos si recibimos parametros
	if(isset($_POST['s']))
	{
		$status = $_POST['s'];
	}
	else
		die ("020");

	if($status=='zoneNames')
	{
		// Abrimos conexion
		$enlace = conectar();
		// Regresa todos los tipos de almaceon
		$sql = 'SELECT type, name FROM wh_types';

		$sqlName = 'zoneNames';

		// Hacemos el query y cerramos conexion
    $res = pg_query($enlace, $sql);
		pg_close($enlace);

		// Se regresa con formato JSON
    $i=0;
    $rows = array();
    while($r = pg_fetch_array($res))
		{
	    $rows[$i]['type'] = $r['type'];
	    $rows[$i]['name'] = $r['name'];
  		$i++;
		}
		print json_encode($rows);
	}
	else
	{
		$rows['status'] = '040';
		print json_encode($rows);
	}

?>
