<?php
include_once("dbconnect.php");

$prname = $_POST['prname'];

if ($prname == "") {
    $sqlloadproducts ="SELECT * FROM tbl_products ORDER BY prid DESC";
} else {
    $sqlloadproducts = "SELECT * FROM tbl_products WHERE prname LIKE '%$prname%'";
}


$result = $conn->query($sqlloadproducts);

if($result ->num_rows >0){
    $response["products"]=array();
    while ($row = $result -> fetch_assoc()){
        $list = array();
        $list[id] = $row['prid'];
        $list[name] = $row['prname'];
        $list[type] = $row['prtype'];
        $list[size] = $row['prsize'];
        $list[price] = $row['prprice'];
        $list[qty] = $row['prqty'];
        array_push($response["products"],$list);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>