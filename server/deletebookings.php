<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$rbid = $_POST['rbid'];

$sqldelete = "DELETE FROM tbl_repairBookings WHERE email='$email' AND rbid = '$rbid'";
$stmt = $conn->prepare($sqldelete);
if ($stmt->execute()) {
    echo "success";
} else {
    echo "failed";
}
?>