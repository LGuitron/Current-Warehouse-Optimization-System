<?php
//function to get and post information from the webservice
function editarperfil($data)
{
  $json = json_encode($data);
// Create the context for the request
$context = stream_context_create(array(
    'http' => array(
        'method' => 'POST',
           'header' => "Content-Type: application/json\r\n",
        'content' => "[".$json."]"
    )
));

// Send the request
$response = file_get_contents('https://webservice-warehouse.run.aws-usw02-pr.ice.predix.io', FALSE, $context);
// Check for errors
if($response === FALSE)
{
    die('Error');
}
$responseData = json_decode($response, TRUE);

return $responseData;
}
?>
