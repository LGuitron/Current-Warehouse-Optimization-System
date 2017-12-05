<?php

 require("conectar.php");

 if(isset($_POST['s'])&&isset($_POST['mnt']))
 {
  $status = $_POST['s'];
  $mnt = $_POST['mnt'];
 }
 else
  die ("020");
	

 if($status=='gilt')
 {

	$enlace = conectar();

	$sql = 'SELECT product_id FROM routes WHERE lift_truck_id=$1 ORDER BY product_id DESC LIMIT 1;';

	$sqlName = 'mont';

	if (!pg_prepare ($enlace,$sqlName, $sql)) 
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

	$res = pg_execute($sqlName, array($mnt));

	$sql = sprintf(
	    'DEALLOCATE "%s"',
	pg_escape_string($sqlName)
  	);

	if(!pg_query($sql)) 
	{
    		die("Can't query '$sql': " . pg_last_error());
	}

  	pg_close($enlace);
	$i=0;
	$rows = array();
  	while($r = pg_fetch_array($res)) 
	{
        	$rows['product_id'] = $r['product_id'];
		$i++;
  	}
	print json_encode($rows);

 }
 else
  echo "030";

?>	
