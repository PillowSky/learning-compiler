'use strict';

if (process.argv.length != 3) {
	console.error('Usage: nodejs ' + process.argv[1] + ' <filename>')
	process.exit(1);
}

var fs = require('fs');
var filename = process.argv[2];
var database = {};
var regex = /^(.*): \[(.*)\] ([^:\n ]*)(: ?(.*))?$/;
var lines = fs.readFileSync(filename).toString().split("\n");

for (var i = 0, length = lines.length; i < length; i++) {
	var m = regex.exec(lines[i]);
	if (m) {
		var timestamp = m[1];
		var action = m[2];
		var username = m[3];
		var message = m[5];
		var data = {
			'timestamp': timestamp,
			'action': action,
			'message': message || ''
		}

		var record = database[username];
		if (record) {
			record.push(data)
		} else {
			database[username] = [data];
		}
	}
}
lines = null;

for (var username in database) {
	var record = database[username];
	process.stdout.write('Logs for ' + username + "\n");
	for (var i = 0, length = record.length; i < length; i++) {
		var r = record[i];
		process.stdout.write("\t" + r.timestamp + ' [' + r.action + '] ' + r.message + "\n");
	}
	process.stdout.write("\n");
}
