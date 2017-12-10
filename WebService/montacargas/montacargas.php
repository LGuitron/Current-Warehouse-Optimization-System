<?php
	require("conectar.php");

	// Get the list of lift trucks on DB
	$query = "SELECT id FROM lift_trucks WHERE status=0 ORDER BY id ASC;";
	$res = connectQuery($query, "010");
	// $enlace = conectar();
	// $res = pg_query($enlace, $query);
	// pg_close($enlace);

	// Return it with JSON format
	$i=0;
	$rows = array();
	while($r = pg_fetch_array($res)){
		$rows[$i]['id'] = $r['id'];
		$i++;
	}
	print json_encode($rows);
?>
