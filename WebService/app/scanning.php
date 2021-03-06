<?php

date_default_timezone_set('America/Mexico_City');
require("conectar.php");

//$ean = $_POST["ean"];
//$montacargas = $_POST["montacargas"];

// Initialize Data -------------------------------------------------

if(isset($_POST['ean']))
    $ean = $_POST['ean'];

if(isset($_POST['mnt']))
    $montacargas = $_POST['mnt'];

if(isset($_POST['sec']))
    $section = $_POST['sec'];

if(isset($_POST['time']))
    $time = $_POST['time'];

if(isset($_POST['pid']))
    $pid = $_POST['pid'];

// Status goes for Upload/Download
// 1 ~ Upload - 0 ~ Download
$status = 0;
if(isset($_POST['s']))
    $status = $_POST['s'];

$log = false;

// Upload a product
if($status){

  // initial_section inventory ----------------------------------------------------------------------
  $query = "SELECT unnest(data) FROM inventory WHERE section_id='$section';";
  $result = connectQuery($query, "110");
  // $enlace = conectar();
  // $result = pg_query($enlace, $query) or die("110");
  // pg_close($enlace);

  $inv = array();
  while($row = pg_fetch_assoc($result))
      $inv[] = $row;

  $arr = array();
  foreach($inv as $key => $val)
      $arr[] = $val['unnest'];

  $eanKey = array_search($ean, $arr);

  if(!is_bool($eanKey)){
      // Delete ean from old section
      unset($arr[$eanKey]);

      // Build the string
      $inv = "{";
      foreach($arr as $k => $v){
          $inv .= $v;
          if($v == end($arr))
              continue;
          $inv .= ",";
      }
      $inv .= "}";


  } else // If ean didn't exist on section, write a log
      $log = true;

  // Initialize the route
  $query = "INSERT INTO routes (lift_truck_id, initial_section, ean, product_id, date_time) VALUES ($montacargas, $section, $ean, '$pid', '$time');";
  $result = connectQuery($query, "120");
  // $enlace = conectar();
  // $result = pg_query($enlace, $query) or die("120");
  // pg_close($enlace);

  // Get id from initilized section
  $query = "SELECT id FROM routes WHERE lift_truck_id='$montacargas' AND initial_section='$section' AND ean='$ean' AND product_id='$pid' AND date_time='$time';";
  $result = connectQuery($query, "130");
  // $enlace = conectar();
  // $result = pg_query($enlace, $query) or die("130");
  // pg_close($enlace);

  $line = array();
  while($row = pg_fetch_assoc($result))
      $line[] = $row;
  $id = $line[0]['id'];

  // If need it write the log
  if($log){
      // Send log "The scanned ean doesn't exist on selected section"
      $query = "INSERT INTO logs (type, log, route_id) VALUES (1, 'El ean marcado no existe en la sección señalada. ERROR[1]', $id)";
  } else {
      // Update inventory to delete ean from initial_section
      $query = "UPDATE inventory SET data='$inv' WHERE section_id='$section';";
  }

// Download the product
} else {

  // Get data from the that route
  $query = "SELECT id, date_time, ean, initial_section FROM routes WHERE lift_truck_id='$montacargas' AND final_section IS NULL AND product_id='$pid';";
  $result = connectQuery($query, "210");
  // $enlace = conectar();
  // $result = pg_query($enlace, $query) or die("210");
  // pg_close($enlace);

  $line = array();
  while($row = pg_fetch_assoc($result))
      $line[] = $row;
  $line = $line[0];

  // Get time difference from route -----------------------------------
  $t = explode(" ", $time);
  $format = 'H:i:s';
  $created = DateTime::createFromFormat($format, $line['date_time']);
  $now = DateTime::createFromFormat($format, $t[1]);
  $diff = $now->diff($created);
  $h = $diff->format('%h');
  $m = $diff->format('%i');
  $s = $diff->format('%s');

  $time = $s + ($m * 60) + ($h * 60 * 60);
  // ------------------------------------------------------------------
  // Add ean to inventory on section selected ---------------------------------------------------------------------------------


  // final_section data
  $query = "SELECT unnest(data), capacity FROM inventory INNER JOIN sections ON (sections.id = inventory.section_id) WHERE inventory.section_id='$section';";
  $result = connectQuery($query, "220");
  // $enlace = conectar();
  // $result = pg_query($enlace, $query) or die("220");
  // pg_close($enlace);

  $inv = array();
  while($row = pg_fetch_assoc($result))
      $inv[] = $row;

  // Check if there is capacity for the new product, if not send a log
  if(count($inv) >= $inv[0]['capacity'] && !empty($inv))
      $log = true;

  // Add ean to new inventory
  $arr = array($ean);
  foreach($inv as $key => $val){
      $arr[] = $val['unnest'];
  }

  // Build string for inventory -----------------------------------------------
  $inv = "{";
  foreach($arr as $k => $v){
      $inv .= $v;
      if($k >= count($arr) - 1)
          continue;
      $inv .= ",";
  }
  $inv .= "}";

  $query = "UPDATE inventory SET data='$inv' WHERE section_id='$section';";
  $result = connectQuery($query, "230");
  // $enlace = conectar();
  // $result = pg_query($enlace, $query) or die("230");
  // pg_close($enlace);

  // --------------------------------------------------------------------------

  // Write the log
  if($log){
      $id = $line['id'];
      $query = "INSERT INTO logs (type, log, route_id) VALUES (2, 'La capacidad de la seccion esta rebazada', $id);";
      $result = connectQuery($query, "240");
      // $enlace = conectar();
      // $result = pg_query($enlace, $query) or die("240");
      // pg_close($enlace);
  }

  $query = "UPDATE routes SET final_section='$section', time='$time' WHERE id='".$line['id']."';";

}

$result = connectQuery($query, "010");
// $enlace = conectar();
// $result = pg_query($enlace, $query) or die("010");
// pg_close($enlace);

echo "001";
?>
