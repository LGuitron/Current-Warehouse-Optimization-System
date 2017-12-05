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
	if($status=='solutionID')
	{

		// Abrimos conexion
		$enlace = conectar();

		// Revisa el ultimo registro de solucion generado
		$sql = 'SELECT MAX(id) FROM solutions;';

		// Realizamos query y cerramos enlace
    $res = pg_query($enlace, $sql);
		pg_close($enlace);

		// Se le da formato para regresarlo como JSON
    $i=0;
    $rows = array();
    while($r = pg_fetch_array($res))
		{
      $rows['max'] = $r['max'];
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
