<!DOCTYPE html>
<html>
<head>
	<!--Load CSS styles, logo and window's name -->
	<title>Previous Solutions</title>
	<meta charset ="UTF-8">
		<link rel="stylesheet" href="css/stylePasadas.css" type="text/css" media="all" />
		        <link rel="stylesheet" href="css/instructionTable.css" type="text/css" media="all" />
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
//User session management
            session_start();
            if(!isset($_SESSION['Name']))
                header("Location: login.php");
				//load navbar
            require("navBar/navBar.php");
            require('functions/editar.php');
            navbar();

            //Get rearrangement instructions with this solution ID//
            $postData = array(
                's' => 'viewInstructions',
                'solution_id' => $_POST['solution_id']
            );


            //Combo box for previous solutions//
            $data = editarperfil($postData);

            ?>
            <div class='container'>
                <div class='row'>
                    <div class='col-sm-12'>
                        <h1 class='text-center'>Instruction List<br><br></h1>
                        <div class='panel panel-info'>
                            <div class='panel-body'>
                                After completing an arrangement check the box in the Completed column that corresponds to the row of that instruction.
                            </div>
                        </div>

                        <?php
                        //Table for showing solution steps//
                        echo "<br><div> <table align='center' class='table-condensed'>
                        <tr>
                        <th>Step</th>
                        <th>Ean</th>
                        <th>Name</th>
                        <th>Initial Zone</th>
                        <th>Initial Floor</th>
                        <th>Final Zone</th>
                        <th>Final Floor</th>
                        <th>Completed</th>
                        </tr>";

                        $solution_id = $_POST['solution_id'];
                        foreach ($data as $row)
                        {
                            $completed = $row['completed'];
                            echo "<tr>";
                            echo "<td>" . $row['step'] . "</td>";
                            echo "<td>" . $row['ean'] . "</td>";
                            echo "<td>" . $row['name'] . "</td>";
                            echo "<td>" . $row['initial_zone'] . "</td>";
                            echo "<td>" . $row['initial_floor'] . "</td>";
                            echo "<td>" . $row['final_zone'] . "</td>";
                            echo "<td>" . $row['final_floor'] . "</td>";

                            if($completed=='t')
                                echo "<td><input type=\"checkbox\" onclick=\"toggleStep(".$row['step'].", $solution_id)\" value = $completed checked name=\"".$row['step']."\" ></div></td>";
                            else
                                echo "<td><input type=\"checkbox\" onclick=\"toggleStep(".$row['step'].", $solution_id)\" value = $completed name=\"".$row['step']."\" ></div></td>";
                        }

                        echo "</table> </div>";
                        ?>
                    </div>
                </div>
            </div>
</body>

<script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>

<script>

  function toggleStep(step, solution_id)
  {
    var json = "[{\"s\":\"updateChecklist\", \"step\":" + step + ", \"solution_id\":" +solution_id +" }]";

    $.ajax({
    type: "POST",
    beforeSend: function(request) {
        request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        request.setRequestHeader("Accept-Language", "en-US,en;q=0.5");
    },
    url: "https://webservice-warehouse.run.aws-usw02-pr.ice.predix.io/index.php",
    data: json,
    processData: false,
    success: function(msg) {
        console.log(msg);
    }
    });
  }
</script>
</html>
