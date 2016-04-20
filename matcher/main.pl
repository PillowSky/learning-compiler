#!/usr/bin/perl -w

use strict;
use warnings;

if ($#ARGV != 0) {
	print "Usage: perl $0 <filename>\n";
	exit;
}

my $filename = $ARGV[0];
my %database;
my $regex = qr/^(.*): \[(.*)\] ([^:\n ]*)(: ?(.*))?$/;

open(my $fin, $filename);
while (my $line = <$fin>) {
	my @m = ($line =~ $regex);
	if (@m) {
		my ($timestamp, $action, $username, $ignore, $message) = @m;
		my $data = {
			'timestamp' => $timestamp,
			'action' => $action,
			'message' => $message || ''
		};

		my $record = $database{$username};
		if ($record) {
			push($record, $data);
		} else {
			$database{$username} = [$data];
		}
	}
}
close($fin);

while(my ($username, $record) = each(%database)) {
	print("Logs for $username\n");
	foreach my $r (@$record) {
		print("\t$r->{'timestamp'} [$r->{'action'}] $r->{'message'}\n")
	}
	print("\n");
}
