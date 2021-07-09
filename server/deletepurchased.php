<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$orderid = $_POST['orderid'];
$prid = $_POST['prid'];

$sqldelete = "DELETE FROM tbl_orderhistory WHERE email='$email' AND orderid = '$orderid' AND prid = '$prid'";
$stmt = $conn->prepare($sqldelete);
if ($stmt->execute()) {
    echo "success";
} else {
    echo "failed";
}
?>