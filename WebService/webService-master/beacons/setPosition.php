<?php
	require("conectar.php");

	// Revisa si enviaron parametros
	if(isset($_POST['s']) && isset($_POST['position']) && isset($_POST['id']))
	{
		$position = $_POST['position'];
		$id = $_POST['id'];
		$status = $_POST['s'];
	}
	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='setPosition')
	{

		// Abrimos conexion
		$enlace = conectar();
		// Actualizar la position de un beacon
		$sql = 'UPDATE beacons SET position = $1 WHERE id = $2;';

		$sqlName = 'setPosition';

		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

		// Pasamos los parametros para el WHERE
		$res = pg_execute($sqlName, array($position,$id));

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
