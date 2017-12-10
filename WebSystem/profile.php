<?php
//User session management
		session_start();
		if(!isset($_SESSION['Name']))
				header("Location: login.php");
//navbar load
		require("navBar/navBar.php");
		navbar();
//function to get and post all the information
		require('functions/editar.php');
//get user id
		$id_cuenta=$_SESSION['id_cuenta'];

		$postPerfil = array(
			'user' => $id_cuenta,
				's' => 'getProfile'
			 );
		$data =editarperfil($postPerfil);
//All profile information
		$mont=$data['no_lt'];
		$costoMont=$data['energy_costs'];
		$tipo=$data['transport_type'];
		$costohora=$data['employee_cost'];
		$mant=$data['maintaince'];
		$frecMant=$data['main_freq'];


echo '

		<div class="container">
		<div class="first-block">
			<div><h1>Profile</h1></div>
		</div>
		<div class=" col-md right-block">
<!--Shows all profile information -->
		<div><label>Number of transport elements: '.$mont.'</label><br></div>
		<div><br><label>Energy cost of transport: $ '.$costoMont.'</label><br></div>
		<div><br><br><br><label>Type of transport: '.$tipo.'</label><br></div>
		<div><br><label>Transport Operator hourly salary: $ '.$costohora.'</label><br><br><br></div>
		<div><br><label>Maintainance cost: $'.$mant.'</label><br></div>
		<div><br><label>Maintainance frecuency: '.$frecMant.' times per year</label><br></div>
		</div>
		</div>';
?>
<!DOCTYPE html>
<html>
	<head>
		<!--Loads CSS styles, logo and window name -->
		<meta charset ="UTF-8">
		<!--link rel="stylesheet" href="css/styleEditar.css" type="text/css" media="all" /-->
		<link rel="stylesheet" href="css/styleProfile.css" type="text/css" media="all" />

		<title>Reportes</title>
		<link rel="shortcut icon" type="image/png" href="images/w.png"/>
		<!-- custom-theme -->
		<link rel="shortcut icon" type="image/png" href="images/w.png"/>
		<!-- custom-theme -->
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="keywords" content="Deft Responsive web template, Bootstrap Web Templates, Flat Web Templates, Android Compatible web template,
	Smartphone Compatible web template, free webdesigns for Nokia, Samsung, LG, SonyEricsson, Motorola web design" />
		<script type="application/x-javascript">
			addEventListener("load", function () {
				setTimeout(hideURLbar, 0);
			}, false);

			function hideURLbar() {
				window.scrollTo(0, 1);
			}
		</script>
		<!-- //custom-theme -->
		<link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
		<!-- Owl-carousel-CSS -->
		<link href="css/owl.carousel.css" rel="stylesheet">
		<link rel="stylesheet" href="css/team.css" type="text/css" media="all" />
		<link href="css/styleT.css" rel="stylesheet" type="text/css" media="all" />
		<!-- font-awesome-icons -->
		<link href="css/font-awesome.css" rel="stylesheet">
		<!-- //font-awesome-icons -->
		<link href="//fonts.googleapis.com/css?family=Raleway:100,100i,200,200i,300,300i,400,400i,500,500i,600,600i,700,700i,800"
		    rel="stylesheet">
		<link href="//fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i,800" rel="stylesheet">
 	</head>
    <body>

<!-- button to navigate to the edit window -->
					<div class="center-button">
         <div><a class="button hvr-ripple-in"  value="editar" name="editar " href ="editProfile.php">Edit Profile</a></div>
       </div>
     </body>
</html>
