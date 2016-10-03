#!/usr/bin/perl -w

use strict;
use warnings;
use IO::Zlib;

my $filename;
if ($#ARGV > 0) {
	print "Usage: perl $0 [filename]\n";
	exit;
} else {
	if ($#ARGV == -1) {
		$filename = "/var/log/syslog";
	} else {
		$filename = $ARGV[0];
	}
}
print("File: $filename\n\n");

my %database;
my $in_regex = qr/^.+ss-server.+(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}).+accept a connection from (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$/;
my $out_regex = qr/^.+connect to: (.+)$/;

my $fin;
if ($filename =~ qr/\.gz$/) {
	$fin = IO::Zlib->new($filename, "rb");
} else {
	open($fin, $filename);
}

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
