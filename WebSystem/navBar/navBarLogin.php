<?php
//navbar function only for the login page
  function navbar()
  {
    echo '<ul>';
    if($_SESSION['Permisos']==1 || $_SESSION['Permisos']==0)
    {
        echo
            '<li><img src="/images/current-logo-3.png" alt="logo" width=90px height=40px></li> 
             <!--<li><a href="inicio.php">Inicio</a></li>
                <li><a href="reportes.php">Generar Reporte</a></li>
                <li><a href="soluciones.php">Soluciones</a></li>-->
                ';
    }

      echo
          '<li style="float:right"><a href="warehouse.php">Regresar</a></li>
        </ul>';
  }
?>
