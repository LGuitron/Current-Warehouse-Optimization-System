<?php

require("conectar.php");

// Initialize data ---------------------------------
if(isset($_POST['ean']))
    $ean = $_POST['ean'];

if(isset($_POST['mnt']))
    $montacargas = $_POST['mnt'];

if(isset($_POST['pid']))
    $pid = $_POST['pid'];

// -------------------------------------------------

// Get the initial section to return ean to inventory table -------------------------------
$query = "SELECT initial_section FROM routes WHERE lift_truck_id='$montacargas' AND product_id='$pid' AND ean='$ean';";
$result = connectQuery($query, "010");
// $enlace = conectar();
// $result = pg_query($enlace, $query) or die("010");
// pg_close($enlace);

$section = array();
while($r = pg_fetch_assoc($result))
    $section[] = $r;
$section = $section[0]['initial_section'];
// ----------------------------------------------------------------------------------------

// Data from final_section------------------------------------------------------------------------------------
$query = "SELECT unnest(data) FROM inventory INNER JOIN sections ON (sections.id = inventory.section_id) WHERE inventory.section_id='$section';";
$result = connectQuery($query, "020");
// $enlace = conectar();
// $result = pg_query($enlace, $query) or die("020");
// pg_close($enlace);

// -----------------------------------------------------------------------------------------------------------

$inv = array();
while($row = pg_fetch_assoc($result))
    $inv[] = $row;

// Add new ean to inventory in final_section ---------------------
$arr = array($ean);
foreach($inv as $key => $val){
    $arr[] = $val['unnest'];
}
// ---------------------------------------------------------------

// Build the string to push  ------------------------------------------------------------
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
// --------------------------------------------------------------------------------------

// Delete route from table ----------------------------------------------------------------------------------------
$query = "DELETE FROM routes WHERE lift_truck_id='$montacargas' AND product_id='$pid' AND ean='$ean';";
$result = connectQuery($query, "030");
// $enlace = conectar();
// $result = pg_query($enlace, $query) or die("030");
// pg_close($enlace);
// ---------------------------------------------------------------------------------------------------------------=

echo "001";
?>
