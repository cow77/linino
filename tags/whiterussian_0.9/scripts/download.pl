#!/usr/bin/perl
# 
# Copyright (C) 2006 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

use strict;
use warnings;

my $target = shift @ARGV;
my $filename = shift @ARGV;
my $md5sum = shift @ARGV;
my @mirrors;

my $ok;

@ARGV > 0 or die "Syntax: $0 <target dir> <filename> <md5sum> <mirror> [<mirror> ...]\n";

sub which($) {
	my $prog = shift;
	my $res = `which $prog`;
	$res or return undef;
	$res =~ /^no / and return undef;
	$res =~ /not found/ and return undef;
	return $res;
}

my $md5cmd = which("md5sum");
$md5cmd or $md5cmd = which("md5");
$md5cmd or die 'no md5 checksum program found, please install md5 or md5sum';
chomp $md5cmd;

sub download
{
	my $mirror = shift;
	my $options = $ENV{WGET_OPTIONS};
	$options or $options = "";

	open WGET, "wget -t1 --timeout=20 $options -O- \"$mirror/$filename\" |" or die "Cannot launch wget.\n";
	open MD5SUM, "| $md5cmd > \"$target/$filename.md5sum\"" or die "Cannot launch md5sum.\n";
	open OUTPUT, "> $target/$filename.dl" or die "Cannot create file $target/$filename.dl: $!\n";
	my $buffer;
	while (read WGET, $buffer, 1048576) {
		print MD5SUM $buffer;
		print OUTPUT $buffer;
	}
	close MD5SUM;
	close WGET;
	close OUTPUT;
	
	if (($? >> 8) != 0 ) {
		print STDERR "Download failed.\n";
		cleanup();
		return;
	}
	
	my $sum = `cat "$target/$filename.md5sum"`;
	$sum =~ /^(\w+)\s*/ or die "Could not generate md5sum\n";
	$sum = $1;
	
	if (($md5sum =~ /\w{32}/) and ($sum ne $md5sum)) {
		print STDERR "MD5 sum of the downloaded file does not match - deleting download.\n";
		cleanup();
		return;
	}
	
	unlink "$target/$filename";
	system("mv \"$target/$filename.dl\" \"$target/$filename\"");
	cleanup();
}

sub cleanup
{
	unlink "$target/$filename.dl";
	unlink "$target/$filename.md5sum";
}

foreach my $mirror (@ARGV) {
	if ($mirror =~ /^\@SF\/(.+)$/) {
		# give sourceforge a few more tries, because it redirects to different mirrors
		for (1 .. 5) {
			push @mirrors, "http://downloads.sourceforge.net/$1";
		}
	} elsif ($mirror =~ /^\@GNU\/(.+)$/) {
		my $gnupath = $1;
		push @mirrors, "ftp://ftp.gnu.org/gnu/$gnupath";
		push @mirrors, "ftp://ftp.belnet.be/mirror/ftp.gnu.org/gnu/$gnupath";
		push @mirrors, "ftp://ftp.mirror.nl/pub/mirror/gnu/$gnupath";
		push @mirrors, "http://mirror.switch.ch/ftp/mirror/gnu/$gnupath";
		push @mirrors, "ftp://ftp.uu.net/archive/systems/gnu/$gnupath";
		push @mirrors, "ftp://ftp.eu.uu.net/pub/gnu/$gnupath";
		push @mirrors, "ftp://ftp.leo.org/pub/comp/os/unix/gnu/$gnupath";
		push @mirrors, "ftp://ftp.digex.net/pub/gnu/$gnupath";
	} else {
		push @mirrors, $mirror;
	}
}

#push @mirrors, 'http://mirror1.openwrt.org/';
push @mirrors, 'http://mirror2.openwrt.org/sources';
push @mirrors, 'http://downloads.openwrt.org/sources/';

while (!$ok) {
	my $mirror = shift @mirrors;
	$mirror or die "No more mirrors to try - giving up.\n";
	
	download($mirror);
	-f "$target/$filename" and $ok = 1;
}

$SIG{INT} = \&cleanup;

