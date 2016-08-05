#!/usr/bin/perl -w

use strict;
use warnings;

if ($#ARGV > 1) {
	print "Usage: perl $0 [filename] [date]\n";
	exit;
} else {
	if ($#ARGV == -1) {
		$ARGV[0] = "/var/log/syslog";
	}
	if ($#ARGV == 0) {
		my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
		$ARGV[1] = sprintf("%d-%02d-%02d", $year + 1900, $mon + 1, $mday);	
	}
}


my $filename = $ARGV[0];
my $date = $ARGV[1];
print("File: $filename Date: $date\n\n");

my %database;
my $in_regex = qr/^.+ss-server.+($date \d{2}:\d{2}:\d{2}).+accept a connection from (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$/;
my $out_regex = qr/^.+connect to: (.+)$/;

open(my $fin, $filename);
while (my $line = <$fin>) {
	my @m = ($line =~ $in_regex);
	if (@m) {
		my ($datetime, $ip) = @m;
		
		$line = <$fin>;
		my ($host)= ($line =~ $out_regex);

		my $data = {
			'datetime' => $datetime,
			'host' => $host || ''
		};

		my $record = $database{$ip};
		if ($record) {
			push($record, $data);
		} else {
			$database{$ip} = [$data];
		}

	}
}
close($fin);

while(my ($ip, $record) = each(%database)) {
	print("Logs for $ip\n");
	foreach my $r (@$record) {
		print("\t$r->{'datetime'} => $r->{'host'}\n")
	}
	print("\n");
}
