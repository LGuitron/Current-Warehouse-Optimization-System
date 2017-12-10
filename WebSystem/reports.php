<?php
// User session management
		session_start();
		if(!isset($_SESSION['Name']))
				header("Location: login.php");
//navbar load
		require("navBar/navBar.php");
		navbar();
//function that gets and posts all the informaton for the reports
	require('functions/reportes.php');
//dates validation
 if(isset($_POST['generar']))
	{
		if (date('m-d-Y',strtotime($_POST['date1'])) > date('m-d-Y',strtotime($_POST['date2'])))
		{
			echo "<div class=\"infRojo\">Start date should be before the end date.</div>";

		}
		else
		{
			//post the dates selected
			$postData = array(
			'date1' => $_POST['date1'],
			'date2' => $_POST['date2'],
			's' => 'lt_movements'
			);

		$dataP = createReport($postData);
		}
	}

?>
<!DOCTYPE html>
<html>
	<head>
		  <!--Loads CSS styles, logo and window name -->
		<meta charset ="UTF-8">
		<link rel="stylesheet" href="css/stylereportes.css" type="text/css" media="all" />
		<title>Reports</title>
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
		<link href="css/styleT.css" rel="stylesheet" type="text/css" media="all" />
		<!-- font-awesome-icons -->
		<link href="css/font-awesome.css" rel="stylesheet">
		<!-- //font-awesome-icons -->
		<link href="//fonts.googleapis.com/css?family=Raleway:100,100i,200,200i,300,300i,400,400i,500,500i,600,600i,700,700i,800"
				rel="stylesheet">
		<link href="//fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i,800" rel="stylesheet">
	</head>
    <body>
    <div>
	  	<div class="container">
              <form action="reports_graph.php" method="post">

               <h1>Create Report</h1>


							 <div class="col-md-12" align="middle">

															 <br>
															 <div class="panel panel-info">
																 <!--Relevant information for the user to properly enter the inputs needed -->
																 <div class="panel-body" align="middle" >

																		 <p>Select the dates, based on wich you would like to create your reports on.</p>
																			 </div>
															 </div>
													 </div>
						 <!-- Part to select the dates based on which the reports should be made -->
							 		<div class="right-block">
	               			<div><label>Start date:</label><br></div>
	                    <div><input id="date1"  name="date1" placeholder="dd-mm-yyyy" required></div>
											<div><label>End date:</label><br></div>
	                    <div><input id="date2" name="date2" placeholder="dd-mm-yyyy" required></div>
	  										</div>
</div>
                <div><button class="button hvr-ripple-in" href = "reports_graph.php" value="generar" type="generar" name="generar">Create Report</button></div>
            </form>
        </div>
     </body>
</html>
