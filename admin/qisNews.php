<?php

$file = "../qisNews.txt"; 
$stripString = "qisNews=";
$currentTime = date("D m/d/Y H:i",strtotime("-3 hours"));

//OPEN THE FILE, STRIP OUT THE VARIABLE DECLARATION AND CLOSE IT
$fp = fopen($file, "r");
$oldText = fread($fp, filesize($file));
$oldTextStripped = substr($oldText, strlen($stripString));
fclose($fp);

//REOPEN THE FILE AND CONCATENATE NEW ENTRY WITH OLD ENTRIES
$newText = stripslashes($HTTP_POST_VARS['newsHeader'].$currentTime.$HTTP_POST_VARS['newsBody']);

$fp = fopen($file, "w+");
fwrite($fp, $newText.$oldTextStripped);
fclose($fp);

?>