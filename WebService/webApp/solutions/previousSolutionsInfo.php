<?php
	require("conectar.php");
	$_POST = $_POST[0];

	if(isset($_POST['s']))
	{
		$status = $_POST['s'];
	}
	else
		die ("020");

	if($status=='previousSolutionsInfo')
	{

		$enlace = conectar();

		$sql = 'select solutions.id, wh_types.name as wh_name, solutions.created_at 
                from solutions 
                Inner join users on (users.id = solutions.user_id)
                Inner join rearrangements on (rearrangements.solution_id = solutions.id)
                Inner join sections on (rearrangements.initial_section = sections.id)
                Inner join wh_types on (wh_types.type = sections.type)
                group by solutions.id, users.name, wh_types.name ,since, until, time_reduction, distance_reduction, solutions.created_at
                order by solutions.created_at DESC, solutions.id DESC';
		
        $res = pg_query($enlace, $sql);        
		pg_close($enlace);
        $i=0;
        $rows = array();
        while($r = pg_fetch_array($res)) 
		{
            $rows[$i]['id'] = $r['id'];
			$rows[$i]['wh_name'] = $r['wh_name'];
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
