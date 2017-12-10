<?php
	require("conectar.php");
	$_POST = $_POST[0];

	// Revisa si enviaron parametros
	if(isset($_POST['s']) && isset($_POST['type']) && isset($_POST['secondFloor']))
	{
		$type = $_POST['type'];
		$secondFloor = $_POST['secondFloor'];
		$status = $_POST['s'];
	}

	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='upVerticalCost')
	{

		// Abrimos conexion
		$enlace = conectar();
		// Revisa el ultimo registro de solucion generado
		$sql = 'SELECT AVG(time) as average
                FROM routes
                INNER JOIN sections as initial ON(routes.initial_section = initial.id)
                INNER JOIN sections as final ON(routes.final_section = final.id)
                WHERE
                (initial.type = $1 AND final.type = 1 AND initial.floor = $2)
                OR(final.type = $1 AND initial.type = 1 AND final.floor = $2);';

		$sqlName = 'profile';
		// Preparamos el statement
		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}
		// Pasamos los parametros al WHERE
		$res = pg_execute($sqlName, array($type, $secondFloor));

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
            if(!is_null($r['average']))
            {
                $rows[$i]['average'] = $r['average'];
                $i++;
			}
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
