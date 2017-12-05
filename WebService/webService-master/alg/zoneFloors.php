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
	if($status=='zoneFloors')
	{

		// Abrimos conexion
		$enlace = conectar();
		// Regresa los pisos que tiene cierta seccion
		$sql = 'SELECT sections.id, floor
                FROM sections
                WHERE floor > 0 AND sections.type = $1
                ORDER By sections.id ASC , floor ASC;';

		$sqlName = 'profile';

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
			$rows[$i]['id'] = $r['id'];
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
