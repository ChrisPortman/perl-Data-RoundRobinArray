#!/usr/bin/false

package Data::RoundRobinArray;

use strict;
use warnings;

sub new {
    my $class    = shift;
    my $elements = shift || die 'Must supply number of elements';
    
    unless ( $elements =~ /^\d+$/ and $elements > 0 ) {
		die 'Elements must be a number greater than 0';
	}
    
    $class = ref $class || $class;

    my %objHash = (
        'elements' => $elements,
        'nextIdx'  => 0,
        'lastIdx'  => undef,
        'array'    => [],
    );
    
    for my $idx ( 0..$elements - 1) {
		$objHash{'array'}->[$idx] = undef;
	}
	
	my $object = bless \%objHash, $class;
	
	return $object;
}

sub add {
	my $self = shift;
	my $newVal = shift;
	
	#Where to put the new value
	my $idx = $self->{'nextIdx'};
	
	#add the new value
	$self->{'array'}->[$idx] = $newVal;
	
    #increment the index counters
	$self->{'nextIdx'}++;
	defined $self->{'lastIdx'} ? $self->{'lastIdx'}++ 
	                             : $self->{'lastIdx'} = 0;
	                             
	#Roll the index counters if need be
	if ( $self->{'nextIdx'} > $elements - 1 ) {
		$self->{'nextIdx'} = 0;
	}
	if ( $self->{'lastIdx'} > $elements - 1 ) {
		$self->{'lastIdx'} = 0;
	}
	
	return 1;
}
