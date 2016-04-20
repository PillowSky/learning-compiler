<?php

if ($argc != 2) {
	echo("Usage: php {$argv[0]} <filename>\n");
	exit(1);
}

$filename = $argv[1];
$database = [];
$regex = '/^(.*): \[(.*)\] ([^:\n ]*)(: ?(.*))?$/S';

$fin = fopen($filename, 'r');
while ($line = fgets($fin)) {
	preg_match($regex, $line, $m);
	if ($m) {
		$timestamp = $m[1];
		$action = $m[2];
		$username = $m[3];
		$message = isset($m[5]) ? $m[5] : '';
		$data = [
			'timestamp' => $timestamp,
			'action' => $action,
			'message' => $message
		];

		if (isset($database[$username])) {
			$database[$username][] = $data;
		} else {
			$database[$username] = [$data];
		}
	}
}
fclose($fin);

foreach($database as $username => $record) {
	echo("Logs for {$username}:\n");
	foreach ($record as $r) {
		echo("\t{$r['timestamp']} [{$r['action']}] {$r['message']}\n");
	}
	echo("\n");
}
