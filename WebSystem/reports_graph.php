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
 <link href="css/font-awesome.css" rel="stylesheet"/>
 <!-- //font-awesome-icons -->
 <link href="//fonts.googleapis.com/css?family=Raleway:100,100i,200,200i,300,300i,400,400i,500,500i,600,600i,700,700i,800"
		 rel="stylesheet"/>
 <link href="//fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i,800" rel="stylesheet"/>
 <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>

</head>
	    <body>
        <?php
				//User session management
            session_start();
            if(!isset($_SESSION['Name']))
                header("Location: login.php");
				//navbar load
            require("navBar/navBar.php");
            navbar();
				//function to get and post all the information
						 require('functions/reportes.php');

				//get 20 products based on time
				$postProducts = array(
						's' => 'times',
            'startDate' => $_POST['date1'],
            'endDate' => $_POST['date2']

					 );
				$dataP =createReport($postProducts);

				$Ptimes= json_encode($dataP);

				//get 20 most moved products
				$postProducts = array(

					's' => 'movements',
          'startDate' => $_POST['date1'],
          'endDate' => $_POST['date2']
				 );
				$dataP =createReport($postProducts);

				$Pmovements= json_encode($dataP);
				//get lift-truck's times
				$postProducts = array(

						's' => 'lt_times',
            'startDate' => $_POST['date1'],
            'endDate' => $_POST['date2']
					 );
				$dataP =createReport($postProducts);

				$lt_times = json_encode($dataP);

				 //get lift-truck's movements

				$postProducts = array(

						's' => 'lt_movements',
            'startDate' => $_POST['date1'],
            'endDate' => $_POST['date2']
					 );
				$dataP =createReport($postProducts);

				$lt_movements = json_encode($dataP);
		 ?>

			<div class="container">
              <form action="reportes.php" method="post">

               <h1>Reports</h1>
						<!-- Second navbar, to navigate between graphs -->
                <nav class="navbar navbar-default">
                    <div class="navbar-header navbar-left">
          					<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
          						<span class="sr-only">Toggle navigation</span>
          						<span class="icon-bar"></span>
          						<span class="icon-bar"></span>
          						<span class="icon-bar"></span>
          					</button>

               <div class="collapse navbar-collapse navbar-right" id="bs-example-navbar-collapse-1">
          					<nav class="menu-hover-effect menu-hover-effect-4">
          						<ul class="nav navbar-nav">

                     <li><a href="#section1" class="hvr-ripple-in" styl="center-block">Products' time</a></li>
										 <li><a href="#section2" class="hvr-ripple-in" styl="center-block">Products' movements</a></li>
										 <!--li><a href="#section3" class="hvr-ripple-in" styl="center-block">Lift-trucks' time</a></li>
										 <li><a href="#section4" class="hvr-ripple-in" styl="center-block">Lift-trucks' movements</a></li-->


                    </ul>
                  </nav>
              </div>
							</div>
            </nav>
            <div class="clearfix"> </div>


		<!-- Section 1 -->
		<div id="section1">
		<div class="center-block">
				<h1>Products' time</h1>
				<!-- function to call Products' time graph -->
				<div id="Ptime" style="height: 500px; width: 100%;"></div><br><br><br><br>
		 </div>
	 </div>


		<!-- Section 2 -->
		<div id="section2">
		<div class="center-block">
						<h1>Products' movements</h1>
						<!-- function to call Products' movements graph -->
					<div id="Pmovement" style="height: 500px; width: 100%;"></div><br><br><br><br>
		</div>
	</div>

	<!-- Section 3 -->
	<!--div id="section3">
	<div class="center-block">
			<h1>Lift-trucks' time</h1>
			<!-- function to call Lift-trucks' time graph -->
			<!--div id="lt_time" style="height: 500px; width: 100%;"></div><br><br><br><br>
	 </div>
 </div-->

 <!-- Section 4 -->
 <!--div id="section4">
 <div class="center-block">
		 <h1>Lift-trucks' movements</h1>
		 <!-- function to call Lift-trucks' movements graph -->
		 <!--div id="lt_movements" style="height: 500px; width: 100%;"></div><br><br><br><br>
	</div>
</div-->

     </form>
					</div>
		<script>
				//Draw Products' time graph
									function func1(){
										var chart1 = new CanvasJS.Chart("Ptime", {
											animationEnabled: true,
											exportEnabled: true,
											theme: "light1", // "light1", "light2", "dark1", "dark2"
											title:{
												text: "Top 20 products based on time"
											},
											data: [{
												type: "bar",
												indexLabelFontColor: "#ffffff",
												indexLabelPlacement: "outside",
												dataPoints: <?php echo $Ptimes; ?>
											}]
										});
										chart1.render();
									}

	//Draw Products' mpvements graph
									function func2(){
										var chart2 = new CanvasJS.Chart("Pmovement", {
											animationEnabled: true,
											exportEnabled: true,
											theme: "light1", // "light1", "light2", "dark1", "dark2"
											title:{
												text: "Top 20 moved products"
											},
											data: [{
												type: "bar",
												indexLabelFontColor: "#ffffff",
												indexLabelPlacement: "outside",
												dataPoints: <?php echo $Pmovements; ?>
											}]
										});
										chart2.render();
									}
	//Draw Lift-trucks' time graph
									function func3(){
										var chart3 = new CanvasJS.Chart("lt_time", {
											animationEnabled: true,
											exportEnabled: true,
											theme: "light1", // "light1", "light2", "dark1", "dark2"
											title:{
												text: "Lift-trucks' time"
											},
											data: [{
												type: "bar",
												indexLabelFontColor: "#ffffff",
												indexLabelPlacement: "outside",
												dataPoints:  <?php echo $lt_times; ?>
											}]
										});
										chart3.render();
									}

						//Draw Lift-trucks' movements graph
									function func4(){
										var chart4 = new CanvasJS.Chart("lt_movements", {
											animationEnabled: true,
											exportEnabled: true,
											theme: "light1", // "light1", "light2", "dark1", "dark2"
											title:{
												text: "Lift-trucks' movements"
											},
											data: [{
												type: "bar",
												indexLabelFontColor: "#ffffff",
												indexLabelPlacement: "outside",
												dataPoints:  <?php echo $lt_movements; ?>
											}]
										});
										chart4.render();
									}

									func1();
									func2();
									func3();
									func4();

								</script>

     </body>

     		<script src="https://canvasjs.com/assets/script/jquery-1.11.1.min.js"></script>
<script src="https://canvasjs.com/assets/script/jquery.canvasjs.min.js"></script>
</html>
