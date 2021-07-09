<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$instime = $_GET['time'];
$insdate = $_GET['date'];

$total = $_GET['total']; 
$balance = $total-$amount; 

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];

if ($paidstatus=="true"){
  $receiptid = $_GET['billplz']['id'];
  $signing = 'S-b2R3qIG4FOSMoFBXQwhxhA';
    foreach ($data as $key => $value) {
        $signing.= 'billplz'.$key . $value;
        if ($key === 'paid') {
            break;
        } else {
            $signing .= '|';
        }
    }
    
    if($amount==$total){
   $sqlinsertpurchased = "INSERT INTO tbl_purchased(orderid,email,paid,balance,status) VALUES('$receiptid','$userid', '$amount',$balance,'paid')";
   
    }else{
   $sqlinsertpurchased = "INSERT INTO tbl_purchased(orderid,email,paid,balance,status) VALUES('$receiptid','$userid', '$amount',$balance,'deposit')";     
    }

    $sqladd1 = "INSERT INTO tbl_orderhistory (email,prid,qty)
              SELECT email,prid, qty FROM tbl_carts
              WHERE email='$userid'";

   if($amount==$total){
        $sqlupdate = "UPDATE tbl_orderhistory SET orderid = '$receiptid', status = 'paid', insdate = '$insdate', instime = '$instime' WHERE status = '' AND email='$userid'";
    }else{
        $sqlupdate = "UPDATE tbl_orderhistory SET orderid = '$receiptid', status = 'deposit', insdate = '$insdate', instime = '$instime' WHERE status = '' AND email='$userid'";  
    }
    
   $sqlupdate2 = "UPDATE tbl_products join tbl_orderhistory ON tbl_products.prid=tbl_orderhistory.prid SET tbl_products.prqty = tbl_products.prqty-tbl_orderhistory.qty WHERE tbl_products.prid=tbl_orderhistory.prid AND tbl_orderhistory.orderid = '$receiptid' AND tbl_orderhistory.email='$userid'";
              
   $sqldeletecart = "DELETE FROM tbl_carts WHERE email='$userid'";
   
   $stmt = $conn->prepare($sqlinsertpurchased);
   $stmt->execute();
  $stmtadd1 = $conn->prepare($sqladd1);
  $stmtadd1->execute();

  $stmtup = $conn->prepare($sqlupdate);
  $stmtup->execute();
  $stmtup2 = $conn->prepare($sqlupdate2);
  $stmtup2->execute();
   $stmtdel = $conn->prepare($sqldeletecart);
   $stmtdel->execute();
   
   
       echo '<br><br><body><div><h2><br><br><center>Your Receipt</center>
     </h1>
     <table border=1 width=80% align=center>
     <tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td>
     <td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr>
     <tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr>
     <tr><td>Date </td><td>'.date("d/m/Y").'</td></tr>
     <tr><td>Time </td><td>'.date("h:i a").'</td></tr>
     </table><br>
     <p><center>Press back button to return to your app</center></p></div></body>';
    
}
else{
     echo 'Payment Failed!';
}
?>