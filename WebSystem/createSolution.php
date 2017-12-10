<!DOCTYPE html>
<html>
<head>
	<!--Load CSS styles, logo and window's name  -->
	<title>Generar Solución</title>
	<meta charset ="UTF-8">
		<link rel="stylesheet" href="css/styleNew.css" type="text/css" media="all" />

		<link rel="shortcut icon" type="image/png" href="images/w.png"/><!-- custom-theme -->
		<!--link rel="shortcut icon" type="image/png" href="images/w.png"/-->
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
<?php
	//user session management
			      session_start();
            if(!isset($_SESSION['Name']))
                header("Location: login.php");
					//load navbar
            require("navBar/navBar.php");
					//function to get and post all the information needed
						require("functions/algorithm.php");
            navbar();
					//user information
						$id_cuenta=$_SESSION['id_cuenta'];
						$emails = array(
							'1' => $id_cuenta
						);
						/*$emails = array(
							'1' => 'legl_1995@hotmail.com'
						);*/
						json_encode($emails);

				if(isset($_POST['generar']))
				{
					//validate dates
					 if (date('d-m-Y',strtotime($_POST['date1'])) > date('d-m-Y',strtotime($_POST['date2'])))
					 {
						 echo "<div class=\"infRojo\">Start date should be before the end date.</div>";

					 }
					 else
					 {
                        $reservePercent = $_POST['reservePercent'];
                        if($reservePercent>100)
                            $reservePercent=100;
                        else if($reservePercent<0)
                            $reservePercent=0;
						//information needed
						 $data = array(
						 'startDate' => $_POST['date1'],
						 'endDate' => $_POST['date2'],
						 'reservePercent' => $reservePercent,
						 'user_id' => '1',
						 'emails' => $emails
						 );
						 $dataAnalytic = json_encode($data);

						echo "<div class=\"infVerde\">Your request has been made.</div>";
						//executes the algorithm
						runAlgorithm($dataAnalytic);

				}

				}

         ?>
				 <!--User input -->
            <div class="container">
                <form action="createSolution.php" method="post">
                <br><br>
                    <div class='row'>
                        <div class="col-sm-12 col-mid-12 col-lg-12 ">
                            <br><br> <h1>Create Solution</h1>
                        </div>
                    </div>

                    <div class='row'>
                        <div class="col-md-5 left-block">
                            <div><label>Data recovery:</label><br></div>
                            <div><label>Start Date:</label><br></div>
                            <div><input id="date"  name="date1" placeholder="dd-mm-yyyy" required></div>
                            <div><label>End date:</label><br></div>
                            <div><input id="date" name="date2" placeholder="dd-mm-yyyy" required></div>
                            <div><label>Parameters:</label><br></div>
                            <div><label>Reservation Percentage:</label><br></div>
                            <div><input id="time" type="float" name="reservePercent" placeholder="%"required></div>
                        </div>

						<div class="col-md-2">
						</div>

						<div class="col-md-5">
                            <br>
                            <div class="panel panel-info">
															<!--Relevant information for the user to properly enter the inputs needed -->
                                <div class="panel-body">
																												Enter the dates based on which the solution should be made. <br><br>
                                                        The reservation percentage parameter allows you to decide how much of your
                                                        available space would you like to reserve for incoming product.
                                                        <br><br>
                                                        A high value for this parameter (> 70%) means that you expect a considerable amount
                                                        of frequent moving product for the next period, by setting this parameter high you are making
                                                        sure that these frequently moving incoming products will have a good spot in the warehouse
                                                        available at their arrival.
                                                        <br><br>
                                                        For deciding the value of this parameter you should take into account that lower reservation
                                                        percentages may be riskier, but are able to yield higher optimization percentages.
                                </div>
                            </div>
                        </div>
                    </div>
										<!--Submit button -->
							<div class="col-sm-12 col-mid-8 col-lg-8 ">
								<div><button class=" button hvr-ripple-in" value=" generar" type="generar" name="generar">Create Solution</button></div>
							</div>
             </form>
					 </div>
</body>
</html>
