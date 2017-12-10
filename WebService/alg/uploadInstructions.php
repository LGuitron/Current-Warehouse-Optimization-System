<?php
	require("conectar.php");
	$_POST=$_POST[0];

	// Revisa si enviaron parametros
    if(isset($_POST['s'])&& isset($_POST['step']) && isset($_POST['ean']) && isset($_POST['initial_section']) && isset($_POST['final_section']) && isset($_POST['solution_id']))
	{
		$status = $_POST['s'];
        $step=$_POST['step'];
        $ean=$_POST['ean'];
        $initial_section=$_POST['initial_section'];
        $final_section=$_POST['final_section'];
        $solution_id=$_POST['solution_id'];
	}
	else
	{
        die("020");
	}

	// Si es correcto el status entra al query
	if($status=='arrangeInstructions')
	{
		// Abrimos conexion
        $enlace = conectar();

				// Inserta nueva instruccion de reacomodo
        $sql = 'INSERT INTO rearrangements (step, ean, initial_section,final_section, solution_id)
                VALUES ($1, $2, $3, $4, $5);';

        $sqlName = 'arrangeInstructions';
				// Preparamos el statement
        if (!pg_prepare ($enlace,$sqlName, $sql))
        {
            ("Can't prepare '$sql': " . pg_last_error());
        }
				// Pasamos parametros al WHERE
        $res = pg_execute($sqlName, array($step, $ean, $initial_section,$final_section,$solution_id));

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
