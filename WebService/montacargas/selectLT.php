<?php
	require("conectar.php");

	// Revisa si enviaron parametros
	if(isset($_POST['s']) && isset($_POST['lt']))
	{
		$lt = $_POST['lt'];
		$status = $_POST['s'];
	}
	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='selectLT')
	{

		// Abrimos conexion
		$enlace = conectar();
		// Selecciona un montacargas
		$sql = 'SELECT status FROM lift_trucks WHERE id=$1;';

		$sqlName = 'selectLT';

		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}
		// Le pasamos parametros al WHERE
		$res = pg_execute($sqlName, array($lt));

		$sql = sprintf('DEALLOCATE "%s"',pg_escape_string($sqlName));

		// Realizamos query y cerramos enlace
		if(!pg_query($sql))
		{
	    		die("Can't query '$sql': " . pg_last_error());
		}
		pg_close($enlace);

		// Se le da formato para regresarlo como JSON
		$i=0;
		$rows = array();
		while($r = pg_fetch_array($res))
		{
			if($r['status']==0)
			{
				$enlace = conectar();
				// Update status to 1 = occupied
				$sql = 'UPDATE lift_trucks SET status = 1 WHERE id= $1;';

				$sqlName = 'profile';

				if (!pg_prepare ($enlace,$sqlName, $sql))
				{
					die("Can't prepare '$sql': " . pg_last_error());
				}

				$res = pg_execute($sqlName, array($lt));

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
			{
				$rows['status'] = '030';
			}
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
