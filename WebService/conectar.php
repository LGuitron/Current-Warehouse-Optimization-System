<?php
  function conectar()
  {
    /*$vcap_services = json_decode($_ENV["VCAP_SERVICES"]);
    echo $_ENV["VCAP_SERVICES"];
    $db_url = $vcap_services->postgres[0]->credentials->dsn;
    $db_conn = pg_connect($db_url) or die('Could not connect: ' . pg_last_error());
    return $db_conn;*/
    $vcap_services = json_decode($_ENV["VCAP_SERVICES"]);
    $vcap_services=$vcap_services->{"postgres-2.0"}[0]->credentials;
    $username = $vcap_services->username;
    $password = $vcap_services->password;
    $db_name = $vcap_services->database;
    $host = $vcap_services->hostname;
    $port = $vcap_services->port;
    $db_url = "host=$host dbname=$db_name user=$username password=$password port=$port ";
    $db_conn = pg_connect($db_url) or die('Could not connect: ' . pg_last_error());
    return $db_conn;
  }

  function connectQuery($query, $err = "888"){
    $enlace = conectar();
    $result = pg_query($enlace, $query) or die($err);
    pg_close($enlace);

    return $result;
  }
?>
