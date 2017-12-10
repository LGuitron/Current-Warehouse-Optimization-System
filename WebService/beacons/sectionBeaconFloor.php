<?php
	require("conectar.php");
	// Abrimos conexion
	$enlace = conectar();

	// Realizamos query y cerramos enlace
	$res = pg_query($enlace, "SELECT public.sections.id as section_id, public.beacons.id as beacon_id, public.beacons.minor as beacon_minor, public.sections.floor FROM public.sections, public.beacons WHERE public.sections.beacon_id = public.beacons.id AND public.beacons.has_beacon = TRUE;");
	pg_close($enlace);
	// Se le da formato para regresarlo como JSON
	$i=0;
	$rows = array();
	while($r = pg_fetch_array($res))
	{
		$rows[$i]['section_id'] = $r['section_id'];
		$rows[$i]['beacon_id'] = $r['beacon_id'];
		$rows[$i]['beacon_minor'] = $r['beacon_minor'];
		$rows[$i]['floor'] = $r['floor'];
		$i++;
	}
	print json_encode($rows);
?>
