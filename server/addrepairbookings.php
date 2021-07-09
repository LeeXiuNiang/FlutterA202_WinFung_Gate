<?php

include_once("dbconnect.php");
$email = $_POST['email'];
$name = $_POST['name'];
$phone = $_POST['phone'];
$date = $_POST['date'];
$time =  $_POST['time'];
$address =  $_POST['address'];
						
$sqlbook = "INSERT INTO tbl_repairBookings(email,name,phone,date,time,address,status) VALUES('$email','$name','$phone','$date','$time','$address','pending')";
if($conn->query($sqlbook) === TRUE){
    echo "success";
}else{
    echo "failed";
}

?>