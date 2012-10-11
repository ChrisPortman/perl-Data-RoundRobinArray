#!/usr/bin/env perl 
use strict;
use warnings;

use Data::RoundRobinArray;

my $rrArray = Data::RoundRobinArray->new(5);
my $count = 1;

print 'Enter an age: ';

my $code = sub { my $s = shift; my ($r) = $s =~ /(\d+)/; return $r; };

while (<>) {
	chomp();
    $rrArray->add($_);
    
    print "$count - Entered age is $_\n";
    print "\tSmallest age is: ".$rrArray->smallest($code)."\n";
    print "\tLargest age is: ".$rrArray->largest($code)."\n";
    print "\tAverage age is: ".$rrArray->average($code)."\n";
    print "\tTotal age is: ".$rrArray->total($code)."\n";
    print "\tArray is: @{$rrArray->getArray()} \n";
    
    $count++;
    
    print 'Enter an age: ';
}

exit;
    
    
