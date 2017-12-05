<?php
	require("conectar.php"); 
	$_POST = $_POST[0];

	if(isset($_POST['s']) && isset($_POST['user']) && isset($_POST['main_freq']))
	{
		$user = $_POST['user'];
		$main_freq = $_POST['main_freq'];
		$status = $_POST['s'];
	}
	else
		die ("020");
	
	if($status=='main_freq')
	{

		$enlace = conectar();
		$sql = 'UPDATE users SET main_freq = $1 WHERE username= $2;';

		$sqlName = 'profile';

		if (!pg_prepare ($enlace,$sqlName, $sql)) 
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

		$res = pg_execute($sqlName, array($main_freq,$user));

		$sql = sprintf('DEALLOCATE "%s"',pg_escape_string($sqlName));

		if(!pg_query($sql)) 
		{
	    		die("Can't query '$sql': " . pg_last_error());
		}
		pg_close($enlace);

		if(pg_affected_rows($res)!=0)
		{
			$rows['status'] = '001';
		}
	  	else
			$rows['status'] = '040';
		
		print json_encode($rows);
		
		
	}
	else
	{
		$rows['status'] = '040';
		print json_encode($rows);
	}

?>	
