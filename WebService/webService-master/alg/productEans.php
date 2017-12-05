<?php
	require("conectar.php");
	$_POST = $_POST[0];

	// Revisa si enviaron parametros
	if(isset($_POST['s']))
	{
		$status = $_POST['s'];
	}
	else
		die ("020");

		// Si es correcto el status entra al query
	if($status=='productEans')
	{

		// Abrimos conexion
		$enlace = conectar();

		// Regresa todos los eans
		$sql = 'SELECT ean from products order by ean ASC';

		// Realizamos query y cerramos enlace
        $res = pg_query($enlace, $sql);
		pg_close($enlace);

		// Se le da formato para regresarlo como JSON
    $i=0;
    $rows = array();
    while($r = pg_fetch_array($res))
		{
      $rows[$i]['ean'] = $r['ean'];
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
