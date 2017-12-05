<?php
	require("conectar.php");

	// Revisa si enviaron parametros
	if(isset($_POST['s']) && isset($_POST['minor']) && isset($_POST['id']))
	{
		$minor = $_POST['minor'];
		$id = $_POST['id'];
		$status = $_POST['s'];
	}
	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='updateMinor' && $minor=='n')
	{
		// Abrimos conexion
		$enlace = conectar();
		// Actualiza el minor de un beacon
		$sql = 'UPDATE beacons SET minor = NULL WHERE id = $1;';
		$sqlName = 'updateMinor';

		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}
		// Pasamos los parametros para el WHERE
		$res = pg_execute($sqlName, array($id));
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
	elseif($status=='updateMinor')
	{
		$enlace = conectar();
		$sql = 'SELECT * FROM beacons WHERE minor=$1;';

		$sqlName = 'updateMinor';

		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

		$res = pg_execute($sqlName, array($minor));

		$sql = sprintf('DEALLOCATE "%s"',pg_escape_string($sqlName));

		if(!pg_query($sql))
		{
	    		die("Can't query '$sql': " . pg_last_error());
		}
		pg_close($enlace);

		if(pg_num_rows($res)==0)
		{

			$enlace = conectar();
			$sql = 'UPDATE beacons SET minor = $1 WHERE id = $2;';

			$sqlName = 'updateMinor';

			if (!pg_prepare ($enlace,$sqlName, $sql))
			{
				die("Can't prepare '$sql': " . pg_last_error());
			}

			$res = pg_execute($sqlName, array($minor,$id));

			$sql = sprintf('DEALLOCATE "%s"',pg_escape_string($sqlName));

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
		}
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
