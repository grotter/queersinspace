<?php

$file = "log.html";

if (filesize($file) < 536870912) {
	$userInfo = "<p>-----------------------------------".
	"<p>**<b>Date:</b> ".date("D m/d/Y H:i",strtotime("-3 hours")).
	"<br>".
	"<b>IP Address:</b> ".getenv('REMOTE_ADDR').
	"<br>".
	"<b>Domain:</b> ".gethostbyaddr(getenv('REMOTE_ADDR')). 
	"<br>".
	"<b>Referrer:</b> ".$_REQUEST['userReferrer'].
	"<br>".
	"<b>Platform:</b> ".$_REQUEST['userPlatform'].
	"<br>".
	"<b>Browser:</b> ".getenv('HTTP_USER_AGENT').
	"<br>".
	"<b>Flash Player:</b> ".$_REQUEST['flashVersion'];
	
	$fp = fopen($file, "a+");
	fwrite($fp, $userInfo);
	fclose($fp);
}

?>