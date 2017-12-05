<?php
// User session management
				session_start();
				if(!isset($_SESSION['Name']))
						header("Location: login.php");
//navbar load
				require("navBar/navBar.php");
				navbar();
?>
<!DOCTYPE html>
<html>

<body>
	<!-- Two buttons for the two different views of solutions -->
         <br><br> <h1>Solutions</h1><br><br><br>



         <div class='container'>
					 <div class="col-md-12" align="middle" text-align=center>

													<br>
													<div class="panel panel-info">
														<!--Relevant information for the user to properly enter the inputs needed -->
														<div class="panel-body" align="middle" >

																<p>Select an option.</p>
																	</div>
													</div>
											</div>
             <div class='row center-block center-button text-center'>
                <a class="btn-default hvr-ripple-in"  value="pasadas" name="pasadas" href ="previousSolutions.php">Previous Solutions</a>
            </div>
            <br><br>
            <div class='row center-block center-button text-center'>
                <a class="btn-default hvr-ripple-in center-button" value="nueva" name="nueva" href="createSolution.php" style = "text-ce">Create New Solution</a>
             </div>
         </div>


</body>
<head>
	 <!--Loads CSS styles, logo and window name -->
		<meta charset ="UTF-8">
				<link rel="stylesheet" href="css/styleSoluciones.css" type="text/css" media="all" />

				<title>Solutions</title>
				<link rel="shortcut icon" type="image/png" href="images/w.png"/>
				<link rel="shortcut icon" type="image/png" href="images/w.png"/>

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
				<link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
				<link href="css/owl.carousel.css" rel="stylesheet">
				<link rel="stylesheet" href="css/team.css" type="text/css" media="all" />
				<link href="css/styleT.css" rel="stylesheet" type="text/css" media="all" />
				<link href="css/font-awesome.css" rel="stylesheet">
				<link href="//fonts.googleapis.com/css?family=Raleway:100,100i,200,200i,300,300i,400,400i,500,500i,600,600i,700,700i,800"
						rel="stylesheet">
				<link href="//fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i,800" rel="stylesheet">
</head>
</html>
