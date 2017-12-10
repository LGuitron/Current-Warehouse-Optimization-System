<?php
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PATCH, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token');

	$_JSON = json_decode(file_get_contents('php://input'), true);
	if(isset($_JSON)){
 		$_POST = $_JSON ;
		$status = $_POST[0]['s'];
	} elseif(isset($_POST['s'])) {
  // if(isset($_POST[0]['s']))
	// $status = $_POST[0]['s'];
		$status = $_POST['s'];
  } else {
    die("050");
  }

  // App -----------------------------------------------------------------------
	if($status=='1' || $status =='0')
    require("app/scanning.php");
  elseif($status == "offline")
    require("app/offline.php");
  elseif($status == "delete")
		require("app/delete.php");
  elseif($status == "gilt")
		require("app/getIdLiftT.php");
  elseif($status == "listaProducto")
		require("app/listaProductos.php");
  // ---------------------------------------------------------------------------
  // Web App -------------------------------------------------------------------
  elseif($status == "no_lt")
		require("webApp/profile/editProfile/no_lt.php");
	elseif($status == "energy_costs")
		require("webApp/profile/editProfile/energy_costs.php");
	elseif($status == "transport_type")
		require("webApp/profile/editProfile/transport_type.php");
	elseif($status == "employee_cost")
		require("webApp/profile/editProfile/employee_cost.php");
	elseif($status == "maintaince")
		require("webApp/profile/editProfile/maintaince.php");
	elseif($status == "main_freq")
		require("webApp/profile/editProfile/main_freq.php");
	elseif($status=="a")
		require("webApp/login/authentication.php");
  elseif($status == "types")
		require("webApp/reports/types.php");
	elseif($status == "times")
		require("webApp/reports/times.php");
  elseif($status == "movements")
		require("webApp/reports/movements.php");
  elseif($status == "lt_times")
		require("webApp/reports/lt_times.php");
  elseif($status == "lt_movements")
		require("webApp/reports/lt_movements.php");
  elseif($status == "previousSolutionsInfo")
		require("webApp/solutions/previousSolutionsInfo.php");
  elseif($status == "viewInstructions")
		require("webApp/solutions/viewInstructions.php");
  elseif($status == "solutionInfo")
		require("webApp/solutions/solutionOptimizationInfo.php");
  elseif($status == "updateChecklist")
		require("webApp/solutions/updateChecklist.php");
  elseif($status == "prodXsection")
		require("webApp/services/prodPerSection.php");
  elseif($status == "sectionsDraw")
		require("webApp/services/sectionsDrawing.php");
  elseif($status=="gr")
		require("webApp/services/report.php");
  elseif($status == "getProfile")
    require("webApp/services/getProfile.php");
  // ---------------------------------------------------------------------------
  // Genetic Algorithm ---------------------------------------------------------
  elseif($status == "productZones")
		require("alg/productZones.php");
	elseif($status == "beaconZones")
		require("alg/beaconZones.php");
	elseif($status == "movementRegisters")
		require("alg/movementRegisters.php");
	elseif($status == "distinctProds")
		require("alg/distinctProds.php");
	elseif($status == "zoneCapacities")
		require("alg/zoneCapacities.php");
	elseif($status == "outgoingRegisters")
		require("alg/outgoingRegisters.php");
	elseif($status == "zSecitionMapping")
		require("alg/zSecitionMapping.php");
	elseif($status == "productAmounts")
		require("alg/productAmounts.php");
  elseif($status == "productMapping")
		require("alg/productMapping.php");
  elseif($status == "zoneCapacities")
		require("alg/zoneCapacities.php");
  elseif($status == "zoneFloors")
		require("alg/zoneFloors.php");
  elseif($status == "verticalCost")
		require("alg/verticalCost.php");
  elseif($status == "insertSolution")
    require("alg/insertSolution.php");
  elseif($status == "solutionID")
		require("alg/getSolutionId.php");
  elseif($status == "solutionPercentages")
		require("alg/solutionPercentages.php");
  elseif($status == "getZoneTypes")
		require("alg/getZoneTypes.php");
  elseif($status == "upVerticalCost")
		require("alg/upVerticalCost.php");
  elseif($status == "arrangeInstructions")
		require("alg/uploadInstructions.php");
  elseif($status=="freqData")
		require("alg/freqData.php");
  elseif($status=="sections")
		require("alg/getSections.php");
  elseif($status=="productEans")
		require("alg/productEans.php");
  // ---------------------------------------------------------------------------
  // Beacons -------------------------------------------------------------------
  elseif($status == "beacons")
		require("beacons/beacons.php");
	elseif($status == "adjacencies")
		require("beacons/adjacencies.php");
  elseif($status == "floors")
		require("beacons/floors.php");
  elseif($status == "sectionType")
		require("beacons/sectionType.php");
  elseif($status == "updateMinor")
		require("beacons/updateMinor.php");
  elseif($status == "sectionBeacon_id")
		require("beacons/sectionBeacon_id.php");
  elseif($status == "setX")
		require("beacons/setX.php");
  elseif($status == "setY")
		require("beacons/setY.php");
  elseif($status == "setPosition")
		require("beacons/setPosition.php");
  elseif($status == "sectionBeaconFloor")
		require("beacons/sectionBeaconFloor.php");
  elseif($status == "beaconFloors")
		require("beacons/beaconFloors.php");
  elseif($status == "setFloors")
		require("beacons/setFloors.php");
  elseif($status == "zoneNames")
		require("beacons/zoneNames.php");
  elseif($status == "sl")
		require("beacons/setLocation.php");
	elseif($status == "gs")
		require("beacons/setLocation.php");
  // ---------------------------------------------------------------------------
  // Lift Trucks ---------------------------------------------------------------
  elseif($status=="mont")
		require("montacargas/montacargas.php");
  elseif($status == "selectLT")
		require("montacargas/selectLT.php");
  elseif($status == "unselectLT")
		require("montacargas/unselectLT.php");
  // ---------------------------------------------------------------------------
  elseif($status=="prod")
		require("productos.php");
	else
		die("404 No encontrado");
?>
