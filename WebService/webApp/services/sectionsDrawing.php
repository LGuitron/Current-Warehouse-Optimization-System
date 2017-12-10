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
	if($status=='sectionsDraw')
	{
		// Abrimos conexion
		$enlace = conectar();
		// 
		$sql = 'SELECT beacons.id, AVG(initial.x) as initial_x, AVG(initial.y) as initial_y, AVG(final.x) as final_x, AVG(final.y) as final_y, AVG(sections.type) as type
                FROM sections
                INNER JOIN beacons ON (sections.beacon_id = beacons.id)
                INNER JOIN vertexes as initial ON (beacons.vertex_1 = initial.id)
                INNER JOIN vertexes as final ON (beacons.vertex_2 = final.id)
                GROUP BY beacons.id
                ORDER BY beacons.id ASC;';

		// Realizamos query y cerramos enlace
    $res = pg_query($enlace, $sql);
		pg_close($enlace);

		// Se le da formato para regresarlo como JSON
    $i=0;
    $rows = array();
    while($r = pg_fetch_array($res))
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
