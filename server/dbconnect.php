<?php
$servername = "localhost";
$username   = "crimsonw_winfunggateadmin";
$password   = "0d4Zz&LHJ#ft";
$dbname     = "crimsonw_winfunggatedb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>