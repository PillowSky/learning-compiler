'use strict'

fs = require('fs')

lyric = fs.readFileSync('lyric.lrc').toString()
regex = /^\[(\d+):(\d+)\.(\d+)\]\s(.*)$/mg
match = null

while true
	match = regex.exec(lyric)
	if match
		console.log
			hour: match[1]
			minute: match[2]
			second: match[3]
			lyric: match[4]
	else
		break
