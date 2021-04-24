<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/crimsonw/public_html/s272033/winfunggate/php/PHPMailer/src/Exception.php';
require '/home8/crimsonw/public_html/s272033/winfunggate/php/PHPMailer/src/PHPMailer.php';
require '/home8/crimsonw/public_html/s272033/winfunggate/php/PHPMailer/src/SMTP.php';

include_once("dbconnect.php");

$username = $_POST['username'];
$user_email = $_POST['email'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(1000,9999);

$sqlregister = "INSERT INTO tbl_user(username,user_email,password,otp) VALUES('$username','$user_email','$passha1','$otp')";
if($conn->query($sqlregister) === TRUE){
    sendEmail($otp,$user_email);
    echo "success";
}else{
    echo "failed";
}

function sendEmail($otp,$user_email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                               //Disable verbose debug output
    $mail->isSMTP();                                                    //Send using SMTP
    $mail->Host       = 'mail.crimsonwebs.com';                         //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                           //Enable SMTP authentication
    $mail->Username   = 'winfunggate@crimsonwebs.com';                  //SMTP username
    $mail->Password   = 'OE^gBeI}pSZH';                                 //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "winfunggate@crimsonwebs.com";
    $to = $user_email;
    $subject = "From WinFungGate. Please verify your account";
    $message = "<p>Click the following link to verify your account<br><br>
    <a href='https://crimsonwebs.com/s272033/winfunggate/php/verify_account.php?email=".$user_email."&key=".$otp."'>Click Here to verify your account</a>";
    
    $mail->setFrom($from,"WinFungGate");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}

?>