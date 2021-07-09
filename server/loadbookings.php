<?php
include_once("dbconnect.php");
$email = $_POST['email'];

if($email=='xnlee1999@gmail.com'){
    $sqlloadbookings = "SELECT * FROM tbl_repairBookings";
}else{
    $sqlloadbookings = "SELECT * FROM tbl_repairBookings WHERE tbl_repairBookings.email = '$email'";;
}

$result = $conn->query($sqlloadbookings);

if($result ->num_rows >0){
    $response["bookings"]=array();
    while ($row = $result -> fetch_assoc()){
        $bookinglist = array();
        $bookinglist[id] = $row['rbid'];
        $bookinglist[email] = $row['email'];
        $bookinglist[date] = $row['date'];
        $bookinglist[time] = $row['time'];
        $bookinglist[address] = $row['address'];
        $bookinglist[status] = $row['status'];
        array_push($response["bookings"],$bookinglist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>