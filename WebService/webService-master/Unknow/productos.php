<?php
	/*require("conectar.php");
	$enlace = conectar();

	$res = pg_query($enlace, "SELECT ean, name FROM Products;");

	pg_close($enlace);
	$i=0;
	$rows = array();
	while($r = pg_fetch_array($res)) 
	{
		$rows[$i]['name'] = $r['name'];
		$rows[$i]['ean'] = $r['ean'];
		$i++;
	}
	print json_encode($rows);*/



 require("conectar.php");

 if(isset($_POST['s'])&&isset($_POST['ean']))
 {
	$status = $_POST['s'];
	$ean = $_POST['ean'];
 }
 else
  die ("020");
	

 if($status=='prod')
 {

	$enlace = conectar();
	
	$sql = 'SELECT ean, name FROM Products WHERE ean=$1;';

	$sqlName = 'prod';

	if (!pg_prepare ($enlace,$sqlName, $sql)) 
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

	$res = pg_execute($sqlName, array($ean));

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
        	$rows['ean'] = $r['ean'];
		$rows['name'] = $r['name'];
		$i++;
  	}
	print $rows['name'];
	//print json_encode($rows);

 }
 else
  echo "030";

?>	
