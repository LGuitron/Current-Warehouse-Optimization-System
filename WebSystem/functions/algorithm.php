<?php
//function to run the genetic algorithm
function runAlgorithm($dataAnalytic)
{
  $curl = curl_init();
  $url = 'https://warehouse-uaa.predix-uaa.run.aws-usw02-pr.ice.predix.io/oauth/token';
  $header = array ('Pragma: no-cache' , 'content-type: application/x-www-form-urlencoded', 'Cache-Control: no-cache', 'authorization: Basic cnRfY2xpZW50OmlHSUUwd1kxNEVBWWpSeUZETGpY');
  $data = 'client_id=rt_client&grant_type=client_credentials';

  curl_setopt($curl, CURLOPT_POST, 1);
  curl_setopt($curl, CURLOPT_HTTPHEADER, $header);
  curl_setopt($curl, CURLOPT_URL, $url );
  curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($curl, CURLOPT_POSTFIELDS,$data);
  //curl_setopt($curlAnalytic, CURLOPT_TIMEOUT_MS, 1);

  $json = curl_exec($curl);
  $obj = json_decode($json);
  $access_token =  $obj->{'access_token'};

  //ANALYTIC EXECUTION//
  $curlAnalytic = curl_init();
  $urlAnalytic = 'https://predix-analytics-catalog-release.run.aws-usw02-pr.ice.predix.io/api/v1/catalog/analytics/095f1618-b4fa-4aa0-abe4-8d4c34814b32/execution';
  
  $headerAnalytic = array('Predix-Zone-Id: 14ec97b3-4b0f-4f94-adf5-4b893e5a88da' , 'content-type: application/json', 'authorization: Bearer ' . $access_token, 'content-type: application/json');

  curl_setopt($curlAnalytic, CURLOPT_POST, 1);
  curl_setopt($curlAnalytic, CURLOPT_HTTPHEADER, $headerAnalytic);
  curl_setopt($curlAnalytic, CURLOPT_URL, $urlAnalytic );
  curl_setopt($curlAnalytic, CURLOPT_RETURNTRANSFER, 1 );
  curl_setopt($curlAnalytic, CURLOPT_POSTFIELDS,$dataAnalytic);
  curl_setopt($curlAnalytic, CURLOPT_TIMEOUT, 1);
  curl_setopt($curlAnalytic, CURLOPT_RETURNTRANSFER, false);
  curl_setopt($curlAnalytic, CURLOPT_CONNECTTIMEOUT, 1);
  curl_setopt($curlAnalytic, CURLOPT_FRESH_CONNECT, true);


  $resultJson = curl_exec($curlAnalytic);
}
?>
