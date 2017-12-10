<?php
	require("conectar.php");

	if($status=='gr')
	{
    $enlace = conectar();
		foreach ($_POST as $k=>$v){
      if($v!='gr'){
        $section_id=$v['section_id'];
        $data=$v['data'];
        $solution_id=$v['solution_id'];

        $rows['0'] = $section_id;
        $rows['1'] = $data;
        $rows['2'] = $solution_id;
        
        $sql = 'INSERT INTO results (section_id, data, solution_id) VALUES ($1, $2, $3)';
        $sqlName = 'gr';
        if (!pg_prepare ($enlace,$sqlName, $sql))
        {
            ("Can't prepare '$sql': " . pg_last_error());
        }
        $res = pg_execute($sqlName, array($section_id,$data, $solution_id));

        if(pg_affected_rows($res)!=0)
        {
            $rows['status'] = '001';
        }
        else
            $rows['status'] = '039';
      }
    }
        print json_encode($rows);
    }
    else
    {
        $rows['status'] = '040';
        print json_encode($rows);
    }
?>
