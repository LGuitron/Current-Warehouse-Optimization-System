<?php
	require("conectar.php");
	$_POST = $_POST[0];

	// Revisa si enviaron parametros
	if(isset($_POST['s']))
	{
		$status = $_POST['s'];
	}
	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='sections')
	{

		// Abrimos conexion
		$enlace = conectar();

		// Retorna las secciones del almacen incluyendo pisos
		$sql = 'SELECT sections.id, initial.x as initial_x, initial.y as initial_y, final.x as final_x, final.y as final_y, type, cost, floor
                FROM sections
                INNER JOIN beacons ON (beacons.id = sections.beacon_id)
                INNER JOIN vertexes as initial ON (beacons.vertex_1 = initial.id)
                INNER JOIN vertexes as final ON (beacons.vertex_2 = final.id)
                ORDER BY  sections.type DESC, sections.id ASC;';

		$res = pg_query($enlace, $sql);
    pg_close($enlace);

		// Le damos formato para regresarlo como JSON
		$rows = array();
		$i=0;
		while($r = pg_fetch_assoc($res))
		{
      $rows[] = $r;
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
