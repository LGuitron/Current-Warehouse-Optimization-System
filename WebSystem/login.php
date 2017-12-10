<?php
//user session management
    session_start();
    if(isset($_SESSION['Name']))
        header("Location: home.php");
//user information
    if (isset($_POST['submit']))
    {
      //function that sends the user's information
        require('functions/sesion.php');
        $usuario=$_POST["usuario"];
        $contrasena=$_POST["contrasena"];
        $existe=iniciarSesion($usuario,$contrasena);
      }
?>
<!DOCTYPE html>
<html>
    <head>
      <!-- Loads CSS styles, logo and window's name-->
      <title>Login</title>
        <meta charset ="UTF-8">
        <link rel="stylesheet" href="css/stylelogin.css" type="text/css" media="all" />
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
        <!-- //custom-theme -->
        <link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
        <!-- Owl-carousel-CSS -->
        <link href="css/owl.carousel.css" rel="stylesheet">
        <!--link rel="stylesheet" href="css/team.css" type="text/css" media="all" /-->
        <link href="css/styleT.css" rel="stylesheet" type="text/css" media="all" />
        <!-- font-awesome-icons -->
        <link href="css/font-awesome.css" rel="stylesheet">
        <!-- //font-awesome-icons -->
        <link href="//fonts.googleapis.com/css?family=Raleway:100,100i,200,200i,300,300i,400,400i,500,500i,600,600i,700,700i,800"
            rel="stylesheet">
        <link href="//fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i,800" rel="stylesheet">

    </head>
    <body background-image="images/ware.jpg">
      <nav class="navbar navbar-default">
        <div class="navbar-header navbar-left">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
        <!--	<img class="navbar-brand"type="image/png" src="/images/w.png"/>-->
        <h1><a style="display:inline-block " class="navbar-brand" href="index.php" ><img style="display:inline-block" href="index.php" type="image/png" src="images/w.png" height="80" width="80"/>areHouse</a> </h1>


        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->

      </nav>
        <div class='centrar'>
            <div>
                <link href='http://fonts.googleapis.com/css?family=Montserrat:400,700' rel='stylesheet' type='text/css'>
                <form action="" method="post" >
                  <!--LOGIN BLOCK -->
                    <div class='centrar'>
                    <div class="login-block">
                    <img src="images/current-logo-3.png" alt="logo" width=300px height=150px text-align=center>
                    <!--Form for user input -->
                         <br><br>
                        <div><input id ="usuario" name="usuario" type="text" placeholder="Username"></div>
                        <br>
                        <div><input id ="contrasena" name="contrasena" type="password" placeholder="Password"></div>
                        <br><br>
                         <button value="Ingresar" type="submit" name="submit">Login</button>
                         </div>
                    </div>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>
