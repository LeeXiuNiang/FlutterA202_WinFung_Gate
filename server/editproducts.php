<?php
include_once("dbconnect.php");
$prid = $_POST['prid'];
$name= $_POST['name'];
$type = $_POST['type'];
$size = $_POST['size'];
$price = $_POST['price'];
$qty = $_POST['qty'];

$sqlupdateproducts = "UPDATE tbl_products SET prname = '$name', prtype = '$type', prsize = '$size', prprice = '$price', prqty = '$qty' WHERE prid = '$prid'";;
    

    if ($conn->query($sqlupdateproducts) === TRUE) {
        echo "success";
    } else {
        echo "failed";
    }


?>