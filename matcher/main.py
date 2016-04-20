#!/usr/bin/python

import sys
import re

if len(sys.argv) != 2:
	print("Usage: python %s <filename>" % sys.argv[0])
	exit()

filename = sys.argv[1]
database = {}
regex = re.compile(r'^(.*): \[(.*)\] ([^:\n ]*)(: ?(.*))?$')

with open(filename) as fin:
	for line in fin:
		m = regex.search(line)
		if m:
			timestamp, action, username, _, message = m.groups()
			data = {
				'timestamp': timestamp,
				'action': action,
				'message': message or ''
			}

			record = database.get(username)
			if record:
				record.append(data)
			else:
				database[username] = [data]

for username, record in database.iteritems():
	print("Logs for %s:" % username)
	for r in record:
		print("\t%s [%s] %s" % (r['timestamp'], r['action'], r['message']))
	print
