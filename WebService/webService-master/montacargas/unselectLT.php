<?php
	require("conectar.php");
	//$_POST = $_POST[0];

	// Revisa si enviaron parametros
	if(isset($_POST['s']) && isset($_POST['lt']))
	{
		$lt = $_POST['lt'];
		$status = $_POST['s'];
	}
	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='unselectLT')
	{
		// Abrimos conexion
		$enlace = conectar();
		// Update lift_truck to 0 = free to use
		$sql = 'UPDATE lift_trucks SET status = 0 WHERE id= $1;';

		$sqlName = 'unselectLT';

		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

		$res = pg_execute($sqlName, array($lt));

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
			$rows['status'] = '030';

	}
	else
	{
		$rows['status'] = '040';
	}
	print json_encode($rows);

?>
