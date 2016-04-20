#!/usr/bin/ruby -w

if ARGV.length != 1
	puts("Usage: ruby #{$0} <filename>")
	exit()
end

$filename = ARGV[0]
$database = {}
$regex = /^(.*): \[(.*)\] ([^:\n ]*)(: ?(.*))?$/

File.open($filename) do |fin|
	for line in fin
		m = $regex.match(line)
		if m
			_, timestamp, action, username, _, message = *m
			data = {
				'timestamp' => timestamp,
				'action' => action,
				'message' => message || ''
			}
			
			record = $database.fetch(username, nil)
			if record
				record.push(data)
			else
				$database[username] = [data]
			end
		end
	end
end

for username, record in $database
	puts("Logs for #{username}:")
	for r in record
		puts("\t#{r['timestamp']} [#{r['action']}] #{r['message']}")
	end
	puts
end
