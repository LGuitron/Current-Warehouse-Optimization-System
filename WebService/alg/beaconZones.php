<?php
	require("conectar.php");
	$_POST = $_POST[0];

	// Revisa si enviaron parametros
	if(isset($_POST['s']) && isset($_POST['type']))
	{
		$type = $_POST['type'];
		$status = $_POST['s'];
	}
	else
		die ("020");

	// Si es correcto el status entra al query
	if($status=='beaconZones'){
		// Abrimos conexion
		$enlace = conectar();
		// Cuenta las secciones de un cierto tipo
		$sql = 'SELECT Count(sections.id)
                FROM sections
                WHERE type = $1;';

		$sqlName = 'profile';

		// Valida si se puede preparar el query
		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

		// Le pasamos las variables del WHERE
		$res = pg_execute($sqlName, array($type));

		$sql = sprintf('DEALLOCATE "%s"',pg_escape_string($sqlName));

		// Hacemos el query, preguntamos si hay error
		if(!pg_query($sql))
		{
	    		die("Can't query '$sql': " . pg_last_error());
		}
		// Cerramos conexion
		pg_close($enlace);

		//Le damos formato para regresarlo como JSON
		$i=0;
		$rows = array();
		while($r = pg_fetch_array($res))
		{
			$rows['count'] = $r['count'];
			$i++;
		}
		if($i!=0)
			$rows['status'] = '001';
		else
			$rows['status'] = '030';
		print json_encode($rows);


	}
	else
	{
		$rows['status'] = '040';
		print json_encode($rows);
	}

?>
