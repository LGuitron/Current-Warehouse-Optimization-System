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
	if($status=='verticalCost')
	{

		// Abrimos conexion
		$enlace = conectar();
		// Regresa el costo desde el piso 1 de una seccion hasta el piso X
		$sql = 'SELECT initial_section, final_section, time, initial.type as initial_type, final.type as final_type
                FROM routes
                INNER JOIN sections as initial ON (routes.initial_section=initial.id)
                INNER JOIN sections as final ON (routes.final_section=final.id)
                WHERE
                (initial.floor = 1
                AND initial.type = $1
                AND final.floor IS NULL)
                OR
                (final.floor = 1
                AND final.type = $1
                AND initial.floor IS NULL);';

		$sqlName = 'profile';

		// Preparamos el statement
		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}
		// Pasamos parametros al WHERE
		$res = pg_execute($sqlName, array($type));

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
			$rows[$i]['final_section'] = $r['final_section'];
			$rows[$i]['time'] = $r['time'];
			$rows[$i]['initial_type'] = $r['initial_type'];
			$rows[$i]['final_type'] = $r['final_type'];
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
