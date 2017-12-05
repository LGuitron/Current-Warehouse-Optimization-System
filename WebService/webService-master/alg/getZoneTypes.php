<?php
	require("conectar.php");
	$_POST = $_POST[0];

	// Revisa si enviaron parametros
	if(isset($_POST['s']))
	{
		$status = $_POST['s'];
	}
	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='getZoneTypes')
	{

		// Abrimos conexion
		$enlace = conectar();

		// Regresa todos los diferentes tipos de secciones que existen en el almacen de producto solamente.
		$sql = 'SELECT distinct type FROM sections WHERE type >= 2 ORDER BY type ASC';

		$sqlName = 'getZoneTypes';

    //Realizamos query y cerramos enlace    
    $res = pg_query($enlace, $sql);
		pg_close($enlace);

		// Se le da formato para regresarlo como JSON
    $i=0;
    $rows = array();
    while($r = pg_fetch_array($res))
		{
      $rows[$i]['type'] = $r['type'];
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
