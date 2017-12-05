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

	if($status=='solutionInfo')
	{

		$enlace = conectar();

		$sql = 'select users.name as u_name, wh_types.name as wh_name ,since, until, time_reduction, distance_reduction, solutions.created_at, reserveperc  
                from solutions 
                Inner join users on (users.id = solutions.user_id)
                Inner join rearrangements on (rearrangements.solution_id = solutions.id)
                Inner join sections on (rearrangements.initial_section = sections.id)
                Inner join wh_types on (wh_types.type = sections.type)
                where solutions.id = $1
                group by solutions.id, users.name, wh_types.name ,since, until, time_reduction, distance_reduction, solutions.created_at
                order by solutions.created_at DESC, solutions.id DESC';
		
		
        $sqlName = 'solutionInfo';
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
			$rows[$i]['u_name'] = $r['u_name'];
			$rows[$i]['wh_name'] = $r['wh_name'];
			$rows[$i]['since'] = $r['since'];
            $rows[$i]['until'] = $r['until'];
            $rows[$i]['time_reduction'] = $r['time_reduction'];
            $rows[$i]['distance_reduction'] = $r['distance_reduction'];
            $rows[$i]['reserveperc'] = $r['reserveperc'];
            $rows[$i]['created_at'] = $r['created_at'];
            $i++;
		}
		print json_encode($rows);

	}
	else
	{
		$rows['status'] = '040';
		print json_encode($rows);
	}

?>
