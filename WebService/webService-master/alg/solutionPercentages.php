<?php
	require("conectar.php");
	$_POST=$_POST[0];

	// Revisa si enviaron parametros
    if(isset($_POST['s'])&& isset($_POST['time']) && isset($_POST['distance']) && isset($_POST['solution_id']))
	{
		$status = $_POST['s'];
        $solution_id=$_POST['solution_id'];
        $time=$_POST['time'];
        $distance=$_POST['distance'];
	}
	else
	{
        die("020");
	}

	// Si es correcto el status entra al query
	if($status=='solutionPercentages')
	{
		// Abrimos conexion
        $enlace = conectar();

				// Actualiza tabla de solution otorgandole una optimizacion de tiempo y distancia
        $sql = 'UPDATE solutions SET time_reduction = $1, distance_reduction = $2 WHERE id = $3;';

        $sqlName = 'solutionPercentages';
        if (!pg_prepare ($enlace,$sqlName, $sql))
        {
            ("Can't prepare '$sql': " . pg_last_error());
        }

        $res = pg_execute($sqlName, array($time, $distance, $solution_id));

				// Realizamos query y cerramos enlace
        if(pg_affected_rows($res)!=0)
        {
            $rows['status'] = '001';
        }
        else
            $rows['status'] = '039';
        print json_encode($rows);
    }
    else
    {
        $rows['status'] = '040';
        print json_encode($rows);
    }
?>
