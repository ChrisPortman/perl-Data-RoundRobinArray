#!/usr/bin/false

package Data::RoundRobinArray;

use strict;
use warnings;

sub new {
    my $class = shift;
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

    my $object = bless \%objHash, $class;

    return $object;
}

sub add {
    my $self   = shift;
    my $newVal = shift;
    
    chomp($newVal);

    #Where to put the new value
    my $idx = $self->{'nextIdx'};

    #add the new value
    $self->{'array'}->[$idx] = $newVal;

    #increment the index counters
    $self->{'nextIdx'}++;
    defined $self->{'lastIdx'}
      ? ( $self->{'lastIdx'}++ )
      : ( $self->{'lastIdx'} = 0 );

    #Roll the index counters if need be
    if ( $self->{'nextIdx'} > $self->{'elements'} - 1 ) {
        $self->{'nextIdx'} = 0;
    }
    if ( $self->{'lastIdx'} > $self->{'elements'} - 1 ) {
        $self->{'lastIdx'} = 0;
    }

    $self->_validateArray();

    return 1;
}

sub getArray {
	my $self    = shift;
	my @array   = @{$self->{'array'}};
	my $next    = $self->{'nextIdx'};
	my $last    = $self->{'lastIdx'};
	my $lastIdx = $#{$self->{'array'}};
	
	my @realArray;
	if ($next == 0) {
	    @realArray = @array[$next..$lastIdx];
	}
	else {
		@realArray = @array[$next..$lastIdx,0..$last];
	}	
	
	return wantarray ? @realArray : \@realArray;
}

sub largest {
    my $self = shift;
    my $code = shift;
	my @array = $self->_sortArray($code);
    
    return $array[-1];
}
	
sub smallest {
    my $self = shift;
    my $code = shift;
	my @array = $self->_sortArray($code);
    
    return $array[0];
}

sub average {
	my $self = shift;
	my $code = shift;
	my @array = $self->getArray();
	
	my $total;
	my $count;
	
	for my $val ( @array ) {
		if ($code and ref $code eq 'CODE') {
			#use the suppled code ref to extract a number.
			eval {
				$val = $code->($val);
			};
			if ( $@ ) {
				die "Code reference provided to average() died: $!\n";
			}
		}
		
		#we can only care about numbers.
		next unless ($val =~ /^\d+$/);
		
		$total += $val;
		$count++;
	}
	
	if ( $total and $count ) {
		return ($total / $count);
	}
	elsif ( $total == 0 or $count == 0 ) {
        return 0;		
	}
	
	return;
}

sub total {
	my $self = shift;
	my $code = shift;
	my @array = $self->getArray();
	
	my $total;
	
	for my $val ( @array ) {
		if ($code and ref $code eq 'CODE') {
			#use the suppled code ref to extract a number.
			eval {
				$val = $code->($val);
			};
			if ( $@ ) {
				die "Code reference provided to average() died: $!\n";
			}
		}
		
		#we can only care about numbers.
		next unless ($val =~ /^\d+$/);
		
		$total += $val;
	}
	
    return $total;	
}

sub clear {
	my $self = shift;
	
    $self->{'nextIdx'} = 0;
	$self->{'lastIdx'} = undef;
	$self->{'array'}   = [];

    return 1;
}

sub _sortArray {
	my $self  = shift;
	my $code  = shift;
	my @array = @{$self->{'array'}};
	my @sorted;
	
	if ( $code and ref($code) eq 'CODE' ) {
		@sorted = sort { $a <=> $b }
		          grep { /^\d+$/ } 
		          map  { $code->($_) }  @array;
	}
	else {
		@sorted = sort { $a <=> $b } 
		          grep { /^\d+$/ } @array;
	}
	
	return wantarray ? @sorted : \@sorted;
}

sub _validateArray {
	my $self = shift;
	
	if ( scalar @{$self->{'array'}} > $self->{'elements'} ) {
		die "The array has somehow gotten bigger than the number of elements. This is a bug!\n";
	}
	
	return 1;
}

1;
