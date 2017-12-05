<?php
	require("conectar.php");
	// Abrimos conexion
	$enlace = conectar();
	// Obtener informacion de las secciones en cierto formato
  $query = "SELECT beacon_id, type, COUNT (beacon_id) as floors, capacity, cost FROM public.sections GROUP BY beacon_id, type, capacity, cost;";
	// Realizamos query y cerramos enlace
	$res = pg_query($enlace, $query);
	pg_close($enlace);
	// Se le da formato para regresarlo como JSON
	$i=0;
	$rows = array();
	while($r = pg_fetch_array($res))
	{
		$rows[$i]['beacon_id'] = $r['beacon_id'];
		$rows[$i]['floors'] = $r['floors'];
		$rows[$i]['capacity'] = $r['capacity'];
		$rows[$i]['cost'] = $r['cost'];
		$rows[$i]['type'] = $r['type'];
		$i++;
	}
	print json_encode($rows);
?>
