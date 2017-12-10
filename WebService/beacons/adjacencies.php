<?php
	require("conectar.php");

	// Abrimos conexion
	$enlace = conectar();

	// Realizamos query y cerramos enlace
	$res = pg_query($enlace, "SELECT * FROM public.adjacencies;");
	pg_close($enlace);

	// Se le da formato para regresarlo como JSON
	$i=0;
	$rows = array();
	while($r = pg_fetch_array($res))
	{
		$rows[$i]['id'] = $r['id'];
		$rows[$i]['beacon_id'] = $r['beacon_id'];
		$rows[$i]['adjacent_beacon_id'] = $r['adjacent_beacon_id'];
		$i++;
	}
	print json_encode($rows);
?>
