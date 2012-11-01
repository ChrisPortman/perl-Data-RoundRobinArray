#!/usr/bin/env perl 
use strict;
use warnings;

use Data::RoundRobinArray;

my $rrArray = Data::RoundRobinArray->new(5);
my $count = 1;

print 'Enter an age: ';

#my $code = sub { my $s = shift; my ($r) = $s =~ /(\d+)/; return $r; };
my $code = '\d+';

while (<>) {
	chomp();
    
    last if $_ eq 'done';
    
    $rrArray->add($_);
    analyseArray($rrArray);
    $count++;
    
    print 'Enter an age: ';
}

while ( 1 ) {
    print 'Enter an index to update: ';
    my $idx = <>;
    last unless $idx;
    
    print 'Enter a new value: ';
    my $val = <>;
    last unless $val;
    
    $rrArray->updateIndex($idx, $val);
    analyseArray($rrArray);
}

sub analyseArray {
    my $obj = shift;

    print "$count - Entered age is $_\n";
    print "\tSmallest age is: ".$rrArray->smallest($code)."\n";
    print "\tLargest age is: ".$rrArray->largest($code)."\n";
    print "\tAverage age is: ".$rrArray->average($code)."\n";
    print "\tTotal age is: ".$rrArray->total($code)."\n";
    print "\tArray is: @{$rrArray->getArray()} \n";
    
    return 1;
}    

exit;
    
    
