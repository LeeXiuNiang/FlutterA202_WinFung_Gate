<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$newpass = $_POST['newpass'];
$passha1 = sha1($newpass);


$sqlupdatepassword = "UPDATE tbl_user SET password = '$passha1' WHERE user_email = '$email'";
    

    if ($conn->query($sqlupdatepassword) === TRUE) {
        echo "success";
    } else {
        echo "failed";
    }


?>