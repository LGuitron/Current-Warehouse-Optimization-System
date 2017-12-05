<?php
//function star to be called in all other windows
  function navbar()
  {
    echo '<ul>';
    if($_SESSION['Permisos']==1 || $_SESSION['Permisos']==0)
    {
        echo
            '
            <div class="main_section_agile" id="home">
          		<div class="agileits_w3layouts_banner_nav">

          			<nav class="navbar navbar-default">
          				<div class="navbar-header navbar-left">
          					<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
          						<span class="sr-only">Toggle navigation</span>
          						<span class="icon-bar"></span>
          						<span class="icon-bar"></span>
          						<span class="icon-bar"></span>
          					</button>

                    <h1><a style="display:inline-block" class="navbar-brand"><img style="display:inline-block" type="image/png" src="images/w.png" height="50" width="50"/></a> </h1>

          				</div>
          				<!-- Collect the nav links, forms, and other content for toggling -->
          				<div class="collapse navbar-collapse navbar-right" id="bs-example-navbar-collapse-1">
          					<nav class="menu-hover-effect menu-hover-effect-4">
          						<ul class="nav navbar-nav">

                      <li><a href="home.php" class="hvr-ripple-in">Home</a></li>
                       <li><a href="reports.php" class="hvr-ripple-in">Reports</a></li>
                       <li><a href="solutions.php" class="hvr-ripple-in">Solutions</a></li>
                        <li><a href="profile.php" class="hvr-ripple-in">Profile</a></li>


                ';
    }

      echo
          '

                    <li style="position:absolute right:0"><a href="terminarSesion.php" class="hvr-ripple-in">Log out</a></li>
                    </ul>
                </nav>

              </div>
            </nav>
            <div class="clearfix"> </div>
          </div>
          <br><br>
        </div>';
  }
?>
