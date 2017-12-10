<?php
	require("conectar.php");

	// Revisa si enviaron parametros
	if(isset($_POST['s']) && isset($_POST['y']) && isset($_POST['id']))
	{
		$y = $_POST['y'];
		$id = $_POST['id'];
		$status = $_POST['s'];
	}
	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='setY')
	{

		// Abrimos conexion
		$enlace = conectar();
		// Actualiza la Y de un beacon 
		$sql = 'UPDATE beacons SET y = $1 WHERE id = $2;';

		$sqlName = 'setY';

		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

		// Pasamos los parametros para el WHERE
		$res = pg_execute($sqlName, array($y,$id));

		$sql = sprintf('DEALLOCATE "%s"',pg_escape_string($sqlName));

		// Realizamos query y cerramos enlace
		if(!pg_query($sql))
		{
	    		die("Can't query '$sql': " . pg_last_error());
		}
		pg_close($enlace);

		if(pg_affected_rows($res)!=0)
		{
			$rows['status'] = '001';
		}
	  	else
			$rows['status'] = '040';

		print json_encode($rows);


	}
	else
	{
		$rows['status'] = '040';
		print json_encode($rows);
	}

?>
