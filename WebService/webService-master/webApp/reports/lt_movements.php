<?php
	require("conectar.php");
	$_POST = $_POST[0];

	if(isset($_POST['s']) && isset($_POST['startDate'])&& isset($_POST['endDate']))
	{
		$startDate = $_POST['startDate'];
		$endDate = $_POST['endDate'];
		$status = $_POST['s'];
	}
	else
		die ("020");

	if($status=='lt_movements')
	{

		$enlace = conectar();

		$sql = 'SELECT lift_truck_id, count(lift_truck_id) FROM public.routes WHERE routes.created_at >= to_timestamp($1, \'dd-mm-yyyy hh24:mi:ss\') AND routes.created_at <= to_timestamp($2, \'dd-mm-yyyy hh24:mi:ss\') GROUP BY lift_truck_id ORDER BY count DESC LIMIT 20;';

		$sqlName = 'lt_movements';

		if (!pg_prepare ($enlace,$sqlName, $sql))
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

		$res = pg_execute($sqlName, array($startDate,$endDate));

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
			$rows[$i]['y'] = $r['count'];
			$rows[$i]['label'] = intval($r['lift_truck_id']);
			$i++;
		}
		if($i==0)
			$rows['status'] = '030';
		print json_encode($rows);

	}
	else
	{
		$rows['status'] = '040';
		print json_encode($rows);
	}

?>
