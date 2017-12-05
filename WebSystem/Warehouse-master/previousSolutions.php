<!DOCTYPE html>
<html>
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
            require('functions/editar.php');


            $postData = array(
            's' => 'previousSolutionsInfo'
            );

            //Previous Solutions Combo box
            $data = editarperfil($postData);
            $comboSolutions = "";

            //Get the solution id for the default option
            $defaultOption = true;

            foreach($data as $row)
            {
                if($defaultOption)
                {
                    $defaultSolutionID = $row['id'];
                    $defaultOption = false;
                }
                $solution_id = $row['id'];
                $text = $row['wh_name'] . " - "  . $row['created_at'];


                //If a solution Id is sent to the function actualizar() the combobox is selected
                if(isset($_POST['solutionValue']) && $_POST['solutionValue']==$solution_id)
                {
                    $defaultSolutionID = $_POST['solutionValue'];
                    $comboSolutions .=" <option value='".$solution_id."' selected=\"selected\">".$text."</option>";
                }
                else
                    $comboSolutions .=" <option value='".$solution_id."'>".$text."</option>";
            }

            //Gets the information of the solution selected
                $infoData = array(
                's' => 'solutionInfo',
                'solution_id' => $defaultSolutionID
                );

            $infoSolucion = editarperfil($infoData);
						// gets all the solution's information
            foreach($infoSolucion as $row)
            {
                $u_name = $row['u_name'];
                $wh_name = $row['wh_name'];
                $since = $row['since'];
                $until = $row['until'];
                $time_reduction = $row['time_reduction'];
                $distance_reduction = $row['distance_reduction'];
                $created_at = $row['created_at'];
                $reserveperc = $row['reserveperc'];
            }
        ?>

        <div class='container'>
            <!--form id= "sol_form" method="post"-->
                <div class='row'>
                    <div class='col-md-12 col-sm-12'>
                        <h1>Previous Solutions</h1><br>
                    </div>
                </div>

								<!-- Option to select the solution wished to view-->
                <div class='row text-center'>
                    <div class='col-md-12 col-sm-12'>
                        <div><label>Select the previous solution you would like to see:</label><br></div>
                        <select id = "solution_id" name="solution_id" onchange="actualizar()"><?php echo $comboSolutions;?></select>
                        <br><br>
                    </div>
                </div>

                <div class='row'>
                    <div class='col-md-6 col-sm-6'>
                        <div class='panel panel-primary'>
                          <!--Optimization percentages -->
                        <?php
                            $timeF = number_format((float)$time_reduction, 2, '.', '');
                            $distF = number_format((float)$distance_reduction, 2, '.', '');
                            echo "<h2 class='text-center'>Optimization</h2><br>";
                            echo "<h3>Time: $timeF% </h3><br>";
                            echo "<h3>Distance: $distF%</h3><br>";
                        ?>
                        </div>

                        <div class='panel panel-primary'>
                          <!--Solution's general information -->
                        <?php
                            echo "<h2 class='text-center'>General Information</h2><br>";
                            echo "<label>Warehouse: $wh_name </label><br>";
                            echo "<label>Created at: $created_at </label><br>";
                            echo "<label>Created by: $u_name </label><br>";
                            echo "<label>Start capture date: $since </label><br>";
                            echo "<label>End capture date: $until  </label><br>";
                            echo "<label>Reservation Percentage: $reserveperc% </label><br>";
                        ?>
                        </div>
                    </div>
                    <div class='col-md-6 col-sm-6'>
                        <form action="arrangeInstructions.php" method="post">
                          <!--Buttons to select the desired option  --> 
                            <?php
                                echo "<input type=\"hidden\" name=\"solution_id\" value=$defaultSolutionID>"
                            ?>
                            <div><button class="btn btn-default" value=" Instrucciones" type="seleccionar" name="instrucciones" >Instruction List</button></div>
                        </form>

                        <form action="mapInstructions.php" method="post">
                            <?php
                                echo "<input type=\"hidden\" name=\"solution_id\" value=$defaultSolutionID>"
                            ?>
                            <div><button class="btn btn-default" value="Visual Instructions" type="seleccionar" name="inicial" >Map Instructions</button></div>
                        </form>

                    </div>
                </form>
            </div>



</body>

<script>
  function actualizar()
  {
      var form = document.createElement("form");
      form.setAttribute("method", "post");
      form.setAttribute("action", "previousSolutions.php");

      var solutionSelected = document.getElementById("solution_id").value;
      var solutionValue = document.createElement("input");
      solutionValue.setAttribute("type", "hidden");
      solutionValue.setAttribute("name", "solutionValue");
      solutionValue.setAttribute("value", solutionSelected);
      form.appendChild(solutionValue);

      document.body.appendChild(form);
      form.submit();
  }
</script>

<head>
			<!--Loads CSS styles, logo and window name -->
	<title>Previous Solutions</title>
	<meta charset ="UTF-8">
		<link rel="stylesheet" href="css/stylePasadas.css" type="text/css" media="all" />
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
</html>
