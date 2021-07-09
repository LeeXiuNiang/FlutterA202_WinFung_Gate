<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$newname = $_POST['newname'];


$sqlupdateusername = "UPDATE tbl_user SET username = '$newname' WHERE user_email = '$email'";
    

    if ($conn->query($sqlupdateusername) === TRUE) {
        echo "success";
    } else {
        echo "failed";
    }


?>