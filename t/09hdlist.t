#!/usr/bin/perl
# $Id$

use strict;
use Test::More tests => 6;
use FindBin qw($Bin);
use File::Temp qw(tempdir);
use File::Glob;

my $testdir = tempdir( CLEANUP => 1 );

use_ok('RPM4');
use_ok('RPM4::Index');

my @headers;
my $callback = sub { my %arg = @_; defined($arg{header}) and push(@headers, $arg{header}); };

my @rpms = <$Bin/*.rpm>;

RPM4::parserpms(callback => $callback, rpms => [ @rpms ]);
ok(scalar(@headers) == 4, "RPM4::parserpms works");

ok(RPM4::Index::buildhdlist(hdlist => "$testdir/hdlist.cz", rpms => [ @rpms ]), 
    "Creating a hdlist");
ok(RPM4::Index::buildsynthesis(synthesis => "$testdir/synthesis.hdlist.cz", rpms => [ @rpms ]), 
    "Creating a synthesis");
ok(RPM4::Index::buildindex(list => "$testdir/list", rpms => [ @rpms ]), 
    "Creating a list file");
