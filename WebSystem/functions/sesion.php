<?php
//function to do the login
function iniciarSesion($usuario,$contrasena)
{
$hashed_password = hash("sha256",$contrasena);
$postData = array(
    'user' => "$usuario",
    'pwd' => "$hashed_password",
    's' => 'a'
   );


// Create the context for the request
$context = stream_context_create(array(
    'http' => array(
        'method' => 'POST',
           'header' => "Content-Type: application/json\r\n",
        'content' => "[".json_encode($postData)."]"

    )

));

// Send the request
$response = file_get_contents('https://webservice-warehouse.run.aws-usw02-pr.ice.predix.io', FALSE, $context);
// Check for errors
if($response === FALSE){
    die('Error');
}
$responseData = json_decode($response, TRUE);
if($responseData['status']== '001')
{
  $_SESSION['Name']=$responseData['name'];
  $_SESSION['id_cuenta']=$usuario;
  $_SESSION['Permisos']= 1;
 header("Location: login.php");
}
else
{
echo "<div class=infRojo><label>Usuario o contraseña incorrectos</label></div>";



}
}
?>
