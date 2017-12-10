<?php
	require("conectar.php");

	// Revisa si enviaron parametros
	if(isset($_POST['s']) && isset($_POST['beacon_id']))
	{
		$beacon_id = $_POST['beacon_id'];
		$status = $_POST['s'];
	}
	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='floors')
	{

		// Abrimos conexion
		$enlace = conectar();

		// Regresa informacion de la seccion y sus niveles divididas por beacon_id
		$sql = 'SELECT id, beacon_id,capacity,type,cost,floor FROM public.sections WHERE beacon_id = $1;';

		$sqlName = 'floors';

		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

		// Pasamos los parametros para el WHERE
		$res = pg_execute($sqlName, array($beacon_id ));

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
			$rows[$i]['id'] = $r['id'];
			$rows[$i]['beacon_id'] = $r['beacon_id'];
			$rows[$i]['capacity'] = $r['capacity'];
			$rows[$i]['type'] = $r['type'];
			$rows[$i]['cost'] = $r['cost'];
			$rows[$i]['floor'] = $r['floor'];
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
