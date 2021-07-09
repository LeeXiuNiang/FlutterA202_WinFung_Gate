<?php

include_once("dbconnect.php");
$name = $_POST['name'];
$type = $_POST['type'];
$size = $_POST['size'];
$price = $_POST['price'];
$qty=  $_POST['qty'];
$encoded_string = $_POST["encoded_string"];
						
$sqlinsert = "INSERT INTO tbl_products(prname,prtype, prsize, prprice,prqty) VALUES('$name','$type','$size','$price','$qty')";
if ($conn->query($sqlinsert) === TRUE){
    $decoded_string = base64_decode($encoded_string);
    $filename = mysqli_insert_id($conn);
    $path = '../images/products/'.$filename.'.png';
    $is_written = file_put_contents($path, $decoded_string);
    echo "success";
}else{
    echo "failed";
}