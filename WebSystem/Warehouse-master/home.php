
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
<head>
  <!--Loads CSS styles, logo and window name -->
		<meta charset ="UTF-8">
		<link rel="stylesheet" href="css/styleEditar.css" type="text/css" media="all" />
		<title>Home</title>
		 <link rel="shortcut icon" type="image/png" href="images/w.png"/><!-- custom-theme -->
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
        <div class='container'>
            <div class='row'>
                <div class='col-md-5 col-sm-5'>
                </div>
                <div class='col-md-2 col-sm-2'>
                    <img src="images/w.png"  align="middle" alt="logo" width=150px height=150px text-align=center>
                </div>
                <div class='col-md-5 col-sm-5'>
                </div>

                </div>
            </div>

          <!-- Warehouse Logo-->
          <div class='centrar'>

          <!-- Brief description of all sections inside the webapp-->
          <div class="col-md-12">

                          <br>
                          <div class="panel panel-info">
                            <!--Relevant information for the user to properly enter the inputs needed -->
                            <div class="panel-body">
                              <h3><br> Reports</h3><br>
                                <p>In the report section, you will find the most moved and the most time consuming products inside the warehouse,
                                  as well as the times spent and movements of the Lift Trucks based on the selected dates.</p>
                                  <h3><br><br>Solutions</h3><br>
                                  <p>In the solution sectrion, you will find two modules, in the first one, you will be able to visualize solutions created in the past,
                                  and in the second one you will be able to select the dates based on which the solution will be created.</p>
                                  <h3><br><br>Profile</h3><br>
                                  <p>In the profile section, you will find all the Warehouse's information.</p>
                                  </div>
                          </div>
                      </div>

              </div>
</body>
</html>
