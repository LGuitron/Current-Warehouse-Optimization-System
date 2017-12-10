<?php

require("conectar.php");

$_POST = $_POST[0];

// Revisa si enviaron parametros
if(isset($_POST['s']) && isset($_POST['user'])){
  $user = $_POST['user'];
  $status = $_POST['s'];
} else
    die ("020");

    // Si es correcto el status entra al query
if($status=='getProfile'){

  // Abrimos conexion
  $enlace = conectar();
  // Obtiene los datos del perfil actual
  $sql = 'SELECT no_lt,energy_costs, transport_type, employee_cost, maintaince,main_freq FROM users WHERE username=$1;';
  $sqlName = 'profile';

  if (!pg_prepare ($enlace,$sqlName, $sql)){
		die("Can't prepare '$sql': " . pg_last_error());
  }
  // Pasamos los parametros para el WHERE
  $res = pg_execute($sqlName, array($user));
  $sql = sprintf('DEALLOCATE "%s"', pg_escape_string($sqlName));

  // Realizamos query y cerramos enlace
  if(!pg_query($sql)){
    die("Can't query '$sql': " . pg_last_error());
  }

	pg_close($enlace);

  // Se le da formato para regresarlo como JSON
  if(pg_num_rows($res) == 1){
  	$r = pg_fetch_array($res);
  	$rows = array();
  	$rows['status'] = 001;
  	$rows['no_lt'] = $r['no_lt'];
  	$rows['energy_costs'] = $r['energy_costs'];
  	$rows['transport_type'] = $r['transport_type'];
  	$rows['employee_cost'] = $r['employee_cost'];
  	$rows['maintaince'] = $r['maintaince'];
  	$rows['main_freq'] = $r['main_freq'];

  	print json_encode($rows);
  } else
  	 echo "040";

} else
    echo "030";

?>
