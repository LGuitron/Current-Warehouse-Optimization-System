<?php
	require("conectar.php");
	$_POST=$_POST[0];

	// Revisa si enviaron parametros
    if(isset($_POST['s'])&& isset($_POST['uid']) && isset($_POST['since']) && isset($_POST['until']) && isset($_POST['reservePercent']))
	{
		$status = $_POST['s'];
        $uid=$_POST['uid'];
        $since=$_POST['since'];
        $until=$_POST['until'];
        $reservePercent=$_POST['reservePercent'];
	}
	else
	{
        die("020");
	}

	// Si es correcto el status entra al query
	if($status=='insertSolution')
	{
		// Abrimos conexion
        $enlace = conectar();
        $since = date('Y-m-d', strtotime($since));
        $until = date('Y-m-d', strtotime($until));

				// Genera una nueva solution entre ciertas fechas
        $sql = 'INSERT INTO solutions (user_id, since, until, reserveperc) VALUES ($1, $2, $3, $4)';

        $sqlName = 'insertSolution';
        if (!pg_prepare ($enlace,$sqlName, $sql))
        {
            ("Can't prepare '$sql': " . pg_last_error());
        }

				// Pasamos los parametros al WHERE
        $res = pg_execute($sqlName, array($uid, $since, $until, $reservePercent));

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
