<?php
	require("conectar.php");
	// Abrimos conexion
	$enlace = conectar();

	// Realizamos query y cerramos enlace
	$res = pg_query($enlace, "SELECT id, uuid, major, minor,position,vertex_1,vertex_2, has_beacon FROM beacons;");
	pg_close($enlace);
	// Se le da formato para regresarlo como JSON
	$i=0;
	$rows = array();
	while($r = pg_fetch_array($res))
	{
		$rows[$i]['uuid'] = $r['uuid'];
		$rows[$i]['major'] = $r['major'];
		$rows[$i]['minor'] = $r['minor'];
		$rows[$i]['position'] = $r['position'];
		$rows[$i]['id'] = $r['id'];
		$rows[$i]['vertex_1'] = $r['vertex_1'];
		$rows[$i]['vertex_2'] = $r['vertex_2'];
		$rows[$i]['has_beacon'] = $r['has_beacon'];

		$i++;
	}
	print json_encode($rows);
?>
