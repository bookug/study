<?php
$a = "sbsb!";
$b = 1;
function test()
{
	global $a, $b;
	echo $a, "\n", $b, "\n";
	$c = "a";
	if($a)
		echo "sb!";
	if($c)
		echo "bs!";
}

test();
?>

