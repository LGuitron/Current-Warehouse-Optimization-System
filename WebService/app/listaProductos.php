<?php
	require("conectar.php");
	$enlace = conectar();

	$res = pg_query($enlace, "SELECT ean, name FROM products;");
	pg_close($enlace);
	$i=0;
	$rows = array();
	while($r = pg_fetch_array($res)) 
	{
		$rows[$i]['name'] = $r['name'];
		$rows[$i]['ean'] = $r['ean'];
		$i++;
	}
	print json_encode($rows);
?>	
