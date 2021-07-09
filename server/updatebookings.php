<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$rbid = $_POST['rbid'];
$status = $_POST['status'];

$sqlupdatebookings = "UPDATE tbl_repairBookings SET status = 'completed' WHERE rbid = '$rbid'";
    
if ($status == 'completed') {
        echo "failed";
    } else {
    if ($conn->query($sqlupdatebookings) === TRUE) {
        echo "success";
    } else {
        echo "failed";
    }
}

?>