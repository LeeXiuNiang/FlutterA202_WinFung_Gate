<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$prid = $_POST['prid'];
$orderid = $_POST['orderid'];
$status = $_POST['status'];

$sqlupdatepurchased = "UPDATE tbl_orderhistory SET status = 'completed' WHERE prid = '$prid' AND orderid = '$orderid'";

$sqlupdatepurchased2 = "UPDATE tbl_purchased SET status = 'completed', paid = paid+balance, balance='0' WHERE orderid = '$orderid'";

if ($status == 'completed') {
        echo "failed";
    } else {
    if ($conn->query($sqlupdatepurchased) === TRUE && $conn->query($sqlupdatepurchased2) === TRUE) {
        echo "success";
    } else {
        echo "failed";
    }
}

?>