<?php
	require("conectar.php");
	$_POST = $_POST[0];

	// Revisa si enviaron parametros
	if(isset($_POST['s']) && isset($_POST['startDate'])&& isset($_POST['endDate'])&& isset($_POST['type']))
	{
		$startDate = $_POST['startDate'];
		$endDate = $_POST['endDate'];
		$type = $_POST['type'];
		$status = $_POST['s'];
	}
	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='movementRegisters')
	{

		// Abrimos conexion
		$enlace = conectar();

		// Regresa rutas que van desde zonas tipo 1 a zonas de producto en un rango de tiempo
		$sql = 'SELECT initial_section, ean, time
                FROM routes
                INNER JOIN sections  as initial ON (routes.initial_section = initial.id)
                INNER JOIN sections as final ON (routes.final_section = final.id)
                WHERE routes.created_at >= to_timestamp($1, \'dd-mm-yyyy hh24:mi:ss\')
                AND routes.created_at <= to_timestamp($2, \'dd-mm-yyyy hh24:mi:ss\')
                AND initial.type = 1
                AND final.type = $3
                ORDER BY initial_section ASC;';

		$sqlName = 'movementRegisters';

		// Preparamos el statement
		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

		// pasamos los parametros al WHERE
		$res = pg_execute($sqlName, array($startDate,$endDate, $type));

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
			$rows[$i]['initial_section'] = $r['initial_section'];
			$rows[$i]['time'] = $r['time'];
            $rows[$i]['ean'] = $r['ean'];
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
