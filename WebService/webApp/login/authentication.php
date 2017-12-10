<?php

 require("conectar.php");
 
 //$_POST = json_decode(file_get_contents('php://input'), true);
 //$_POST = json_decode($_GET['data'],true);
 $_POST = $_POST[0];
 if(isset($_POST['user'])&&isset($_POST['pwd'])&&isset($_POST['s']))
 {
  $user = $_POST['user'];
  $pwd = $_POST['pwd'];
  $status = $_POST['s'];
 }
 else
  die ("020");
	
 if($status=='r'&&isset($_POST['name']))
 {
	$name = $_POST['name'];
	$query = "SELECT id FROM users ORDER BY id DESC LIMIT 1;";
	$enlace = conectar();
	$result = pg_query($enlace, $query) or die("010");
	pg_close($enlace);
	$arr = array();
	while($row = pg_fetch_assoc($result))
	$arr[] = $row;
	$arr = $arr[0];
	$id = $arr['id'];
	$id++;
	$query = "INSERT INTO users (id,name,username,password) values ($id, '$name','$user', '$pwd');";
	$enlace = conectar();
	$result = pg_query($enlace, $query) or die("020");
	pg_close($enlace);
	echo "{\"status\":\"001\"}";	
 }
 elseif($status=='a')
 {

	$enlace = conectar();

	$sql = 'SELECT name, username FROM users WHERE username=$1 AND password=$2;';

	$sqlName = 'auten';

	if (!pg_prepare ($enlace,$sqlName, $sql)) 
		{
			die("Can't prepare '$sql': " . pg_last_error());
		}

	$res = pg_execute($sqlName, array($user,$pwd));

	$sql = sprintf(
	    'DEALLOCATE "%s"',
	pg_escape_string($sqlName)
  	);

	if(!pg_query($sql)) 
	{
    		die("Can't query '$sql': " . pg_last_error());
	}

  	pg_close($enlace);
	if(pg_num_rows($res)==1)
	{ 
		$r = pg_fetch_array($res);
		$rows = array();
		$rows['status'] = 001;
		$rows['name'] = $r['name'];
		print json_encode($rows);
	}
	else
		echo "040";

	/*$query = "SELECT name, username FROM users WHERE username='$user' AND password='$pwd';";
	$enlace = conectar();
	$result = pg_query($enlace, $query) or die("020");
	pg_close($enlace);

	if(pg_num_rows($result)==1)
	{ 
		$r = pg_fetch_array($result);
		$rows = array();
		$rows['status'] = 001;
		$rows['name'] = $r['name'];
		print json_encode($rows);
	}
	else
		echo "040";*/

 }
 else
  echo "030";

?>	
