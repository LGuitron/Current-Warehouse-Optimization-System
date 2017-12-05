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
	if($status=='prodXsection')
	{

		// Abrimos conexion
		$enlace = conectar();

		// 
		$sql = 'SELECT sectionDraw.id, beacon_id, initial_x, initial_y, final_x, final_y, type, cost, floor, products.name
                FROM
                (SELECT sections.id as id, beacons.id as beacon_id, initial.x as initial_x, initial.y as initial_y, final.x as final_x, final.y as final_y, type, cost, floor, unnest(data) as data
                FROM sections
                INNER JOIN beacons ON (beacons.id = sections.beacon_id)
                INNER JOIN vertexes as initial ON (beacons.vertex_1 = initial.id)
                INNER JOIN vertexes as final ON (beacons.vertex_2 = final.id)
                INNER JOIN inventory ON (sections.id = inventory.section_id)
                ORDER BY sections.id ASC) as sectionDraw
                INNER JOIN products ON (sectionDraw.data = products.ean);';


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
