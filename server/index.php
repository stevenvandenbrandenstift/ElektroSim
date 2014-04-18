<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> 
<HTML>
<HEAD>
<TITLE>Elektrosim</TITLE>
<SCRIPT language="javascript">
<!--

/* This function is pulled from a generic validation file from
some other site (probably developer.netscape.com) and strips out
characters you don't want */

function stripCharsInBag (s, bag) {
	var i;
    var returnString = "";

    // Search through string's characters one by one.
    // If character is not in bag, append to returnString.

    for (i = 0; i < s.length; i++)
    {   
        // Check that current character isn't whitespace.
        var c = s.charAt(i);
        if (bag.indexOf(c) == -1) returnString += c;
    }
    return returnString;
}

// This function just makes sure the comment field is not empty

function valForm(frm) {
	badChars = "<[]>{}";
	if(frm.frmPasssword.value == "") {
		alert("Please fill in your password.");
		return false;
	} else {
		frm.frmComment.value = stripCharsInBag(frm.frmComment.value, badChars);
		// These values may be empty, but strip chars in case they're not
		frm.frmName.value = stripCharsInBag(frm.frmName.value, badChars);
		frm.frmEmail.value = stripCharsInBag(frm.frmEmail.value, badChars);
		return true;
	}
}

-->
</SCRIPT>
</HEAD>

<BODY bgcolor="#FFFFFF">
<?php
$mysqli = new mysqli("localhost", "root", "normaal", "elektrosim");
if ($mysqli->connect_errno) {
    echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}


// If form is submitted, then insert into DB
if (!empty($_POST["submit"])) {

	if($_POST["submit"]==="register"){
	$name = $_POST["frmName"];
	$email = $_POST["frmEmail"];
	$password = $_POST["frmPassword"];
	$hashAndSalt = password_hash($password, PASSWORD_BCRYPT);
	
		if ($mysqli->query("INSERT INTO logins VALUES (0, '$name', '$email', '$hashAndSalt', '0000-00-00 00:00:00')") === TRUE) {
   		 	echo "ok : ";
		}
		$id =  $mysqli->insert_id;
	}
	if($_POST["submit"]==="login"){
		$name = $_POST["frmName"];
		$password = $_POST["frmPassword"];	

		$stmt = $mysqli->prepare("SELECT Password, Id FROM logins WHERE Name =?");
		$stmt->bind_param("s",$name); 
		$stmt->execute();
		$stmt->bind_result($hashSalt,$Id);


		$stmt->fetch();
	       	if (password_verify($password, $hashSalt)) {
				echo exec("./Server $Id > ./users/out$Id.txt ",$out);
				echo $out;
				echo "\n"+$Id;
				echo "<meta http-equiv=\"refresh\" content=\"0;URL=http://";
				echo $_SERVER['SERVER_ADDR'];
				echo ":";
				echo $Id+8080;
				echo "\">";
		}
	    	
		$stmt->close();
	}
}


?>
<form name="gb" action="<?php $_SERVER['PHP_SELF'] ?>" method="post">
<table cellpadding="3" cellspacing="0" border="0">`
  <tr>
    <td class="tdhead" valign="top" align="right">Name</td>
    <td valign="top"><input type="text" name="frmName" value="" size="30" maxlength="50"></td>
  </tr>
  <tr>
    <td class="tdhead" valign="top" align="right">Email</td>
    <td valign="top"><input type="text" name="frmEmail" value="" size="30" maxlength="100"></td>
  </tr>
  <tr>
    <td class="tdhead" valign="top" align="right">Password</td>
    <td valign="top"><input type="text" name="frmPassword" value="" size="30" maxlength="100"></td>
  </tr>
  <tr>
    <td> </td>
    <td><input type="submit" name="submit" value="register" onClick="return valForm(document.gb)">
    	<input type="submit" name="submit" value="login" onClick="return valForm(document.gb)"></td>
  </tr>
</table>
</form>

</BODY>
</HTML>
