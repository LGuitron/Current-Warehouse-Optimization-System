<?php
	require("conectar.php");

	// Revisa si enviaron parametros
	if(isset($_POST['s']) && isset($_POST['x']) && isset($_POST['id']))
	{
		$x = $_POST['x'];
		$id = $_POST['id'];
		$status = $_POST['s'];
	}
	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='setX')
	{

		// Abrimos conexion
		$enlace = conectar();
		// Actualizar la x de un beacon en especifico
		$sql = 'UPDATE beacons SET x = $1 WHERE id = $2;';

		$sqlName = 'setX';

		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

		// Pasamos los parametros para el WHERE
		$res = pg_execute($sqlName, array($x,$id));

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
