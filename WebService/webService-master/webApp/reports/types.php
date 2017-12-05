<?php
	require("conectar.php");
	$enlace = conectar();

	$res = pg_query($enlace, "SELECT DISTINCT type FROM public.sections ORDER BY type ASC LIMIT 20;");
	pg_close($enlace);
	$i=0;
	$rows = array();
	while($r = pg_fetch_array($res)) 
	{
		$rows[$i]['type'] = $r['type'];
		$i++;
	}
	print json_encode($rows);
?>	
