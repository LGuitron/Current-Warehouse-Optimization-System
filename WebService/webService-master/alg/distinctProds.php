<?php
	require("conectar.php");
	$_POST = $_POST[0];

	/*if(isset($_POST['s']) && isset($_POST['type']))
	{
		$type = $_POST['type'];
		$status = $_POST['s'];
	}*/

	// Revisa si enviaron parametros
  if(isset($_POST['s']))
	{
		$status = $_POST['s'];
	}
	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='distinctProds')
	{

		// Abrimos conexion
		$enlace = conectar();
        $sql = 'SELECT COUNT (ean)
                FROM products;';
		
        $res = pg_query($enlace, $sql);        
		pg_close($enlace);

    $i=0;
    $rows = array();
    while($r = pg_fetch_array($res))
		{
      $rows[$i]['count'] = $r['count'];
      $i++;
		}
		print json_encode($rows);


		/*$sql = 'SELECT COUNT (DISTINCT eans.ean)
                FROM
                (SELECT unnest(data) as ean
                FROM inventory
                INNER JOIN sections ON (inventory.section_id = sections.id)
                WHERE sections.type = $1) as eans;';


		$sqlName = 'distinctProds';

		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

		$res = pg_execute($sqlName, array($type));

		$sql = sprintf('DEALLOCATE "%s"',pg_escape_string($sqlName));

		if(!pg_query($sql))
		{
	    		die("Can't query '$sql': " . pg_last_error());
		}
		pg_close($enlace);
		$i=0;
		$rows = array();
		while($r = pg_fetch_array($res))
		{
			$rows[$i]['count'] = $r['count'];
			$i++;
		}
		if($i!=0)
			$rows['status'] = '001';
		else
			$rows['status'] = '030';
		print json_encode($rows);*/

	}
	else
	{
		$rows['status'] = '040';
		print json_encode($rows);
	}

?>
