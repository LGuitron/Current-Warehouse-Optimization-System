<?php
	require("conectar.php"); 
	$_POST=$_POST[0];
	
    if(isset($_POST['s'])&& isset($_POST['step']) && isset($_POST['solution_id']))
	{
		$status = $_POST['s'];
        $solution_id=$_POST['solution_id'];
        $step=$_POST['step'];
	}
	else
	{
        die("020");
	}
	
	if($status=='updateChecklist')
	{
        $enlace = conectar();  
    
        $sql = 'UPDATE rearrangements
                SET completed = NOT completed
                WHERE solution_id=$1 AND step=$2;';
        
        $sqlName = 'updateChecklist';
        if (!pg_prepare ($enlace,$sqlName, $sql)) 
        {
            ("Can't prepare '$sql': " . pg_last_error());
        }
        
        $res = pg_execute($sqlName, array($solution_id, $step));
        
        if(pg_affected_rows($res)!=0)
        {
            $rows['status'] = '001';
        }
        else
            $rows['status'] = '039';
        print json_encode($rows);
    }
    else
    {
        $rows['status'] = '040';
        print json_encode($rows);
    }
?>	
