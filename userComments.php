<?php

$file = "projects/".$HTTP_POST_VARS['projectDirectory']."/userComments.txt"; 
$stripString = "userComments=";
$currentTime = date("D m/d/Y H:i",strtotime("-3 hours"));

//OPEN THE FILE, STRIP OUT THE VARIABLE DECLARATION AND CLOSE IT
$fp = fopen($file, "r");
$oldText = fread($fp, filesize($file));
$oldTextStripped = substr($oldText, strlen($stripString));
fclose($fp);

//REOPEN THE FILE AND CONCATENATE NEW ENTRY WITH OLD ENTRIES
$newText = stripslashes($HTTP_POST_VARS['name'].$HTTP_POST_VARS['email'].$currentTime.$HTTP_POST_VARS['comment']);

$fp = fopen($file, "w+");
fwrite($fp, $newText.$oldTextStripped);
fclose($fp);

?>