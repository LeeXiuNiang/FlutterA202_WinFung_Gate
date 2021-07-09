<?php
include_once("dbconnect.php");
$email = $_POST['email'];

if($email=='xnlee1999@gmail.com'){
    $sqlloadpurchased = "SELECT * FROM tbl_orderhistory INNER JOIN tbl_products ON tbl_orderhistory.prid = tbl_products.prid";
}else{
    $sqlloadpurchased = "SELECT * FROM tbl_orderhistory INNER JOIN tbl_products ON tbl_orderhistory.prid = tbl_products.prid WHERE tbl_orderhistory.email = '$email'";
}

$result = $conn->query($sqlloadpurchased);

if($result ->num_rows >0){
    $response["purchased"]=array();
    while ($row = $result -> fetch_assoc()){
        $purchaselist = array();
        $purchaselist[orderid] = $row['orderid'];
        $purchaselist[email] = $row['email'];
        $purchaselist[status] = $row['status'];
        $purchaselist[prid] = $row['prid'];
        $purchaselist[qty] = $row['qty'];
        $purchaselist[insdate] = $row['insdate'];
        $purchaselist[instime] = $row['instime'];
        $purchaselist[prname] = $row['prname'];
        array_push($response["purchased"],$purchaselist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>