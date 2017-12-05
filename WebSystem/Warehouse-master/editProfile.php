<?php
//User session management
session_start();
if(!isset($_SESSION['Name']))
		header("Location: login.php");
	//load navbar
		require("navBar/navBar.php");
		navbar();
		//loads function to get all profile information
		require('functions/editar.php');
		//gets user id
		$id_cuenta=$_SESSION['id_cuenta'];

		$postPerfil = array(
			'user' => $id_cuenta,
				's' => 'getProfile'
			 );
		$data =editarperfil($postPerfil);
//all profile information
		$mont=$data['no_lt'];
		$costoMont=$data['energy_costs'];
		$tipo=$data['transport_type'];
		$costohora=$data['employee_cost'];
		$mant=$data['maintaince'];
		$frecMant=$data['main_freq'];

		if(isset($_POST['generar']))
			{
				//when the number of liftrucks is modified a post is made
				if($_POST["mont"]!=null)
				{
					$postData = array(
						'user' => $id_cuenta,
							'no_lt' => $_POST["mont"],
							's' => 'no_lt'
						 );

						 editarperfil($postData);
				}
				//when the energy cost of liftrucks is modified a post is made
				if($_POST["costoMont"]!=null)
				{
					$postData = array(
						'user' => $id_cuenta,
							'energy_costs' => $_POST["costoMont"],
							's' => 'energy_costs'
						 );
						 editarperfil($postData);
				}
				//when the type of liftrucks is modified a post is made
				if($_POST["tipo"]!=null)
				{
					$postData = array(
						'user' => $id_cuenta,
							 'transport_type' => $_POST["tipo"],
							's' => 'transport_type'
						 );
						 editarperfil($postData);
				}
				//when the employee cost is modified a post is made
				if($_POST["costohora"]!=null)
				{
					$postData = array(
						'user' => $id_cuenta,
							'employee_cost' => $_POST["costohora"],
							's' => 'employee_cost'
						 );
						 editarperfil($postData);
				}
				//when the mantainance cost is modified a post is made
				if($_POST["mant"]!=null)
				{
					$postData = array(
						'user' => $id_cuenta,
							'maintaince' => $_POST["mant"],
							's' => 'maintaince'
						 );
						 editarperfil($postData);
				}
				//when the maintainance frequency is modified a post is made
				if($_POST["frecMant"]!=null)
				{
					$postData = array(
						'user' => $id_cuenta,
							'main_freq' => $_POST["frecMant"],
							's' => 'main_freq'
						 );
						 editarperfil($postData);
				}
					header("Location: profile.php");
		}
		// To post the image
		if(isset($_POST['enviar']))
		{
			$imagen = $_REQUEST['imagen'];

			// upload image
         $copiarArchivo = false;
				 //Copy image in the directory of the files uploaded
				 //Rename the file to avoid name conflicts
         if (is_uploaded_file ($_FILES['imagen']['tmp_name']))
         {
            $nombreDirectorio = "images";
            $idUnico = time();
            $nombreArchivo = $idUnico . "-" . $_FILES['imagen']['name'];
            $copiarArchivo = true;
         }
      // No file has been selected
            else if ($_FILES['imagen']['name'] == "")
            $nombreArchivo = '';
			//file selected was unable to upload
         else
         {
            $errores = $errores . "<LI>Image could not be uploaded\n";
            $nombreArchivo = '';
         }

     // Show errors found
         if ($errores != "")
         {
            print ("No se ha podido realizar la inserci&oacute;n debido a los siguientes errores:");
            print ("<UL>");
            print ($errores );
            print ("</UL>");
            print ("[ <A HREF='javascript:history.back()'>Volver</A> ]");
            exit();
         }

     // Move image to final destination
         if ($copiarArchivo)
            move_uploaded_file ($_FILES['imagen']['tmp_name'],
            $nombreDirectorio . $nombreArchivo);

			print ("<A TARGET='_blank' HREF='" . $nombreDirectorio . $nombreArchivo . "'>" . $nombreArchivo . "</A>");
			print ("<IMG SRC=\"$nombreDirectorio$nombreArchivo\">");
		}


echo '
<!-- HTML part to be visualized by the user -->
			<div class ="container">
			<form action="editProfile.php" method="post">
			<br><br>
			 <h1>Edit Profile</h1><br><br>
			 <div class="row">
				 <div class = "col-md-12 col-sm-2"align="middle">
					 <div><label>Number of transport elements:</label><br></div>
						 <div><input id="mont"  placeholder="  '.$mont.'"name="mont"></div>

				 </div>
				  <div class = "col-md-12 col-sm-2" align="middle">
					 <div><label>Maintainance cost: </label><br></div>
					 <div><input id="mant"  placeholder="  $ '. $mant.'" name="mant"></div>
				 </div>
				  <div class = "col-md-12 col-sm-2" align="middle">
					 <div><br><label>Maintainance frecuency: </label><br></div>
					<div><input id="frecMant"  placeholder="  '.$frecMant.' times per year" name="frecMant"></div>
				 </div>
			 </div>
			 <div class ="row">
		 		 <div class = "col-md-12 col-sm-2 " align="middle">
		 			<div><br><label>Energy cost of transport:</label><br></div>
		 			<div><input id="costoMont" placeholder="  $ '.$costoMont.'" name="costoMont"></div>
		 		</div>
		 		 <div class = "col-md-12 col-sm-2"align="middle">
		 			<div><br><label>Transport Operator hourly salary:</label><br></div>
		 			<div><input id="costohora" placeholder="  $ '.$costohora.'" name="costohora" ></div>
		 		</div>
		 	</div>
			<div class ="row">
				 <div class = "col-md-12 col-sm-2" align="middle">
					<div><br><label>Type of transport:</label><br></div>
 			 <select placeholder='.$tipo.' name="tipo" >
 				 <option></<option value="">'.$tipo.'</option>
 			 <option value="electrico">Electric</option>
 			 <option value="disel">Disel</option>
 			 <option value="gas">Gas</option>
 			 </select>
				</div>
			</div>
			<!-- Submit button-->
			<div class = "col-md-12 col-sm-2"align="middle">
			<INPUT TYPE="FILE" SIZE="44" NAME="imagen"></TD></TR>
			</div>
	<div><button  class="button hvr-ripple-in" align="middle" value="generar" type="submit" name="generar">Edit Profile</button></div>


		</form>
	</div>';
		?>
<!DOCTYPE html>
<html>
	<head>
		  <!--Loads CSS styles, logo and window name -->
		<meta charset ="UTF-8">
		<link rel="stylesheet" href="css/styleEditProfile.css" type="text/css" media="all" />
		<!--link rel="stylesheet" href="css/style.css" type="text/css" media="all" /-->
		<title>Edit Profile</title>
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
</html>
