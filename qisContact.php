<?php

$name = $HTTP_POST_VARS['name'];
$email = $HTTP_POST_VARS['email'];
$message = $HTTP_POST_VARS['message'];

$subject = "QUEERSINSPACE.ORG : qisContact.php";

mail("info@queersinspace.org", $subject, stripslashes($message), "From: $name <$email>");

?>