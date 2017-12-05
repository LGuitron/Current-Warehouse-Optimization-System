<?php
	require("conectar.php"); 
	$_POST = $_POST[0];

	if(isset($_POST['s']) && isset($_POST['solution_id']))
	{
		$solution_id = $_POST['solution_id'];
		$status = $_POST['s'];
	}
	else
		die ("020");
	
	if($status=='viewInstructions')
	{

		$enlace = conectar();
		/*$sql = 'select step, rearrangements.ean , products.name , initial_section, final_section, completed, initial.beacon_id as final_beacon, sections.floor as final_floor*/
		$sql = 'select step, rearrangements.ean , products.name , completed, initial.beacon_id as initial_zone, final.beacon_id as final_zone,
		initial.floor as initial_floor, final.floor as final_floor
                from rearrangements
                inner join products on (products.ean = rearrangements.ean)
                inner join sections initial on (initial.id = rearrangements.initial_section)
                inner join sections final on (final.id = rearrangements.final_section)
                where solution_id=$1
                order by step ASC';

		$sqlName = 'viewInstructions';

		if (!pg_prepare ($enlace,$sqlName, $sql)) 
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

		$res = pg_execute($sqlName, array($solution_id));

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
			$rows[$i]['step'] = $r['step'];
			$rows[$i]['ean'] = $r['ean'];
            $rows[$i]['name'] = $r['name'];
            //$rows[$i]['initial_section'] = $r['initial_section'];
			//$rows[$i]['final_section'] = $r['final_section'];
            $rows[$i]['initial_zone'] = $r['initial_zone'];
			$rows[$i]['initial_floor'] = $r['initial_floor'];
			$rows[$i]['completed'] = $r['completed'];
            $rows[$i]['final_zone'] = $r['final_zone'];
            $rows[$i]['final_floor'] = $r['final_floor'];
			$i++;
		}
		print json_encode($rows);
	}
?>	
